require 'spec_helper'

describe Entities::Contact do

  describe 'class methods' do
    subject { Entities::Contact }

    it { expect(subject.connec_entity_name).to eql('People') }
    it { expect(subject.external_entity_name).to eql('Contact') }
    it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'Ahsan', 'last_name' => 'Ellahi'})).to eql('Ahsan Ellahi') }
    it { expect(subject.object_name_from_external_entity_hash({'name' => 'Ahsan Ellahi'})).to eql('Ahsan Ellahi') }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::Contact.new(organization, connec_client, external_client, opts) }

    describe 'external to connec!' do
      let(:external_hash) {
        {
          'id' => '530370b477ad7120001d',
          'user_id' => '25',
          'email' => 'wash@serenity.io',
          'name' => 'Hoban Washburne',
          'location_data' => {
              'city_name' => 'Dublin',
              'country_name' => 'Ireland',
              'postal_code' => '54000',
              'region_name' => 'NSW',
          },
          'companies' => [
            {
              'id' => '530370b477ad7120001e',
            }
          ]
        }
      }

      let (:mapped_external_hash) {
        {
          'code' => '25',
          'email' => {
            'address' => 'wash@serenity.io'
          },
          'first_name' => 'Hoban',
          'last_name' => 'Washburne',
          'is_customer' => false,
          'is_lead' => true,
          'address_work' => {
            'billing' => {
              'city' => 'Dublin',
              'region' => 'NSW',
              'postal_code' => '54000',
              'country' => 'Ireland',
            },
          },
          'organization_id' => [{'id' => '530370b477ad7120001e', 'provider' => 'this_app', 'realm' => 'sfuiy765'}],
          'id' => [{'id' => '530370b477ad7120001d', 'provider' => 'this_app', 'realm' => 'sfuiy765'}],
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          'code' => '25',
          'email' => {
            'address' => 'wash@serenity.io'
          },
          'first_name' => 'Hoban',
          'last_name' => 'Washburne',
          'is_customer' => true,
          'is_lead' => false,
          'address_work' => {
            'billing' => {
              'city' => 'Dublin',
              'region' => 'NSW',
              'postal_code' => '54000',
              'country' => 'Ireland',
            },
          },
        }
      }

      let(:mapped_connec_hash) {
        {
          'user_id' => '25',
          'email' => 'wash@serenity.io',
          'name' => 'Hoban Washburne',
          'location_data' => {
              'city_name' => 'Dublin',
              'country_name' => 'Ireland',
              'postal_code' => '54000',
              'region_name' => 'NSW',
          },
        }.with_indifferent_access
      }

      it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
    end
  end
end
