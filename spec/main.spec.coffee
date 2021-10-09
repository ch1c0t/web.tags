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
      html = await @page.evaluate ->
        { SomeName } = TAGS
        element = SomeName()
        element.outerHTML

      that = '<some-name><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></some-name>'
      expect(html).toBe that

    it 'works when some of the arguments were passed', ->
      html = await @page.evaluate ->
        { SomeName } = TAGS
        element = SomeName link: 'https://github.com/ch1c0t/wrapjsx'
        element.outerHTML

      that = '<some-name><p>CoffeeScript of https://github.com/ch1c0t/wrapjsx</p></some-name>'
      expect(html).toBe that

    it 'works when all the arguments were passed', ->
      html = await @page.evaluate ->
        { SomeName } = TAGS
        element = SomeName link: 'https://github.com/ch1c0t/hobby-rpc', language: 'Ruby'
        element.outerHTML

      that = '<some-name><p>Ruby of https://github.com/ch1c0t/hobby-rpc</p></some-name>'
      expect(html).toBe that
