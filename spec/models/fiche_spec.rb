require File.dirname(__FILE__) + '/../spec_helper'

describe Fiche do
  before(:each) do
    @fiche = Fiche.new
  end
  it "should be valid" do
    @fiche.should be_valid
  end
end



















# == Schema Information
#
# Table name: fiches
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  state                 :string(255)
#  decision_id           :integer
#  validation_date       :date
#  commentaire           :text
#  distinction_name      :text
#  dci_id                :integer
#  suivi                 :string(255)
#  revalider_le          :date
#  ei                    :text
#  conditions            :text
#  surveillance          :text
#  biodisponibilite      :string(255)
#  dose_par_rapport_dmap :string(255)
#  dose_par_rapport_dp   :string(255)
#  liaison_pp            :string(255)
#  vol_dist              :string(255)
#  tmax                  :string(255)
#  thalf                 :string(255)
#  pm                    :string(255)
#  passage_lait          :string(255)
#  rapport_lp            :string(255)
#  has_poso_pedia        :boolean
#  metabolites_actifs    :boolean
#  risque_accumulation   :boolean
#  risque_dim_lactation  :boolean
#  poso_pedia_des        :string(255)
#  arg_autre             :text
#  distinction_id        :integer
#  ei_theoriques         :text
#  de_choix              :boolean
#  pic_lacte             :string(255)
#  poso_pedia_dose       :string(255)
#  user_id               :integer
#

