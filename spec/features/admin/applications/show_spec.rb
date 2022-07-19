require 'rails_helper'

RSpec.describe 'Admin Applications Show Page' do
  it 'has a button to approve the application for the specific pet' do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Application.destroy_all
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
  end

  it 'removes the button if application has been approved' do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Application.destroy_all
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
      click_on 'Approve application for this pet'
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
    # save_and_open_page

    within "#pet-#{lucy.id}" do
      expect(page).to have_button('Reject application for this pet')
    end

    within "#pet-#{pirate.id}" do
      expect(page).to have_button('Reject application for this pet')
      click_button 'Reject application for this pet'
    end

    expect(current_path).to eq("/admin/applications/#{app.id}")
    # save_and_open_page

    within "#pet-#{pirate.id}" do
      expect(page).to_not have_button('Reject application for this pet')
      expect(page).to have_content('This pet has been rejected for adoption')
    end
  end

  it 'displays buttons to approve or reject the pet regardless of other applications' do 
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

    ApplicationPet.create!(application: app2, pet: pirate)

    visit "/admin/applications/#{app1.id}"
    within "#pet-#{pirate.id}" do
      click_button 'Approve application for this pet'
    end

    visit "/admin/applications/#{app2.id}"
    # save_and_open_page
    
    expect(page).to have_button('Approve application for this pet')
    expect(page).to have_button('Reject application for this pet')
  end

  it "shows that the application is 'Approved' if all PetApplications are approved" do
    app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                              state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    ApplicationPet.create!(application: app, pet: pirate, status: 2)
    ApplicationPet.create!(application: app, pet: lucy, status: 2)

    visit "/admin/applications/#{app.id}"
    # save_and_open_page

    expect(page).to have_content 'Status: Accepted'
  end

  it 'shows that the application is Rejected if one or more pets on the application are rejected and all others are approved' do 
    app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                              state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    pirate = shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    clawdia = shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    lucy = shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    ApplicationPet.create!(application: app, pet: pirate, status: 1)
    ApplicationPet.create!(application: app, pet: clawdia, status: 1)
    ApplicationPet.create!(application: app, pet: lucy, status: 1)

    visit "/admin/applications/#{app.id}"
    
    within "#pet-#{pirate.id}" do
      click_button 'Approve application for this pet'
    end

    within "#pet-#{clawdia.id}" do
      click_button 'Approve application for this pet'
    end

    within "#pet-#{lucy.id}" do
      click_button 'Reject application for this pet'
    end

    expect(page).to have_content 'Status: Rejected'
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

  it 'only allows for pet application to be rejected if another application involving the pet has been approved' do 
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

    visit "/admin/applications/#{app2.id}"


    within "#pet-#{clawdia.id}" do
      expect(page).to_not have_button('Approve application for this pet')
      expect(page).to have_button('Reject application for this pet')
      expect(page).to have_content('This pet has been approved for adoption by another applicant.')
    end
    
  end
end
