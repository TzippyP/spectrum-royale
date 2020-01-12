package com.unhurdle.spectrum.renderers
{
  import org.apache.royale.html.util.getLabelFromData;
  import com.unhurdle.spectrum.TextNode;
  import com.unhurdle.spectrum.Icon;

  COMPILE::JS
  {
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
  }
  import com.unhurdle.spectrum.Application;
  import com.unhurdle.spectrum.const.IconType;
  import com.unhurdle.spectrum.const.IconSize;
  import com.unhurdle.spectrum.ImageIcon;
  import com.unhurdle.spectrum.data.IListItem;

  public class ListItemRenderer extends DataItemRenderer
  {
    public function ListItemRenderer()
    {
      super();
      typeNames = appendSelector('-item');
    }
    override protected function getSelector():String{
      return "spectrum-SideNav";
    }

		// override public function updateRenderer():void{
    //   COMPILE::JS
    //   {
    //     // Hover is handled by the css classes
		// 		if (selected){
		// 			element.style.backgroundColor = Application.getSelectionColor();
    //       element.style.color = "#FFFFFF";
    //     } else {
    //       element.style.backgroundColor = null;
    //       element.style.color = null
    //     }

    //   }
    // }

    override public function set data(value:Object):void{
      super.data = value;
      textNode.text = getLabelFromData(this,value);
      COMPILE::JS
      {
        var iconSelector:String = getIconSelector();
        if(iconSelector){
          if(!icon){
            icon = new Icon(iconSelector);
            addElementAt(icon,0);
          } else {
            icon.setStyle("display",null);
            icon.selector = iconSelector;
          }
        } else if(icon){
          icon.setStyle("display","none");
        }
        
        var iconSrc:String = getImageIcon();
        if(iconSrc){
          if(!imageIcon){
            imageIcon = new ImageIcon(iconSrc);
            addElementAt(imageIcon,0);
          } else {
            imageIcon.setStyle("display",null);
            imageIcon.src = iconSrc;
          }
        } else if(imageIcon){
          imageIcon.setStyle("display","none");
        }
      }
    }
    private function getIconSelector():String{
      if(data is IListItem){
        return (data as IListItem).icon;
      }
      return data["icon"];
    }
    private function getImageIcon():String{
      if(data is IListItem){
        return (data as IListItem).imageIcon;
      }
      return data["imageIcon"];
    }
    private var icon:Icon;
    private var imageIcon:ImageIcon;
    private var textNode:TextNode;
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
      var elem:WrappedHTMLElement = addElementToWrapper(this,'li');
      textNode = new TextNode("span");
      textNode.className = appendSelector("-itemLink");
      textNode.element.style.userSelect = "none";
      elem.appendChild(textNode.element);
      // setStyle("cursor","default");
      return elem;
    }

  }
}