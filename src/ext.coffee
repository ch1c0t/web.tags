HTMLElement::on = HTMLElement::addEventListener

HTMLElement::emit = (name, detail) ->
  event = new CustomEvent name,
    bubbles: true
    detail: detail

  @dispatchEvent event

HTMLElement::render = (view) ->
  view ?= @view()

  if typeof view.then is 'function'
    view.then (view) => @render view
  else
    if Array.isArray view
      @replaceChildren ...view
    else
      @replaceChildren view
