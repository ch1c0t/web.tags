namelessTag = ({ data, view, methods, once }) ->
  (input) ->
    state =
      data: {}

    for key, fn of data
      value = fn.call input[key]
      state.data[key] = value
      state[key] = value

    element = view.call state

    for key, value of state
      element[key] = value

    if methods
      for name, method of methods
        element[name] = method

    if once
      once.call element

    element

export { namelessTag }
