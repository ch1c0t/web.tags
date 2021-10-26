NamelessTag = (spec) ->
  { div } = TAGS
  NamelessTagWithRoot div, spec

NamelessTagWithRoot = (root, { data, view, once, methods }) ->
  (input) ->
    element = if root instanceof HTMLElement
      root
    else
      root()

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

    if once
      element.once = once.call element

    if view
      element.view = view
      element.render()

    element

export { NamelessTag, NamelessTagWithRoot }
