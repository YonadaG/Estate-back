# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # CRUCIAL: Replace 'http://localhost:3000' with your React app's actual origin
    origins 'http://localhost:5173', 'localhost:5173'

    resource '*', 
      headers: :any, 
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      #  VITAL: This line allows the browser to send/receive session cookies
      credentials: true,
      expose: ['Set-Cookie'],
      max_age: 3600
  end
end