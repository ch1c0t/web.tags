import { wrap } from '../wrap.js'
import { hyphenate } from 'hyphenate.pascalcase'
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

createTag = ({ name, data, base }) ->
  name = hyphenate name
  customElements.define name, base

  if data
    (input) ->
      element = document.createElement name
      element.data ?= {}

      for key, fn of data
        value = input[key] if input
        context = { value }

        result = fn.call context
        element.data[key] = result
        element[key] = result

      element
  else
    wrap name

export { namedTag }
