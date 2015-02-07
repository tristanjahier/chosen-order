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
  getChosenUIContainer: () ->
    @select.next('.chosen-container.chosen-container-multi')

  triggerEvent: (target, event_name) ->
    Event.fire $(target), event_name


# Helper class
# Provides two easy-to-use static functions
class @ChosenOrder

  @getSelectionInOrder: (element) ->
    handler = new ChosenOrderHandler(element)
    return handler.getSelectionInOrder()

  @setSelectionInOrder: (element, selection) ->
    handler = new ChosenOrderHandler(element)
    return handler.setSelectionInOrder(selection)
