# O'Qi AI Agent - Regenerative Wellness App

O'Qi ("Oh-Chee") is a regenerative movement that merges artificial intelligence with timeless healing principles to guide individuals and organizations toward a sustainable, vibrant future. This Flutter app serves as the core platform for the O'Qi Tribe, providing personalized AI wellness guidance.

## 🌟 Features

### Core AI Agent
- **GPT-4o Powered AI Guide**: Personalized wellness coach trained on regenerative principles
- **Conversational Interface**: Natural language interaction with the AI agent
- **Context-Aware Responses**: AI remembers user preferences and conversation history
- **Karma Points System**: Reward conscious behaviors with karma points
- **Carbon Credits Tracking**: Monitor environmental impact

### Wellness Management
- **Personalized Goals**: AI-generated wellness goals based on user preferences
- **Progress Tracking**: Visual progress indicators and milestone tracking
- **Category-Based Goals**: Health, Nutrition, Movement, Sustainability, Mindfulness
- **Difficulty Levels**: Beginner, Intermediate, Advanced goal options

### User Experience
- **Beautiful UI/UX**: Modern, intuitive interface with smooth animations
- **Dashboard Overview**: Comprehensive view of wellness journey
- **Profile Management**: User profiles with achievements and statistics
- **Real-time Updates**: Live progress tracking and notifications

### Data & Privacy
- **Local Storage**: Hive database for offline functionality
- **Data Sovereignty**: User owns their data
- **Secure Communication**: Encrypted API calls to OpenAI
- **Privacy-First**: Minimal data collection, user-controlled sharing

## 🏗️ Architecture

### Tech Stack
- **Frontend**: Flutter 3.8+
- **State Management**: Provider pattern
- **Local Database**: Hive (NoSQL)
- **AI Integration**: OpenAI GPT-4o API
- **Charts**: FL Chart
- **Animations**: Flutter Animate

### Project Structure
```
lib/
├── models/           # Data models
│   ├── user_profile.dart
│   ├── ai_message.dart
│   └── wellness_goal.dart
├── providers/        # State management
│   └── app_provider.dart
├── services/         # Business logic
│   └── ai_service.dart
├── screens/          # UI screens
│   ├── welcome_page.dart
│   ├── ai_chat_page.dart
│   ├── dashboard_page.dart
│   ├── goals_page.dart
│   └── profile_page.dart
├── widgets/          # Reusable components
│   ├── message_bubble.dart
│   └── suggested_actions.dart
└── main.dart         # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8+
- Dart 3.0+
- Android Studio / VS Code
- OpenAI API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd oqiaiagent
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure OpenAI API**
   - Get your OpenAI API key from [OpenAI Platform](https://platform.openai.com/)
   - Update the API key in `lib/services/ai_service.dart`
   ```dart
   static const String _apiKey = 'YOUR_OPENAI_API_KEY';
   ```

4. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Flow

### 1. Welcome & Onboarding
- Beautiful welcome screen with O'Qi branding
- User intake form collecting preferences
- AI pairing process simulation

### 2. Dashboard
- Overview of wellness journey
- Karma points and carbon credits display
- Active goals and progress tracking
- Quick actions for common tasks

### 3. AI Chat Interface
- Conversational AI agent
- Suggested actions for quick interactions
- Real-time karma points and carbon impact
- Message history with animations

### 4. Goals Management
- Create and manage wellness goals
- Category-based organization
- Progress tracking with visual indicators
- AI-generated personalized goals

### 5. Profile & Achievements
- User profile management
- Badges and achievements system
- Statistics and progress charts
- Health and sustainability metrics

## 🎯 Core Principles

### Regenerative Wellness
- Focus on healing the body through natural means
- Plant Paradox nutrition guidance
- Mindful movement and breathwork

### Environmental Stewardship
- Every action considers planetary impact
- Carbon footprint tracking
- Sustainable living practices

### Data Sovereignty
- User owns their data
- Privacy-first approach
- Transparent data usage

### Karma Points System
- Reward conscious behaviors
- Gamification of wellness
- Community engagement

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```
OPENAI_API_KEY=your_openai_api_key_here
```

### API Configuration
The AI service is configured in `lib/services/ai_service.dart`:
- Base URL: OpenAI API
- Model: GPT-4o
- Temperature: 0.7 (balanced creativity)
- Max tokens: 1000

### Local Storage
Hive database configuration:
- User profiles
- Conversation history
- Wellness goals
- App preferences

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## 📦 Dependencies

### Core Dependencies
- `flutter`: UI framework
- `provider`: State management
- `hive`: Local database
- `http`: API communication
- `flutter_animate`: Animations

### UI Dependencies
- `fl_chart`: Data visualization
- `flutter_svg`: SVG support
- `cached_network_image`: Image caching

### Utility Dependencies
- `intl`: Internationalization
- `permission_handler`: Device permissions
- `flutter_local_notifications`: Local notifications

## 🔒 Security

### API Security
- API keys stored securely
- HTTPS communication only
- Request rate limiting

### Data Privacy
- Local data storage
- Encrypted sensitive data
- User consent for data sharing

### Code Security
- Input validation
- Error handling
- Secure coding practices

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- OpenAI for GPT-4o API
- Flutter team for the amazing framework
- O'Qi Tribe for inspiration and vision
- Craig De Luca for the regenerative principles

## 📞 Support

For support and questions:
- Email: support@oqi.ai
- Discord: O'Qi Tribe Community
- Documentation: [docs.oqi.ai](https://docs.oqi.ai)

---

**O'Qi Principle: Sustainability for All**

*This is what it looks like when humanity gets a second chance — and takes it.*
