# jQuery plugin
$.fn.extend
  getSelectionInOrder: ->
    ChosenOrder.getSelectionInOrder this.get(0)
  setSelectionInOrder: (selection) ->
    ChosenOrder.setSelectionInOrder this.get(0), selection


class ChosenOrderHandler extends AbstractChosenOrderHandler

  relAttributeName: "data-option-array-index"

  getChosenUIContainer: () ->
    if $(@select).data('chosen')?
      $(@select).data('chosen').container[0]
    else
      $(@select).next('.chosen-container.chosen-container-multi').get(0)

  triggerEvent: (target, event_name) ->
    $(target).trigger event_name


class @ChosenOrder

  @getSelectionInOrder: (element) ->
    handler = new ChosenOrderHandler(element)
    return handler.getSelectionInOrder()

  @setSelectionInOrder: (element, selection) ->
    handler = new ChosenOrderHandler(element)
    return handler.setSelectionInOrder(selection)
