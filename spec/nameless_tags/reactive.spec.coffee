describe 'nameless reactivity', ->
  SetupPage()

  beforeEach ->
    await @page.evaluate ->
      { p } = TAGS
      Some = tag
        data:
          language: -> @value or 'CoffeeScript'
          link: -> @value or 'https://github.com/ch1c0t/web.tags'
        view: ->
          p "#{@language} of #{@link}"

      window.ROOT = Some()

  it 'updates the data when some of its datum changes', ->
    data = await @page.evaluate ->
      ROOT.language = 'Ruby'
      ROOT.data

    expect(data).toEqual
      language: 'Ruby'
      link: 'https://github.com/ch1c0t/web.tags'
