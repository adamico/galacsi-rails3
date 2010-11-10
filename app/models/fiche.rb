#encoding: utf-8
class Fiche < ActiveRecord::Base
  acts_as_sanitiled :commentaire, :ei, :conditions, :surveillance, :arg_autre, :ei_theoriques, :articles

  # associations
  belongs_to :decision
  belongs_to :dci, :counter_cache => true
  belongs_to :distinction
  belongs_to :user

  has_many :alternativeships, :dependent => :destroy
  has_many :alternatives, :through => :alternativeships
  has_many :sourcings, :dependent => :destroy
  has_many :sources, :through => :sourcings
  accepts_nested_attributes_for :sourcings,
    :reject_if => proc { |attrs| attrs[:source_name].blank? },
    :allow_destroy => true

  # comma CSV support
  comma do

    dci :name => "DCI"
    full_distinction 'Distinction'
    decision :name => "Décision"
    state 'Validation'
    createur
  end

  delegate :name, :to => :dci, :allow_nil => true, :prefix => true

  alias_scope :valide, lambda { state_is("valide")}

  attr_protected :state_event
  attr_reader :createur
  attr_writer :alternative_names

  after_save :assign_alternatives

  def full_distinction
    dist = []
    dist << distinction.name.humanize if distinction
    dist << distinction_name.humanize unless distinction_name.blank?
    dist.join(" : ")
  end

  def createur
    @createur || User.find(user_id).username
  end

  def alternative_names
    @alternative_names || alternatives.map(&:name).join(', ')
  end

  SUIVIS = %w[oui non]
  DIPR = ["DMAP", "dose pédiatrique"]
  PASSAGE = ["dose dépendant", "inconnu", "faible"]
  RLP = ["<1", ">1"]

  alias_scope :expired,     lambda{revalider_le_before(Time.now.to_date)}
  alias_scope :valide,      lambda{state_is("valide")}
  alias_scope :non_valide,  lambda{state_is_not("valide")}
  alias_scope :recent,      lambda{validation_date_after(2.weeks.ago)}

  # state machine stuff
  STATES = [["brouillon", "brouillon"], ["à valider", "a_valider"], ["valide", "valide"], ["en attente", "en_attente"]]
  # workflow
  state_machine :initial => :brouillon do

    after_transition any => :valide do |fiche, transition|
      fiche.publish!
    end

    after_transition any => :en_attente do |fiche, transition|
      fiche.revoke!
    end

    event :initialiser do
      transition :brouillon => :a_valider
    end

    event :valider do
      transition [:a_valider, :en_attente] => :valide
    end

    event :invalider do
      transition :valide => :en_attente
    end
  end

  # publication
  state_machine :published_at, :initial => :unpublished do
    event :publish do
      transition all => :published
    end
    event :revoke do
      transition all => :unpublished
    end
    state :unpublished, :value => nil
    state :published,
      :if => lambda {|value| !value.nil?},
      :value => lambda {Time.now.to_date}
    after_transition any => :published do |fiche, transition|
      fiche.validation_date = Time.now.to_date
      fiche.revalider_le = 3.months.from_now.to_date unless fiche.revalider_le
    end
    after_transition any => :unpublished do |fiche, transition|
      fiche.validation_date = nil
      fiche.revalider_le = nil
    end
  end

  private

  def assign_alternatives
    if @alternative_names
      self.alternatives = @alternative_names.split(', ').map do |name|
        Dci.find_or_create_by_name(name)
      end
    end
  end
end





# == Schema Information
# Schema version: 20101110112900
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
#  articles              :text
#  published_at          :date
#

