# Base class for a Chosen order handler
#
# @version 2.0.0-dev
# @author Tristan Jahier
# @copyright 2013-2015
class ChosenOrderHandlerBase


  # Errors collection. Contains all error messages output by the script.
  # Static member (shared by every instance)
  ERRORS:
    invalid_select_element:    "ChosenOrder::{{function}}: first argument must be a valid HTML Multiple Select element that has been Chosenified!"
    invalid_selection_array:   "ChosenOrder::{{function}}: second argument must be an Array!"
    notfound_chosen_container: "ChosenOrder::{{function}}: could not find the Chosen UI container! To solve the problem, try adding an \"id\" attribute to your <select> element."


  # Construct a new handler
  # @param select [HTMLElement] The <select> element
  constructor: (@select) ->


  # Helper function to output errors in the Javascript console
  # @param errorName [String] The slug name of the error
  # @param functioName [String] The name of the function where it happens
  displayError: (errorName, functionName) ->
    console.error @ERRORS[errorName].replace('{{function}}', functionName)


  # Check if one element is a valid multiple select
  # @return [Boolean] whether the input element is valid or not
  isValidMultipleSelectElement: ->
    @select isnt null                          and
    typeof @select isnt "undefined"            and
    @select.nodeName.toUpperCase() is "SELECT" and
    @select.multiple?


  # Flatten an array of <option> and <optgroup> to have the same relative indexes
  # than Chosen UI
  # @return [Array] a flattened array of options and option groups
  getFlattenedOptionsAndGroups: ->
    options = Array::filter.call @select.childNodes,
                                 (o) -> o.nodeName.toUpperCase() in ['OPTION', 'OPTGROUP']
    flattened_options = []

    for opt in options
      flattened_options.push opt
      if opt.nodeName.toUpperCase() is 'OPTGROUP'
        # If it's an <optgroup>, collect every inner <option> too
        sub_options = Array::filter.call opt.childNodes,
                                         (o) -> o.nodeName.toUpperCase() is 'OPTION'
        for sub_opt in sub_options
          flattened_options.push sub_opt

    return flattened_options


  # Force the Chosen UI to display the given selection, without any notion of order
  # @param selection [Array] an array of <option> values
  forceSelection: (selection) ->
    options = @getFlattenedOptionsAndGroups()
    i = 0
    while i < options.length
      opt = options[i]
      if opt.getAttribute('value') in selection
        opt.selected = true
        opt.setAttribute 'selected', ""
      else
        opt.selected = false
        opt.removeAttribute 'selected'
      i++
    @triggerEvent(@select, 'chosen:updated')


  # Insert an element at a special position among the children of a node
  # @param node [HTMLElement] the element to insert
  # @param index [Integer] target position of the element
  # @param parentNode [HTMLElement] parent element where element is inserted
  insertAt: (node, index, parentNode) ->
    parentNode.insertBefore(node, parentNode.children[index].nextSibling)


  # Retrieve the selection of the <select> element, in the order it appears
  # visually in the Chosen UI
  # @return [Array] ordered selection
  getSelectionInOrder: ->
    selection = []

    unless @isValidMultipleSelectElement()
      @displayError('invalid_select_element', 'getSelectionInOrder')
      return []

    chosen_ui = @getChosenUIContainer()
    unless chosen_ui?
      @displayError('notfound_chosen_container', 'getSelectionInOrder')
      return []

    chosen_options = chosen_ui.querySelectorAll '.search-choice'

    # This is mandatory because of the weird relative indexation
    # of the <select> options in the Chosen UI...
    options = @getFlattenedOptionsAndGroups()

    for opt in chosen_options
      close_btn = opt.querySelectorAll('.search-choice-close')[0]
      rel = close_btn.getAttribute(@relAttributeName) if close_btn?
      option = options[rel]
      selection.push option.value

    return selection


  # Change Chosen elements position to match the order
  # @param selection [Array] the new ordered selection to display
  # @return [Boolean] whether it succeeded or not
  setSelectionInOrder: (selection) ->
    unless @isValidMultipleSelectElement()
      @displayError('invalid_select_element', 'setSelectionInOrder')
      return false

    chosen_ui = @getChosenUIContainer()
    unless chosen_ui?
      @displayError('notfound_chosen_container', 'setSelectionInOrder')
      return false

    unless selection instanceof Array
      @displayError('invalid_selection_array', 'setSelectionInOrder')
      return false

    selection = selection.map(Function::call, String::trim)
    options = @getFlattenedOptionsAndGroups()

    # Ensure that all elements in the selection list are actually selected
    @forceSelection selection

    for opt_val, i in selection
      # Search the relative index of the option in the <select> element
      rel = null
      for opt, j in options
        rel = j if opt.value is opt_val

      chosen_options = chosen_ui.querySelectorAll '.search-choice'
      option = Array::filter.call(chosen_options, (o) ->
        o.querySelector("a.search-choice-close[#{@relAttributeName}=\"#{rel}\"]")?
      , @)[0]

      # Move the option to its desired position
      @insertAt(option, i, chosen_ui.querySelector('ul.chosen-choices'))

    return true
