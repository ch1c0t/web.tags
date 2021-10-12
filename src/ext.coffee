HTMLElement::on = HTMLElement::addEventListener

HTMLElement::emit = (name, detail) ->
  event = new CustomEvent name,
    bubbles: true
    detail: detail

  @dispatchEvent event

HTMLElement::render = (view) ->
  view ?= @view()

  if Array.isArray view
    @replaceChildren ...view
  else
    @replaceChildren view
