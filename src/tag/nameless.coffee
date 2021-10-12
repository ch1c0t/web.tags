namelessTag = ({ data, view, methods, once }) ->
  (input) ->
    element = document.createElement 'div'
    element.data ?= {}

    for key, fn of data
      value = input[key] if input
      context = { value }

      result = fn.call context
      element.data[key] = result
      element[key] = result

    if methods
      for name, method of methods
        element[name] = method

    if view
      element.view = view
      element.render()

    if once
      once.call element

    element

export { namelessTag }
