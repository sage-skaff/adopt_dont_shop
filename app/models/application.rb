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

  def update_ap_status_approved(petid)
    ApplicationPet.where('pet_id = ?', petid).where('application_id = ?', id).update(status: 2)
  end

  def join_pet_with_app_pets
    Pet.select('pets.*, application_pets.*').joins(:application_pets).where("application_pets.application_id = ?", id)
  end

  def evaluate_app_status
    if join_pet_with_app_pets.all? { |pet| pet.status == 2 }
      self.update(status: 2)
    elsif join_pet_with_app_pets.any? { |pet| pet.status == 3 }
      self.update(status: 3)
    end
  end

  def update_ap_status_rejected(pet_id)
    ApplicationPet.where('pet_id = ?', pet_id).update(status: 3)
  end
end
