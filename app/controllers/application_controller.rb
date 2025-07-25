class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :require_ip_consent


  
  private
  # Redirect logic for IP Consent
  def require_ip_consent
    unless session[:ip_consent_given] || request.path == root_path
      respond_to do |format|
        flash[:error] = "You must accept the IP usage terms to continue."
        format.html { redirect_to root_path }
      end
    end
  end
end
