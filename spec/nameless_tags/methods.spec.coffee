describe 'nameless methods', ->
  SetupPage()

  it 'works', ->
    width = await @page.evaluate ->
      { button } = TAGS
      Some = tag
        once: ->
          @style.width = '0px'
        view: ->
          button onclick: 'this.parentNode.toggle()'
        methods:
          toggle: ->
            if @style.width is '0px'
              @style.width = '100%'
            else
              @style.width = '0px'

      element = Some()
      element.toggle()
      element.style.width

    expect(width).toBe '100%'
