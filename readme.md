## Introduction

To install: `npm install web.tags`.

This defines `window.TAGS` and `window.tag`, and extends `HTMLElement.prototype`.

A tag is a function that returns a view.

A view is either of these:

- an instance of [HTMLElement][HTMLElement];
- an Array of HTMLElement instances;

[HTMLElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement

### `window.TAGS`

is to store tags. By default, only the tags for basic elements
(like [p][p], [span][span], and [div][div]) are there.

[p]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p
[span]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span
[div]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div
