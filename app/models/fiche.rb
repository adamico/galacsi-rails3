#encoding: utf-8
class Fiche < ActiveRecord::Base
  belongs_to :decision
  belongs_to :dci
  belongs_to :distinction
  belongs_to :user
  
  has_many :alternativeships, :dependent => :destroy
  has_many :alternatives, :through => :alternativeships
  has_and_belongs_to_many :sources, :join_table => "fiches_sources"
  # uncomment these 2 lines to create sources in fiche form
  #accepts_nested_attributes_for :sources,
  #  :reject_if => proc { |attrs| attrs[:name].blank? }, :allow_destroy => true

  attr_reader :createur
  attr_writer :alternative_names

  after_save :assign_alternative_names

  def full_distinction
    dist = []
    dist << distinction.name if distinction
    dist << distinction_name unless distinction_name.blank?
    dist.join(" : ")
  end

  def createur
    @createur || User.find(self.user_id).username
  end

  def alternative_names
    @alternative_names || alternatives.map(&:name).join(', ')
  end

  SUIVIS = %w[oui non]
  DIPR = ["DMAP", "dose pédiatrique"]
  PASSAGE = ["dose dépendant", "inconnu", "faible"]
  RLP = ["<1", ">1"]

  alias_scope :expired, lambda { revalider_le_before(Time.now.to_date)}
  alias_scope :valide, lambda { state_is("valide")}
  alias_scope :non_valide, lambda { state_is_not("valide")}
  alias_scope :recent, lambda { validation_date_after(2.weeks.ago) }

  # AASM stuff
  include AASM
  aasm_column :state
  aasm_initial_state :brouillon

  aasm_state :brouillon
  aasm_state :a_valider
  aasm_state :valide
  aasm_state :en_attente

  aasm_event :initialiser do
    transitions :to => :a_valider, :from => [:brouillon]
  end

  aasm_event :valider do
    transitions :to => :valide, :from => [:a_valider, :en_attente]
  end

  aasm_event :invalider do
    transitions :to => :en_attente, :from => [:valide]
  end

  private

  def assign_alternative_names
    if @alternative_names
      self.alternatives = @alternative_names.split(', ').map do |name|
        Dci.find_or_create_by_name(name)
      end
    end
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

