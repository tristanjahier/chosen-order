# ////////////////////////////////////////////////
# Prototype JS plugin
Element.addMethods
	getSelectionOrder: (element) ->
		ChosenOrder.getSelectionOrder element
	setSelectionOrder: (element, order, force) ->
		ChosenOrder.setSelectionOrder element, order, force


class @ChosenOrder extends AbstractChosenOrder

  # Attribute for the rank of the option into the original Select element
  @relAttributeName = "rel"
  
  # ////////////////////////////////////////////////
  # Fire an event
  parent.triggerEvent = (target, event_name) -> Event.fire $(target), event_name
