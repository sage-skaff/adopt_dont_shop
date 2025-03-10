require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    Pet.destroy_all
    Shelter.destroy_all
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create!(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search('Fancy')).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#order_by_name' do
      it 'orders Shelters by name in alpha order' do
        expect(Shelter.order_by_name).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '#apps_pending' do
      it 'returns Shelters with pending Applications alphabetically' do
        Application.destroy_all
        app0 = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                                   state: 'CO', zip_code: '80111', description: 'I love animals!', status: 0)
        app1 = Application.create!(name: 'Calliope Carson', street_address: '124 Central Avenue', city: 'Denver',
                                   state: 'CO', zip_code: '80111', description: 'I really love animals!', status: 1)
        pet_5 = @shelter_2.pets.create!(name: 'Bean', breed: 'husky', age: 4, adoptable: true)
        ApplicationPet.create!(pet: @pet_1, application: app1, status: 0)
        ApplicationPet.create!(pet: pet_5, application: app1, status: 1)
        ApplicationPet.create!(pet: @pet_3, application: app1, status: 1)

        expect(Shelter.apps_pending).to eq([@shelter_3, @shelter_2])
      end
    end
    describe '#sql_find_by_id' do
      it 'returns Shelter with the given id' do
        expect(Shelter.sql_find_by_id(@shelter_1.id)).to eq(@shelter_1)
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '#average_pet_age' do
      it 'returns the average age of an adoptable pet' do
        expect(@shelter_1.average_pet_age).to eq 4
      end

      it 'says no pets are in the shelter' do
        expect(@shelter_2.average_pet_age).to eq 'No pets at this shelter'
      end
    end

    describe '#num_adoptable' do
      it 'returns the number of adoptable pets' do
        expect(@shelter_1.num_adoptable).to eq 2
      end
    end

    describe '#adopted_pets_count' do
      it 'returns the number of adopted pets' do
        woof = @shelter_1.pets.create!(name: 'Woof', breed: 'dog', age: 12, adoptable: true)
        ozzy = @shelter_1.pets.create!(name: 'Ozzy', breed: 'chow', age: 1, adoptable: false)
        sofia = @shelter_1.pets.create!(name: 'Sofia', breed: 'hairy', age: 1, adoptable: false)
        trudy = @shelter_1.pets.create!(name: 'Trudy', breed: 'hairy', age: 1, adoptable: true)
        app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                                  state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

        app2 = Application.create!(name: 'Calliope Carson', street_address: '124 Central Avenue', city: 'Denver',
                                   state: 'CO', zip_code: '80111', description: 'I really love animals!', status: 2)

        ApplicationPet.create!(application: app, pet: @pet_1, status: 2)
        ApplicationPet.create!(application: app, pet: @pet_2, status: 1)
        ApplicationPet.create!(application: app, pet: woof, status: 1)
        ApplicationPet.create!(application: app, pet: ozzy, status: 2)
        ApplicationPet.create!(application: app2, pet: @pet_4, status: 2)
        ApplicationPet.create!(application: app2, pet: sofia, status: 2)
        ApplicationPet.create!(application: app2, pet: trudy, status: 2)

        expect(@shelter_1.adopted_pets_count).to eq 3
      end
    end

    describe '#pets_with_pending_apps' do
      it 'returns pets that have a pending application and have not been marked approved or rejected' do
        woof = @shelter_1.pets.create!(name: 'Woof', breed: 'dog', age: 12, adoptable: true)
        ozzy = @shelter_1.pets.create!(name: 'Ozzy', breed: 'chow', age: 1, adoptable: false)
        sofia = @shelter_1.pets.create!(name: 'Sofia', breed: 'hairy', age: 1, adoptable: false)
        trudy = @shelter_1.pets.create!(name: 'Trudy', breed: 'hairy', age: 1, adoptable: true)
        app = Application.create!(name: 'Brigitte Bardot', street_address: '123 Main Street', city: 'Denver',
                                  state: 'CO', zip_code: '80111', description: 'I love animals!', status: 1)

        app2 = Application.create!(name: 'Calliope Carson', street_address: '124 Central Avenue', city: 'Denver',
                                   state: 'CO', zip_code: '80111', description: 'I really love animals!', status: 2)

        ApplicationPet.create!(application: app, pet: @pet_1, status: 2)
        ApplicationPet.create!(application: app, pet: @pet_2, status: 1)
        ApplicationPet.create!(application: app, pet: woof, status: 1)
        ApplicationPet.create!(application: app, pet: ozzy, status: 0)
        ApplicationPet.create!(application: app2, pet: @pet_4, status: 2)
        ApplicationPet.create!(application: app2, pet: sofia, status: 2)
        ApplicationPet.create!(application: app2, pet: trudy, status: 2)

        expect(@shelter_1.pets_with_pending_apps).to eq([@pet_2, woof])
      end
    end
  end
end
