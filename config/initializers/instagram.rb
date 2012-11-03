require "instagram"

Instagram.configure do |config|
  config.client_id = "9329bca7ecec4444ac088cc35d3f188f"
  config.client_secret = "b090f92d7be4426383920ddf48e5d9f4"
end

CALLBACK_URL = "http://localhost:3000/session/callback"
