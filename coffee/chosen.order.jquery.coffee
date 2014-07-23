$ = jQuery # Ensure we are using jQuery

# ////////////////////////////////////////////////
# jQuery plugin
$.fn.extend({
  getSelectionOrder: ->
    ChosenOrder.getSelectionOrder this
  setSelectionOrder: (order, force) ->
    ChosenOrder.setSelectionOrder this, order, force
})


class @ChosenOrder extends AbstractChosenOrder

  # Attribute for the rank of the option into the original Select element
  @relAttributeName = 'data-option-array-index';

  # ////////////////////////////////////////////////
  # To check if an object is a jQuery instance
  isjQueryObject = (obj) -> jQuery? and obj instanceof jQuery


  # ////////////////////////////////////////////////
  # Retrieve the raw DOM element instead of a jQuery wrapper
  parent.retrieveDOMElement = (element) ->
    if isjQueryObject element
      element.get(0)
    else
      element

  # ////////////////////////////////////////////////
  # Fire an event
  parent.triggerEvent = (target, event_name) -> $(target).trigger event_name
