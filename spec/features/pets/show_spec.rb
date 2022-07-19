require 'rails_helper'

RSpec.describe 'the shelter show' do
  it "shows the shelter and all it's attributes" do
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    expect(page).to have_content(pet.name)
    expect(page).to have_content(pet.age)
    expect(page).to have_content(pet.adoptable)
    expect(page).to have_content(pet.breed)
    expect(page).to have_content(pet.shelter_name)
  end

  it "allows the user to delete a pet" do
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create!(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    click_on("Delete #{pet.name}")

    expect(page).to have_current_path('/pets')
    expect(page).to_not have_content(pet.name)
  end

  it 'shows that pets are no longer adoptable if another application has been approved to adopt all pets' do 
    app1 = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                              state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

    app2 = Application.create!(name: 'Calliope Carson', street_address: '124 Central Avenue', city: 'Denver', state: 'CO', zip_code: '80111', description: 'I really love animals!', status: 1)

    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    ApplicationPet.create!(application: app1, pet: pirate)
    ApplicationPet.create!(application: app1, pet: clawdia)

    ApplicationPet.create!(application: app2, pet: clawdia)
    
    visit "/admin/applications/#{app1.id}"
    
    within "#pet-#{pirate.id}" do
      click_button 'Approve application for this pet'
    end

    within "#pet-#{clawdia.id}" do
      click_button 'Approve application for this pet'
    end

    visit "/pets/#{pirate.id}"
    # save_and_open_page

    expect(page).to have_content('Adoptable: false') 
  end
end
