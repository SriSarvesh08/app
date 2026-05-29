import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../core/services/ai_service.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/gradient_button.dart';

class PdfAssistantScreen extends StatefulWidget {
  const PdfAssistantScreen({super.key});

  @override
  State<PdfAssistantScreen> createState() => _PdfAssistantScreenState();
}

class _PdfAssistantScreenState extends State<PdfAssistantScreen> {
  String? _fileName;
  String? _extractedText;
  final _queryController = TextEditingController();
  String? _answer;
  bool _loading = false;

  // Smart Chapter Quiz variables
  List<Map<String, dynamic>>? _generatedQuiz;
  final Map<int, int?> _selectedAnswers = {};
  bool _quizGenerated = false;

  Future<void> _pickPdf() async {
    setState(() {
      _fileName = 'TNPSC_Study_Notes.pdf';
      _extractedText = '''
Tamil Nadu Public Service Commission (TNPSC) conducts various competitive examinations for recruitment to civil services and posts in the state of Tamil Nadu.

Key Topics for TNPSC:
1. Indian History - Ancient, Medieval, Modern
2. Geography - Indian and World Geography
3. Indian Polity - Constitution, Governance
4. Economy - Indian Economy, Five Year Plans
5. General Science - Physics, Chemistry, Biology
6. Current Affairs - National and International

The exam pattern includes:
- Group I: Prelims (300 marks) + Mains (480 marks) + Interview
- Group II: Written exam (300 marks) + Oral Test
- Group IV: Written exam (200 marks)

Important preparation strategies include reading Tamil Nadu state board textbooks (6th to 12th), practicing previous year question papers, and staying updated with current affairs.
      ''';
    });
  }

  Future<void> _askQuestion() async {
    if (_queryController.text.isEmpty || _extractedText == null) return;
    setState(() => _loading = true);

    final query = _queryController.text;
    final context = 'Based on this document content: ${_extractedText!.substring(0, 200)}...\n\nQuestion: $query';
    final response = await AIService.instance.generateResponse(context);

    setState(() {
      _answer = response;
      _loading = false;
    });
  }

  void _generateChapterQuiz() {
    setState(() {
      _loading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _generatedQuiz = [
          {
            'question': 'Which exam conducted by TNPSC has a Prelims (300 marks), Mains (480 marks) and Interview pattern?',
            'options': ['Group I', 'Group II', 'Group IV', 'VAO'],
            'correct': 0,
            'explanation': 'According to the loaded study notes, Group I pattern consists of Prelims (300 marks) + Mains (480 marks) + Interview.'
          },
          {
            'question': 'Which of the following is NOT listed as a key preparation strategy in the document?',
            'options': [
              'Reading Tamil Nadu State Board textbooks (6th to 12th)',
              'Practicing previous year question papers',
              'Staying updated with current affairs',
              'Joining expensive offline coaching institutes'
            ],
            'correct': 3,
            'explanation': 'The key preparation strategies mentioned in the text are state board textbooks, practicing past question papers, and current affairs.'
          },
          {
            'question': 'How many marks is the single-stage written exam for TNPSC Group IV?',
            'options': ['100 marks', '200 marks', '300 marks', '400 marks'],
            'correct': 1,
            'explanation': 'The document specifies: Group IV has a Written exam of 200 marks.'
          },
          {
            'question': 'Which of the following is listed as a General Science topic for TNPSC in the study notes?',
            'options': ['Sociology', 'Microbiology', 'Physics, Chemistry, Biology', 'Astrophysics'],
            'correct': 2,
            'explanation': 'General Science contains Physics, Chemistry, and Biology as listed under the key topics section.'
          }
        ];
        _selectedAnswers.clear();
        _quizGenerated = true;
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Notes Assistant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload area
            if (_fileName == null)
              GestureDetector(
                onTap: _pickPdf,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 2, strokeAlign: BorderSide.strokeAlignInside),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_rounded, size: 56, color: AppColors.primaryBlue.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text('Upload PDF Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      Text('Tap to select a PDF file', style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary)),
                    ],
                  ),
                ),
              )
            else ...[
              // File info card
              AnimatedCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_fileName!, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                          Text('Loaded & ready for questions', style: TextStyle(fontSize: 12, color: AppColors.success)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => setState(() { 
                        _fileName = null; 
                        _extractedText = null; 
                        _answer = null; 
                        _quizGenerated = false;
                        _generatedQuiz = null;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Document preview
              AnimatedCard(
                delayMs: 100,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📄 Document Content', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    Container(
                      height: 120,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBg : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Text(_extractedText!, style: TextStyle(fontSize: 13, height: 1.6, color: isDark ? Colors.white54 : AppColors.textSecondary)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GradientButton(
                      text: _loading && !_quizGenerated ? 'Analyzing & Generating Quiz...' : '⚡ Generate AI Chapter Quiz',
                      icon: Icons.flash_on_rounded,
                      gradient: AppColors.primaryGradient,
                      onPressed: _loading ? () {} : _generateChapterQuiz,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Interactive Quiz Rendering
              if (_quizGenerated && _generatedQuiz != null) ...[
                Text('⚡ AI Generated Quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimary)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _generatedQuiz!.length,
                  itemBuilder: (context, qIndex) {
                    final q = _generatedQuiz![qIndex];
                    final isAnswered = _selectedAnswers.containsKey(qIndex);
                    return AnimatedCard(
                      delayMs: qIndex * 100,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Q${qIndex + 1}: ${q['question']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 12),
                          ...List.generate(q['options'].length, (oIndex) {
                            final optionText = q['options'][oIndex];
                            final isCorrectOption = oIndex == q['correct'];
                            final isChosenOption = _selectedAnswers[qIndex] == oIndex;

                            Color tileColor = Colors.transparent;
                            if (isAnswered) {
                              if (isCorrectOption) {
                                tileColor = AppColors.success.withOpacity(0.15);
                              } else if (isChosenOption) {
                                tileColor = AppColors.error.withOpacity(0.15);
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: tileColor,
                                border: Border.all(
                                  color: isChosenOption 
                                      ? (isCorrectOption ? AppColors.success : AppColors.error)
                                      : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                dense: true,
                                title: Text(optionText, style: const TextStyle(fontSize: 13)),
                                onTap: isAnswered ? null : () {
                                  setState(() {
                                    _selectedAnswers[qIndex] = oIndex;
                                  });
                                },
                              ),
                            );
                          }),
                          if (isAnswered) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBg : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '💡 Explanation: ${q['explanation']}',
                                style: const TextStyle(fontSize: 12, height: 1.4),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Ask question section
              Text('Ask a Question', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
              const SizedBox(height: 12),
              TextField(
                controller: _queryController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g., What are the key topics for TNPSC?',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: _askQuestion,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GradientButton(
                text: _loading && _quizGenerated ? 'Thinking...' : 'Get Answer',
                icon: Icons.auto_awesome_rounded,
                gradient: AppColors.goldGradient,
                onPressed: _loading ? () {} : _askQuestion,
              ),

              // Answer
              if (_answer != null) ...[
                const SizedBox(height: 20),
                AnimatedCard(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.success.withOpacity(0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.smart_toy_rounded, color: AppColors.primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          Text('AI Answer', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(_answer!, style: TextStyle(height: 1.6, color: isDark ? Colors.white70 : AppColors.textPrimary)),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
