package com.unhurdle.spectrum
{
  COMPILE::JS {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
  }
  import org.apache.royale.core.IHasLabelField;
  import org.apache.royale.events.Event;
  import org.apache.royale.events.MouseEvent;
  import org.apache.royale.events.ValueEvent;
  import org.apache.royale.geom.Rectangle;
  import org.apache.royale.html.util.getLabelFromData;
  import org.apache.royale.utils.DisplayUtils;

  public class TagField extends Group implements IHasLabelField
  {
    public function TagField()
    {
      super();
      typeNames = "spectrum-Textfield-input";
      window.addEventListener('resize', calculatePosition);
    }
    
    private var input:TextField;
    private var tagGroup:TagGroup;

    public function get tags():Array
    {
    	return tagGroup.tags;
    }
    
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      var elem:WrappedHTMLElement = addElementToWrapper(this,'div');
      tagGroup = new TagGroup();
      tagGroup.setStyle("display","inline");
      tagGroup.setStyle('flex-grow','1');
      tagGroup.setStyle('flex-shrink','1');
      elem.appendChild(tagGroup.element);
      input = new TextField();
      input.setStyle("display","inline-block");
      input.addEventListener("onBackspace",removeTag);
      input.addEventListener("onEnter",inputChanged);
      input.input.style.borderStyle = "none";
      input.input.style.background = "none";
      input.tabFocusable = false;
      tagGroup.addElement(input);
      return elem;
    }

    override public function addedToParent():void{
      super.addedToParent();
      calculatePosition();
    }

    private var comboBoxList:ComboBoxList;
    private var valuesArr:Array = [];
    private var ind:Number = 0;
    private function selectValue(ev:ValueEvent):void{
      if(input.text == ""){
        updateValue();
      }
      if(!valuesArr.length){
        return;
      }
      var type:String = ev.type;
      switch(type){
        case "onArrowUp":
        case "onArrowDown":
          break;
        default:
          return;
      }
      ev.value.preventDefault();
      var move:int = type == "onArrowDown" ? 1 : -1;
      var index:int = comboBoxList.list.selectedIndex + move;
      var dataLength:int = valuesArr.length;
      if(index == dataLength){
        index = 0;
      }
      if(index == -1){
        index = dataLength - 1;
      }
      comboBoxList.list.selectedIndex = index;
      input.text = valuesArr[index];
    }
    private var updating:Boolean;
    //TODO just show and hide rather than add and remove from dom
    private function updateValue(ev:InputEvent = null):void{
      if(updating){// don't do nested updates
        return;
      }
      updating = true;
      valuesArr = [];
      var len:int = tagList.length;
      var labels:Array = labelList;
      var text:String = input.text;
      if(!text){
        valuesArr = labels.slice();
      } else {
        for each( var t:String in labels){
          if(t.toLowerCase().indexOf(input.text.toLowerCase()) == 0){
            valuesArr.push(t);
          }
        }
        if(_limitToList && !valuesArr.length && ev && ev.data){
          input.text = text.substring(0, text.length - ev.data.length);
          return updateValue();
        }
      }
      if(comboBoxList){
        comboBoxList.list.selectedIndex = -1;
        comboBoxList.list.dataProvider = valuesArr.slice();
        if(valuesArr.length){
          positionPopup();//need to position before opening because adding it to the dom changes the position
          comboBoxList.open = true;
        }else{
          comboBoxList.open = false;
        }
      }
      COMPILE::JS{
        input.input.focus();
      }
      calculatePosition();
      updating = false;
    }
    protected function handleControlMouseDown(event:MouseEvent):void{			
			event.stopImmediatePropagation();
		}
    protected function positionPopup():void{
      var componentBounds:Rectangle = DisplayUtils.getScreenBoundingRect(input);
			comboBoxList.positionPopup(componentBounds);
    }
    private function itemSelected(ev:Event):void{
      if(comboBoxList.list.selectedItem){
        addTag(comboBoxList.list.selectedItem.text);
      }
    }
    private function inputChanged():void{
      addTag(input.text);
    }
    private function addTag(text:String):void{
      if(text){
        if(comboBoxList){
          comboBoxList.open = false;
        }
        var tags:Array = tagGroup.tags;
        var len:int = tags.length;
        for(var index:int = 0; index < len; index++){
          var element:Tag = tags[index];
          if(element.text == text){
            element.setStyle("visibility","hidden");
            input.text = "";
            setTimeout(function():void{
              element.setStyle("visibility","visible");
            },100);
            return;
          }
        }
        var foundInList:Boolean = false;
        if(_limitToList){
          for each(var t:* in tagList){
            if(getLabelFromData(this,t) == text){
              foundInList = true;
              break;
            }
          }
        }
        if(!_limitToList || foundInList){
          var tag:Tag = new Tag();
          tag.deletable = true;
          tag.text = text;
          input.text = "";
          tagGroup.addTag(tag);
        }
      }
      calculatePosition();
    }

    private function calculatePosition():void {
      if(tagGroup.height > input.height){
        if(width - tagGroup.width < input.width){
          height = tagGroup.height + 50;
        } else{
          height = tagGroup.height + 30;
        }
      }else{
        height = input.height + 30;
      }
    }

    private var _tagList:Array;

    public function get tagList():Array{
    	return _tagList;
    }

    public function set tagList(value:Array):void{
    	_tagList = value;
      _labelList = null;
      if(value){
        if(!comboBoxList){
          comboBoxList = new ComboBoxList();
          comboBoxList.addEventListener('change',itemSelected);
          COMPILE::JS{
            input.addEventListener("onArrowDown",selectValue);
            input.addEventListener("onArrowUp",selectValue);
            input.element.addEventListener("input",updateValue);
            input.element.addEventListener("focus",updateValue,true);
            input.addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
          }
        } else if(comboBoxList.open){
          updateValue();
        }
      }else{
        if(comboBoxList){
          comboBoxList.removeEventListener('change',itemSelected);
        }
        comboBoxList = null;
        COMPILE::JS{
          input.removeEventListener("onArrowDown",selectValue);
          input.removeEventListener("onArrowUp",selectValue);
          input.element.removeEventListener("input",updateValue);
          input.element.removeEventListener("focus",updateValue,true);
          input.removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
        }
      }
    }
    private var _labelList:Array;

    private function get labelList():Array{
      if(!_labelList){
        _labelList = [];
        for each(var tag:* in tagList){
          _labelList.push(getLabelFromData(this,tag));
        }
      }
    	return _labelList;
    }


    private function removeTag():void{
      var tags:Array = tagGroup.tags;
      if(!input.text && tags.length){
        tagGroup.removeElement(tags[tags.length-1]);
      }
      calculatePosition();
    }
    private var _labelField:String = "label";

    public function get labelField():String{
    	return _labelField;
    }
    public function set labelField(value:String):void{
    	_labelField = value;
    }
    private var _limitToList:Boolean;

    public function get limitToList():Boolean{
    	return _limitToList;
    }
    public function set limitToList(value:Boolean):void{
    	_limitToList = value;
    }

  }
}