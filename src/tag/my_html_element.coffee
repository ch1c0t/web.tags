class MyHTMLElement extends HTMLElement
  connectedCallback: ->
    @render()
    @once() if @once

export { MyHTMLElement }
