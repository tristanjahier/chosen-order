# PrototypeJS version of the Chosen order handler
# Adds the PrototypeJS-specific part of the library
class @ChosenOrderHandler extends ChosenOrderHandlerBase

  relAttributeName: "rel"

  # Triggers a custom event on a DOM element
  # @param targetElement [HTMLElement] The element to fire the event on
  # @param eventName [String] The name of the event
  triggerEvent: (targetElement, eventName) ->
    Event.fire $(targetElement), eventName


# //////////////////////////////////////////////////////////////////////////////

# PrototypeJS plugin
Element.addMethods
  getSelectionInOrder: (element) ->
    ChosenOrder.getSelectionInOrder element
  setSelectionInOrder: (element, selection) ->
    ChosenOrder.setSelectionInOrder element, selection
