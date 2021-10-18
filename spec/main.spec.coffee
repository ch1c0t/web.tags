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
    describe 'passing arguments', ->
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

  describe 'nameless tags', ->
    describe 'passing the root element', ->
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

    describe 'passing arguments', ->
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
