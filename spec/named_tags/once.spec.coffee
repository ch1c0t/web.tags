describe 'named once', ->
  SetupPage()

  it 'works', ->
    await @page.evaluate ->
      { p } = TAGS
      tag 'SomeName',
        data:
          language: -> @value or 'CoffeeScript'
          link: -> @value or 'https://github.com/ch1c0t/web.tags'
        once: ->
          @string = "#{@language} of #{@link}"
          @asynchronous = await Promise.resolve 'from Promise'
        view: ->
          @once.then =>
            p "#{@asynchronous}: #{@string}"

      { SomeName } = TAGS
      window.element = SomeName()
      document.body.render element

    await @page.waitForTimeout 100
    html = await @page.evaluate -> element.outerHTML

    expect(html).toBe '<some-name><p>from Promise: CoffeeScript of https://github.com/ch1c0t/web.tags</p></some-name>'
