Hi <%= @user.email %>,

You have requested to reset your password.
Please follow this link:
<%= "http://localhost:8080/#/password_resets/#{@user.reset_password_token}" %>
Reset password URL is valid within 24 hours.

Have a nice day!