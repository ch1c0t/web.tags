{ Env } = require '../env.coffee'

ENV = Env()

global.SetupPage = ->
  beforeEach ->
    @page = await ENV 'page'
    await @page.reload()
