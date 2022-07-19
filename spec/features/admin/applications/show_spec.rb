require 'rails_helper'

RSpec.describe 'Admin Applications Show Page' do
  it 'has a button to approve the application for the specific pet' do
    app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                              state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    ApplicationPet.create!(application: app, pet: pirate)
    ApplicationPet.create!(application: app, pet: lucy)

    visit "/admin/applications/#{app.id}"
    # save_and_open_page

    within "#pet-#{pirate.id}" do
      expect(page).to have_button('Approve application for this pet')
    end

    within "#pet-#{lucy.id}" do
      expect(page).to have_button('Approve application for this pet')
    end

    within "#pet-#{pirate.id}" do
      click_button 'Approve application for this pet'
      # save_and_open_page
    end

    expect(current_path).to eq("/admin/applications/#{app.id}")

    within "#pet-#{pirate.id}" do
      expect(page).to_not have_button('Approve application for this pet')
      expect(page).to have_content('This pet has been approved for adoption')
    end

    within "#pet-#{lucy.id}" do
      expect(page).to have_button('Approve application for this pet')
    end
  end

  it 'has a button to reject the application for the specific pet' do
    app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                              state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    ApplicationPet.create!(application: app, pet: pirate)
    ApplicationPet.create!(application: app, pet: lucy)

    visit "/admin/applications/#{app.id}"

    within "#pet-#{lucy.id}" do
      expect(page).to have_button('Reject application for this pet')
    end

    within "#pet-#{pirate.id}" do
      expect(page).to have_button('Reject application for this pet')
      click_button 'Reject application for this pet'
    end

    expect(current_path).to eq("/admin/applications/#{app.id}")

    within "#pet-#{pirate.id}" do
      expect(page).to_not have_button('Reject application for this pet')
      expect(page).to have_content('This pet has been rejected for adoption')
    end
  end
end

