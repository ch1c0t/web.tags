import { wrap } from '../wrap.js'
import { MyHTMLElement } from './my_hmtl_element.js'

namedTag = (name, spec) ->
  el = class extends MyHTMLElement

  if spec.connected
    el::connectedCallback = spec.connected

  if spec.render
    el::template = spec.render

  if spec.once
    el::once = spec.once

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

hyphenate = (string) ->
  string
    .split /([A-Z][a-z]+)/
    .filter Boolean
    .map Function::call, String::toLowerCase
    .join '-'

createTag = ({ name, data }) ->
  (input) ->
    element = document.createElement name
    element.data ?= {}

    for key, fn of data
      value = fn.call input[key]
      element.data[key] = value
      element[key] = value

    element

export { namedTag }
