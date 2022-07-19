class Application < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true

  has_many :application_pets
  has_many :pets, through: :application_pets
  enum status: ['In Progress', 'Pending', 'Accepted', 'Rejected']

  def update_ap_status
    app_pets = ApplicationPet.where('application_id = ?', id)

    app_pets.each do |app_pet|
      app_pet.update(status: 'Pending')
    end
  end

  def update_ap_status_approved(pet_id)
    approved_pet_app = ApplicationPet.joins(:pet).where('pet_id = ?', pet_id)

    approved_pet_app.update(status: 2)

    ApplicationPet.where('status = ?', 2).pluck(:pet_id)
  end

  def update_ap_status_rejected(pet_id)
    approved_pet_app = ApplicationPet.joins(:pet).where('pet_id = ?', pet_id)

    approved_pet_app.update(status: 3)

    ApplicationPet.where('status = ?', 3).pluck(:pet_id)
  end
end
