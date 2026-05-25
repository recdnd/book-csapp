#!/usr/bin/env node
const fs = require("fs");
const path = require("path");
const kramed = require("kramed");

const root = process.cwd();
const skipDirs = new Set([".git", "node_modules", "_book"]);

function walk(dir, out) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      if (!skipDirs.has(entry.name)) walk(full, out);
      continue;
    }
    if (entry.isFile() && entry.name.endsWith(".md")) out.push(full);
  }
}

function labelFromTarget(target) {
  const cleaned = target.replace(/\/+$/, "").split("/").pop() || target;
  return cleaned
    .replace(/\.md$/i, "")
    .replace(/[-_]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function normalize(content) {
  let next = content;

  // GitBook page-ref -> markdown link
  next = next.replace(/\{\%\s*page-ref\s+page="([^"]+)"\s*\%\}/g, (_, p1) => {
    const label = labelFromTarget(p1);
    return `[${label}](${p1})`;
  });

  // GitBook tab blocks -> markdown headings
  next = next.replace(/\{\%\s*tabs\s*\%\}/g, "");
  next = next.replace(/\{\%\s*endtabs\s*\%\}/g, "");
  next = next.replace(/\{\%\s*tab\s+title="([^"]+)"\s*\%\}/g, "\n#### $1\n");
  next = next.replace(/\{\%\s*endtab\s*\%\}/g, "");

  // GitBook hint blocks -> styled callout <div> with PRE-RENDERED body.
  // HonKit's markdown engine (kramed) does not parse markdown inside a raw
  // block-level <div>, so we render the body to HTML here and emit the whole
  // thing as a raw HTML block. This preserves headings/bold/lists inside the
  // callout (57 of the book's hints contain such formatting).
  next = next.replace(
    /\{\%\s*hint\s+style="([^"]+)"\s*\%\}\s*\n([\s\S]*?)\n\s*\{\%\s*endhint\s*\%\}/g,
    (_, style, body) => {
      const html = kramed(body.trim()).trim();
      return `<div class="hint hint-${style}">\n${html}\n</div>`;
    }
  );

  return next;
}

const files = [];
walk(root, files);
let changed = 0;

for (const file of files) {
  const before = fs.readFileSync(file, "utf8");
  const after = normalize(before);
  if (after !== before) {
    fs.writeFileSync(file, after, "utf8");
    changed += 1;
  }
}

console.log(`prepare-honkit: normalized ${changed} markdown files`);
