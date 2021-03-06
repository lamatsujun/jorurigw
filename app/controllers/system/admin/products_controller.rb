class System::Admin::ProductsController < Gw::Controller::Admin::Base
  include System::Controller::Scaffold
  layout "admin/template/admin"

  def pre_dispatch
    return error_auth unless Core.user.has_role?('_admin/admin')

    Page.title = "プロダクト管理"
  end

  def index
    @items = System::Product.order(:sort_no, :id).paginate(page: params[:page], per_page: 30)
  end

  def show
    @item = System::Product.find(params[:id])
  end

  def new
    @item = System::Product.new
  end

  def create
    @item = System::Product.new(params[:item])

    _create @item
  end

  def edit
    @item = System::Product.find(params[:id])
  end

  def update
    @item = System::Product.find(params[:id])
    @item.attributes = params[:item]

    _update @item
  end

  def destroy
    @item = System::Product.find(params[:id])

    _destroy @item
  end
end
