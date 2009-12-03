When /^I log in as a user in the (.*) role$/ do |role|
  @user = Factory(:user,
                 :username => "user",
                 :password => "password",
                 :password_confirmation => "password")
  @role = Factory(:role, :name => role)
  @user.roles << @role
  visit login_url
  fill_in "Utilisateur", :with => "user"
  fill_in "Mot de passe", :with => "password"
  click_button "Se connecter"
  response.body.should =~ /Success/m
end

When /logged in as an? (.*)$/ do |role|
  Then "I log in as a user in the #{role} role"
end

When /^an (.*)$/ do |role|
  Then "I log in as a user in the #{role} role"
end