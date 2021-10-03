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

You can pass to such tags zero, one, or two arguments:

```coffee
import 'web.tags'
{ div } = TAGS

element = div()

element = div 'some string'

element = div [
  div 'first child'
  div 'second child'
  div id: 'SomeId', class: 'SomeClass', [
    div id: 'AnotherId', class 'AnotherClass', 'some grandchild text'
  ]
]
```

To add elements to the document, you can use [the render function from `web.helpers`][render]:

```coffee
import { render } from 'web.helpers'
render 'SomeId', element
```

[p]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p
[span]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span
[div]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div
[render]: https://gitlab.com/ch1c0t/web.helpers/-/tree/module#render
