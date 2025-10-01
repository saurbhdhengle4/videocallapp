class AppConstants {
   static String get appId => dotenv.env['APP_ID'] ?? '';
   static String get channelName => dotenv.env['CHANNEL_NAME'] ?? '';
   static String get tempToken => dotenv.env['TEMP_TOKEN'] ?? '' 
}
/// AppConstants loads keys from the .env file.
///  Create a .env file in your project root 
///  Add keys like:
///    APP_ID=your_app_id_here
///    CHANNEL_NAME=your_channel_name_here
///    TEMP_TOKEN=your_temp_token_here
///  Access keys anywhere using `AppConstants.appId`, etc.
