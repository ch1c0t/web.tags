{ sleep } = require '@ch1c0t/sleep'

describe 'nameless once', ->
  SetupPage()

  it 'works', ->
    await @page.evaluate ->
      { p } = TAGS
      Some = tag
        data:
          language: -> @value or 'CoffeeScript'
          link: -> @value or 'https://github.com/ch1c0t/web.tags'
        once: ->
          @string = "#{@language} of #{@link}"
          @asynchronous = await Promise.resolve 'from Promise'
        view: ->
          @once.then =>
            p "#{@asynchronous}: #{@string}"

      window.element = Some()

    await @page.waitForTimeout 100
    html = await @page.evaluate -> element.outerHTML

    expect(html).toBe '<div><p>from Promise: CoffeeScript of https://github.com/ch1c0t/web.tags</p></div>'
