// Enhanced AI Service with Document Learning
const AIService = {
  uploadedDocs: [],
  maxUploads: 20,

  getUploadsToday() {
    const today = new Date().toDateString();
    const saved = JSON.parse(localStorage.getItem('ai_uploads') || '[]');
    return saved.filter(u => new Date(u.date).toDateString() === today);
  },

  getRemainingUploads() {
    return this.maxUploads - this.getUploadsToday().length;
  },

  async processUpload(text, filename) {
    if (this.getRemainingUploads() <= 0) return { error: 'Daily upload limit (20) reached. Try again tomorrow.' };
    const doc = {
      filename, text: text.substring(0, 50000),
      date: new Date().toISOString(),
      summary: this.generateSummary(text),
      keyPoints: this.extractKeyPoints(text),
      questions: this.generateQuestionsFromText(text, filename)
    };
    this.uploadedDocs.push(doc);
    const saved = JSON.parse(localStorage.getItem('ai_uploads') || '[]');
    saved.push({ filename, date: doc.date, summary: doc.summary });
    localStorage.setItem('ai_uploads', JSON.stringify(saved));
    return doc;
  },

  generateSummary(text) {
    const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 15);
    const important = sentences.slice(0, Math.min(5, sentences.length));
    return important.map(s => s.trim()).join('. ') + '.';
  },

  extractKeyPoints(text) {
    const lines = text.split('\n').filter(l => l.trim().length > 10);
    const points = [];
    const markers = [/^\d+[.)]/,/^[-•*]/,/^[A-Z][^a-z]/,/important/i,/key/i,/note/i,/remember/i];
    for (const line of lines) {
      if (markers.some(m => m.test(line.trim())) && points.length < 10) {
        points.push(line.trim().replace(/^[\d.)•*-]+\s*/, ''));
      }
    }
    if (points.length < 3) {
      const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 20);
      for (let i = 0; i < Math.min(5, sentences.length); i++) {
        if (!points.includes(sentences[i].trim())) points.push(sentences[i].trim());
      }
    }
    return points;
  },

  generateQuestionsFromText(text, filename) {
    const questions = [];
    const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 20);
    // Generate fill-in-the-blank style questions
    for (let i = 0; i < Math.min(5, sentences.length); i++) {
      const s = sentences[i].trim();
      const words = s.split(' ').filter(w => w.length > 4);
      if (words.length > 3) {
        const keyWord = words[Math.floor(words.length / 2)];
        const blanked = s.replace(keyWord, '____');
        const wrongOptions = words.filter(w => w !== keyWord).slice(0, 3);
        while (wrongOptions.length < 3) wrongOptions.push('None of the above');
        const opts = [keyWord, ...wrongOptions].sort(() => Math.random() - 0.5);
        questions.push({
          category: 'uploaded', topic: filename, difficulty: 1,
          question: `Fill in the blank: "${blanked}"`,
          options: opts, correct: opts.indexOf(keyWord),
          explanation: `The complete sentence is: "${s}"`, shortcut: ''
        });
      }
    }
    return questions;
  },

  async respond(prompt) {
    await new Promise(r => setTimeout(r, 300 + Math.random() * 600));
    const p = prompt.toLowerCase();

    // Check uploaded docs for context
    if (this.uploadedDocs.length > 0) {
      for (const doc of this.uploadedDocs) {
        if (doc.text.toLowerCase().includes(p.split(' ').slice(0, 3).join(' '))) {
          return `📄 Based on your uploaded document <strong>"${doc.filename}"</strong>:\n\n${doc.summary}\n\n<strong>Key Points:</strong>\n${doc.keyPoints.map(p => `• ${p}`).join('\n')}\n\n💡 I generated ${doc.questions.length} practice questions from this document. Try them in the Quiz section!`;
        }
      }
    }

    if (p.match(/hello|hi |hey|namaste|start/)) return "Hello! 👋 I'm <strong>examGenious</strong> — your personal exam coach.\n\n🎯 <strong>What I can do:</strong>\n\n📤 <strong>Upload & Learn</strong> — Upload syllabus/notes (20/day) and I'll generate summaries, key points & practice questions\n\n📊 <strong>Topic Mastery</strong> — Ask about any subject and get detailed explanations\n\n⚡ <strong>Shortcuts & Tricks</strong> — Quick formulas and solving techniques\n\n📋 <strong>Mock Tests</strong> — Up to 150 questions with detailed analysis\n\n📈 <strong>Weakness Analysis</strong> — Find and fix your weak areas\n\nTry: \"Upload my notes\" or ask any topic! 💪";

    if (p.match(/upload|syllabus|notes|document/)) return "📤 <strong>Upload Your Study Material!</strong>\n\nGo to the <strong>Upload</strong> section (tap the 📤 button) to:\n\n1️⃣ Upload text/PDF notes (up to 20/day)\n2️⃣ I'll generate a <strong>smart summary</strong>\n3️⃣ Extract <strong>key points</strong> to remember\n4️⃣ Create <strong>practice questions</strong> from your material\n5️⃣ You can then take a quiz on YOUR content!\n\n💡 Remaining uploads today: <strong>${this.getRemainingUploads()}/20</strong>";

    if (p.match(/tnpsc.*(syllabus|pattern|exam)/)) return "📋 <strong>TNPSC Exam Pattern:</strong>\n\n<strong>Group I (Civil Services)</strong>\n• Prelims: 200 Qs, 300 marks, 3 hrs\n• Mains: 3 papers, 480 marks\n• Interview: 120 marks\n\n<strong>Group II</strong>\n• 200 Qs, 300 marks, 3 hrs\n• Oral Test: 40 marks\n\n<strong>Group IV (CCSE)</strong>\n• 200 Qs, 300 marks, 3 hrs\n• No interview\n\n<strong>Subjects:</strong> GK, Aptitude, Tamil/English, Current Affairs\n\n💡 Upload the official syllabus PDF and I'll break it down for you!";

    if (p.match(/tnpsc.*(tips|prepare|strategy|plan)/)) return "🎯 <strong>TNPSC Master Strategy (6 Months):</strong>\n\n<strong>Phase 1 — Foundation (Month 1-2)</strong>\n📚 TN State Board Books (6-12th)\n📝 Basic Aptitude formulas\n🗓️ Daily 4 hours study\n\n<strong>Phase 2 — Deep Study (Month 3-4)</strong>\n📖 Polity, History, Geography in-depth\n🧩 Daily 20 reasoning questions\n📰 Weekly current affairs compilation\n\n<strong>Phase 3 — Revision & Mock (Month 5-6)</strong>\n📋 Weekly full mock tests (150 Qs)\n🔄 Revise weak topics identified by AI\n⏰ Time management practice\n\n<strong>Daily Schedule:</strong>\n⏰ 6-8 AM: GK & Current Affairs\n⏰ 10-12 PM: Aptitude & Reasoning\n⏰ 2-4 PM: English/Tamil\n⏰ 7-8 PM: Mock test & revision\n\n💡 Upload your current study material and I'll create a personalized plan!";

    if (p.match(/percentage|percent/)) return "📊 <strong>Percentage — Complete Guide:</strong>\n\n<strong>Basics:</strong>\nX% of Y = (X × Y) / 100\n\n<strong>Fraction Shortcuts:</strong>\n10% = 1/10 | 12.5% = 1/8 | 20% = 1/5\n25% = 1/4 | 33.3% = 1/3 | 50% = 1/2\n\n<strong>Successive Change:</strong>\nIf a value changes by a% then b%:\nNet = a + b + (ab/100)\n\n<strong>Population Formula:</strong>\nP = P₀(1 + r/100)ⁿ\n\n<strong>Pro Tricks:</strong>\n• 4% of 75 = 75% of 4 = 3\n• To find X% of Y, swap if easier\n• Increase by 25% then decrease by 20% = No change\n\n<strong>TNPSC Pattern:</strong> 2-3 questions in every exam\n\n📋 Take a practice quiz: Go to Aptitude → Percentages";

    if (p.match(/profit|loss|cost price|selling price/)) return "💰 <strong>Profit & Loss — Complete Guide:</strong>\n\n<strong>Formulas:</strong>\nProfit = SP - CP | Loss = CP - SP\nProfit% = (Profit/CP) × 100\nSP = CP × (100+P%)/100\n\n<strong>Discount:</strong>\nSP = MP × (100 - Discount%)/100\n\n<strong>Two Successive Discounts:</strong>\nNet Discount = a + b - ab/100\n\n<strong>Bought & Sold Pattern:</strong>\nBuy X for ₹a, Sell Y for ₹a\nProfit% = (X-Y)/Y × 100\n\n<strong>Dishonest Dealer:</strong>\nProfit% = (True Weight - False Weight)/False Weight × 100\n\n<strong>TNPSC Frequency:</strong> 1-2 questions per exam";

    if (p.match(/time.*(work|distance)|speed|train/)) return "⏰ <strong>Time & Work + Time & Distance:</strong>\n\n<strong>Time & Work:</strong>\nA=n days → 1 day work = 1/n\nTogether = (A×B)/(A+B) days\n\n<strong>LCM Method (Best for TNPSC):</strong>\n1. Take LCM of individual days\n2. Calculate per day efficiency\n3. Add for combined work\n\n<strong>Time & Distance:</strong>\nSpeed = Distance/Time\nkm/h → m/s: × 5/18\nm/s → km/h: × 18/5\n\n<strong>Train Problems:</strong>\n• Crossing pole: Time = Length/Speed\n• Crossing platform: Time = (L₁+L₂)/Speed\n• Two trains same dir: Relative speed = S₁-S₂\n• Opposite dir: Relative speed = S₁+S₂\n\n<strong>Average Speed:</strong>\n= 2×S₁×S₂/(S₁+S₂) for equal distances";

    if (p.match(/ratio|proportion/)) return "⚖️ <strong>Ratio & Proportion Guide:</strong>\n\n<strong>Ratio a:b</strong> means a/b\n\n<strong>Dividing in ratio a:b:c:</strong>\nA's share = (a/(a+b+c)) × Total\n\n<strong>Proportion:</strong> a:b = c:d → ad = bc\n\n<strong>Compound Ratio:</strong>\na:b and c:d → ac:bd\n\n<strong>Important Tricks:</strong>\n• Income:Expenditure = a:b, Savings same → multiply to make savings equal\n• Mixture problems: Use Alligation rule\n\n<strong>Alligation Formula:</strong>\nRatio = (Cheaper - Mean) : (Mean - Dearer)";

    if (p.match(/blood.?relation/)) return "👨‍👩‍👧‍👦 <strong>Blood Relations — Master Guide:</strong>\n\n<strong>Key Relations:</strong>\nFather's son = Brother\nMother's daughter = Sister\nFather's brother = Uncle\nMother's sister = Aunt\nFather's father = Grandfather\n\n<strong>Common Tricks:</strong>\n• 'Only son/daughter of my parents' = Myself\n• Draw family tree for complex problems\n• Use symbols: + Male, - Female\n\n<strong>Coded Relations:</strong>\nA$B = A is father of B\nA#B = A is mother of B\nDecode step by step\n\n<strong>TNPSC Pattern:</strong> 2-3 questions guaranteed";

    if (p.match(/coding|decoding/)) return "🔐 <strong>Coding-Decoding Types:</strong>\n\n<strong>1. Letter Shift:</strong> Each letter shifted by N positions\nExample: +2 → A=C, B=D\n\n<strong>2. Reverse Coding:</strong> Word reversed\nAPPLE → ELPPA\n\n<strong>3. Number Coding:</strong> A=1, B=2...Z=26\nCAT → 3-1-20\n\n<strong>4. Substitution:</strong> Letters replaced by specific code\n\n<strong>5. Mixed Pattern:</strong> Vowels coded differently\n\n<strong>Approach:</strong>\n1. Compare code with original letter by letter\n2. Find shift pattern\n3. Verify with second example\n4. Apply to decode";

    if (p.match(/grammar|tense|article|verb/)) return "✍️ <strong>English Grammar Quick Reference:</strong>\n\n<strong>Subject-Verb Agreement:</strong>\n• Singular subject → singular verb\n• Each/Every/Either → singular\n• Neither...nor → nearest subject\n• Collective noun → usually singular\n\n<strong>Articles:</strong>\n• A/An based on SOUND not letter\n• 'An hour' (silent H) | 'A university' (Y sound)\n\n<strong>Tenses Quick Map:</strong>\nSimple: V1/V2/will+V1\nContinuous: is/was/will be + V-ing\nPerfect: has/had/will have + V3\n\n<strong>Common Errors:</strong>\n• 'Comprise' never takes 'of'\n• 'Discuss' never takes 'about'\n• 'Return back' is redundant";

    if (p.match(/current.?affairs|news|update/)) return "📰 <strong>Current Affairs Strategy:</strong>\n\n<strong>High Priority for TNPSC:</strong>\n🏛️ TN Government schemes & policies\n🇮🇳 National government initiatives\n🌍 International summits & agreements\n🏆 Sports achievements\n🔬 Science & Technology breakthroughs\n📊 Economic indicators (GDP, Inflation)\n\n<strong>Sources:</strong>\n• The Hindu / Indian Express daily\n• PIB (Press Information Bureau)\n• Yojana & Kurukshetra magazines\n\n<strong>Strategy:</strong>\n• Read 30 min daily\n• Make monthly compilations\n• Focus on TN-specific news (extra weightage)\n• Revise last 6 months before exam\n\n💡 Check the Current Affairs section for latest updates!";

    if (p.match(/trick|shortcut|formula|quick/)) return "⚡ <strong>Top Shortcuts for TNPSC:</strong>\n\n<strong>Math Tricks:</strong>\n• ×11: 23×11 = 2_(2+3)_3 = 253\n• Square ending 5: 35² = 3×4|25 = 1225\n• ÷5: X÷5 = X×2÷10\n\n<strong>Divisibility Rules:</strong>\nBy 3: sum of digits ÷ 3\nBy 4: last 2 digits ÷ 4\nBy 8: last 3 digits ÷ 8\nBy 9: sum of digits ÷ 9\nBy 11: (odd position sum - even position sum) ÷ 11\n\n<strong>Time Savers:</strong>\n• Percentage ↔ Fraction conversion\n• LCM method for Time & Work\n• Alligation for Mixture problems\n• Rule of 72: Doubling time = 72/Rate%\n\n<strong>Pro Tip:</strong> Practice 50 problems daily using shortcuts!";

    if (p.match(/motivat|inspire|encourage|confidence/)) {
      const msgs = [
        "🌟 <strong>You've got this!</strong>\n\nEvery TNPSC topper was once in your shoes. The difference?\n\n✅ They didn't give up\n✅ They practiced daily\n✅ They learned from mistakes\n\n💪 Your consistency TODAY will be your success TOMORROW!\n\n📊 Tip: Take a mock test right now to build exam confidence!",
        "🔥 <strong>Stay focused, champion!</strong>\n\nThousands appear for TNPSC. But remember:\n\n• 90% don't prepare seriously\n• 5% give up halfway\n• Only 5% persist and succeed\n\nYou're already in that top 5% by studying now! 🏆\n\n💡 Small daily progress > One big effort",
        "💎 <strong>Success formula:</strong>\n\nHard Work + Smart Strategy + Never Give Up = IAS/IPS/TNPSC Success\n\n📚 Upload your study material\n📋 Take daily mock tests\n📈 Track your improvement\n🎯 Focus on weak areas\n\nEvery question you practice brings you ONE step closer! 🚀"
      ];
      return msgs[Math.floor(Math.random() * msgs.length)];
    }

    if (p.match(/number.?series|sequence|pattern/)) return "🔢 <strong>Number Series Patterns:</strong>\n\n<strong>Type 1 — AP:</strong> Constant difference\n2, 5, 8, 11, 14 (+3)\n\n<strong>Type 2 — GP:</strong> Constant ratio\n3, 9, 27, 81, 243 (×3)\n\n<strong>Type 3 — Squares/Cubes:</strong>\n1, 4, 9, 16, 25 (n²)\n1, 8, 27, 64, 125 (n³)\n\n<strong>Type 4 — Increasing difference:</strong>\n2, 3, 5, 8, 12 (+1,+2,+3,+4)\n\n<strong>Type 5 — Fibonacci:</strong>\n1, 1, 2, 3, 5, 8, 13 (a+b=c)\n\n<strong>Solving Strategy:</strong>\n1. Calculate differences\n2. If constant → AP\n3. If differences form pattern → nested series\n4. Check ×/÷ ratio\n5. Look for prime numbers, squares, cubes";

    return `🤖 I'm examGenious! Here's what I can help with:\n\n📤 <strong>Upload & Learn</strong> — "Upload my notes" or "Learn from syllabus"\n📊 <strong>Subjects</strong> — "Explain percentages" or "Blood relations tips"\n📋 <strong>Exam Info</strong> — "TNPSC Group 4 pattern"\n📅 <strong>Strategy</strong> — "Give me a study plan"\n⚡ <strong>Shortcuts</strong> — "Quick math tricks"\n💪 <strong>Motivation</strong> — "Motivate me"\n📰 <strong>Current Affairs</strong> — "Latest news updates"\n\nRemaining uploads today: <strong>${this.getRemainingUploads()}/20</strong>`;
  },

  formatResponse(text) {
    return text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>').replace(/\n/g, '<br>');
  }
};
