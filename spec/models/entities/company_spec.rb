require 'spec_helper'

describe Entities::Company do

  describe 'class methods' do
    subject { Entities::Company }

    it { expect(subject.connec_entity_name).to eql('Organization') }
    it { expect(subject.external_entity_name).to eql('Company') }
    it { expect(subject.object_name_from_connec_entity_hash({'name' => 'Ahsan'})).to eql('Ahsan') }
    it { expect(subject.object_name_from_external_entity_hash({'name' => 'Ahsan'})).to eql('Ahsan') }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::Company.new(organization, connec_client, external_client, opts) }

    describe 'external to connec!' do
      let(:external_hash) {
        {
          'id' => '531ee472cce572a6ec000006',
          'company_id' => 'AS2',
          'name' => 'Blue',
          'user_count' => 10,
          'created_at' => 1394533506,
          'updated_at' => 1396874658,
        }
      }

      let (:mapped_external_hash) {
        {
          'name' => 'Blue',
          'number_of_employees' => 10,
          'code' => 'AS2',
          'id' => [{'id' => '531ee472cce572a6ec000006', 'provider' => 'this_app', 'realm' => 'sfuiy765'}],
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          'name' => 'Blue',
          'code' => 'AS2',
          'number_of_employees' => 10,
        }
      }

      let(:mapped_connec_hash) {
        {
          'name' => 'Blue',
          'company_id' => 'AS2',
          'user_count' => 10,
        }.with_indifferent_access
      }

      it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
    end
  end
end
