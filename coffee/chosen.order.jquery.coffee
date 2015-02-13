# jQuery version of the Chosen order handler
# Adds the jQuery-specific part of the library
class @ChosenOrderHandler extends ChosenOrderHandlerBase

  relAttributeName: "data-option-array-index"

  # Retrieve the Chosen UI container corresponding to the <select> element
  # @return [HTMLElement] The container of the Chosen multiselect UI
  getChosenUIContainer: ->
    # Quick and easy case
    if @select.id isnt ""
      document.getElementById @select.id.replace(/-/g, "_") + "_chosen"
    else if $(@select).data('chosen')?
      $(@select).data('chosen').container[0]
    else
      $(@select).next('.chosen-container.chosen-container-multi').get(0)

  # Triggers a custom event on a DOM element
  # @param targetElement [HTMLElement] The element to fire the event on
  # @param eventName [String] The name of the event
  triggerEvent: (targetElement, eventName) ->
    $(targetElement).trigger eventName


# //////////////////////////////////////////////////////////////////////////////

# jQuery plugin
$.fn.extend
  getSelectionInOrder: ->
    ChosenOrder.getSelectionInOrder this.get(0)
  setSelectionInOrder: (selection) ->
    ChosenOrder.setSelectionInOrder this.get(0), selection
