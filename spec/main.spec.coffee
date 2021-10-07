{ Env } = require './env.coffee'

describe 'main', ->
  beforeAll ->
    @env = Env()
    @page = await @env 'page'

  beforeEach ->
    await @page.reload()

  it 'provides divs', ->
    await @page.evaluate ->
      { div } = window.TAGS
      element = div id: 'SomeId', 'some text'
      document.body.appendChild element

    text = await @page.evaluate ->
      div = document.getElementById 'SomeId'
      div.textContent

    expect(text).toBe 'some text'

  afterAll ->
    await @env 'end'
