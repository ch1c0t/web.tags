{ fun } = require '@ch1c0t/fun'

# A function to value functions as types.
as = (fn) ->
  -> if @value then fn @value else fn()

SIGNALS = [
  'exit'
  'SIGINT'
  'SIGUSR1'
  'SIGUSR2'
  'uncaughtException'
  'SIGTERM'
]

run = (fn) ->
  (signal) ->
    process.on signal, fn

AtExit = (fn) ->
  SIGNALS.forEach run fn

{ spawn } = require 'child_process'
Server = fun
  init:
    path: -> @value or "#{__dirname}/pwa0/dist.dev"
    port: -> @value or 8080
  once: ->
    @subprocess = spawn './node_modules/.bin/serve', ['-p', @port, @path]
    AtExit => process.kill @subprocess.pid
  call: (input) ->
    switch input
      when 'port'
        @port

puppeteer = require 'puppeteer'
Browser = fun
  init:
    headless: -> @value or no
  once: ->
    browser = await puppeteer.launch headless: @headless
    AtExit -> browser.close()
    @page = await browser.newPage()
  call: (input) ->
    await @once

    switch input
      when 'page'
        @page

exports.Env = fun
  init:
    server: as Server
    browser: as Browser
  once: ->
    port = @server 'port'
    url = "http://localhost:#{port}"

    @page = await @browser 'page'
    await @page.goto url
  call: (input) ->
    await @once

    switch input
      when 'page'
        @page
