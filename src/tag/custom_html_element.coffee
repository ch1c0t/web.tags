class CustomHTMLElement extends HTMLElement
  connectedCallback: ->
    if @onceFunction
      @once = @onceFunction()
      @onceFunction = no
    @render()

export { CustomHTMLElement }
