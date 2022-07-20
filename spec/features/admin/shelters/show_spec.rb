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
end
