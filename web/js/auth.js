// Authentication & Onboarding System

const SUPPORTED_EXAMS = [
  {id:'tnpsc_g1',name:'TNPSC Group I',icon:'🏛️',desc:'Civil Services',subjects:['General Studies','Aptitude','Current Affairs','Tamil/English']},
  {id:'tnpsc_g2',name:'TNPSC Group II',icon:'📋',desc:'Supervisory Services',subjects:['General Studies','Aptitude','Current Affairs','Tamil/English']},
  {id:'tnpsc_g4',name:'TNPSC Group IV',icon:'📝',desc:'CCSE (10th Level)',subjects:['General Knowledge','Aptitude','Current Affairs','Tamil/English']},
  {id:'ssc_cgl',name:'SSC CGL',icon:'🏢',desc:'Combined Graduate Level',subjects:['Quant','English','Reasoning','General Awareness']},
  {id:'ssc_chsl',name:'SSC CHSL',icon:'📊',desc:'10+2 Level',subjects:['Quant','English','Reasoning','General Awareness']},
  {id:'rrb_ntpc',name:'RRB NTPC',icon:'🚂',desc:'Railway Non-Technical',subjects:['Math','Reasoning','General Awareness','English']},
  {id:'rrb_group_d',name:'RRB Group D',icon:'🛤️',desc:'Railway Group D',subjects:['Math','Reasoning','General Science','General Awareness']},
  {id:'upsc_prelims',name:'UPSC Prelims',icon:'🇮🇳',desc:'Civil Services Exam',subjects:['General Studies','CSAT']},
  {id:'ibps_po',name:'IBPS PO',icon:'🏦',desc:'Bank Probationary Officer',subjects:['Quant','Reasoning','English','General Awareness']},
  {id:'ibps_clerk',name:'IBPS Clerk',icon:'💼',desc:'Bank Clerk',subjects:['Quant','Reasoning','English','General Awareness']},
];

const Auth = {
  currentUser: null,

  async init() {
    const saved = localStorage.getItem('tnpsc_user');
    if (saved) { this.currentUser = JSON.parse(saved); return true; }
    return false;
  },

  async register(name, email, password, phone) {
    const users = JSON.parse(localStorage.getItem('tnpsc_users') || '[]');
    if (users.find(u => u.email === email)) return { error: 'Email already registered' };
    const user = {
      id: Date.now().toString(), name, email, phone,
      password: btoa(password), // basic encoding
      exam: null, createdAt: new Date().toISOString(),
      streak: 0, lastActive: null, level: 'beginner'
    };
    users.push(user);
    localStorage.setItem('tnpsc_users', JSON.stringify(users));
    this.currentUser = user;
    localStorage.setItem('tnpsc_user', JSON.stringify(user));
    return { success: true, user };
  },

  async login(email, password) {
    const users = JSON.parse(localStorage.getItem('tnpsc_users') || '[]');
    const user = users.find(u => u.email === email && u.password === btoa(password));
    if (!user) return { error: 'Invalid email or password' };
    user.lastActive = new Date().toISOString();
    this.currentUser = user;
    localStorage.setItem('tnpsc_user', JSON.stringify(user));
    return { success: true, user };
  },

  selectExam(examId) {
    if (!this.currentUser) return;
    this.currentUser.exam = examId;
    this.saveUser();
  },

  saveUser() {
    localStorage.setItem('tnpsc_user', JSON.stringify(this.currentUser));
    const users = JSON.parse(localStorage.getItem('tnpsc_users') || '[]');
    const idx = users.findIndex(u => u.id === this.currentUser.id);
    if (idx >= 0) { users[idx] = this.currentUser; localStorage.setItem('tnpsc_users', JSON.stringify(users)); }
  },

  logout() {
    this.currentUser = null;
    localStorage.removeItem('tnpsc_user');
  },

  getExamInfo() {
    if (!this.currentUser?.exam) return null;
    return SUPPORTED_EXAMS.find(e => e.id === this.currentUser.exam);
  }
};
