require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'validations' do 
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
  end

  describe 'instance methods' do 
    it 'updates the ApplicationPets status when the Application status changes to Pending' do 
      app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver', state: 'CO', zip_code: '80111', status: 1)

      shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
      app_pirate = ApplicationPet.create!(application: app, pet: pirate)
      app_lucy = ApplicationPet.create!(application: app, pet: lucy)

      app.update_ap_status

      expect(app_pirate.reload.status).to eq('Pending')
      expect(app_lucy.reload.status).to eq('Pending')
    end

    it 'joins Pets with ApplicationPets' do 
      app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver', state: 'CO', zip_code: '80111', status: 1)

      shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
      app_pirate = ApplicationPet.create!(application: app, pet: pirate, status: 2)
      app_lucy = ApplicationPet.create!(application: app, pet: lucy, status: 1)

      expect(app.join_pet_with_app_pets.first.status).to eq 2
      expect(app.join_pet_with_app_pets[1].status).to eq 1
    end

    it 'updates the ApplicationPet status when admin changes to Approved' do 
      app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver', state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

      shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      ap1 = ApplicationPet.create!(application: app, pet: pirate, status: 1)
      ap2 = ApplicationPet.create!(application: app, pet: lucy, status: 1)

      app.update_ap_status_approved(pirate.id)

      expect(ap1.reload.status).to eq "Accepted"
      expect(ap2.reload.status).to eq "Pending"
    end

    it 'evaluates the application status' do 
      app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver', state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

      shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      ap1 = ApplicationPet.create!(application: app, pet: pirate, status: 2)
      ap2 = ApplicationPet.create!(application: app, pet: lucy, status: 2)

      app.evaluate_app_status

      expect(app.status).to eq 'Accepted'
    end

    it 'evaluates the application status to rejected if any ApplicationPets are rejected' do 
      app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver', state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

      shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      ap1 = ApplicationPet.create!(application: app, pet: pirate, status: 2)
      ap2 = ApplicationPet.create!(application: app, pet: lucy, status: 3)

      app.evaluate_app_status

      expect(app.status).to eq 'Rejected'
    end

    it 'updates the ApplicationPet to rejected if the application is rejected' do 
      app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver', state: 'CO', zip_code: '80111', description: 'I love animals!', status: 3)

      shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      ap1 = ApplicationPet.create!(application: app, pet: pirate, status: 2)
      ap2 = ApplicationPet.create!(application: app, pet: lucy, status: 2)

      app.update_ap_status_rejected(pirate.id)
      app.update_ap_status_rejected(lucy.id)

      expect(ap1.reload.status).to eq "Rejected"
      expect(ap2.reload.status).to eq "Rejected"
    end

    it 'updates the adoptable status of the pets in an approved application to false' do 
      app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver', state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

      shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      ap1 = ApplicationPet.create!(application: app, pet: pirate, status: 2)
      ap2 = ApplicationPet.create!(application: app, pet: lucy, status: 2)

      app.evaluate_app_status

      expect(pirate.reload.adoptable).to eq false
      expect(lucy.reload.adoptable).to eq false
      expect(clawdia.reload.adoptable).to eq true 
    end
  end
end
