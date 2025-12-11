# Real estate data seed
# db/seeds.rb
puts "Cleaning database..."
User.destroy_all
Property.destroy_all
Image.destroy_all
Inquiry.destroy_all
Favorite.destroy_all

puts "Creating users..."

# Create regular users
user1 = User.create!(
  name: "Mikias Bekele",
  email: "mikias@example.com",
  phone: "+251911234567",
  password: "password123",
  role: "user"
)

user2 = User.create!(
  name: "Selamawit Abebe",
  email: "selam@example.com",
  phone: "+251922345678",
  password: "password123",
  role: "user"
)

# Create owners
owner1 = User.create!(
  name: "Yonas Tadesse",
  email: "yonas@example.com",
  phone: "+251933456789",
  password: "password123",
  role: "owner"
)

owner2 = User.create!(
  name: "Hirut Tesfaye",
  email: "hirut@example.com",
  phone: "+251944567890",
  password: "password123",
  role: "owner"
)

# Create broker
broker = User.create!(
  name: "Daniel Assefa",
  email: "daniel@example.com",
  phone: "+251955678901",
  password: "password123",
  role: "broker"
)

# # Create admin
# admin = User.create!(
#   name: "Admin System",
#   email: "admin@realestate.com",
#   phone: "+251900000000",
#   password: "admin123",
#   role: "admin"
# )

puts "Creating properties..."

# Property statuses and types from your model
STATUSES = [ "Available", "Pending", "Sold", "Rented" ]
PROPERTY_TYPES = [ "House", "Apartment", "Condo", "Townhouse", "Land" ]

# Owner1's properties in Addis Ababa
property1 = owner1.properties.create!(
  title: "Modern Apartment in Bole",
  description: "Beautiful 2-bedroom apartment in Bole area, near Bole Airport and shopping centers. Recently renovated with modern finishes.",
  price: 3500000,
  location: "Bole Road, Addis Ababa, Ethiopia",
  property_type: "Apartment",
  status: "Available",
  bedrooms: 2,
  bathrooms: 2,
  area: 120.5, # Square meters
  floor_number: 3,
  latitude: 8.9806,
  longitude: 38.7578,
  additional_information: {
    "neighborhood" => "Bole",
    "amenities" => [ "security", "generator", "elevator", "parking" ],
    "year_built" => 2018,
    "parking_spaces" => 1
  }
)

property2 = owner1.properties.create!(
  title: "Family House in CMC",
  description: "Spacious 4-bedroom family house in CMC area with large garden. Quiet neighborhood with good schools nearby.",
  price: 8500000,
  location: "CMC, Addis Ababa, Ethiopia",
  property_type: "House",
  status: "Available",
  bedrooms: 4,
  bathrooms: 3,
  area: 280.0, # Square meters
  floor_number: 0, # Ground floor
  latitude: 9.0227,
  longitude: 38.7469,
  additional_information: {
    "neighborhood" => "CMC",
    "amenities" => [ "garden", "garage", "guard house", "water tank" ],
    "year_built" => 2010,
    "parking_spaces" => 2,
    "plot_size" => "500 sqm"
  }
)

# Owner2's property in Kazanchis
property3 = owner2.properties.create!(
  title: "Luxury Condo in Kazanchis",
  description: "High-end 3-bedroom condo in Kazanchis business district. Perfect for professionals with stunning city views.",
  price: 6500000,
  location: "Kazanchis, Addis Ababa, Ethiopia",
  property_type: "Condo",
  status: "Rented",
  bedrooms: 3,
  bathrooms: 3,
  area: 180.0, # Square meters
  floor_number: 8,
  latitude: 9.0221,
  longitude: 38.7578,
  additional_information: {
    "neighborhood" => "Kazanchis",
    "amenities" => [ "gym", "pool", "concierge", "underground parking", "generator" ],
    "year_built" => 2020,
    "parking_spaces" => 2,
    "furnished" => true,
    "monthly_rent" => 45000
  }
)

# Broker's commercial property in Piassa
property4 = broker.properties.create!(
  title: "Commercial Land in Piassa",
  description: "Prime commercial land in historic Piassa area. Ideal for hotel, office building, or commercial center.",
  price: 25000000,
  location: "Piassa, Addis Ababa, Ethiopia",
  property_type: "Land",
  status: "Available",
  bedrooms: 0,
  bathrooms: 0,
  area: 1000.0, # Square meters
  floor_number: 0,
  latitude: 9.0350,
  longitude: 38.7529,
  additional_information: {
    "neighborhood" => "Piassa",
    "zoning" => "commercial",
    "year_acquired" => 2015,
    "frontage" => "30 meters",
    "utilities" => [ "water", "electricity", "sewer" ]
  }
)

# Additional property in Old Airport
property5 = owner2.properties.create!(
  title: "Townhouse in Old Airport",
  description: "Modern townhouse in Old Airport area. 3 bedrooms with shared compound and security.",
  price: 5500000,
  location: "Old Airport, Addis Ababa, Ethiopia",
  property_type: "Townhouse",
  status: "Pending",
  bedrooms: 3,
  bathrooms: 2,
  area: 150.0, # Square meters
  floor_number: 0,
  latitude: 8.9962,
  longitude: 38.7891,
  additional_information: {
    "neighborhood" => "Old Airport",
    "amenities" => [ "shared garden", "security", "parking" ],
    "year_built" => 2017,
    "parking_spaces" => 1,
    "compound_houses" => 6
  }
)

puts "Creating images..."

# Property 1 images (Bole Apartment)
property1.images.create!(
  image_url: "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800",
  caption: "Modern living room in Bole apartment"
)

property1.images.create!(
  image_url: "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800",
  caption: "Kitchen with modern appliances"
)

property1.images.create!(
  image_url: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800",
  caption: "Master bedroom with balcony view"
)

# Property 2 images (CMC House)
property2.images.create!(
  image_url: "https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800",
  caption: "Front view of CMC family house"
)

property2.images.create!(
  image_url: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800",
  caption: "Spacious garden and backyard"
)

property2.images.create!(
  image_url: "https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=800",
  caption: "Living room with traditional Ethiopian decor"
)

# Property 3 images (Kazanchis Condo)
property3.images.create!(
  image_url: "https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800",
  caption: "Luxury condo living area"
)

property3.images.create!(
  image_url: "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800",
  caption: "City view from balcony"
)

# Property 4 images (Piassa Land)
property4.images.create!(
  image_url: "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800",
  caption: "Prime commercial land in Piassa"
)

# Property 5 images (Old Airport Townhouse)
property5.images.create!(
  image_url: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800",
  caption: "Townhouse exterior"
)

puts "Creating inquiries..."

# User1 inquires about Bole apartment
inquiry1 = Inquiry.create!(
  user: user1,
  property: property1,
  message: "Is the Bole apartment still available? I work near the airport and this would be perfect.",
  status: "pending",
  contact_preference: "phone"
)

# Owner responds to inquiry
inquiry1.update!(
  status: "responded",
  response_message: "Yes, it's available! We can show it to you this weekend. Please call me to schedule.",
  responded_by: owner1,
  responded_at: Time.current
)

# User2 inquires about Kazanchis condo
Inquiry.create!(
  user: user2,
  property: property3,
  message: "When will the condo be available for rent again? I'm interested in a 1-year lease.",
  status: "pending",
  contact_preference: "email"
)

# User1 also inquires about townhouse
Inquiry.create!(
  user: user1,
  property: property5,
  message: "Is the Old Airport townhouse still under negotiation? I'm very interested if it becomes available.",
  status: "pending",
  contact_preference: "both"
)

puts "Creating favorites..."

user1.favorites.create!(property: property1)  # Bole apartment
user1.favorites.create!(property: property3)  # Kazanchis condo
user1.favorites.create!(property: property5)  # Old Airport townhouse
user2.favorites.create!(property: property2)  # CMC house
user2.favorites.create!(property: property4)  # Piassa land

puts "Database seeded successfully!"
puts "Created #{User.count} users"
puts "Created #{Property.count} properties"
puts "Created #{Image.count} images"
puts "Created #{Inquiry.count} inquiries"
puts "Created #{Favorite.count} favorites"
