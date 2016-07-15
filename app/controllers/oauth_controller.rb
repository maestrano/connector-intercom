class OauthController < ApplicationController
  def create_omniauth
    if is_admin
      current_organization.update(
        oauth_name: request.env['omniauth.auth'][:extra][:raw_info][:name],
        oauth_uid: request.env['omniauth.auth'][:uid],
        oauth_provider: request.env['omniauth.auth'][:provider],
        oauth_token: request.env['omniauth.auth'][:credentials][:token],
      )
    end

    redirect_to root_url
  end

  def destroy_omniauth
    organization = Maestrano::Connector::Rails::Organization.find_by_id(params[:organization_id])

    if organization && is_admin?(current_user, organization)
      organization.oauth_uid = nil
      organization.oauth_token = nil
      organization.refresh_token = nil
      organization.sync_enabled = false
      organization.save
    end

    redirect_to root_url
  end
end
