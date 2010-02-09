# encoding: utf-8
class FichesController < ApplicationController
  filter_resource_access
  filter_resource_access :additional_collection => { :search => :index }
  #TODO créer une action pour montrer la liste des molécules non vérifiées depuis une certaine date

  def initialiser
    @fiche.initialiser!
    flash[:notice] = "La fiche a été initialisée."
    redirect_to @fiche
  end

  def valider
    @fiche.valider!
    @fiche.update_attribute :validation_date, Time.now.to_date
    flash[:notice] = "La fiche a été validée."
    redirect_to @fiche
  end

  def invalider
    @fiche.invalider!
    flash[:notice] = "La fiche a été mise en attente."
    redirect_to @fiche
  end

  def maj_date
    @fiche.update_attribute :validation_date, Time.now.to_date
    flash[:notice] = "La date de validation a été mise à jour avec succès."
    redirect_to @fiche
  end

  def index
    @search = Fiche.with_permissions_to(:read).search(params[:search])
    @fiches = @search.all
  end
  
  def search
    @search = Fiche.with_permissions_to(:read).search(params[:search])
    @fiches = @search.all
  end


  def show
  end
  
  def new
  end
  
  def create
    if @fiche.save
      flash[:notice] = "La fiche a été créée."
      redirect_to @fiche
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @fiche.update_attributes(params[:fiche])
      flash[:notice] = "La fiche a été mise à jour."
      redirect_to @fiche
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @fiche.destroy
    flash[:notice] = "La fiche a été détruite."
    redirect_to fiches_url
  end
end