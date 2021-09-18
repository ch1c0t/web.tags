HTMLElement::on = HTMLElement::addEventListener

HTMLElement::emit = (name, detail) ->
  event = new CustomEvent name,
    bubbles: true
    detail: detail

  @dispatchEvent event
