import { wrap } from '../wrap.js'
import { MyHTMLElement } from './my_html_element.js'

namedTag = (name, { connected, data, view, methods, once }) ->
  base = class extends MyHTMLElement

  if connected
    base::connectedCallback = connected

  if view
    base::view = view

  if once
    base::once = once

  if methods
    for n, m of methods
      base::[n] = m

  fn = createTag { name, data, base }
  window.TAGS[name] = fn
  fn

hyphenate = (string) ->
  string
    .split /([A-Z][a-z]+)/
    .filter Boolean
    .map Function::call, String::toLowerCase
    .join '-'

createTag = ({ name, data, base }) ->
  name = hyphenate name
  customElements.define name, base

  if data
    (input) ->
      element = document.createElement name
      element.data ?= {}

      for key, fn of data
        value = fn.call input[key]
        element.data[key] = value
        element[key] = value

      element
  else
    wrap name

export { namedTag }
