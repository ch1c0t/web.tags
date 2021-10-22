# Introduction

To install: `npm install web.tags`.

This defines `window.TAGS` and `window.tag`, and extends `HTMLElement.prototype`.
For the sake of composability.

A tag is a function that returns a view.

A view is either of these:

- an instance of [HTMLElement][HTMLElement];
- an Array of HTMLElement instances;

[HTMLElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement

## `window.TAGS`

is to store tags. By default, only the tags for basic elements
(like [p][p] and [div][div]) are there. The full
list is in [src/tags.coffee](src/tags.coffee).

You can pass to such tags 0, 1, or 2 arguments:

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

# A call with two arguments(attributes and content)
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

To add elements to [the `document.body`][document.body],
you can use [the `render` function](#render):

```coffee
document.body.render element
```

[p]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p
[div]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div
[render]: https://gitlab.com/ch1c0t/web.helpers/-/tree/module#render
[document.body]: https://developer.mozilla.org/en-US/docs/Web/API/Document/body

## `window.tag`

is a function to define tags which

- return an instance of [HTMLElement][HTMLElement](the root element of a tag);
- receive 0 or 1 argument(an Object feeding the root element's [`data`](#data));

Tags can be named or nameless.

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
#=> <some-name></some-name>

document.body.render element
element.outerHTML
#=> <some-name><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></some-name>
```

Named tags create [custom elements][custom_elements]
that call [`render`](#render) in their [connectedCallback][connectedCallback].

[custom_elements]: https://developer.mozilla.org/en-US/docs/Web/API/Window/customElements
[connectedCallback]: https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements#using_the_lifecycle_callbacks

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

is an Object that specifies how a tag processes its argument.

Each property of `data` must be associated with a function that returns a value.
When a tag gets called, this value is assigned to a property with the same name
in the root element.

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
in the root element. And besides that, all the data get assigned
to the `data` property.

#### `view`

is a function that must return either of these:

- a view;
- a Promise to resolve to a view;

This function will be executed in the element's context,
which allows to use the element's `data` inside of it:

```coffee
# Definition
{ p } = TAGS
Some = tag
  data:
    name: -> @value or 'Ruby'
  view: ->
    p "Hello, #{@name}."

# Usage
element = Some name: 'Alice'
element.outerHTML
#=> <div><p>Hello, Alice</p></div>
```

#### `reactive`

is a Boolean which is `true` by default.

If an element is reactive, it will wrap its `data` in [Proxy objects][Proxy]
and call [`render`](#render) when its `data` change.

[Proxy]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy

#### `once`

is a function that will be executed only once.

For common elements, it happens immediately after all the `data` were assigned to the element;
for custom elements, it happens once the element was [connected to the document][connectedCallback].

The returned value of this function will be assigned to the `@once` attribute.
If it is a Promise, it may be convenient to use it in the `@view`:

```coffee
# Definition
{ p } = TAGS
Some = tag
  data:
    language: -> @value or 'CoffeeScript'
    link: -> @value or 'https://github.com/ch1c0t/web.tags'
  once: ->
    @string = "#{@language} of #{@link}"
    @asynchronous = await Promise.resolve 'from Promise'
  view: ->
    @once.then =>
      p "#{@asynchronous}: #{@string}"


# Usage
element = Some()
element.outerHTML
#=> <div><p>from Promise: CoffeeScript of https://github.com/ch1c0t/web.tags</p></div>
```

#### `methods`

is an Object that specifies what methods to add to the root element.

```coffee
# Definition
{ button } = TAGS
Some = tag
  once: ->
    @style.width = '0px'
  view: ->
    button onclick: 'this.parentNode.toggle()'
  methods: ->
    toggle: ->
      if @style.width is '0px'
        @style.width = '100%'
      else
        @style.width = '0px'

# Usage
element = Some()
element.toggle()
```

## `HTMLElement`

enriched with the following functions:

### `on`

is the same as [HTMLElement.addEventListener][addEventListener].

[addEventListener]: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener

### `emit`

is to emit [CustomEvents][CustomEvent]. Its signature: `emit(name, detail?)`.

It creates [an event that bubbles][bubbles], and dispatches it to the current element.

[CustomEvent]: https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent
[bubbles]: https://developer.mozilla.org/en-US/docs/Web/Events/Creating_and_triggering_events#event_bubbling

### `render`

is to replace the children of the current element. Its signature: `render(view?)`.

A usage example:

```coffee
{ div } = TAGS

document.body.render [
  div 'first child'
  div 'second child'
]

document.body.outerHTML
#=> <body><div>first child</div><div>second child</div></body>
```

If you don't pass an argument,
it will use [the `view` function](#view) of the current element to obtain
a view to render.

It uses [HTMLElement.replaceChildren][replaceChildren] under the hood.

[replaceChildren]: https://developer.mozilla.org/en-US/docs/Web/API/Element/replaceChildren

# Tools

[maketag][maketag] is a tool to make tags. It allows to:

- generate new packages providing tags;
- augment tags with Sass styles;
- test tags with Jasmine and Puppeteer;

[maketag]: https://github.com/ch1c0t/maketag
