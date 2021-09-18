import { wrap } from './wrap.js'

hyphenate = (string) ->
  string
    .split /([A-Z][a-z]+)/
    .filter Boolean
    .map Function::call, String::toLowerCase
    .join '-'

class MyHTMLElement extends HTMLElement
  connectedCallback: ->
    @render()

  render: (template) ->
    template ?= @template()

    if Array.isArray template
      @replaceChildren ...template
    else
      @replaceChildren template

window.tag = ->
  switch arguments.length
    when 1
      namelessTag arguments[0]
    when 2
      [name, spec] = arguments
      namedTag name, spec

namedTag = (name, spec) ->
  el = class extends MyHTMLElement

  if spec.connected
    el::connectedCallback = spec.connected

  if spec.render
    el::template = spec.render

  if spec.methods
    for n, m of spec.methods
      el::[n] = m

  hyphenated = hyphenate name
  customElements.define hyphenated, el

  fn = if spec.data
    createTag { name: hyphenated, data: spec.data }
  else
    wrap hyphenated

  window.TAGS[name] = fn
  fn

namelessTag = ({ data, render, methods, once }) ->
  (input) ->
    state =
      data: {}

    for key, fn of data
      value = fn.call input[key]
      state.data[key] = value
      state[key] = value

    element = render.call state

    for key, value of state
      element[key] = value

    if methods
      for name, method of methods
        element[name] = method

    if once
      once.call element

    element

createTag = ({ name, data }) ->
  (input) ->
    element = document.createElement name
    element.data ?= {}

    for key, fn of data
      value = fn.call input[key]
      element.data[key] = value
      element[key] = value

    element
