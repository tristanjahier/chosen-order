# ////////////////////////////////////////////////////////////////
# Prototype JS plugin
Element.addMethods
  getSelectionOrder: (element, optgroup) ->
    ChosenOrder.getSelectionOrder element, optgroup
  setSelectionOrder: (element, order, force, optgroup) ->
    ChosenOrder.setSelectionOrder element, order, force, optgroup


class @ChosenOrder extends AbstractChosenOrder

  # Attribute for the rank of the option into the original Select element
  @relAttributeName = "rel"

  # ////////////////////////////////////////////////////////////////
  # Search the Chosen UI container of a given select element
  parent.searchChosenUIContainer = (element) ->
    # Hypothesis: the Chosen UI container is the first sibling
    # of the raw <select> element.
    element.next(".chosen-container.chosen-container-multi")


  # ////////////////////////////////////////////////////////////////
  # Fire an event
  parent.triggerEvent = (target, event_name) -> Event.fire $(target), event_name
