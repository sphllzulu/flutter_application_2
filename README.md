# Weather & Recommendations App

A Flutter application that provides weather information and location-based recommendations using the Foursquare API.

## Features

- Current weather conditions (temperature, humidity, wind speed)
- Weather description and icons
- Location-based venue recommendations
- Search by city name
- Automatic location detection
- Responsive UI with scrollable content

## Architecture

The app follows the Model-Controller-Presenter (MCP) pattern:

- **Models**:
  - `WeatherModel`: Stores weather data
  - `VenueModel`: Stores venue/recommendation data

- **Controllers**:
  - `WeatherController`: Business logic for weather and recommendations
  - `FoursquareService`: API client for venue recommendations
  - `WeatherService`: API client for weather data

- **Presenters**:
  - `WeatherScreen`: Main UI screen
  - Widgets for weather cards and venue cards

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Create a `.env` file in the root directory with these required API keys:
   ```
   # Weather API (OpenWeatherMap)
   OPENWEATHER_API_KEY=your_openweather_api_key_here
   
   # Foursquare Places API
   FOURSQUARE_API_KEY=your_foursquare_api_key_here
   FOURSQUARE_API_SECRET=your_foursquare_api_secret_here
   
   # Optional: Google Maps API (if adding maps later)
   # GOOGLE_MAPS_API_KEY=your_google_maps_key
   ```

   Note:
   - Never commit your .env file to version control
   - Add `.env` to your `.gitignore` file
   - These keys can be obtained from:
     - OpenWeatherMap: https://openweathermap.org/api
     - Foursquare: https://developer.foursquare.com/
4. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- `provider`: State management
- `geolocator`: Location services
- `http`: API requests
- `cached_network_image`: Image loading
- `flutter_dotenv`: Environment variables

## Screenshots

TODO: Add screenshots of the app

## Known Issues

- Limited error handling for API failures
- Basic UI styling could be improved
- No offline support

## Future Improvements

- Add weather forecasts
- Implement favorites/bookmarks
- Improve recommendation filtering
- Add more detailed venue information
- Implement dark mode
