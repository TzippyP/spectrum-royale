package com.unhurdle.spectrum
{
  COMPILE::JS
  {
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
  }
  import org.apache.royale.html.List;
  import com.unhurdle.spectrum.includes.SideNavInclude;

  public class List extends org.apache.royale.html.List
  {
    /**
     * List is for basic selectable lists. The content of the list is provided by a dataProvider and the rendering is done by DataRendererers.
     * The basic ListDataRenderer accepts text and an optional icon.
     * If the dataProvider is a list of strings, the data will not be converted.
     * Use List for compact selectable lists. If you want check-able lists, use Menu.
     * For a more spaced styling with room for checkboxes, icons, etc. use AssetList.
     * List uses the styling for SideNav because it is more compact than AssetList and has background selection unlike Menu.
     * 
     */
    public function List()
    {
      super();
      typeNames = getSelector();
    }

    protected function getSelector():String{
      return SideNavInclude.getSelector();
    }
    protected function appendSelector(value:String):String{
      return getSelector() + value;
    }
    protected function valueToSelector(value:String):String{
      return getSelector() + "--" + value;
    }

    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
      return addElementToWrapper(this,'ul');
    }
  }
}