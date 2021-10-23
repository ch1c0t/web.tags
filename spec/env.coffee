{ AtExit } = require 'hook.at-exit'
{ fun } = require '@ch1c0t/fun'
{ as } = require 'value.as'
{ sleep } = require '@ch1c0t/sleep'

{ spawn } = require 'child_process'
Server = fun
  init:
    path: -> @value or "#{__dirname}/pwa0/dist.dev"
    port: -> @value or 8080
  once: ->
    serve = spawn './node_modules/.bin/serve', ['-p', @port, @path]
    AtExit -> process.kill serve.pid
    sleep 200
  call: (input) ->
    await @once

    switch input
      when 'port'
        @port

puppeteer = require 'puppeteer'
Browser = fun
  init:
    headless: -> @value or no
  once: ->
    browser = await puppeteer.launch
      headless: @headless
      args: [
        '--no-sandbox'
        '--disable-setuid-sandbox'
      ]
    AtExit -> browser.close()
    @page = await browser.newPage()
  call: (input) ->
    await @once

    switch input
      when 'page'
        @page

Env = fun
  init:
    server: as Server
    browser: as Browser
  once: ->
    port = await @server 'port'
    url = "http://localhost:#{port}"

    @page = await @browser 'page'
    await @page.goto url
  call: (input) ->
    try
      await @once

      switch input
        when 'page'
          @page
    catch error
      console.log error

module.exports = { Server, Browser, Env }
