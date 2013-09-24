# Chosen order plugin

Chosen Order is a plugin for Chosen which aims to provide functions to handle the order of the selection.

Typically, you may want to retrieve the order in which the elements were selected with Chosen. You also may want to force the order in which Chosen displays the select options. Unfortunately, Chosen does not handle that, because DOM Multiple Select elements do not have any notion of order of selection.

Created by [Tristan Jahier](http://tristan-jahier.fr).

Chosen is a library originally created by [Patrick Filler](http://patrickfiller.com) for [Harvest](http://getharvest.com/).

-------------------------

THIS SOFTWARE IS NOT ASSOCIATED WITH **HARVEST** IN ANY WAY.

-------------------------

## Compatibility

- jQuery : `1.4+`
- Prototype : `1.7.1+`
- Chosen : `1.0.0+`


## Usage

Let's say you have a select element into your page, which is handled by Chosen:

```
<select id="my-list" multiple>
	<option value="fianle" selected>Fianle</option>
	<option value="plop" selected>Plop</option>
	<option value="zorp">Zorp</option>
	<option value="catakt">Catakt</option>
	<option value="cacatac">Cacatac</option>
	<option value="nioup" selected>Nioup</option>
	<option value="ratacat-mic">Ratacat-mic</option>
</select>
```

So, you have 3 values selected : *Fianle*, *Plop* and *Nioup*. Chosen UI displays them in the order they are declared into the DOM:

![Chosen unordered elements](img/chosen_unordered.png)

Import the Javascript file in your HTML document. Choose the version which corresponds to the framework of your choice: jQuery or Prototype.

	<script type="text/javascript" src="chosen.order.jquery.min.js"></script>

or

	<script type="text/javascript" src="chosen.order.proto.min.js"></script>


Chosen Order provides 2 public functions, in 2 flavors each.

Functional way is a direct call to ChosenOrder class\* static functions.

	ChosenOrder.theFreakingFunction(element, params);

Object-oriented way is another approach that extends the objects.

	$(element).theFreakingFunction(params);

*Yes, classes do not exist in Javascript. Well, it's just a function with other functions in it.


### Retrieving the order

```
// Functional flavor
var selection = ChosenOrder.getSelectionOrder(document.getElementById('my-list'));

// Object-oriented flavor, example for jQuery plugin
var selection = $('#my-list').getSelectionOrder();
```

`getSelectionOrder()` takes no argument and **returns an array of the selected values** in the order they appear in Chosen UI.
For the above example, it should return `["fianle", "plop", "nioup"]`.

### Setting the order

```
var order = ['nioup', 'plop', 'fianle']; // Ordered options values

// Functional flavor
ChosenOrder.setSelectionOrder($('#my-list'), order);

// Object-oriented flavor, example for jQuery plugin
$('#my-list').setSelectionOrder(order);
```

`setSelectionOrder()` takes an array **an array of ordered values**.

It also takes an optional argument : `force`, which is a boolean. Default value is `false`. Set it to `true` if you plan to pass an array of ordered values that are not necessarily all selected yet.

For example, let's introduce *Cacatac* and *Ratacat-mic* and get rid of *Zorp*:

	var order = ['cacatac', 'plop', 'ratacat-mic', 'fianle'];
	$('#my-list').setSelectionOrder(order, true);

It forces the selection of the values for the Select element and Chosen UI before ordering them.

![Chosen ordered elements](img/chosen_ordered.png)


## Technical aspects

Chosen Order handles both DOM raw elements and jQuery objects. For example, these 2 lines will work:

	ChosenOrder.getSelectionOrder(document.getElementById('my-list'));
	ChosenOrder.getSelectionOrder($('#my-list'));

`setSelectionOrder()` trims the values of the order array. 
