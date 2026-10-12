import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';

/// Screen 4: Main Home / Scanner & Translator Dashboard
/// The primary workspace where the user lands after completing onboarding.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  final TextEditingController _inputController = TextEditingController();
  String _translatedText = '';
  bool _isTranslating = false;

  String _sourceLanguage = 'English';
  String _targetLanguage = 'Spanish';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Arabic',
    'Urdu',
    'Japanese',
    'Russian',
    'Hindi',
  ];

  // Quick dictionary for instant interactive demonstration in the semester project
  final Map<String, Map<String, String>> _sampleTranslations = {
    'Hello world': {
      'Spanish': 'Hola mundo',
      'French': 'Bonjour le monde',
      'German': 'Hallo Welt',
      'Chinese': '你好世界',
      'Arabic': 'مرحبا بالعالم',
      'Urdu': 'ہیلو دنیا',
    },
    'Welcome to Text Scanner': {
      'Spanish': 'Bienvenido a Text Scanner',
      'French': 'Bienvenue sur Text Scanner',
      'German': 'Willkommen bei Text Scanner',
      'Chinese': '欢迎使用文本扫描仪',
      'Arabic': 'مرحبًا بك في ماسح النصوص',
      'Urdu': 'ٹیکسٹ اسکینر میں خوش آمدید',
    },
  };

  @override
  void initState() {
    super.initState();
    _inputController.text = 'Welcome to Text Scanner';
    _performTranslation();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
      if (_translatedText.isNotEmpty) {
        _inputController.text = _translatedText;
      }
    });
    _performTranslation();
  }

  void _performTranslation() {
    final query = _inputController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    // Simulate instant natural processing
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _isTranslating = false;
        if (_sampleTranslations.containsKey(query) &&
            _sampleTranslations[query]!.containsKey(_targetLanguage)) {
          _translatedText = _sampleTranslations[query]![_targetLanguage]!;
        } else {
          // Dynamic demonstration output
          _translatedText = '[$_targetLanguage] $query';
        }
      });
    });
  }

  void _copyToClipboard(String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Copied to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _simulateCameraScan() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'OCR Camera Scanner',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select sample document to simulate instant camera text extraction:',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMedium, fontSize: 14),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long,
                      color: AppColors.primaryOrange),
                ),
                title: const Text('Store Receipt / Invoice'),
                subtitle: const Text('Extracts date, totals, and item names'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _inputController.text = 'Total: \$42.50 • Date: Oct 11, 2026';
                  _performTranslation();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.translatorBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_book,
                      color: AppColors.translatorBlue),
                ),
                title: const Text('Book Page / Article'),
                subtitle: const Text('Extracts paragraphs and quotes'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _inputController.text =
                      'Knowledge is power, information is liberating.';
                  _performTranslation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Text Scanner & Translator',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.textDark),
            tooltip: 'History',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textDark),
            tooltip: 'Settings',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // OCR Quick Action Banner
            _buildOcrActionCard(),

            const SizedBox(height: 24),

            // Translation Studio Header
            const Row(
              children: [
                Icon(Icons.translate_rounded,
                    size: 20, color: AppColors.primaryOrange),
                SizedBox(width: 8),
                Text(
                  'Translation Studio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Language Selector Bar
            _buildLanguageSelectorBar(),

            const SizedBox(height: 14),

            // Input Text Card
            _buildInputTextCard(),

            const SizedBox(height: 14),

            // Translated Result Card
            _buildResultCard(),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Scan OCR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.g_translate),
            label: 'Translate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Saved',
          ),
        ],
      ),
    );
  }

  Widget _buildOcrActionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFA8427), Color(0xFFFF9A4B)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instant OCR Scanner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Capture text from camera or photos',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _simulateCameraScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryOrange,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.camera_enhance_rounded, size: 18),
                  label: const Text(
                    'Scan Camera',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _simulateCameraScan,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text(
                    'Import Photo',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectorBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Source Language Dropdown
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sourceLanguage,
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppColors.textMedium),
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              items: _languages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(lang),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _sourceLanguage = val;
                  });
                  _performTranslation();
                }
              },
            ),
          ),

          // Swap Button
          IconButton(
            onPressed: _swapLanguages,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.primaryOrange,
                size: 20,
              ),
            ),
          ),

          // Target Language Dropdown
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _targetLanguage,
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppColors.textMedium),
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              items: _languages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(lang),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _targetLanguage = val;
                  });
                  _performTranslation();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTextCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Original ($_sourceLanguage)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              if (_inputController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _inputController.clear();
                    setState(() {
                      _translatedText = '';
                    });
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _inputController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter or paste text to translate...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Color(0xFFA0A5B0), fontSize: 15),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
              height: 1.4,
            ),
            onChanged: (val) {
              _performTranslation();
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_inputController.text.length} characters',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    color: AppColors.textMedium,
                    tooltip: 'Copy input',
                    onPressed: () => _copyToClipboard(_inputController.text),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, size: 20),
                    color: AppColors.textMedium,
                    tooltip: 'Speak text',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Playing pronunciation audio...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.translatorBlue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.translatorBlue.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Translation ($_targetLanguage)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.translatorBlue,
                ),
              ),
              if (_isTranslating)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _translatedText.isEmpty
                ? 'Translation will appear here...'
                : _translatedText,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: _translatedText.isEmpty
                  ? AppColors.textLight
                  : AppColors.textDark,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                color: AppColors.translatorBlue,
                tooltip: 'Copy translation',
                onPressed: () => _copyToClipboard(_translatedText),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, size: 20),
                color: AppColors.translatorBlue,
                tooltip: 'Listen pronunciation',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Playing translated pronunciation audio...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 19),
                color: AppColors.translatorBlue,
                tooltip: 'Share',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sharing translation...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
