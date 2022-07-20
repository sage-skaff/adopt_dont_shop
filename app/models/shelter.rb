class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :application_pets, through: :pets
  has_many :applications, through: :application_pets

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select('shelters.*, count(pets.id) AS pets_count')
      .joins('LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id')
      .group('shelters.id')
      .order('pets_count DESC')
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def adopted_pets_count
    pets.includes(:applications).where(applications: { status: 2 }).count
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.order_by_name
    Shelter.find_by_sql('SELECT * FROM shelters ORDER BY name DESC')
  end

  def self.apps_pending
    # pets_with_pending_apps = Pet.joins(:application_pets).where(application_pets: { status: 1 }).pluck(:id)

    # pets_with_pending_apps.flat_map do |pet_id|
    #   Shelter.joins(:pets).where(pets: { id: pet_id })
    # end
    order(:name).includes(:application_pets).where(application_pets: { status: 1 }).to_a
  end

  def pets_with_pending_apps
    pets.includes(:application_pets).where(application_pets: { status: 1 })
  end

  def self.sql_find_by_id(id)
    find_by_sql("select * from shelters where shelters.id = #{id}").first
  end

  def average_pet_age
    if pets == []
      'No pets at this shelter'
    else
      pets.where('adoptable = ?', true).average(:age).round(2).to_f
    end
  end

  def num_adoptable
    pets.where('adoptable =?', true).count
  end
end
