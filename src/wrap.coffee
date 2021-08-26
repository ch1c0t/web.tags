isString = (object) ->
  (typeof object is 'string') or (object instanceof String)

element = ->
  switch arguments.length
    when 1
      name = arguments[0]
      document.createElement name
    when 2
      [name, content] = arguments
      node = document.createElement name

      if isString content
        node.innerHTML = content
      else if Array.isArray content
        node.replaceChildren ...content
      else
        attributes = content
        for name, value of attributes
          node.setAttribute name, value

      node
    when 3
      [name, attributes, content] = arguments
      node = document.createElement name

      for name, value of attributes
        node.setAttribute name, value

      if isString content
        node.innerHTML = content
      else if Array.isArray content
        node.replaceChildren ...content
      else
        console.log content
        console.error 'What to do with the above content?'

      node
    else
      console.log arguments
      console.error 'What to do with the above arguments?'

wrap = (name) ->
  (...args) ->
    element name, ...args

export { wrap }
