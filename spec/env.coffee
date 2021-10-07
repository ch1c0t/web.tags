{ fun } = require '@ch1c0t/fun'

# A function to value functions as types.
as = (fn) ->
  -> if @value then fn @value else fn()

{ spawn } = require 'child_process'
Server = fun
  init:
    path: -> @value or "#{__dirname}/pwa0/dist.dev"
    port: -> @value or 8080
  once: ->
    @subprocess = spawn './node_modules/.bin/serve', ['-p', @port, @path]
  call: (input) ->
    switch input
      when 'port'
        @port
      when 'end'
        process.kill @subprocess.pid
  
puppeteer = require 'puppeteer'
exports.Env = fun
  init:
    server: as Server
  once: ->
    port = @server 'port'
    url = "http://localhost:#{port}"

    @browser = await puppeteer.launch headless: no
    @page = await @browser.newPage()

    await @page.goto url
  call: (input) ->
    await @once

    switch input
      when 'page'
        @page
      when 'end'
        @browser.close()
        @server 'end'
