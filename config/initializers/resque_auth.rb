Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == ADMIN_PASSWORD
end