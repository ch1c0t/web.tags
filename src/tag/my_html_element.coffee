class MyHTMLElement extends HTMLElement
  connectedCallback: ->
    @render()
    @once() if @once

  render: (view) ->
    view ?= @view()

    if Array.isArray view
      @replaceChildren ...view
    else
      @replaceChildren view

export { MyHTMLElement }
