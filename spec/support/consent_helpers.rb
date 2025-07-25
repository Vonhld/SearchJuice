module ConsentHelpers
  def give_ip_consent_ui
    visit root_path
    find('#modal-button').click
    sleep(1)
    find('#modal-confirm').click
    expect(page).to have_current_path(home_path)
  end

  def give_ip_consent_request
    post give_consent_path
  end
end