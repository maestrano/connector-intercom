class Maestrano::Connector::Rails::External
  include Maestrano::Connector::Rails::Concerns::External

  def self.external_name
    'Intercom'
  end

  def self.get_client(organization)
    IntercomClient.new organization
  end

  def self.entities_list
    %w(company user contact)
  end
end
