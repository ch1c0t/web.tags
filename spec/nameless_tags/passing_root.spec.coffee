describe 'passing the root element', ->
  SetupPage()

  it 'works when it is passed as a nullary function', ->
    html = await @page.evaluate ->
      { li, ul } = TAGS
      List = tag ul,
        view: ->
          [
            li 'first'
            li 'second'
          ]

      element = List()
      element.outerHTML

    that = '<ul><li>first</li><li>second</li></ul>'
    expect(html).toBe that

  it 'works when it is passed as an instance of HTMLElement', ->
    html = await @page.evaluate ->
      { li, ul } = TAGS
      element = ul()
      List = tag element,
        view: ->
          [
            li 'first'
            li 'second'
          ]

      element = List()
      element.outerHTML

    that = '<ul><li>first</li><li>second</li></ul>'
    expect(html).toBe that
