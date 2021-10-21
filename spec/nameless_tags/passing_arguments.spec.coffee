describe 'passing arguments', ->
  SetupPage()

  beforeEach ->
    await @page.evaluate ->
      { p } = TAGS
      window.SomeName = tag
        data:
          language: -> @value or 'CoffeeScript'
          link: -> @value or 'https://github.com/ch1c0t/web.tags'
        view: ->
          p "#{@language} of #{@link}"

  it 'works when no arguments were passed', ->
    html = await @page.evaluate ->
      element = SomeName()
      document.body.appendChild element
      element.outerHTML

    that = '<div><p>CoffeeScript of https://github.com/ch1c0t/web.tags</p></div>'
    expect(html).toBe that

  it 'works when some of the arguments were passed', ->
    html = await @page.evaluate ->
      element = SomeName link: 'https://github.com/ch1c0t/wrapjsx'
      document.body.appendChild element
      element.outerHTML

    that = '<div><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></div>'
    expect(html).toBe that

  it 'works when all the arguments were passed', ->
    html = await @page.evaluate ->
      element = SomeName link: 'https://github.com/ch1c0t/hobby-rpc', language: 'Ruby'
      document.body.appendChild element
      element.outerHTML

    that = '<div><p>Ruby of https://github.com/ch1c0t/hobby-rpc</p></div>'
    expect(html).toBe that
