class WelcomeController < ApplicationController
  layout 'welcome'
  skip_before_action :require_ip_consent, only: [:index, :consent]

  
  def index
  end

  # Consent logic about the use of your IP address
  def consent
    session[:ip_consent_given] = true
    redirect_to home_path
  end
end
