# PrototypeJS plugin
Element.addMethods
  getSelectionInOrder: (element) ->
    ChosenOrder.getSelectionInOrder element
  setSelectionInOrder: (element, selection) ->
    ChosenOrder.setSelectionInOrder element, selection


class ChosenOrderHandler extends AbstractChosenOrderHandler

  relAttributeName: "rel"

  getChosenUIContainer: () ->
    @select.next('.chosen-container.chosen-container-multi')

  triggerEvent: (target, event_name) ->
    Event.fire $(target), event_name


class @ChosenOrder

  @getSelectionInOrder: (element) ->
    handler = new ChosenOrderHandler(element)
    return handler.getSelectionInOrder()

  @setSelectionInOrder: (element, selection) ->
    handler = new ChosenOrderHandler(element)
    return handler.setSelectionInOrder(selection)
