describe 'passing arguments', ->
  SetupPage()

  beforeEach ->
    await @page.evaluate ->
      { p } = TAGS
      tag 'SomeName',
        data:
          language: -> @value or 'CoffeeScript'
          link: -> @value or 'https://github.com/ch1c0t/web.tags'
        view: ->
          p "#{@language} of #{@link}"

  it 'works when no arguments were passed', ->
    [InitialHTML, RenderedHTML] = await @page.evaluate ->
      { SomeName } = TAGS
      element = SomeName()
      InitialHTML = element.outerHTML

      document.body.appendChild element
      RenderedHTML = element.outerHTML

      [InitialHTML, RenderedHTML]

    expect(InitialHTML).toBe  '<some-name></some-name>'
    expect(RenderedHTML).toBe '<some-name><p>CoffeeScript of https://github.com/ch1c0t/web.tags</p></some-name>'

  it 'works when some of the arguments were passed', ->
    [InitialHTML, RenderedHTML] = await @page.evaluate ->
      { SomeName } = TAGS
      element = SomeName link: 'https://github.com/ch1c0t/wrapjsx'
      InitialHTML = element.outerHTML

      document.body.appendChild element
      RenderedHTML = element.outerHTML

      [InitialHTML, RenderedHTML]

    expect(InitialHTML).toBe  '<some-name></some-name>'
    expect(RenderedHTML).toBe '<some-name><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></some-name>'

  it 'works when all the arguments were passed', ->
    [InitialHTML, RenderedHTML] = await @page.evaluate ->
      { SomeName } = TAGS
      element = SomeName link: 'https://github.com/ch1c0t/hobby-rpc', language: 'Ruby'
      InitialHTML = element.outerHTML

      document.body.appendChild element
      RenderedHTML = element.outerHTML

      [InitialHTML, RenderedHTML]

    expect(InitialHTML).toBe  '<some-name></some-name>'
    expect(RenderedHTML).toBe '<some-name><p>Ruby of https://github.com/ch1c0t/hobby-rpc</p></some-name>'
