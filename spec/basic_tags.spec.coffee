describe 'basic tags', ->
  SetupPage()

  it 'provides divs', ->
    await @page.evaluate ->
      { div } = window.TAGS
      element = div id: 'SomeId', 'some text'
      document.body.appendChild element

    text = await @page.evaluate ->
      div = document.getElementById 'SomeId'
      div.textContent

    expect(text).toBe 'some text'
