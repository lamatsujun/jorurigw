class Gwmonitor::Admin::CustomUserGroupsController < Gw::Controller::Admin::Base
  include System::Controller::Scaffold
  include Gwmonitor::Controller::Systemname
  layout "admin/template/gwmonitor"

  def pre_dispatch
    @system_title = disp_system_name
    @css = ["/_common/themes/gw/css/monitor.css"]
    params[:limit] = 50
  end

  def index
    @items = load_index_items
  end

  def show
  end

  def new
    @item = Gwmonitor::CustomUserGroup.new(
      state: 'enabled',
      sort_no: 10
    )
  end

  def create
    @item = Gwmonitor::CustomUserGroup.new(params[:item])
    @item.owner_uid = Core.user.id
    _create @item
  end

  def edit
    @item = Gwmonitor::CustomUserGroup.find(params[:id])
    return error_auth if @item.owner_uid != Core.user.id
  end

  def update
    @item = Gwmonitor::CustomUserGroup.find(params[:id])
    return error_auth if @item.owner_uid != Core.user.id
    @item.attributes = params[:item]
    _update @item
  end

  def destroy
    @item = Gwmonitor::CustomUserGroup.find(params[:id])
    return error_auth if @item.owner_uid != Core.user.id
    _destroy @item
  end

  def sort_update
    @items = load_index_items
    @items.each {|item| item.attributes = params[:items][item.id.to_s] if params[:items][item.id.to_s] }
    _index_update @items
  end

private

  def load_index_items
    Gwmonitor::CustomUserGroup.where(owner_uid: Core.user.id)
      .order(sort_no: :asc, id: :asc)
      .paginate(page: params[:page], per_page: params[:limit])
  end
end
