class MyHTMLElement extends HTMLElement
  connectedCallback: ->
    @render()
    @once() if @once

  render: (template) ->
    template ?= @template()

    if Array.isArray template
      @replaceChildren ...template
    else
      @replaceChildren template

export { MyHTMLElement }
