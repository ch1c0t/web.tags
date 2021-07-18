{ wrap } = require './wrap'

hyphenate = (string) ->
  string
    .split /([A-Z][a-z]+)/
    .filter Boolean
    .map Function::call, String::toLowerCase
    .join '-'

class MyHTMLElement extends HTMLElement
  render: (object) ->
    if Array.isArray object
      @replaceChildren ...object
    else
      @replaceChildren object

window.tag = (name, spec) ->
  el = class extends MyHTMLElement

  if spec.connected
    el::connectedCallback = spec.connected

  if spec.methods
    for n, m of spec.methods
      el::[n] = m

  hyphenated = hyphenate name
  customElements.define hyphenated, el
  TAGS[name] = wrap hyphenated
