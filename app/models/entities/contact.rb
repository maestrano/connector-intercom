class Entities::Contact < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'People'
  end

  def self.external_entity_name
    'Contact'
  end

  def self.mapper_class
    ContactMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    [entity['first_name'], entity['last_name']].join(' ')
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end

  def self.references
    %w(organization_id)
  end
end

class ContactMapper
  extend HashMapper

  # Mapping to Intercom
  after_normalize do |input, output|
    output[:name] = [input['first_name'], input['last_name']].join(' ').to_s.strip
    output
  end

  # Mapping to Connec!
  after_denormalize do |input, output|
    if input['name']
      output[:first_name] = input['name'].split(' ', 2).first
      output[:last_name] = input['name'].split(' ', 2).last
    end

    output[:is_customer] = false
    output[:is_lead] = true

    output
  end

  map from('id'), to('id')
  map from('code'), to('user_id')
  map from('email/address'), to('email')

  map from('address_work/billing/city'), to('location_data/city_name')
  map from('address_work/billing/country'), to('location_data/country_name')
  map from('address_work/billing/postal_code'), to('location_data/postal_code')
  map from('address_work/billing/region'), to('location_data/region_name')

  map from('organization_id'), to('companies[0]/id')
end
