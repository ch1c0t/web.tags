{ wrap } = require './wrap'

hyphenate = (string) ->
  string
    .split /([A-Z][a-z]+)/
    .filter Boolean
    .map Function::call, String::toLowerCase
    .join '-'

class MyHTMLElement extends HTMLElement
  constructor: ->
    super()

    if @shadowTemplate
      @attachShadow mode: 'open'
      @render()

  render: (object) ->
    root = if @shadowTemplate then @shadowRoot else @
    object = object or @shadowTemplate

    if Array.isArray object
      root.replaceChildren ...object
    else
      root.replaceChildren object

  shadow: (selector) ->
    @shadowRoot.querySelector selector

  emit: (name, detail) ->
    event = new CustomEvent name,
      bubbles: true
      composed: true
      detail: detail

    @shadowRoot.dispatchEvent event

window.tag = ->
  switch arguments.length
    when 1
      namelessTag arguments[0]
    when 2
      [name, spec] = arguments
      namedTag name, spec

namedTag = (name, spec) ->
  el = class extends MyHTMLElement

  if spec.shadow
    el::shadowTemplate = spec.shadow

  if spec.connected
    el::connectedCallback = spec.connected

  if spec.methods
    for n, m of spec.methods
      el::[n] = m

  hyphenated = hyphenate name
  customElements.define hyphenated, el
  TAGS[name] = wrap hyphenated

namelessTag = (spec) ->
  console.log spec
