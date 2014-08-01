class AbstractChosenOrder

  # Plugin errors messages
  ERRORS = {
    invalid_select_element: "ChosenOrder::{{function}}: first argument must be a valid HTML Multiple Select element that has been Chosenified!",
    invalid_selection_array: "ChosenOrder::{{function}}: second argument must be an Array!",
    unreachable_chosen_container: "ChosenOrder::{{function}}: could not find the Chosen UI container! To solve the problem, try adding an \"id\" attribute to your <select> element."
  }


  # ////////////////////////////////////////////////////////////////
  # Insert an element at a special position among the children of a node
  insertAt = (node, index, parent) ->
    parent.insertBefore node, parent.children[index].nextSibling


  # ////////////////////////////////////////////////////////////////
  # Check if one element is a valid multiple select
  isValidMultipleSelectElement = (element) ->
    element isnt null               and
    typeof element isnt "undefined" and
    element.nodeName is "SELECT"    and
    element.multiple


  # ////////////////////////////////////////////////////////////////
  # Retrieve Chosen UI Element for a given select element
  getChosenUIContainer = (select) ->
    # Quick and easy case
    if select.id isnt ""
      document.getElementById select.id.replace(/-/g, "_") + "_chosen"
    # Tricky case, try to identify the container without any ID...
    else
      searchChosenUIContainer(select)


  # ////////////////////////////////////////////////////////////////
  # Check if a select element has been chosenified
  # /!\ Relies firstly on the ID. If there is no "id" attribute,
  # it tries to retrieve the Chosen container by a less reliable way
  isChosenified = (select) -> getChosenUIContainer(select)?


  # ////////////////////////////////////////////////////////////////
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


  # ////////////////////////////////////////////////////////////////
  # Retrieve order of the <select> <options>
  @getSelectionOrder = (select) ->
    select = getDOMElement select if getDOMElement? # Ensure to handle a true DOM element
    order = []

    unless isValidMultipleSelectElement(select)
      console.error ERRORS.invalid_select_element.replace('{{function}}', 'getSelectionOrder')
      return order

    chosen_ui = getChosenUIContainer(select)
    unless chosen_ui?
      console.error ERRORS.unreachable_chosen_container.replace('{{function}}', 'getSelectionOrder')
      return order

    chosen_options = chosen_ui.getElementsByClassName 'search-choice'

    for opt in chosen_options
      close_btn = opt.getElementsByClassName('search-choice-close')[0]
      rel = close_btn.getAttribute(@relAttributeName) if close_btn?
      options = Array::filter.call select.childNodes, (o) -> o.nodeName is 'OPTION'
      option = options[rel]
      order.push option.value

    return order


  # ////////////////////////////////////////////////////////////////
  # Change Chosen elements position to match the order
  # @param force : boolean  Force the exact matching of the elements and the selection order
  @setSelectionOrder = (select, order, force) ->
    select = getDOMElement select if getDOMElement? # Ensure to handle a true DOM element

    unless isValidMultipleSelectElement(select)
      console.error ERRORS.invalid_select_element.replace('{{function}}', 'setSelectionOrder')
      return

    chosen_ui = getChosenUIContainer(select)
    unless chosen_ui?
      console.error ERRORS.unreachable_chosen_container.replace('{{function}}', 'setSelectionOrder')
      return

    if order instanceof Array
      order = order.map(Function::call, String::trim)

      # Ensure that all elements in the order list are actually selected
      forceSelection.call select, order if force? and force is true

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
