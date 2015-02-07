# jQuery plugin
$.fn.extend
  getSelectionInOrder: ->
    ChosenOrder.getSelectionInOrder this.get(0)
  setSelectionInOrder: (selection) ->
    ChosenOrder.setSelectionInOrder this.get(0), selection


# jQuery version of the Chosen order handler
# Adds the jQuery-specific part of the library
class @ChosenOrderHandler extends ChosenOrderHandlerBase

  relAttributeName: "data-option-array-index"

  # Retrieve the Chosen UI container corresponding to the <select> element
  getChosenUIContainer: () ->
    if $(@select).data('chosen')?
      $(@select).data('chosen').container[0]
    else
      $(@select).next('.chosen-container.chosen-container-multi').get(0)

  triggerEvent: (target, event_name) ->
    $(target).trigger event_name


# Helper class
# Provides two easy-to-use static functions
class @ChosenOrder

  @getSelectionInOrder: (element) ->
    handler = new ChosenOrderHandler(element)
    return handler.getSelectionInOrder()

  @setSelectionInOrder: (element, selection) ->
    handler = new ChosenOrderHandler(element)
    return handler.setSelectionInOrder(selection)
