// Structured Lesson Content from Government Syllabus
const LESSONS = {
  tnpsc: [
    {id:'tn_hist',title:'Tamil Nadu History',icon:'🏛️',lessons:[
      {title:'Ancient Tamil Nadu',content:'The Sangam Age (3rd century BCE to 3rd century CE) is one of the most important periods in Tamil history.\n\n**Three Tamil Kingdoms:**\n• Chera Dynasty - Western Tamil Nadu, Kerala\n• Chola Dynasty - Thanjavur, Kaveri delta\n• Pandya Dynasty - Madurai region\n\n**Sangam Literature:**\n• Ettuthogai (8 anthologies)\n• Pattupattu (10 idylls)\n• Tolkappiyam - oldest Tamil grammar\n\n**Key Points for TNPSC:**\n• Karikala Chola built Kallanai (Grand Anicut)\n• Neduncheliyan I - patron of Sangam literature\n• Trade with Romans through Muziri port'},
      {title:'Pallava Dynasty',content:'The Pallavas ruled from 275 CE to 897 CE from Kanchipuram.\n\n**Important Rulers:**\n• Simhavishnu - founder\n• Mahendravarman I - rock-cut temples\n• Narasimhavarman I (Mamalla) - defeated Chalukyas, built Mahabalipuram\n• Narasimhavarman II - built Shore Temple\n\n**Contributions:**\n• Dravidian temple architecture\n• Mahabalipuram monuments (UNESCO)\n• Kailasanatha Temple, Kanchipuram\n• Pallava Grantha script'},
      {title:'Chola Empire',content:'The Medieval Cholas (848-1279 CE) were one of the longest-ruling dynasties.\n\n**Key Rulers:**\n• Vijayalaya - founded dynasty (848 CE)\n• Rajaraja Chola I - built Brihadeeswarar Temple\n• Rajendra Chola I - conquered up to Ganga, naval expeditions to SE Asia\n\n**Administration:**\n• Village assemblies: Ur, Sabha, Nagaram\n• Land revenue system\n• Uttaramerur inscription - democratic elections\n\n**TNPSC Important:**\n• Brihadeeswarar Temple = UNESCO World Heritage\n• Chola bronze sculptures\n• Naval supremacy in Indian Ocean'}
    ]},
    {id:'indian_polity',title:'Indian Polity',icon:'⚖️',lessons:[
      {title:'Constitution Basics',content:'Indian Constitution adopted on 26 Nov 1949, effective from 26 Jan 1950.\n\n**Key Facts:**\n• Longest written constitution in the world\n• Originally 395 Articles, 8 Schedules, 22 Parts\n• Currently 470+ Articles, 12 Schedules, 25 Parts\n\n**Sources:**\n• UK - Parliamentary system, Rule of law\n• USA - Fundamental Rights, Judicial Review\n• Ireland - DPSP, Presidential election\n• France - Republic, Liberty/Equality\n• USSR - Fundamental Duties\n• Australia - Concurrent List\n\n**Preamble Keywords:**\nSovereign, Socialist, Secular, Democratic, Republic'},
      {title:'Fundamental Rights (Part III)',content:'6 Fundamental Rights (Article 12-35):\n\n1. **Right to Equality (14-18)**\n• Equal before law\n• No discrimination\n• Equal opportunity\n• Abolition of untouchability\n\n2. **Right to Freedom (19-22)**\n• 6 freedoms under Article 19\n• Protection of life & liberty (Art 21)\n\n3. **Right against Exploitation (23-24)**\n• No forced labor\n• No child labor (<14 years)\n\n4. **Right to Freedom of Religion (25-28)**\n\n5. **Cultural & Educational Rights (29-30)**\n\n6. **Right to Constitutional Remedies (32)**\n• Dr. Ambedkar called it "Heart and Soul"'},
      {title:'Tamil Nadu State Government',content:'**Governor:**\n• Constitutional head\n• Appointed by President\n• 5-year term\n\n**Chief Minister:**\n• Real executive head\n• Leader of majority in Assembly\n\n**State Legislature:**\n• Tamil Nadu has unicameral (only Assembly)\n• 234 members + 1 Anglo-Indian\n• Term: 5 years\n\n**Local Government:**\n• 73rd Amendment - Panchayats\n• 74th Amendment - Municipalities\n• 3-tier Panchayat system in TN'}
    ]},
    {id:'geography',title:'Geography',icon:'🌍',lessons:[
      {title:'Tamil Nadu Geography',content:'**Location:** 8°5\' to 13°35\' N latitude\n\n**Area:** 1,30,058 sq km (11th largest state)\n\n**Borders:**\n• North: Andhra Pradesh, Karnataka\n• West: Kerala (Western Ghats)\n• East: Bay of Bengal\n• South: Indian Ocean\n\n**Major Rivers:**\n• Kaveri (Cauvery) - longest in TN\n• Vaigai, Tamiraparani, Palar\n\n**Highest Peak:** Doddabetta (2,637m)\n\n**Districts:** 38 districts\n\n**Climate:** Tropical, NE monsoon dominant'},
      {title:'Indian Geography Basics',content:'**Physical Features:**\n• Himalayan Mountains\n• Indo-Gangetic Plains\n• Peninsular Plateau\n• Coastal Plains & Islands\n\n**Major Rivers:**\n• Ganga (2,525 km)\n• Godavari (1,465 km)\n• Brahmaputra\n• Krishna, Narmada\n\n**Climate Types:**\n• Tropical monsoon\n• SW Monsoon (Jun-Sep)\n• NE Monsoon (Oct-Dec)\n\n**Soils:**\n• Alluvial - Indo-Gangetic\n• Black/Regur - Deccan\n• Red - TN, Andhra\n• Laterite - Western Ghats'}
    ]},
    {id:'science',title:'General Science',icon:'🔬',lessons:[
      {title:'Physics Basics',content:'**Laws of Motion (Newton):**\n1. Body at rest stays at rest (Inertia)\n2. F = ma (Force = mass × acceleration)\n3. Every action has equal & opposite reaction\n\n**Units:**\n• Force: Newton (N)\n• Energy: Joule (J)\n• Power: Watt (W)\n• Pressure: Pascal (Pa)\n\n**Important Concepts:**\n• Speed = Distance/Time\n• Acceleration = Change in velocity/Time\n• Work = Force × Distance\n• Power = Work/Time'},
      {title:'Chemistry Basics',content:'**Periodic Table:**\n• 118 elements\n• Groups (18 vertical) & Periods (7 horizontal)\n\n**Important Elements:**\n• Hydrogen - lightest\n• Oxygen - supports combustion\n• Carbon - organic chemistry basis\n• Iron, Gold, Silver - metals\n\n**pH Scale:**\n• 0-6: Acidic\n• 7: Neutral\n• 8-14: Basic/Alkaline\n\n**Chemical Reactions:**\n• Combustion, Decomposition\n• Neutralization (Acid+Base→Salt+Water)\n• Oxidation & Reduction'}
    ]}
  ],
  ssc: [
    {id:'quant',title:'Quantitative Aptitude',icon:'📊',lessons:[
      {title:'Number System',content:'**Types of Numbers:**\n• Natural: 1,2,3...\n• Whole: 0,1,2,3...\n• Integers: ...,-2,-1,0,1,2...\n• Rational: p/q form\n• Irrational: √2, π\n\n**Divisibility Rules:**\n• By 2: last digit even\n• By 3: digit sum ÷ 3\n• By 4: last 2 digits ÷ 4\n• By 5: ends in 0 or 5\n• By 9: digit sum ÷ 9\n• By 11: (odd-even position sum) ÷ 11\n\n**HCF & LCM:**\n• HCF × LCM = Product of numbers\n• HCF divides LCM'},
      {title:'Algebra',content:'**Basic Identities:**\n• (a+b)² = a² + 2ab + b²\n• (a-b)² = a² - 2ab + b²\n• a² - b² = (a+b)(a-b)\n• (a+b)³ = a³ + 3a²b + 3ab² + b³\n\n**Linear Equations:**\n• ax + b = 0 → x = -b/a\n\n**Quadratic:**\n• ax² + bx + c = 0\n• x = (-b ± √(b²-4ac)) / 2a\n\n**Important for SSC:**\n• Practice 50 simplification daily\n• Focus on shortcut methods'}
    ]},
    {id:'reasoning_ssc',title:'Reasoning',icon:'🧩',lessons:[
      {title:'Verbal Reasoning',content:'**Types for SSC:**\n1. Analogy\n2. Classification (Odd one out)\n3. Series Completion\n4. Coding-Decoding\n5. Blood Relations\n6. Direction Sense\n7. Ranking & Arrangement\n\n**Tips:**\n• Practice 30 questions daily\n• Learn common analogy patterns\n• Master coding shift patterns'}
    ]}
  ],
  rrb: [
    {id:'math_rrb',title:'Mathematics',icon:'🔢',lessons:[
      {title:'RRB Math Syllabus',content:'**Key Topics for RRB NTPC:**\n• Number System\n• Decimals & Fractions\n• LCM & HCF\n• Ratio & Proportion\n• Percentage\n• Mensuration\n• Time & Work\n• Time & Distance\n• Simple & Compound Interest\n• Profit & Loss\n• Algebra\n• Geometry & Trigonometry\n\n**Difficulty:** Moderate (10th level)\n**Questions:** 30 out of 100\n**Time tip:** 1 min per question max'}
    ]},
    {id:'ga_rrb',title:'General Awareness',icon:'📰',lessons:[
      {title:'Static GK for RRB',content:'**Important Topics:**\n• Indian History & Culture\n• Indian Polity & Constitution\n• Geography - India & World\n• Economy basics\n• Science & Technology\n• Computer Awareness\n\n**RRB Specific:**\n• Railway history in India\n• Railway zones & divisions\n• First Railway: Mumbai-Thane (1853)\n• Railway Budget merged with Union Budget (2017)\n• Indian Railways HQ: New Delhi'}
    ]}
  ],
  upsc: [
    {id:'history_upsc',title:'Indian History',icon:'🏛️',lessons:[
      {title:'Ancient India',content:'**Indus Valley Civilization (3300-1300 BCE):**\n• Harappa & Mohenjo-daro\n• Urban planning, drainage\n• Great Bath, granaries\n• Script not yet deciphered\n\n**Vedic Period:**\n• Rigveda - oldest (1500 BCE)\n• 4 Vedas: Rig, Yajur, Sama, Atharva\n• Varna system began\n\n**Buddhism & Jainism:**\n• Buddha: Siddhartha Gautama (563 BCE)\n• Mahavira: 24th Tirthankara\n• Ashoka spread Buddhism\n\n**Maurya Empire:**\n• Chandragupta Maurya (321 BCE)\n• Ashoka - Kalinga War, Dhamma\n• Kautilya/Chanakya - Arthashastra'},
      {title:'Medieval India',content:'**Delhi Sultanate (1206-1526):**\n• Slave/Mamluk Dynasty\n• Khalji Dynasty - Alauddin Khalji\n• Tughlaq Dynasty - Muhammad bin Tughlaq\n• Sayyid & Lodi Dynasties\n\n**Mughal Empire (1526-1857):**\n• Babur - Battle of Panipat (1526)\n• Akbar - Din-i-Ilahi, Mansabdari\n• Shah Jahan - Taj Mahal\n• Aurangzeb - largest extent\n\n**Vijayanagara Empire:**\n• Hampi - capital\n• Krishna Deva Raya\n• Battle of Talikota (1565)'},
      {title:'Modern India & Freedom Struggle',content:'**British East India Company:**\n• Battle of Plassey (1757)\n• Battle of Buxar (1764)\n• Permanent Settlement (1793)\n\n**Freedom Movement Timeline:**\n• 1857 - First War of Independence\n• 1885 - INC founded\n• 1905 - Swadeshi Movement\n• 1919 - Jallianwala Bagh\n• 1920 - Non-Cooperation\n• 1930 - Salt March\n• 1942 - Quit India\n• 1947 - Independence\n\n**Key Leaders:**\n• Gandhi, Nehru, Patel, Bose\n• Bhagat Singh, Tilak, Ambedkar'}
    ]},
    {id:'polity_upsc',title:'Indian Polity',icon:'⚖️',lessons:[
      {title:'Union Government',content:'**Parliament:**\n• Lok Sabha: 545 members, 5 years\n• Rajya Sabha: 245 members, 6 years\n• Money Bill - only in Lok Sabha\n• Joint session - Article 108\n\n**President:**\n• Head of State\n• Electoral college elects\n• Emergency powers (Art 352, 356, 360)\n\n**Prime Minister:**\n• Head of Government\n• Leader of majority in LS\n• Chairs Cabinet meetings\n\n**Judiciary:**\n• Supreme Court - apex\n• High Courts - state level\n• Judicial Review power'},
      {title:'Fundamental Rights & DPSP',content:'**6 Fundamental Rights (Part III):**\n1. Right to Equality (14-18)\n2. Right to Freedom (19-22)\n3. Against Exploitation (23-24)\n4. Freedom of Religion (25-28)\n5. Cultural & Educational (29-30)\n6. Constitutional Remedies (32)\n\n**DPSP (Part IV, Art 36-51):**\n• Non-justiciable\n• Directive to State\n• Gandhian, Socialist, Liberal principles\n\n**Fundamental Duties (Part IVA):**\n• Art 51A - 11 duties\n• Added by 42nd Amendment'}
    ]}
  ],
  banking: [
    {id:'banking_awareness',title:'Banking Awareness',icon:'🏦',lessons:[
      {title:'Indian Banking System',content:'**RBI (Reserve Bank of India):**\n• Established: 1 April 1935\n• Nationalized: 1949\n• HQ: Mumbai\n• Governor heads RBI\n\n**Types of Banks:**\n• Commercial Banks (SBI, PNB, etc.)\n• Cooperative Banks\n• Regional Rural Banks\n• Payment Banks\n• Small Finance Banks\n\n**Bank Nationalization:**\n• 1969: 14 banks nationalized\n• 1980: 6 more banks\n\n**Important Rates:**\n• Repo Rate, Reverse Repo\n• CRR, SLR\n• Bank Rate, MSF'},
      {title:'Financial Terms',content:'**Key Banking Terms:**\n• NPA: Non-Performing Asset\n• CASA: Current Account Savings Account\n• KYC: Know Your Customer\n• NEFT: National Electronic Fund Transfer\n• RTGS: Real Time Gross Settlement\n• UPI: Unified Payments Interface\n• IMPS: Immediate Payment Service\n\n**Insurance:**\n• IRDA regulates insurance\n• LIC - largest insurer\n• PMJJBY, PMSBY schemes\n\n**Stock Market:**\n• BSE (1875) - oldest in Asia\n• NSE - largest in India\n• SEBI regulates markets'}
    ]},
    {id:'quant_banking',title:'Quantitative Aptitude',icon:'📊',lessons:[
      {title:'Data Interpretation',content:'**Types of DI:**\n1. Table-based\n2. Bar Graph\n3. Pie Chart\n4. Line Graph\n5. Mixed/Caselet\n\n**Tips for Banking Exams:**\n• Practice percentage calculation mentally\n• Learn fraction-percentage equivalents:\n  - 1/2=50%, 1/3=33.33%, 1/4=25%\n  - 1/5=20%, 1/6=16.67%, 1/8=12.5%\n• Approximation is key in DI\n• Target: 15 DI questions in 20 mins'}
    ]}
  ]
};

function getExamLessons(examId) {
  if (!examId) return LESSONS.tnpsc;
  if (examId.startsWith('tnpsc')) return LESSONS.tnpsc;
  if (examId.startsWith('ssc')) return LESSONS.ssc;
  if (examId.startsWith('rrb')) return LESSONS.rrb;
  if (examId.startsWith('upsc')) return LESSONS.upsc;
  if (examId.startsWith('ibps')) return LESSONS.banking;
  return LESSONS.tnpsc;
}
