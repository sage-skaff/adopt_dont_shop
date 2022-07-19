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
    app_pets = ApplicationPet.where("application_id = ?", self.id)
    
    app_pets.each do |app_pet| 
      app_pet.update(status: 'Pending')
    end
  end

  def update_ap_status_approved(petid)
    approved_pet_app = ApplicationPet.where('pet_id = ?', petid).update(status: 2)
    # test = Pet.joins(:application_pets).where("pets.id = ?", pet_id).first.application_pets.update(status: 2)

    ApplicationPet.where("status = ?", 2)
  end

  def join_pet_with_app_pets
    Pet.select('pets.*, application_pets.*').joins(:application_pets)
  end

  def evaluate_app_status
    if join_pet_with_app_pets.all? { |pet| pet.status == 2 }
      self.status = 2 
    end
  end
end
