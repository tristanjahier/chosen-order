# ////////////////////////////////////////////////////////////////
# Prototype JS plugin
Element.addMethods
  getSelectionOrder: (element) ->
    ChosenOrder.getSelectionOrder element
  setSelectionOrder: (element, order, force) ->
    ChosenOrder.setSelectionOrder element, order, force


class @ChosenOrder extends AbstractChosenOrder

  # Attribute for the rank of the option into the original Select element
  @relAttributeName = "rel"

  # ////////////////////////////////////////////////////////////////
  # Search the Chosen UI container of a given select element
  @searchChosenUIContainer = (element) ->
    # Hypothesis: the Chosen UI container is the first sibling
    # of the raw <select> element.
    element.next(".chosen-container.chosen-container-multi")


  # ////////////////////////////////////////////////////////////////
  # Fire an event
  @triggerEvent = (target, event_name) -> Event.fire $(target), event_name
