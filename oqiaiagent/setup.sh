#!/bin/bash

# O'Qi AI Agent Setup Script
# This script helps set up the O'Qi AI agent Flutter app

echo "🌱 Welcome to O'Qi AI Agent Setup"
echo "=================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed."
    echo "Please install Flutter first:"
    echo "https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | grep -o "Flutter [0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
echo "📱 $FLUTTER_VERSION detected"

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Generate Hive adapters
echo "🔧 Generating Hive adapters..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check if OpenAI API key is configured
echo "🤖 Checking OpenAI API configuration..."
if grep -q "YOUR_OPENAI_API_KEY" lib/services/ai_service.dart; then
    echo "⚠️  Warning: OpenAI API key not configured"
    echo "Please update lib/services/ai_service.dart with your OpenAI API key"
    echo "Get your API key from: https://platform.openai.com/api-keys"
else
    echo "✅ OpenAI API key appears to be configured"
fi

# Create assets directories if they don't exist
echo "📁 Creating asset directories..."
mkdir -p assets/images
mkdir -p assets/animations
mkdir -p assets/icons
mkdir -p assets/fonts

# Create placeholder files
echo "📝 Creating placeholder files..."
touch assets/images/.gitkeep
touch assets/animations/.gitkeep
touch assets/icons/.gitkeep
touch assets/fonts/.gitkeep

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Configure your OpenAI API key in lib/services/ai_service.dart"
echo "2. Add your assets to the assets/ directories"
echo "3. Run 'flutter run' to start the app"
echo ""
echo "For more information, see README.md"
echo ""
echo "🌍 O'Qi Principle: Sustainability for All"