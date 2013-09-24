class AbstractChosenOrder

  # Plugin errors messages
  ERRORS = {
    invalid_select_element: "ChosenOrder::{{function}}: first argument must be a valid HTML Multiple Select element that has been Chosenified!",
    invalid_selection_array: "ChosenOrder::{{function}}: second argument must be an Array!"
  }


  # ////////////////////////////////////////////////
  # Insert an element at a special position among the children of a node
  insertAt = (node, index, parent) ->
    parent.insertBefore node, parent.children[index].nextSibling


  # ////////////////////////////////////////////////
  # Check if one element is a valid multiple select
  validMultipleSelectElement = (element) ->
    element isnt null               and
    typeof element isnt "undefined" and
    element.nodeName is "SELECT"    and
    element.multiple


  # ////////////////////////////////////////////////
  # Retrieve Chosen UI Element for a given select element
  getChosenUIElement = (select) ->
    document.getElementById select.id.replace(/-/g, "_") + "_chosen"


  # ////////////////////////////////////////////////
  # Check if a select element has been chosenified
  # /!\ Rely on the ID. That means you must attribute an ID to every select element
  # you want to retrieve the selection order
  isChosenified = (select) -> getChosenUIElement(select)?


  # ////////////////////////////////////////////////
  # Force the Chosen selection to the one given in argument
  forceSelection = (selection) ->
    options = @children
    i = 0
    while i < options.length
      opt = options[i]
      if opt.getAttribute("value") in selection
        opt.selected = true
        opt.setAttribute "selected", ""
      else
        opt.selected = false
        opt.removeAttribute "selected"
      i++
    triggerEvent this, "chosen:updated"


  # ////////////////////////////////////////////////
  # Retrieve order of the <select> <options>
  @getSelectionOrder = (select) ->
    select = retrieveDOMElement select if retrieveDOMElement? # Ensure to handle a true DOM element
    if validMultipleSelectElement(select) and isChosenified(select)
      chosen_ui = getChosenUIElement select
      chosen_options = chosen_ui.getElementsByClassName 'search-choice'
      order = []

      for opt in chosen_options
        close_btn = opt.getElementsByClassName('search-choice-close')[0]
        rel = close_btn.getAttribute(@relAttributeName) if close_btn?
        options = Array::filter.call select.childNodes, (o) -> o.nodeName is 'OPTION'
        option = options[rel]
        order.push option.value

      return order
    else
      console.error ERRORS.invalid_select_element.replace('{{function}}', 'getSelectionOrder')


  # ////////////////////////////////////////////////
  # Change Chosen elements position to match the order
  # @param force : boolean  Force the exact matching of the elements and the selection order
  @setSelectionOrder = (select, order, force) ->
    select = retrieveDOMElement select if retrieveDOMElement? # Ensure to handle a true DOM element
    if validMultipleSelectElement(select) and isChosenified(select)
      if order instanceof Array
        order = order.map(Function::call, String::trim)

        # Ensure that all elements in the order list are actually selected
        forceSelection.call select, order if force? and force is true

        chosen_ui = getChosenUIElement select

        for opt, i in order
          rel = Array::indexOf.call(select, select.querySelector("option[value=\"" + opt + "\"]"))
          chosen_options = chosen_ui.getElementsByClassName 'search-choice'
          relAttributeName = @relAttributeName
          option = Array::filter.call(chosen_options, (o) ->
            o.querySelector("a.search-choice-close[" + relAttributeName + "=\"" + rel + "\"]")?
          )[0]
          chosen_choices = chosen_ui.querySelector("ul.chosen-choices")
          insertAt option, i, chosen_ui.querySelector('ul.chosen-choices')

      else
        console.error ERRORS.invalid_selection_array.replace('{{function}}', 'setSelectionOrder')
    else
      console.error ERRORS.invalid_select_element.replace('{{function}}', 'setSelectionOrder')
