# PrototypeJS plugin
Element.addMethods
  getSelectionInOrder: (element) ->
    ChosenOrder.getSelectionInOrder element
  setSelectionInOrder: (element, selection) ->
    ChosenOrder.setSelectionInOrder element, selection


# PrototypeJS version of the Chosen order handler
# Adds the PrototypeJS-specific part of the library
class @ChosenOrderHandler extends ChosenOrderHandlerBase

  relAttributeName: "rel"

  # Retrieve the Chosen UI container corresponding to the <select> element
  # @return [HTMLElement] The container of the Chosen multiselect UI
  getChosenUIContainer: ->
    # Quick and easy case
    if @select.id isnt ""
      document.getElementById @select.id.replace(/-/g, "_") + "_chosen"
    else
      @select.next('.chosen-container.chosen-container-multi')

  # Triggers a custom event on a DOM element
  # @param targetElement [HTMLElement] The element to fire the event on
  # @param eventName [String] The name of the event
  triggerEvent: (targetElement, eventName) ->
    Event.fire $(targetElement), eventName
