# Chosen Order plug-in

Chosen Order is a plugin for [Chosen](https://github.com/harvesthq/chosen) which lets you handle the order of selection.

Typically, when using a multiple `<select>` element with Chosen, you may want to retrieve the selection in the order the options were selected. You may also want to force the selection in a specific order. Unfortunately, this is not natively possible with Chosen ([more info here](https://github.com/harvesthq/chosen/issues/1847)). Chosen Order does the job.

Created by [Tristan Jahier](http://tristan-jahier.fr).

---

THIS SOFTWARE IS NOT ASSOCIATED WITH **HARVEST** IN ANY WAY.

Chosen is a library originally created by [Patrick Filler](http://patrickfiller.com) for [Harvest](http://getharvest.com/).

---


## Compatibility

- Chosen : `1.0.0+`
- jQuery : `1.4+`
- Prototype : `1.7.1+`

### Internet Explorer 8

Chosen Order is now compatible with IE8, but you'll still need to add the [es5-shim](https://github.com/es-shims/es5-shim) script to your page in order to make it work.

```html
<!--[if lte IE 8]>
    <script type="text/javascript" src="workingdirectory/vendor/es5-shim.min.js"></script>
<![endif]-->
```

## Demo

You can see a live demonstration of the plugin at : [http://labo.tristan-jahier.fr/chosen_order](http://labo.tristan-jahier.fr/chosen_order)

#### Hey! Demo in `public` directory does not work!!!

This is probably because you browser cannot find the JavaScript files. Indeed, there is no compiled sources in this repository. You must use the `grunt` command to compile the project, and a task will fill this directory with the freshly built JavaScript files.

If you have no idea what I'm talking about, just download a release package of Chosen Order.

#### JsFiddle

For demonstration purpose, there is also 2 live examples on JsFiddle:

- jQuery: [http://jsfiddle.net/oj3cjw9w](http://jsfiddle.net/oj3cjw9w)
- Prototype: [http://jsfiddle.net/ch5bjh53](http://jsfiddle.net/ch5bjh53)


## Usage

Download a release package of Chosen Order to get the compiled JavaScript files (development and minified versions are available), or compile the project yourself with Grunt.

Firstly, import the version corresponding to the framework of your choice:

```html
<script type="text/javascript" src="chosen.order.jquery.min.js"></script>
<!-- OR -->
<script type="text/javascript" src="chosen.order.proto.min.js"></script>
```

For example, let's say you have this `<select>` element in your document, which is handled by Chosen:

```html
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

There are 3 options selected. By default, Chosen displays them in the order they are declared in the DOM:

![Chosen Order example 1](img/chosen_unordered.png)

---

For each of the following public API methods, you have 2 ways to access it:

- **Static helper** (direct call to the static helper class `ChosenOrder`)

	```javascript
	ChosenOrder.myAwesomeFunction(element, params);
	```

- **Object-oriented** (use the framework object extension system – example with jQuery here)

	```javascript
	$(element).myAwesomeFunction(params);
	```

---


### Retrieving the order

`getSelectionInOrder()` returns an array of the selected option values in the order they appear visually.

```javascript
// Static
var selection = ChosenOrder.getSelectionInOrder(document.getElementById('my-list'));
// Object-oriented – example with jQuery
var selection = $('#my-list').getSelectionInOrder();
```

In the example above, it should return `["fianle", "plop", "nioup"]`.


### Setting the order

`setSelectionInOrder()` takes an array of option values.

```javascript
var selection = ["cacatac", "plop", "ratacat-mic", "fianle"]; // Ordered option values

// Static
ChosenOrder.setSelectionInOrder(document.getElementById('my-list'), selection);
// Object-oriented – example with jQuery
$('#my-list').setSelectionInOrder(selection);
```

In the example above, the Chosen UI should now display something like this:
![Chosen Order example 2](img/chosen_ordered.png)


### Binding selection retrieval on Chosen `change` event

If you try to retrieve the selection order as it changes by listening to the `change` event, you'll run into an issue. For example:

```javascript
$('#my_select').chosen().change(function() {
    // Get selection and display...
});
```

Every time you'll remove an element from the select, the last selection (before the removal) will be retrieved. Indeed, the callback is called before the DOM is actually updated and the option removed. That's why the script computes a false order. There is a *race condition*.

[Demonstration of the problem](http://jsfiddle.net/9sfq9oqt/2)

**@jgoyvaerts** reported this issue and shared a trick for this: simply use `setTimeout(myFunc, 0)` instead to move the call to the end of the event stack.

```javascript
$('#my_select').chosen().change(function() {
    setTimeout(function() {
        // Get selection and display...
    }, 0);
});
```

[Demonstration of the solution](http://jsfiddle.net/9sfq9oqt/1)

*If you have a better solution for this issue, please contact me.*
