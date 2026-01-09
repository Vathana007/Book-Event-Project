class CategoriesController < ApplicationController
  before_action :require_admin

  # GET /categories
  def index
    if params[:q].present?
      query = params[:q]
      @categories = Category.where("CAST(id AS TEXT) ILIKE ? OR name ILIKE ?", "%#{query}%", "%#{query}%")
    else
      @categories = Category.all
    end
  end

  # GET /categories/:id
  def show
    @category = Category.find(params[:id])
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  
  # GET /categories/:id/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  def create 
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /categories/:id
  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /categories/:id
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: 'Category was successfully destroyed.'
  end

  private 

  def category_params
    params.require(:category).permit(:name, :description)
  end

end