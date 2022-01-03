package com.unhurdle.spectrum
{
	COMPILE::JS{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import com.unhurdle.spectrum.const.IconType;
	import org.apache.royale.html.elements.Span;
	import org.apache.royale.events.Event;
	/**
	 *  Dispatched when the user checks or un-checks the CheckBox.
	 *
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	public class CheckBox extends SpectrumBase
	{
	/**
	 * <inject_html>
	 * <link rel="stylesheet" href="assets/css/components/checkbox/dist.css">
	 * </inject_html>
	 * 
	 */

		public function CheckBox()
		{
			super();
		}
		override protected function getSelector():String{
			return "spectrum-Checkbox";
		}

		COMPILE::JS
		override public function addedToParent():void{
			if(!input){
				initialize();
			}
			super.addedToParent();
		}

		COMPILE::JS
		protected function initialize():void{
			var elem:WrappedHTMLElement = element;
			input = newElement("input") as HTMLInputElement;
			input.type = "checkbox";
			input.className = appendSelector("-input");
			input.onclick = elementClicked;
			elem.appendChild(input);
			var spanBox:Span = new Span();
			spanBox.element.className = appendSelector("-box");
			var type:String = IconType.CHECKMARK_SMALL;
			var icon:Icon = new Icon(Icon.getCSSTypeSelector(type));
			icon.type = type;
			icon.className = appendSelector("-checkmark");
			spanBox.addElement(icon);
			type = IconType.DASH_SMALL;
			icon = new Icon(Icon.getCSSTypeSelector(type));
			icon.type = type;
			icon.className = appendSelector("-partialCheckmark");
			spanBox.addElement(icon);
			elem.appendChild(spanBox.element);

			// set values
			input.disabled = disabled;
			input.checked = checked;
			if(text){
				setText(text);
			}

		}
		private var input:HTMLInputElement;

		private function elementClicked():void{
			indeterminate = false;
			checked = !checked;
		}
		private var spanLabel:TextNode;

		private var _text:String = "";
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			COMPILE::JS
			{
				if(input && _text != value){
					setText(value);
				}
			}
			_text = value;
		}
		
		COMPILE::JS
		protected function setText(value:String):void{
			if(!spanLabel){
				spanLabel = new TextNode("span");
				spanLabel.className = appendSelector("-label");
				/**
				 * A fix for https://github.com/adobe/spectrum-css/issues/1029 - 
				 * Checkbox css no longer has ellipsis for overset label
				 * Truncated labels are necessary for panels with limited space.
				 */
				if(truncate){
					spanLabel.element.style.textOverflow = "ellipsis";
					spanLabel.element.style.overflow = "hidden";
					spanLabel.element.style.whiteSpace = "nowrap";
				}
				element.appendChild(spanLabel.element);
			}
			spanLabel.text = value;
		}
		private var _truncate:Boolean;

		public function get truncate():Boolean
		{
			return _truncate;
		}

		public function set truncate(value:Boolean):void
		{
			COMPILE::JS
			{
				if(spanLabel){
					if(value){
						spanLabel.element.style.textOverflow = "ellipsis";
						spanLabel.element.style.overflow = "hidden";
						spanLabel.element.style.whiteSpace = "nowrap";
					} else {
						spanLabel.element.style.removeProperty("text-overflow");
						spanLabel.element.style.removeProperty("overflow");
						spanLabel.element.style.removeProperty("white-space");
					}
				}
			}
			_truncate = value;
		}
		private var _invalid:Boolean;

		public function get invalid():Boolean
		{
			return _invalid;
		}

		public function set invalid(value:Boolean):void
		{
			if(value != !!_invalid){
				toggle("is-invalid",value);
			}
			_invalid = value;
		}
		private var _indeterminate:Boolean;

		public function get indeterminate():Boolean
		{
			return _indeterminate;
		}

		public function set indeterminate(value:Boolean):void
		{
			if(value != !!_indeterminate){
				toggle("is-indeterminate",value);
				checked = false;
			}
			_indeterminate = value;
		}
		private var _disabled:Boolean;

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			if(value != !!_disabled){
				toggle("is-disabled",value);
				if(input){
					input.disabled = value;
				}
			}
			_disabled = value;
		}
		private var _checked:Boolean;
		[Bindable]
		public function get checked():Boolean
		{
			return _checked;
		}

		public function set checked(value:Boolean):void
		{
			if(value != !!_checked){
				if(input){
					input.checked = value;
				}
				indeterminate = false;
			}
			_checked = value;
		dispatchEvent(new Event("change"));
		}
		private var _quiet:Boolean;

		public function get quiet():Boolean
		{
			return _quiet;
		}

		public function set quiet(value:Boolean):void
		{
			if(value != !!_quiet){
				toggle(valueToSelector("quiet"),value);
			}
			_quiet = value;
		}
	}
}
