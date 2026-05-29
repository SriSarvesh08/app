class Translations {
  static const Map<String, Map<String, String>> _keys = {
    'en': {
      'app_title': 'TNPSC AI',
      'tagline': 'Your Offline AI Exam Coach',
      'ask_ai': 'Ask AI Assistant',
      'quick_actions': 'Quick Actions',
      'aptitude': 'Aptitude & Mental Ability',
      'general_studies': 'General Studies',
      'reasoning': 'Logical Reasoning',
      'current_affairs': 'Current Affairs',
      'mock_test': 'Mock Tests',
      'progress': 'My Progress',
      'pdf_assistant': 'PDF Notes Assistant',
      'achievements': 'Achievements',
      'settings': 'Settings',
      'search_hint': 'Search topics...',
      'welcome_back': 'Welcome Back',
      'streak_active': 'Streak Active!',
      'motivation': 'Consistency is key!',
      'questions_solved': 'Questions Solved',
      'accuracy': 'Accuracy',
      'daily_target': 'Daily Target',
      'profile': 'Profile',
      'language_toggle': 'Change Language / தமிழ்',
      'group_selection': 'Target Exam',
    },
    'ta': {
      'app_title': 'டி.என்.பி.எஸ்.சி AI',
      'tagline': 'உங்களின் ஆஃப்லைன் AI தேர்வு பயிற்சியாளர்',
      'ask_ai': 'AI உதவியாளரிடம் கேளுங்கள்',
      'quick_actions': 'விரைவுச் செயல்கள்',
      'aptitude': 'திறனறிவு மற்றும் மனக்கணக்கு',
      'general_studies': 'பொது அறிவு',
      'reasoning': 'தருக்க அறிவு',
      'current_affairs': 'நடப்பு நிகழ்வுகள்',
      'mock_test': 'மாதிரித் தேர்வுகள்',
      'progress': 'எனது முன்னேற்றம்',
      'pdf_assistant': 'PDF குறிப்பு உதவியாளர்',
      'achievements': 'சாதனைகள்',
      'settings': 'அமைப்புகள்',
      'search_hint': 'தலைப்புகளைத் தேடுங்கள்...',
      'welcome_back': 'மீண்டும் வருக',
      'streak_active': 'தொடர் கற்றல் செயலில் உள்ளது!',
      'motivation': 'தொடர்ச்சியான முயற்சியே வெற்றிக்கு வழி!',
      'questions_solved': 'தீர்க்கப்பட்ட கேள்விகள்',
      'accuracy': 'துல்லியம்',
      'daily_target': 'தினசரி இலக்கு',
      'profile': 'சுயவிவரம்',
      'language_toggle': 'Change Language / English',
      'group_selection': 'இலக்கு தேர்வு',
    }
  };

  static String translate(String key, String lang) {
    return _keys[lang]?[key] ?? key;
  }
}
