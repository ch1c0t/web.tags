# Introduction

To install: `npm install web.tags`.

This defines `window.TAGS` and `window.tag`, and extends `HTMLElement.prototype`.

A tag is a function that returns a view.

A view is either of these:

- an instance of [HTMLElement][HTMLElement];
- an Array of HTMLElement instances;

[HTMLElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement

## `window.TAGS`

is to store tags. By default, only the tags for basic elements
(like [p][p], [span][span], and [div][div]) are there. The full
list is in [src/tags.coffee](src/tags.coffee).

You can pass to such tags zero, one, or two arguments:

```coffee
import 'web.tags'
{ div } = TAGS

# A call with zero arguments
element = div()

# A call with one argument, a String representing a Text node:
# https://developer.mozilla.org/en-US/docs/Web/API/Text
element = div 'some string'

# A call with one argument, an Object representing Element.attributes:
# https://developer.mozilla.org/en-US/docs/Web/API/Element/attributes
element = div id: 'SomeId', class: 'SomeClass'

# A call with one argument, an Array representing Element.children:
# https://developer.mozilla.org/en-US/docs/Web/API/Element/children
element = div [
  div 'first child'
  div 'second child'
]

# A call with two arguments(attributes and content):
element = div id: 'SomeId', class: 'SomeClass', 'some content'

# A nested example
element = div [
  div 'first child'
  div 'second child'
  div id: 'SomeId', class: 'SomeClass', [
    div id: 'AnotherId', class: 'AnotherClass', 'some grandchild text'
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

## `window.tag`

is a function to define tags. They can be named or nameless.

### Named tags

When a named tag is defined, it gets added to `window.TAGS`.

To define a named tag, pass two arguments to `window.tag`:

- `name`, under which the tag will be available in `window.TAGS`.
   A String in PascalCase.
- `spec`, which defines what the tag provides.
   An Object defined [here](#spec).

For example:

```coffee
# Definition
{ p } = TAGS
tag 'SomeName',
  data:
    language: -> @value or 'CoffeeScript'
    link: -> @value or 'https://github.com/ch1c0t/web.tags'
  view: ->
    p "#{@language} of #{@link}"

# Usage
{ SomeName } = TAGS
element = SomeName link: 'https://github.com/ch1c0t/wrapjsx'
element.outerHTML
#=> <some-name><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></some-name>
```

Named tags create [custom elements][custom_elements].

[custom_elements]: https://developer.mozilla.org/en-US/docs/Web/API/Window/customElements

### Nameless tags

Nameless tags do not get added to `window.TAGS`.

To define a nameless tag, pass to `window.tag` one argument
(which is [the same `spec`](#spec) as for named tags).

For example:

```coffee
# Definition
{ p } = TAGS
SomeName = tag
  data:
    language: -> @value or 'CoffeeScript'
    link: -> @value or 'https://github.com/ch1c0t/web.tags'
  view: ->
    p "#{@language} of #{@link}"

# Usage
element = SomeName link: 'https://github.com/ch1c0t/wrapjsx'
element.outerHTML
#=> <div><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></div>
```

By default, if you pass one argument, nameless tags return divs.
To change the default, pass two arguments -- `root` and `spec`:

```coffee
# Definition
{ li, ul } = TAGS
List = tag ul,
  view: ->
    [
      li 'first'
      li 'second'
    ]

# Usage
element = List()
element.outerHTML
#=> <ul><li>first</li><li>second</li></ul>
```

In the above example, `root` is the `ul` function.
`root` can be either of these:

- an instance of [HTMLElement][HTMLElement];
- a nullary function that returns an instance of HTMLElement;

### `spec`

is the tag specification.
It is an Object that might have the following properties:

#### `data`

is an Object that specifies:

- what data a tag can receive as an argument;
- how a tag processes these data;

Each property of `data` must be associated with a function that returns a value.
When a tag gets called, this value is assigned to a property with the same name
in the returned element.

```coffee
# Definition
Some = tag
  data:
    language: -> @value or 'CoffeeScript'
    link: -> @value or 'https://github.com/ch1c0t/web.tags'

# Usage
element = Some language: 'Ruby'
element.language #=> 'Ruby'
element.link #=> 'https://github.com/ch1c0t/web.tags'
element.data #=> { language: 'Ruby', link: 'https://github.com/ch1c0t/web.tags' }
```

In the above example, the tag `Some` can receive an Object,
in which it looks for `language` and `link` properties.
It passes the values of these properties to their corresponding functions as `@value`.
For `language`, it is `'Ruby'`; for `link`, it is `undefined`.

Then, the values returned from the functions get assigned to `language` and `link`
in the returned element. And besides that, all the data get assigned
to the `data` property.
