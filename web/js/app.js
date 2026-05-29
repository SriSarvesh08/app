// ExamAI - Main App Controller
let currentPage='dashboard',pageHistory=[],chatMessages=[],testState={},testTimer=null;
let testConfig={categories:['aptitude','reasoning','verbal','gk'],count:10,difficulty:'all'};
let quizState={},uploadedDocs=[];

// ===== STARTUP =====
window.addEventListener('DOMContentLoaded',async()=>{
  await db.init();
  const t=await db.getSetting('theme');
  if(t==='dark')document.documentElement.setAttribute('data-theme','dark');
  chatMessages=await db.getAll('chat_messages');
  uploadedDocs=JSON.parse(localStorage.getItem('uploaded_docs')||'[]');

  setTimeout(async()=>{
    document.getElementById('splash-screen').classList.add('fade-out');
    setTimeout(async()=>{
      document.getElementById('splash-screen').classList.add('hidden');
      const loggedIn=await Auth.init();
      if(!loggedIn){showAuthScreen('login');}
      else if(!Auth.currentUser.exam){showOnboarding();}
      else{showApp();}
    },500);
  },2000);
});

// ===== AUTH SCREENS =====
function showAuthScreen(mode){
  document.getElementById('auth-screen').classList.remove('hidden');
  document.getElementById('app').classList.add('hidden');
  document.getElementById('onboarding-screen').classList.add('hidden');
  const s=document.getElementById('auth-screen');
  if(mode==='login'){
    s.innerHTML=`
      <div class="auth-container">
        <div style="text-align:center;margin-bottom:32px"><div style="font-size:56px">🎓</div><h1 style="font-size:28px;font-weight:700;margin:8px 0">ExamAI</h1><p style="color:var(--text-secondary)">Your AI Exam Coach</p></div>
        <div id="auth-error" class="auth-error hidden"></div>
        <div class="form-group"><label>Email</label><input type="email" id="login-email" class="form-input" placeholder="Enter your email"></div>
        <div class="form-group"><label>Password</label><input type="password" id="login-pass" class="form-input" placeholder="Enter password"></div>
        <button class="btn btn-primary" onclick="doLogin()"><span class="material-icons-round">login</span> Sign In</button>
        <p style="text-align:center;margin-top:20px;color:var(--text-secondary)">Don't have an account? <a href="#" onclick="showAuthScreen('register')" style="color:var(--primary);font-weight:600">Create Account</a></p>
        <div style="text-align:center;margin-top:24px;padding-top:24px;border-top:1px solid var(--border)"><p style="font-size:12px;color:var(--text-secondary)">Supports: TNPSC • SSC • RRB • UPSC • Banking</p></div>
      </div>`;
  } else {
    s.innerHTML=`
      <div class="auth-container">
        <div style="text-align:center;margin-bottom:24px"><div style="font-size:48px">🎓</div><h1 style="font-size:24px;font-weight:700;margin:8px 0">Create Account</h1><p style="color:var(--text-secondary)">Start your exam preparation journey</p></div>
        <div id="auth-error" class="auth-error hidden"></div>
        <div class="form-group"><label>Full Name</label><input type="text" id="reg-name" class="form-input" placeholder="Your full name"></div>
        <div class="form-group"><label>Email</label><input type="email" id="reg-email" class="form-input" placeholder="Your email"></div>
        <div class="form-group"><label>Phone</label><input type="tel" id="reg-phone" class="form-input" placeholder="Mobile number"></div>
        <div class="form-group"><label>Password</label><input type="password" id="reg-pass" class="form-input" placeholder="Create password (min 6 chars)"></div>
        <button class="btn btn-primary" onclick="doRegister()"><span class="material-icons-round">person_add</span> Create Account</button>
        <p style="text-align:center;margin-top:20px;color:var(--text-secondary)">Already have an account? <a href="#" onclick="showAuthScreen('login')" style="color:var(--primary);font-weight:600">Sign In</a></p>
      </div>`;
  }
}

async function doLogin(){
  const email=document.getElementById('login-email').value.trim();
  const pass=document.getElementById('login-pass').value;
  if(!email||!pass){showAuthError('Please fill all fields');return;}
  const r=await Auth.login(email,pass);
  if(r.error){showAuthError(r.error);return;}
  if(!Auth.currentUser.exam)showOnboarding();else showApp();
}

async function doRegister(){
  const name=document.getElementById('reg-name').value.trim();
  const email=document.getElementById('reg-email').value.trim();
  const phone=document.getElementById('reg-phone').value.trim();
  const pass=document.getElementById('reg-pass').value;
  if(!name||!email||!pass){showAuthError('Please fill all required fields');return;}
  if(pass.length<6){showAuthError('Password must be at least 6 characters');return;}
  const r=await Auth.register(name,email,pass,phone);
  if(r.error){showAuthError(r.error);return;}
  showOnboarding();
}

function showAuthError(msg){const e=document.getElementById('auth-error');e.textContent=msg;e.classList.remove('hidden');}

// ===== ONBOARDING =====
function showOnboarding(){
  document.getElementById('auth-screen').classList.add('hidden');
  document.getElementById('app').classList.add('hidden');
  const o=document.getElementById('onboarding-screen');
  o.classList.remove('hidden');
  o.innerHTML=`
    <div class="auth-container" style="max-width:500px">
      <div style="text-align:center;margin-bottom:24px"><div style="font-size:48px">🎯</div><h1 style="font-size:24px;font-weight:700">Choose Your Exam</h1><p style="color:var(--text-secondary)">Select the exam you're preparing for</p></div>
      <div class="exam-grid">${SUPPORTED_EXAMS.map(e=>`
        <div class="card card-clickable exam-option" onclick="selectExamAndStart('${e.id}')">
          <div style="display:flex;align-items:center;gap:12px"><span style="font-size:28px">${e.icon}</span>
          <div><div style="font-weight:600">${e.name}</div><div style="font-size:12px;color:var(--text-secondary)">${e.desc}</div></div></div>
        </div>`).join('')}
      </div>
      <p style="text-align:center;margin-top:16px;font-size:13px;color:var(--text-secondary)">You can change this later in Settings</p>
    </div>`;
}

function selectExamAndStart(examId){
  Auth.selectExam(examId);
  showApp();
}

// ===== MAIN APP =====
function showApp(){
  document.getElementById('auth-screen').classList.add('hidden');
  document.getElementById('onboarding-screen').classList.add('hidden');
  document.getElementById('app').classList.remove('hidden');
  navigateTo('dashboard');
}

// ===== NAVIGATION =====
async function navigateTo(page,push=true){
  if(push&&currentPage!==page)pageHistory.push(currentPage);
  currentPage=page;
  const c=document.getElementById('page-container');
  c.style.animation='none';c.offsetHeight;c.style.animation='fadeIn 0.3s ease';
  const titles={dashboard:'Dashboard',chat:'AI Assistant',aptitude:'Aptitude',reasoning:'Reasoning',verbal:'Verbal Ability',gk:'General Knowledge','current-affairs':'Current Affairs','mock-test':'Mock Test',progress:'Progress',settings:'Settings','topic-quiz':'Practice','test-active':'Mock Test','test-result':'Results',upload:'Upload & Learn',lessons:'Lessons','lesson-view':'Lesson'};
  document.getElementById('page-title').textContent=titles[page]||'ExamAI';
  document.getElementById('back-btn').classList.toggle('hidden',page==='dashboard');
  document.getElementById('settings-btn').classList.toggle('hidden',page==='settings');
  document.getElementById('bottom-nav').classList.toggle('hidden',['test-active','topic-quiz','test-result','lesson-view'].includes(page));
  document.querySelectorAll('.nav-item').forEach(n=>n.classList.toggle('active',n.dataset.page===page));
  let html='';
  switch(page){
    case'dashboard':html=await renderDashboard();break;
    case'chat':html=renderChat();break;
    case'aptitude':html=renderTopicList('aptitude',APTITUDE_TOPICS,'📊⚖️💰⏰🚗🔢🔢📉🎲💵💳','var(--aptitude)');break;
    case'reasoning':html=renderTopicList('reasoning',REASONING_TOPICS,'👨‍👩‍👧‍👦🔐🪑🧭🔢🧩🧠📐🔗','var(--reasoning)');break;
    case'verbal':html=renderTopicList('verbal',VERBAL_TOPICS,'📖🔄✍️🔍📄✏️📝💬','var(--verbal)');break;
    case'gk':html=renderTopicList('gk',GK_TOPICS,'🏛️⚖️🌍⚡🧪🧬💰🏛️💻','var(--info)');break;
    case'current-affairs':html=renderCurrentAffairs();break;
    case'mock-test':html=renderMockTestConfig();break;
    case'progress':html=await renderProgress();break;
    case'settings':html=await renderSettings();break;
    case'upload':html=renderUploadPage();break;
    case'lessons':html=renderLessonsPage();break;
    default:html='<p>Page not found</p>';
  }
  c.innerHTML=html;
  if(page==='chat')initChat();
}
function navigateBack(){if(testTimer){clearInterval(testTimer);testTimer=null;}if(pageHistory.length>0)navigateTo(pageHistory.pop(),false);else navigateTo('dashboard',false);}

async function toggleTheme(){
  const d=document.documentElement.getAttribute('data-theme')==='dark';
  if(d)document.documentElement.removeAttribute('data-theme');else document.documentElement.setAttribute('data-theme','dark');
  await db.setSetting('theme',d?'light':'dark');navigateTo('settings',false);
}

// ===== LESSONS =====
function renderLessonsPage(){
  const examInfo=Auth.getExamInfo();
  const lessons=getExamLessons(Auth.currentUser?.exam);
  return`
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px">
      <h2 style="font-size:22px;font-weight:700">📚 Lessons</h2>
      <span style="background:var(--primary);color:#fff;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600">${examInfo?.name||'All Exams'}</span>
    </div>
    ${lessons.map(cat=>`
      <h3 class="section-header">${cat.icon} ${cat.title}</h3>
      ${cat.lessons.map((l,i)=>`
        <div class="card card-clickable" onclick="viewLesson('${cat.id}',${i})">
          <div class="topic-item"><div class="topic-icon" style="background:var(--primary)10">${cat.icon}</div>
          <div class="topic-info"><div class="topic-name">${l.title}</div>
          <div class="topic-meta">${l.content.substring(0,60)}...</div></div>
          <span class="material-icons-round" style="color:var(--text-secondary);font-size:16px">arrow_forward_ios</span></div>
        </div>`).join('')}
    `).join('')}
    <div class="card card-clickable" onclick="navigateTo('aptitude')"><div class="topic-item"><div class="topic-icon" style="background:var(--aptitude)10">📊</div><div class="topic-info"><div class="topic-name">Practice Questions</div><div class="topic-meta">Aptitude, Reasoning, Verbal</div></div><span class="material-icons-round" style="color:var(--text-secondary);font-size:16px">arrow_forward_ios</span></div></div>`;
}

function viewLesson(catId,lessonIdx){
  const lessons=getExamLessons(Auth.currentUser?.exam);
  const cat=lessons.find(c=>c.id===catId);if(!cat)return;
  const lesson=cat.lessons[lessonIdx];if(!lesson)return;
  pageHistory.push(currentPage);currentPage='lesson-view';
  document.getElementById('page-title').textContent=lesson.title;
  document.getElementById('back-btn').classList.remove('hidden');
  document.getElementById('bottom-nav').classList.add('hidden');
  const c=document.getElementById('page-container');
  const formatted=lesson.content.replace(/\*\*(.*?)\*\*/g,'<strong>$1</strong>').replace(/\n/g,'<br>').replace(/• /g,'<br>• ');
  c.innerHTML=`
    <div class="card" style="padding:20px"><h2 style="font-size:22px;font-weight:700;margin-bottom:4px">${lesson.title}</h2><p style="color:var(--text-secondary);font-size:13px">${cat.title} • ${Auth.getExamInfo()?.name||'General'}</p></div>
    <div class="card" style="padding:20px;line-height:1.8;font-size:15px">${formatted}</div>
    <div class="btn-row">
      ${lessonIdx>0?`<button class="btn btn-outline" onclick="viewLesson('${catId}',${lessonIdx-1})"><span class="material-icons-round">arrow_back</span> Previous</button>`:''}
      ${lessonIdx<cat.lessons.length-1?`<button class="btn btn-primary" onclick="viewLesson('${catId}',${lessonIdx+1})">Next <span class="material-icons-round">arrow_forward</span></button>`:''}
    </div>
    <button class="btn btn-gold" style="margin-top:8px" onclick="sendChat('Explain ${lesson.title} in detail');navigateTo('chat')"><span class="material-icons-round">smart_toy</span> Ask AI About This</button>`;
}

// ===== CHAT =====
function initChat(){
  if(chatMessages.length===0){const w={message:"Hello "+((Auth.currentUser?.name)||"")+"! 👋 I'm your <strong>ExamAI Assistant</strong>.<br><br>📤 Upload syllabus/notes (PDF, images, text)<br>📚 Ask about any topic<br>⚡ Get shortcuts & tricks<br>📋 Take mock tests up to 150 Qs<br><br>What would you like to learn today?",isUser:false,time:new Date()};chatMessages.push(w);db.add('chat_messages',w);}
  renderChatMessages();
}
function renderChatMessages(){const m=document.getElementById('chat-messages');if(!m)return;m.innerHTML=chatMessages.map(msg=>{const t=new Date(msg.time||msg.createdAt||Date.now());const ts=`${String(t.getHours()).padStart(2,'0')}:${String(t.getMinutes()).padStart(2,'0')}`;return`<div class="chat-bubble ${msg.isUser?'user':'ai'}"><div>${msg.isUser?esc(msg.message):msg.message}</div><div class="time">${ts}${!msg.isUser?`<div class="actions"><button onclick="speakText(this)"><span class="material-icons-round" style="font-size:14px">volume_up</span></button><button onclick="copyText(this)"><span class="material-icons-round" style="font-size:14px">content_copy</span></button></div>`:''}</div></div>`;}).join('');m.scrollTop=m.scrollHeight;}
async function sendChat(text){const input=document.getElementById('chat-input');const msg=text||(input?input.value.trim():'');if(!msg)return;if(input)input.value='';const s=document.getElementById('chat-suggestions');if(s)s.classList.add('hidden');chatMessages.push({message:msg,isUser:true,time:new Date()});db.add('chat_messages',{message:msg,isUser:true,time:new Date()});renderChatMessages();const m=document.getElementById('chat-messages');m.innerHTML+='<div class="chat-bubble ai" id="typing"><div class="typing-indicator"><div class="typing-dot"></div><div class="typing-dot"></div><div class="typing-dot"></div></div></div>';m.scrollTop=m.scrollHeight;const r=await AIService.respond(msg);document.getElementById('typing')?.remove();const ai={message:AIService.formatResponse(r),isUser:false,time:new Date()};chatMessages.push(ai);db.add('chat_messages',ai);renderChatMessages();}
function speakText(b){const t=b.closest('.chat-bubble').querySelector('div').textContent;if('speechSynthesis'in window){speechSynthesis.cancel();const u=new SpeechSynthesisUtterance(t);u.lang='en-IN';u.rate=0.9;speechSynthesis.speak(u);}}
function copyText(b){const t=b.closest('.chat-bubble').querySelector('div').textContent;navigator.clipboard.writeText(t);b.innerHTML='<span class="material-icons-round" style="font-size:14px">check</span>';setTimeout(()=>{b.innerHTML='<span class="material-icons-round" style="font-size:14px">content_copy</span>';},1500);}

// ===== UPLOAD (PDF, Image, Word, Text) =====
function handleFileUpload(){
  const input=document.createElement('input');input.type='file';
  input.accept='.txt,.md,.csv,.json,.pdf,.doc,.docx,.jpg,.jpeg,.png,.webp';
  input.onchange=async(e)=>{
    const file=e.target.files[0];if(!file)return;
    if(AIService.getRemainingUploads()<=0){alert('Daily upload limit (20) reached!');return;}
    let text='';
    if(file.type.startsWith('image/')){
      text=`[Image uploaded: ${file.name}]\nImage analysis is available with on-device AI models.\nFor now, please describe the content of the image in chat for AI assistance.`;
    } else if(file.name.endsWith('.pdf')){
      text=`[PDF uploaded: ${file.name}]\nPDF text extraction requires PDF.js library.\nFor now, copy-paste the important text content into a .txt file and upload again for full analysis.`;
    } else if(file.name.endsWith('.doc')||file.name.endsWith('.docx')){
      text=`[Document uploaded: ${file.name}]\nWord document processing available with on-device AI.\nFor now, save as .txt and re-upload for full analysis.`;
    } else {
      text=await file.text();
    }
    const result=await AIService.processUpload(text,file.name);
    if(result.error){alert(result.error);return;}
    uploadedDocs.push(result);
    localStorage.setItem('uploaded_docs',JSON.stringify(uploadedDocs.map(d=>({filename:d.filename,date:d.date,summary:d.summary,keyPoints:d.keyPoints}))));
    navigateTo('upload',false);
  };input.click();
}

// ===== CHANGE EXAM =====
function changeExam(){
  const overlay=document.createElement('div');overlay.className='modal-overlay';overlay.onclick=(e)=>{if(e.target===overlay)overlay.remove();};
  overlay.innerHTML=`<div class="modal-sheet"><div class="modal-handle"></div><h2 style="font-size:20px;font-weight:700;margin-bottom:16px">Change Exam</h2>
    ${SUPPORTED_EXAMS.map(e=>`<div class="card card-clickable" style="margin-bottom:8px" onclick="Auth.selectExam('${e.id}');this.closest('.modal-overlay').remove();navigateTo('settings',false)"><div style="display:flex;align-items:center;gap:12px"><span style="font-size:24px">${e.icon}</span><div><div style="font-weight:600">${e.name}</div><div style="font-size:12px;color:var(--text-secondary)">${e.desc}</div></div>${Auth.currentUser?.exam===e.id?'<span class="material-icons-round" style="color:var(--success);margin-left:auto">check_circle</span>':''}</div></div>`).join('')}
  </div>`;document.body.appendChild(overlay);
}

function doLogout(){
  if(!confirm('Are you sure you want to logout?'))return;
  Auth.logout();showAuthScreen('login');
}

// ===== DATA CLEAR =====
async function clearAllData(){
  if(!confirm('Delete ALL progress, chat, and test results?'))return;
  await db.clear('chat_messages');await db.clear('user_answers');await db.clear('mock_tests');
  chatMessages=[];localStorage.removeItem('uploaded_docs');localStorage.removeItem('ai_uploads');
  uploadedDocs=[];AIService.uploadedDocs=[];alert('All data cleared!');navigateTo('settings',false);
}

// ===== UTILS =====
function esc(t){const d=document.createElement('div');d.textContent=t;return d.innerHTML;}
function shuffle(a){const b=[...a];for(let i=b.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[b[i],b[j]]=[b[j],b[i]];}return b;}
function fmtTime(s){return`${String(Math.floor(s/60)).padStart(2,'0')}:${String(s%60).padStart(2,'0')}`;}
