class IntercomClient

  # Intercom API Client
  def initialize(organization)
    @intercom_client = Intercom::Client.new(token: organization.oauth_token)
  end

  def find_all(entity, created_since = nil)
    method = "get_#{entity.downcase.pluralize}"

    entities = if created_since
                 created_since = (Date.today - created_since.to_date).to_i
                 @intercom_client.send("#{entity.downcase.pluralize}").find_all(created_since: created_since.zero? ? 1 : created_since).to_a
               else
                 @intercom_client.send("#{entity.downcase.pluralize}").all.to_a
               end

    entities.map {|x| JSON.parse(x.to_json)}
  end

  def create(entity, params)
    @intercom_client.send("#{entity.downcase.pluralize}").create(params)
  end
end
