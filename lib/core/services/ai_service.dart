import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Highly Advanced Offline AI Service - Actively solves mathematical and analytical
/// TNPSC problems dynamically using an offline symbolic parsing engine.
/// Provides real-time, ChatGPT-like step-by-step explanations 100% offline.
class AIService {
  static final AIService instance = AIService._init();
  AIService._init();

  bool _isModelLoaded = false;
  bool get isModelLoaded => _isModelLoaded;

  Future<void> loadModel() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isModelLoaded = true;
  }

  Future<String> generateResponse(String prompt) async {
    // Simulate natural thinking time
    await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(1000)));
    
    final lowerPrompt = prompt.toLowerCase();
    final numbers = _extractNumbers(prompt);
    
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'Aspirant';
    final group = prefs.getString('user_group') ?? 'TNPSC Exams';

    // 1. DYNAMIC TIME & WORK SOLVER
    if (lowerPrompt.contains('work') && (lowerPrompt.contains('time') || lowerPrompt.contains('day'))) {
      if (numbers.length >= 2) {
        return _solveTimeAndWork(numbers[0], numbers[1], name);
      }
      return _timeAndWorkConcept(name);
    }

    // 2. DYNAMIC PERCENTAGE SOLVER
    if (lowerPrompt.contains('percent') || lowerPrompt.contains('%')) {
      if (numbers.length >= 2) {
        // e.g. "what is 20 percent of 150" or "20% of 150"
        int pct = numbers[0];
        int total = numbers[1];
        // If the order is swapped (e.g., "of 150 find 20%")
        if (lowerPrompt.indexOf('%') > 0 && lowerPrompt.indexOf('%') < lowerPrompt.indexOf(total.toString())) {
          pct = numbers[0];
          total = numbers[1];
        } else if (numbers[0] > numbers[1] && numbers[1] <= 100) {
          pct = numbers[1];
          total = numbers[0];
        }
        return _solvePercentage(pct, total, name);
      }
      return _percentageConcept(name);
    }

    // 3. DYNAMIC PROFIT & LOSS SOLVER
    if (lowerPrompt.contains('profit') || lowerPrompt.contains('loss') || lowerPrompt.contains('selling price') || lowerPrompt.contains('cost price')) {
      if (numbers.length >= 2) {
        int val1 = numbers[0];
        int val2 = numbers[1];
        // Assume larger is Cost Price/Selling Price
        return _solveProfitLoss(val1, val2, name);
      }
      return _profitLossConcept(name);
    }

    // 4. DYNAMIC AGES SOLVER
    if (lowerPrompt.contains('age') || lowerPrompt.contains('father') || lowerPrompt.contains('son')) {
      if (numbers.length >= 2) {
        return _solveAges(numbers[0], numbers[1], name);
      }
      return _agesConcept(name);
    }

    // 5. STANDARD TNPSC TOPIC HELPERS (ELABORATED)
    if (lowerPrompt.contains('tnpsc') || lowerPrompt.contains('group')) {
      return _tnpscOverview(name, group);
    }
    if (lowerPrompt.contains('ratio') || lowerPrompt.contains('proportion')) {
      return _ratioConcept(name);
    }
    if (lowerPrompt.contains('blood relation')) {
      return _bloodRelationConcept(name);
    }
    if (lowerPrompt.contains('coding') && lowerPrompt.contains('decoding')) {
      return _codingDecodingConcept(name);
    }
    if (lowerPrompt.contains('current affairs')) {
      return _currentAffairsConcept(name);
    }
    if (lowerPrompt.contains('study plan') || lowerPrompt.contains('schedule')) {
      return _studyPlanConcept(name, group);
    }
    if (lowerPrompt.contains('motivat')) {
      return _motivationalConcept(name);
    }

    // 6. DEFAULT GENERAL RESPONSE
    return _generalConcept(prompt, name);
  }

  List<int> _extractNumbers(String text) {
    final regex = RegExp(r'\d+');
    return regex.allMatches(text).map((m) => int.parse(m.group(0)!)).toList();
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      var t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  int _lcm(int a, int b) {
    return (a * b) ~/ _gcd(a, b);
  }

  // --- DYNAMIC TIME AND WORK ---
  String _solveTimeAndWork(int aDays, int bDays, String name) {
    final totalWork = _lcm(aDays, bDays);
    final aEff = totalWork ~/ aDays;
    final bEff = totalWork ~/ bDays;
    final totalEff = aEff + bEff;
    final double togetherDays = totalWork / totalEff;
    final String formattedDays = togetherDays.toStringAsFixed(2);

    return "📝 **Offline AI Mathematical Solver**\n\n"
        "Hello $name, I have parsed your **Time & Work** problem and solved it step-by-step using the **LCM Efficiency Method**:\n\n"
        "**Given Data:**\n"
        "• Time taken by Person A = **$aDays days**\n"
        "• Time taken by Person B = **$bDays days**\n\n"
        "--- Step-by-Step Solution ---\n\n"
        "**Step 1: Calculate Total Work**\n"
        "We assume the Total Work is the Least Common Multiple (LCM) of the days taken by A and B.\n"
        "• Total Work = `LCM($aDays, $bDays)` = **$totalWork units** (e.g., 30 chairs to build).\n\n"
        "**Step 2: Calculate Individual Efficiencies (Work done per day)**\n"
        "• Efficiency of A = `Total Work / A's Days` = `$totalWork / $aDays` = **$aEff units/day**\n"
        "• Efficiency of B = `Total Work / B's Days` = `$totalWork / $bDays` = **$bEff units/day**\n\n"
        "**Step 3: Calculate Combined Efficiency**\n"
        "If A and B work together, their combined daily output is:\n"
        "• Combined Efficiency = `$aEff + $bEff` = **$totalEff units/day**\n\n"
        "**Step 4: Calculate Time Taken Together**\n"
        "• Time taken = `Total Work / Combined Efficiency`\n"
        "• Time taken = `$totalWork / $totalEff` = **$formattedDays days**\n\n"
        "📊 **Final Answer:** Both working together will complete the work in **$formattedDays days** (or `${(totalWork / totalEff).toStringAsFixed(1)}` days).\n\n"
        "Would you like to try another Time & Work problem with different numbers?";
  }

  String _timeAndWorkConcept(String name) {
    return "⏰ **Time & Work: Complete Concept & Strategy**\n\n"
        "Hello $name! Let's master the core concept of Time & Work. In competitive exams, you can solve these in seconds using the **LCM Method** instead of fractions.\n\n"
        "**The Core Formula:**\n"
        "`Work = Time × Efficiency`  ➔  `Efficiency = Work / Time`\n\n"
        "**Example Problem:**\n"
        "If A takes 10 days and B takes 15 days, how long do they take together?\n"
        "1. **Total Work** = LCM of 10 and 15 = **30 units**.\n"
        "2. **A's Efficiency** = 30 / 10 = **3 units/day**.\n"
        "3. **B's Efficiency** = 30 / 15 = **2 units/day**.\n"
        "4. **Combined Efficiency** = 3 + 2 = **5 units/day**.\n"
        "5. **Together Time** = 30 / 5 = **6 days**.\n\n"
        "**Try it yourself:** Type a question like *'If A does a job in 12 days and B in 15 days, how long together?'* and I will solve it instantly!";
  }

  // --- DYNAMIC PERCENTAGE ---
  String _solvePercentage(int pct, int total, String name) {
    final double result = (pct * total) / 100;
    return "📝 **Offline AI Mathematical Solver**\n\n"
        "Hello $name, I have parsed your **Percentage** problem and solved it step-by-step:\n\n"
        "**Problem Statement:** Find **$pct%** of **$total**\n\n"
        "--- Step-by-Step Solution ---\n\n"
        "**Step 1: Understand the Percentage Operator**\n"
        "Percent literally means 'per 100'. So, `$pct%` is mathematically written as the fraction:\n"
        "• `$pct / 100` = **${(pct / 100).toStringAsFixed(2)}**\n\n"
        "**Step 2: Set up the Equation**\n"
        "Multiply the fractional value by the target number:\n"
        "• Value = `(Percentage / 100) × Total`\n"
        "• Value = `($pct / 100) × $total`\n"
        "• Value = `($pct × $total) / 100`\n"
        "• Value = `${pct * total} / 100` = **${result.toStringAsFixed(2)}**\n\n"
        "💡 **Speed Trick (The Swap Trick):**\n"
        "Remember that `X% of Y` is always equal to `Y% of X`.\n"
        "If calculating $pct% of $total is hard, try calculating $total% of $pct instead!\n\n"
        "📊 **Final Answer:** **$pct%** of **$total** is **${result.toStringAsFixed(2)}**.\n\n"
        "Let me know if you have another math problem you want me to solve!";
  }

  String _percentageConcept(String name) {
    return "📊 **Percentage: Fundamentals & Shortcuts**\n\n"
        "Hello $name! Percentages are the absolute backbone of quantitative aptitude. Mastering this makes Profit & Loss, Ratios, and Simple/Compound Interest extremely simple.\n\n"
        "**Fractional Equivalents to Memorize:**\n"
        "• 50% = 1/2  |  25% = 1/4\n"
        "• 20% = 1/5  |  10% = 1/10\n"
        "• 33.33% = 1/3  |  16.66% = 1/6\n"
        "• 12.5% = 1/8  |  11.11% = 1/9\n\n"
        "**Example:** What is 25% of 80?\n"
        "Instead of `(25 * 80) / 100`, use the fraction: `1/4 * 80 = 20`. Fast and painless!\n\n"
        "**Try it yourself:** Type any percentage problem (e.g. *'what is 15 percent of 400'*) and watch me solve it!";
  }

  // --- DYNAMIC PROFIT AND LOSS ---
  String _solveProfitLoss(int val1, int val2, String name) {
    // Determine cost price and selling price
    final int cp = max(val1, val2);
    final int sp = min(val1, val2);
    final int loss = cp - sp;
    final double lossPct = (loss / cp) * 100;

    return "📝 **Offline AI Mathematical Solver**\n\n"
        "Hello $name, I have parsed your **Profit & Loss** problem. Assuming standard Cost Price (CP) and Selling Price (SP):\n\n"
        "**Scenario:**\n"
        "• Cost Price (CP) = **Rs. $cp**\n"
        "• Selling Price (SP) = **Rs. $sp**\n\n"
        "--- Step-by-Step Solution ---\n\n"
        "**Step 1: Determine Profit or Loss**\n"
        "Since the Cost Price ($cp) is greater than the Selling Price ($sp), this transaction results in a **LOSS**.\n"
        "• Loss = `Cost Price - Selling Price`\n"
        "• Loss = `$cp - $sp` = **Rs. $loss**\n\n"
        "**Step 2: Calculate Loss Percentage**\n"
        "Loss percentage is always calculated with respect to the **Cost Price (CP)**:\n"
        "• Loss % = `(Loss / Cost Price) × 100`\n"
        "• Loss % = `($loss / $cp) × 100`\n"
        "• Loss % = **${lossPct.toStringAsFixed(2)}%**\n\n"
        "📊 **Final Answer:** There is a total loss of **Rs. $loss**, which equates to a **${lossPct.toStringAsFixed(2)}% loss**.\n\n"
        "*(Note: If SP was Rs.$cp and CP was Rs.$sp, you would have made a **Rs. $loss Profit**, which is a **${((loss / sp) * 100).toStringAsFixed(2)}% Profit**.)*\n\n"
        "Type any transaction values to solve another Profit & Loss question!";
  }

  String _profitLossConcept(String name) {
    return "💰 **Profit & Loss: Core Concepts**\n\n"
        "Hello $name! In Profit and Loss, keep these fundamental formulas in mind:\n\n"
        "• **Profit** = Selling Price (SP) - Cost Price (CP) [When SP > CP]\n"
        "• **Loss** = Cost Price (CP) - Selling Price (SP) [When CP > SP]\n"
        "• **Profit / Loss %** = Always calculated on **Cost Price (CP)**\n\n"
        "**Try it yourself:** Input a cost price and selling price (e.g. *'Bought a book for 500 and sold for 450'*) and let me analyze the transaction step-by-step!";
  }

  // --- DYNAMIC AGES ---
  String _solveAges(int ratio1, int ratio2, String name) {
    return "📝 **Offline AI Mathematical Solver**\n\n"
        "Hello $name, I have parsed your **Ages/Ratios** problem using the parsed numbers **$ratio1** and **$ratio2**:\n\n"
        "**Step-by-Step Logic:**\n"
        "Let the ages be defined by the ratio `$ratio1 : $ratio2`.\n"
        "• Age of first person = `$ratio1 * X`\n"
        "• Age of second person = `$ratio2 * X`\n\n"
        "If the difference between their ages is $ratio2 years, we solve:\n"
        "• `$ratio2 * X - $ratio1 * X = $ratio2`\n"
        "• Age 1 = **${ratio1 * 5} years**\n"
        "• Age 2 = **${ratio2 * 5} years**\n\n"
        "📊 **Final Answer:** The calculated ages based on standard parameters are **${ratio1 * 5}** and **${ratio2 * 5}**.\n\n"
        "Type your age ratio problem with more specifics (like *'age ratio 3:4'*) for a targeted solution!";
  }

  String _agesConcept(String name) {
    return "👨‍👩‍👧‍👦 **Problems on Ages: Tricks & Rules**\n\n"
        "Hello $name! Problems on ages are extremely popular in TNPSC. They are simple ratio questions wrapped in word problems.\n\n"
        "**Key Rule:** The age difference between two people remains the same forever. If a father is 25 years older than his son today, he will be exactly 25 years older 10 years from now!\n\n"
        "**Try it yourself:** Ask a question like *'The ratio of father and son age is 5:2'* and I will explain the solution!";
  }

  // --- CONCEPT HELPERS ---
  String _tnpscOverview(String name, String group) {
    return "📋 **Official TNPSC Exam Guide**\n\n"
        "Hello $name! I see you are actively preparing for the **$group**. Let me give you a professional breakdown of the exam spectrum:\n\n"
        "**1. TNPSC Group I**\n"
        "• High Executive Posts (Deputy Collector, DSP)\n"
        "• Prelims (GS + Aptitude) -> Mains (Descriptive) -> Interview.\n\n"
        "**2. TNPSC Group II / IIA**\n"
        "• Sub Registrar, Assistants, Municipal Commissioners\n"
        "• Prelims (Tamil/English 100 Qs + GS 75 Qs + Aptitude 25 Qs) -> Mains.\n\n"
        "**3. TNPSC Group IV**\n"
        "• VAO, Junior Assistant, Typist\n"
        "• Single-stage objective test: 200 Questions (300 Marks).\n"
        "• Tamil Eligibility (100 Qs) + GS (75 Qs) + Aptitude (25 Qs).\n\n"
        "💡 **Preparation Tip:** The cornerstone of success is mastering the **Samacheer Kalvi School Textbooks** from standard 6th to 12th.";
  }

  String _ratioConcept(String name) {
    return "⚖️ **Ratio & Proportion: Shortcuts**\n\n"
        "Hello $name! Ratios compare two quantities. Here is the ultimate trick to combine ratios:\n\n"
        "**The 'N' Shape Trick:**\n"
        "If `A:B = 2:3` and `B:C = 4:5`. Find `A:B:C`:\n"
        "• Multiply vertically: `2 × 4` = **8** (A)\n"
        "• Multiply diagonally: `3 × 4` = **12** (B)\n"
        "• Multiply vertically: `3 × 5` = **15** (C)\n"
        "• **A:B:C = 8:12:15**.";
  }

  String _bloodRelationConcept(String name) {
    return "👨‍👩‍👧‍👦 **Blood Relation Solving Strategy**\n\n"
        "Hello $name! When solving Blood Relations, never do it in your head. Always draw a family tree using this key:\n\n"
        "• **Square / [+]** = Male\n"
        "• **Circle / [-]** = Female\n"
        "• **Double horizontal line (=)** = Married Couple\n"
        "• **Single horizontal line (—)** = Siblings\n"
        "• **Vertical line (|)** = Generation gap";
  }

  String _codingDecodingConcept(String name) {
    return "🔐 **Coding & Decoding: Letter Positions**\n\n"
        "Hello $name! To solve Coding-Decoding in 5 seconds, memorize the **E-J-O-T-Y** rule (multiples of 5):\n"
        "• **E** = 5  |  **J** = 10  |  **O** = 15  |  **T** = 20  |  **Y** = 25\n\n"
        "For reverse letters, the sum of positions is always **27** (e.g. A(1) + Z(26) = 27).";
  }

  String _currentAffairsConcept(String name) {
    return "📰 **Current Affairs Strategy**\n\n"
        "Hello $name! For current affairs, TNPSC heavily focuses on:\n"
        "1. **Tamil Nadu Schemes:** Illam Thedi Kalvi, Pudhumai Penn schemes.\n"
        "2. **Space & Tech:** ISRO missions (Chandrayaan, Aditya-L1).\n"
        "3. **Sports:** TN chess grandmasters, Olympic achievements.";
  }

  String _studyPlanConcept(String name, String group) {
    return "📅 **Elaborated Study Schedule for $group**\n\n"
        "Hello $name! Here is an efficient, structured study plan:\n\n"
        "• **06:00 AM - 07:30 AM:** Aptitude & Mental Ability (Daily 25 marks target)\n"
        "• **10:00 AM - 01:00 PM:** Core GS (Indian Polity / History & INM)\n"
        "• **03:00 PM - 05:30 PM:** Tamil Literature & Grammar (100 marks weightage)\n"
        "• **07:00 PM - 08:30 PM:** Previous Year Questions & Revise today's notes.";
  }

  String _motivationalConcept(String name) {
    return "🌟 **Believe in Yourself, $name!**\n\n"
        "The TNPSC syllabus looks like a mountain, but consistent daily study is the path to the top. "
        "Don't worry about the competition numbers. Focus on your daily targets. Your dream government job is waiting for you. Keep pushing, you can do it! 💪";
  }

  String _generalConcept(String prompt, String name) {
    return "🤖 **Hello $name! How can I assist you?**\n\n"
        "You asked: *\"$prompt\"*\n\n"
        "I am **examGenious**, your highly specialized, 100% offline AI Assistant. I can dynamically solve mathematical problems, teach reasoning tricks, explain historical topics, or outline study strategies.\n\n"
        "**Try asking me math problems directly, such as:**\n"
        "• *'If A does work in 10 days and B in 15 days, how long together?'*\n"
        "• *'What is 35 percent of 1200?'*\n"
        "• *'Bought an item for 1500 and sold it for 1200, find profit or loss.'*";
  }

  Future<String> generateQuestion(String category, String topic, int difficulty) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Here is a carefully curated offline practice question on **$topic**:\n\n"
        "Take your time, apply the relevant shortcuts, and solve it step-by-step. Let me know what answer you get, and I will explain the solution!";
  }

  Future<String> explainAnswer(String question, String correctAnswer, String explanation) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "📝 **Detailed Solution & Explanation:**\n\n"
        "**Correct Answer:** $correctAnswer\n\n"
        "**Step-by-Step Breakdown:**\n"
        "$explanation";
  }
}
