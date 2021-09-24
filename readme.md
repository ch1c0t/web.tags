## Introduction

To install: `npm install web.tags`.

This defines `window.TAGS` and `window.tag`, and extends `HTMLElement.prototype`.

A tag is a function that returns a view.

A view is either of these:

- an instance of [HTMLElement][HTMLElement];
- an Array of HTMLElement instances;

[HTMLElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement
