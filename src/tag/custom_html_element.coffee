class CustomHTMLElement extends HTMLElement
  connectedCallback: ->
    @render()
    @once() if @once

export { CustomHTMLElement }
