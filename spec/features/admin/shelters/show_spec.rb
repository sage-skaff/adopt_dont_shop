require 'rails_helper'

RSpec.describe 'Admin Shelters Show Page' do
  it 'has shelters name and address' do
    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content('Aurora shelter')
    expect(page).to have_content('Aurora, CO')
  end

  it 'shows average age of all adoptable pets for the shelter' do
    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    shelter_1.pets.create!(name: 'Woof', breed: 'dog', age: 12, adoptable: true)
    shelter_1.pets.create!(name: 'Ozzy', breed: 'chow', age: 1, adoptable: false)

    visit "/admin/shelters/#{shelter_1.id}"
    # save_and_open_page

    expect(page).to have_content('Shelter Statistics')
    expect(page).to have_content('Average age of adoptable pets: 6.67')
  end

  it 'shows number of pets that are adoptable' do
    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    shelter_1.pets.create!(name: 'Woof', breed: 'dog', age: 12, adoptable: true)
    shelter_1.pets.create!(name: 'Ozzy', breed: 'chow', age: 1, adoptable: false)
    shelter_1.pets.create!(name: 'Sofia', breed: 'hairy', age: 1, adoptable: false)
    shelter_1.pets.create!(name: 'Trudy', breed: 'hairy', age: 1, adoptable: true)

    visit "/admin/shelters/#{shelter_1.id}"
    # save_and_open_page

    expect(page).to have_content('Number of adoptable pets: 4')
  end

  it 'shows number of pets that have been adopted' do
    app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                              state: 'CO', zip_code: '80111', description: 'I love animals!', status: 2)

    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    ApplicationPet.create!(application: app, pet: pirate, status: 2)
    ApplicationPet.create!(application: app, pet: clawdia, status: 2)

    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content('Number of adopted pets: 2')
  end
end
