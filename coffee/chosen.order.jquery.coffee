$ = jQuery # Ensure we are using jQuery

# ////////////////////////////////////////////////////////////////
# jQuery plugin
$.fn.extend({
  # Added param for added optgroup functionality for getSectionOrder and setSelectionOrder
  getSelectionOrder: (optgroup) ->
    ChosenOrder.getSelectionOrder this, optgroup
  setSelectionOrder: (order, force, optgroup) ->
    ChosenOrder.setSelectionOrder this, order, force, optgroup
})


class @ChosenOrder extends AbstractChosenOrder

  # Attribute for the rank of the option into the original Select element
  @relAttributeName = 'data-option-array-index';

  # ////////////////////////////////////////////////////////////////
  # To check if an object is a jQuery instance
  isjQueryObject = (obj) -> jQuery? and obj instanceof jQuery


  # ////////////////////////////////////////////////////////////////
  # Retrieve the raw DOM element instead of a jQuery wrapper
  parent.getDOMElement = (element) ->
    if isjQueryObject element
      element.get(0)
    else
      element


  # ////////////////////////////////////////////////////////////////
  # Search the Chosen UI container of a given select element
  parent.searchChosenUIContainer = (element) ->
    # In the case of jQuery it's quite simple... a reference to
    # the Chosen UI container is stored in jQuery "data"
    if $(element).data("chosen")?
      $(element).data("chosen").container[0]
    else
      $(element).next(".chosen-container.chosen-container-multi").get(0)


  # ////////////////////////////////////////////////////////////////
  # Fire an event
  parent.triggerEvent = (target, event_name) -> $(target).trigger event_name
