using Gtk;

public class NavTreeCtx
{
    /**
     *
     * 显示时机 {@link NavTRowStatus}
     *
     */
    public NavTRowStatus status {
        private set;
        get;
    }
    public NavTreeItem item {
        private set;
        get;
    }

    public NavTreeCtx(NavTRowStatus status,NavTreeItem item)
    {
        this.item = item;
        this.status = status;
    }

    private static NavTreeCtx create(NavTRowStatus status,NavTreeItem item)
    {
        return new NavTreeCtx(status,item);
    }

    private static NavTreeCtx[] rootCtx = null;


    public static NavTreeCtx[] getRootCtx()
    {
        if(rootCtx == null)
        {
            rootCtx =
            {
                NavTreeCtx.create(NavTRowStatus.INACTIVE , NavTreeItem.OPEN),
                NavTreeCtx.create(NavTRowStatus.ACTIVED , NavTreeItem.BREAK_OFF),
                NavTreeCtx.create(NavTRowStatus.ANY , NavTreeItem.EDIT),
                NavTreeCtx.create(NavTRowStatus.ANY , NavTreeItem.DELETE)
            };
        }
        return rootCtx;
    }

}


/**
 *
 * 导航视图自定义弹出菜单
 *
 *
 **/
public class NavTreeEvent
{
    //  private Gdk.Pixbuf viewIcon;
    //  private Gdk.Pixbuf tableIcon;
    //  private Gdk.Pixbuf folderIcon;
    //  private Gdk.Pixbuf schemaIcon;
    
    private GLib.Menu menu;
    private Gtk.PopoverMenu popoverMenu;
    
    private unowned TreeView navTree;
    private unowned Gtk.TreeModel treeModel;
    private unowned MainController controller;

    public NavTreeEvent.register(TreeView navTree,MainController controller)
    {
        this.navTree = navTree;
        this.controller = controller;
        this.treeModel = navTree.get_model();
        var gester = new GestureClick();
        this.navTree.add_controller(gester);
        gester.released.connect(this.btnPreEvent);

        this.menu = (Menu)UIUtil.loadXmlUI("nav-tree-menu.xml","menu");
        this.popoverMenu = new Gtk.PopoverMenu.from_model(this.menu);

        //  //缓存常用图标
        //  this.viewIcon = IconTheme.get_default().load_icon("dbfx-view",25,0);
        //  this.tableIcon = IconTheme.get_default().load_icon("dbfx-table",18,0);
        //  this.folderIcon = IconTheme.get_default().load_icon("dbfx-folder",15,0);
        //  this.schemaIcon = IconTheme.get_default().load_icon("dbfx-schema",16,0);
    }

    private void btnPreEvent(int num,double x,double y)
    {
        //  var type = event.type;
        var iter = this.getSelectIter();
        if( iter != null )
        {
            //  //右键按下=>弹出菜单
            //  if(button == 3)
            //  {
            //  //     this.showMenu(iter);
            //  }
            //  //双击
            //  if(num > 1)
            //  {
            //      //  this.open(null,null);
            //  }
        }
    }

    //  private void showMenu(TreeIter iter)
    //  {
    //      Value val;
    //      this.treeModel.get_value(iter,NavTreeCol.NT_ROW,out val);
    //      var row = (NTRow)val.get_int();
    //      var arr = new NavTreeCtx[0];
    //      if(row == NTRow.ROOT)
    //      {
    //          arr = NavTreeCtx.getRootCtx();
    //      }
    //      //菜单不存在则不显示
    //      if(arr.length == 0)
    //      {
    //          return;
    //      }
    //      this.treeModel.get_value(iter,NavTreeCol.STATUS,out val);
    //      var status = (NavTRowStatus)val.get_int();

    //      var index = 0;
    //      this.foreach((child)=>{
    //          child.visible = false;
    //          foreach(var temp in arr)
    //          {
    //              var _status = temp.status;
    //              if(temp.item == index && (_status == NavTRowStatus.ANY || status == _status))
    //              {
    //                  child.visible = true;
    //                  break;
    //              }
    //          }
    //          ++index;
    //      });

    //      this.show();
    //      //  this.popup_at_pointer(event);
    //  }

    //  /**
    //   *
    //   *
    //   * 响应打开Open事件
    //   *
    //   **/
    //  [GtkCallback]
    //  public bool open(Gtk.Widget? item,Gdk.EventButton? event)
    //  {
    //      var iter = this.getSelectIter();
    //      if(iter == null)
    //      {
    //          return false;
    //      }
    //      Value val;

    //      //
    //      // 获取行类别
    //      //
    //      this.treeModel.get_value(iter,NavTreeCol.NT_ROW,out val);
    //      var row = (NTRow)val.get_int();

    //      //
    //      // 获取行状态
    //      //
    //      this.treeModel.get_value(iter,NavTreeCol.STATUS,out val);
    //      var status = (NavTRowStatus)val.get_int();

    //      //
    //      // 获取行id
    //      //
    //      this.treeModel.get_value(iter,NavTreeCol.UUID, out val);
    //      var uuid = val.get_string();
        
    //      var pathStr = this.treeModel.get_string_from_iter(iter);
    //      var treePath = new TreePath.from_string(pathStr);
    //      var isExpand = this.navTree.is_row_expanded(treePath);
    //      var beforeEnd = false;
    //      if(status == NavTRowStatus.ACTIVED || (beforeEnd = (status == NavTRowStatus.ACTIVING)))
    //      {
    //          if(!beforeEnd)
    //          {
    //              collExpand(iter,isExpand);
    //          }
    //          return false;
    //      }

    //      if(row == NTRow.ROOT)
    //      {
    //          this.fetchSchema(iter,uuid);
    //      }

    //      if(row == NTRow.SCHEMA)
    //      {
    //          this.fetchTable(iter,uuid);
    //      }

    //      if(row == NTRow.TABLE || row == NTRow.VIEW)
    //      {
    //          this.loadTable(row == NTRow.VIEW, iter, uuid );
    //      }

    //      return false;
    //  }

    //  /**
    //   *
    //   * 
    //   * 断开连接
    //   *
    //   **/
    //  [GtkCallback]
    //  public bool breakOff(Gtk.Widget item,Gdk.EventButton event)
    //  {
    //      var iter = this.getSelectIter();
    //      if( iter == null )
    //      {
    //          return false;
    //      }
    //      this.clear(iter);
    //      var val = new Value(typeof(string));
    //      this.treeModel.get_value(iter,NavTreeCol.UUID,out val);
    //      var uuid = val.get_string();
    //      //移除连接池
    //      Application.ctx.removePool(uuid);
    //      this.treeStore().set_value( iter , NavTreeCol.STATUS , NavTRowStatus.INACTIVE );
    //      return false;
    //  }

    //  /**
    //   *
    //   *
    //   * 将表信息加载到可视化界面中
    //   *
    //   */
    //  public async void loadTable(bool view,TreeIter iter,string uuid)
    //  {
    //      var str = this.treeModel.get_string_from_iter(iter);
    //      var path = @"$uuid:$str";
    //      if( Application.ctx.tabExist(path,true) != -1)
    //      {
    //          return;
    //      }
    //      var pathVal = this.getPathValue(iter);
    //      Application.ctx.addTab(new NotebookTable(path,pathVal,view),true);
    //  }

    //  /**
    //   *
    //   *
    //   * 获取schema下的表
    //   *
    //   **/
    //  private async void fetchTable(TreeIter iter,string uuid)
    //  {
    //      this.updateNTStatus(iter,NavTRowStatus.ACTIVING);

    //      Value val = new Value(typeof(string));

    //      this.treeModel.get_value(iter,NavTreeCol.NAME, out val);

    //      FXError error = null;
        
    //      //基础表
    //      Gee.List<TableInfo> tables = null;
    //      //视图
    //      Gee.List<TableInfo> views  = null;

    //      SourceFunc callback = fetchTable.callback;

    //      var work = AsyncWork.create(()=>{
    //          SqlConnection con = null;
    //          try
    //          {
    //              con  = Application.getConnection(uuid);
    //              tables = con.tables(val.get_string(),false);
    //              views  = con.tables(val.get_string(),true);
    //          }
    //          catch(FXError e)
    //          {
    //              warning("Query table list fail:%s".printf(e.message));
    //              error = e;
    //          }
    //          finally
    //          {
    //              con.close();
    //              Idle.add(callback);
    //          }
    //      });
    //      work.execute();

    //      yield;

    //      this.updateNTStatus(iter,error != null ? NavTRowStatus.INACTIVE : NavTRowStatus.ACTIVED );

    //      if(error != null)
    //      {
    //          return;
    //      }
    //      this.createTableOrView(iter,tables,false,uuid);
    //      this.createTableOrView(iter,views,true,uuid);
    //  }

    //  private void createTableOrView(TreeIter parent,Gee.List<TableInfo> list,bool view,string uuid)
    //  {
    //      TreeIter iter;
    //      this.treeStore().append(out iter,parent);
    //      this.treeStore().set(
    //          iter,
    //          NavTreeCol.UUID,uuid,
    //          NavTreeCol.ICON,folderIcon,
    //          NavTreeCol.NAME,view?_("views"):_("tables"),
    //          NavTreeCol.STATUS,NavTRowStatus.INACTIVE,
    //          NavTreeCol.NT_ROW,view ? NTRow.VIEW_FOLDER : NTRow.TABLE_FOLDER,
    //          -1
    //      );
        
    //      //设置为激活状态
    //      this.updateNTStatus(iter,NavTRowStatus.ACTIVED);
        
    //      TreeIter child;
    //      foreach(var table in list)
    //      {
    //          this.treeStore().append(out child,iter);
    //             this.treeStore().set(
    //              child,
    //              NavTreeCol.NAME,table.name,
    //              NavTreeCol.ICON,view?viewIcon:tableIcon,
    //              NavTreeCol.NT_ROW,!view ? NTRow.TABLE : NTRow.VIEW,
    //              NavTreeCol.STATUS,NavTRowStatus.INACTIVE,
    //              NavTreeCol.UUID,uuid,
    //              -1
    //          );
    //      }
    //      this.collExpand(parent,false);
    //  }
    //  /**
    //   *
    //   *
    //   * 获取Schema列表
    //   *
    //   */
    //  private async void fetchSchema(TreeIter iter,string uuid)
    //  {
    //      //更新为激活中状态
    //      this.updateNTStatus(iter,NavTRowStatus.ACTIVING);

    //      FXError error = null;
    //      Gee.List<DatabaseSchema> list = null;
    //      SourceFunc callback = fetchSchema.callback;

    //      var work = AsyncWork.create(()=>{
    //          SqlConnection con = null;
    //          try
    //          {
    //              var context = Application.ctx;
    //              list = context.getConnection(uuid).schemas();
    //          }
    //          catch(FXError e)
    //          {
    //              warning("Open/Query database schema fail:%s".printf(e.message));
    //              error = e;
    //          }
    //          finally
    //          {
    //              //关闭连接
    //              if( con != null ){
    //                  con.close();
    //              }

    //              //清除连接池
    //              if( error == null )
    //              {
    //                  Application.ctx.removePool(uuid);
    //              }
    //              Idle.add(callback);
    //          }
    //      });

    //      work.execute();

    //      yield;

    //      //根据是否发生错误决定状态
    //      this.updateNTStatus( iter , error == null ? NavTRowStatus.ACTIVED : NavTRowStatus.INACTIVE );

    //      if( error != null )
    //      {
            
    //          return;
    //      }
    //      foreach(var schema in list)
    //      {
    //          TreeIter child = {0};
    //          this.treeStore().append(out child,iter);
    //          this.treeStore().set(
    //              child,
    //              NavTreeCol.ICON,schemaIcon,
    //              NavTreeCol.NAME,schema.name,
    //              NavTreeCol.NT_ROW,NTRow.SCHEMA,
    //              NavTreeCol.STATUS,NavTRowStatus.INACTIVE,
    //              NavTreeCol.UUID,uuid,
    //              -1
    //          );
    //      }
    //      if ( list.size > 0 )
    //      {
    //          this.collExpand(iter,false);
    //      }
    //  }

    //  private void collExpand(TreeIter iter,bool collapse)
    //  {
    //      var pathStr = this.treeModel.get_string_from_iter(iter);
    //      var treePath = new TreePath.from_string(pathStr);
    //      if(collapse)
    //      {
    //          this.navTree.collapse_row(treePath);
    //      }
    //      else
    //      {
    //          this.navTree.expand_row(treePath,false);    
    //      }
    //  }

    //  /**
    //   *
    //   *
    //   * 从{@link TreeModel}中获取{@link TreeStore}
    //   *
    //   **/
    //  private Gtk.TreeStore treeStore()
    //  {
    //      return (Gtk.TreeStore)this.treeModel;
    //  }

    //  /**
    //   *
    //   * 更新某一行状态
    //   *
    //   **/
    //  private void updateNTStatus(TreeIter iter,NavTRowStatus status)
    //  {
    //      var val = new Value(typeof(int));
    //      val.set_int(status);
    //      this.treeStore().set_value(iter,NavTreeCol.STATUS,val);
    //      //非激活状态=>清空子节点
    //      if (status == NavTRowStatus.INACTIVE)
    //      {
    //          this.clear(iter);
    //      }
    //  }

    //  /**
    //   *
    //   * 
    //   * 清除指定行子节点
    //   *    
    //   **/
    //  private void clear(TreeIter? parent)
    //  {
    //      TreeIter child;
    //      while(this.treeModel.iter_children(out child,parent))
    //      {
    //          this.treeStore().remove(ref child);
    //      }
    //  }

    /**
     *
     * 获取当前选中行
     *
     *
     **/
    private TreeIter? getSelectIter()
    {
        TreeIter iter;
        var selection = this.navTree.get_selection();
        var selected = selection.get_selected(out treeModel,out iter);
        if(!selected)
        {
            return null;
        }
        return iter;
    }
    //  /**
    //   *
    //   * 获取指定路径值,以`:`分隔
    //   *
    //   **/
    //  private string getPathValue(TreeIter iter)
    //  {
    //      TreeIter lIter;
    //      TreePath path;
    //      var iterStr = this.treeModel.get_string_from_iter(iter);

    //      var index = 0;
    //      var pathStr = "";
    //      string[] temp = {};
    //      var paths = iterStr.split(":");
    //      var val = new Value(typeof(string));

    //      var pathVal = "";

    //      foreach(unowned string str  in paths)
    //      {
    //          if( index != 0 )
    //          {
    //              pathStr = @"$pathStr:$str";
    //          }
    //          else
    //          {
    //              pathStr = str;
    //          }
    //          path = new TreePath.from_string(pathStr);
    //          this.treeModel.get_iter(out lIter,path);
    //          this.treeModel.get_value(lIter,NavTreeCol.NAME,out val);
            
    //          pathVal += ((index == 0 ?"":":")+val.get_string());

    //          index++;
    //      }
        
    //      return pathVal;
    //  }
}
