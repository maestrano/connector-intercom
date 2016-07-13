class Entities::Company < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Organization'
  end

  def self.external_entity_name
    'Company'
  end

  def self.mapper_class
    CompanyMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end
end

class CompanyMapper
  extend HashMapper

  map from('id'), to('id')
  map from('code'), to('company_id')
  map from('name'), to('name')
  map from('number_of_employees'), to('user_count')
end
