class IntercomClient

  # Intercom API Client
  def initialize(organization)
    @intercom_client = Intercom::Client.new(app_id: ENV['intercom_api_id'], api_key: ENV['intercom_api_key'])
  end

  def find_all(entity, created_since = nil)
    method = "get_#{entity.pluralize}"

    resource =  if created_since
                  @intercom_client.send("#{entity.pluralize}").find_all(created_since: (Date.today - Date.parse(created_since)).to_i)
                else
                  @intercom_client.send("#{entity.pluralize}").all
                end

    send(method, resource)
  end

  def get_users(resource)
    entities = resource.collect do |user|
      {
        id: user.id,
        user_id: user.user_id,
        email: user.email,
        name: user.name,
        location_data: {
          city_name: user.location_data.city_name,
          country_name: user.location_data.country_name,
          postal_code: user.location_data.postal_code,
          region_name: user.location_data.region_name
        },
        company_id: user.companies[0].id,
      }
    end

    entities
  end

  def get_companies(resource)
    entities = resource.collect do |company|
      {
        id: company.id,
        name: company.name,
        user_count: company.user_count,
        monthly_spend: company.monthly_spend,
      }
    end

    entities
  end

  def get_contacts(resource)
    entities = resource.collect do |contact|
      {
        id: contact.id,
        user_id: contact.user_id,
        email: contact.email,
        name: contact.name,
        location_data: {
          city_name: contact.location_data.city_name,
          country_name: contact.location_data.country_name,
          postal_code: contact.location_data.postal_code,
          region_name: contact.location_data.region_name
        },
      }
    end

    entities
  end

  def create(entity, params)
    @intercom_client.send("#{entity.pluralize}").create(params)
  end
end
