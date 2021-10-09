{ Env } = require './env.coffee'

describe 'main', ->
  beforeAll ->
    @env = Env()
    @page = await @env 'page'

  beforeEach ->
    await @page.reload()

  describe 'basic tags', ->
    it 'provides divs', ->
      await @page.evaluate ->
        { div } = window.TAGS
        element = div id: 'SomeId', 'some text'
        document.body.appendChild element

      text = await @page.evaluate ->
        div = document.getElementById 'SomeId'
        div.textContent

      expect(text).toBe 'some text'

  describe 'named tags', ->
    it 'works when no arguments were passed', ->
      await @page.evaluate ->
        { p } = TAGS
        tag 'SomeName',
          data:
            language: -> @value or 'CoffeeScript'
            link: -> @value or 'https://github.com/ch1c0t/web.tags'
          view: ->
            p "#{@language} of #{@link}"

      html = await @page.evaluate ->
        { SomeName } = TAGS
        element = SomeName()
        element.outerHTML

      that = '<some-name><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></some-name>'
      expect(html).toBe that
