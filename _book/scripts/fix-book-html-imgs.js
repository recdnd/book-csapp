#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const root = path.join(process.cwd(), "_book");
let changed = 0;

function walk(dir) {
  for (const name of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, name.name);
    if (name.isDirectory()) {
      walk(full);
      continue;
    }
    if (!name.isFile() || !full.endsWith(".html")) continue;
    const before = fs.readFileSync(full, "utf8");
    const after = before.replace(/([("'=])(?:\.\.\/)+_imgs\//g, "$1/_imgs/");
    if (after !== before) {
      fs.writeFileSync(full, after, "utf8");
      changed += 1;
    }
  }
}

if (fs.existsSync(root)) {
  walk(root);
}

console.log(`fix-book-html-imgs: normalized ${changed} html files`);
