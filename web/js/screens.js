// ExamAI - Screen Renderers

async function renderDashboard(){
  const stats=await db.getStats();const rem=AIService.getRemainingUploads();
  const hour=new Date().getHours();const g=hour<12?'Good Morning':hour<17?'Good Afternoon':'Good Evening';
  const user=Auth.currentUser||{name:'Student'};const examInfo=Auth.getExamInfo();
  return`
    <div style="margin-bottom:16px"><p style="opacity:0.6;font-size:14px">${g}! 👋</p><h1 style="font-size:28px;font-weight:700">${user.name||'Student'}</h1>
    ${examInfo?`<span style="background:var(--primary);color:#fff;padding:3px 10px;border-radius:12px;font-size:11px;font-weight:600">${examInfo.icon} ${examInfo.name}</span>`:''}</div>
    <div class="stats-row">
      <div class="card stat-card"><div class="stat-emoji">📊</div><div class="stat-value" style="color:var(--aptitude)">${QUESTIONS.length}</div><div class="stat-label">Questions</div></div>
      <div class="card stat-card"><div class="stat-emoji">✅</div><div class="stat-value" style="color:var(--success)">${stats.totalAnswered}</div><div class="stat-label">Answered</div></div>
      <div class="card stat-card"><div class="stat-emoji">🎯</div><div class="stat-value" style="color:var(--accent)">${stats.accuracy}%</div><div class="stat-label">Accuracy</div></div>
    </div>
    <div class="card gradient-card" style="display:flex;gap:14px;align-items:center">
      <span style="font-size:28px">📚</span><div style="flex:1"><strong>Start Learning</strong><br><span style="font-size:13px;opacity:0.8">Lessons from syllabus • ${rem}/20 uploads left</span></div>
      <button onclick="navigateTo('lessons')" style="background:rgba(255,255,255,0.2);border:none;color:#fff;padding:8px 16px;border-radius:10px;cursor:pointer;font-family:var(--font);font-weight:600">Learn</button>
    </div>
    <h3 class="section-header">Study Modules</h3>
    <div class="category-grid">
      ${[{i:'📚',t:'Lessons',s:'Syllabus Content',p:'lessons'},{i:'📊',t:'Aptitude',s:`${APTITUDE_TOPICS.length} topics`,p:'aptitude'},{i:'🧩',t:'Reasoning',s:`${REASONING_TOPICS.length} topics`,p:'reasoning'},{i:'📝',t:'Verbal',s:`${VERBAL_TOPICS.length} topics`,p:'verbal'},{i:'🌍',t:'General Knowledge',s:`${GK_TOPICS.length} topics`,p:'gk'},{i:'📰',t:'Current Affairs',s:`${CURRENT_AFFAIRS.length} articles`,p:'current-affairs'},{i:'📋',t:'Mock Tests',s:'Up to 150 Qs',p:'mock-test'},{i:'📈',t:'Progress',s:'Analytics',p:'progress'}].map(c=>
        `<div class="card category-card card-clickable" onclick="navigateTo('${c.p}')"><div class="category-icon" style="background:var(--bg)">${c.i}</div><div><div class="category-title">${c.t}</div><div class="category-subtitle">${c.s}</div></div></div>`
      ).join('')}
    </div>
    <h3 class="section-header">Quick Actions</h3>
    <div class="card card-clickable" onclick="navigateTo('chat')"><div style="display:flex;align-items:center;gap:14px"><div style="width:48px;height:48px;border-radius:14px;background:linear-gradient(135deg,var(--primary),var(--primary-lighter));display:flex;align-items:center;justify-content:center;color:#fff"><span class="material-icons-round">smart_toy</span></div><div style="flex:1"><div style="font-weight:600">Ask AI Assistant</div><div style="font-size:12px;color:var(--text-secondary)">Upload syllabus, get explanations</div></div><span class="material-icons-round" style="color:var(--text-secondary);font-size:16px">arrow_forward_ios</span></div></div>`;
}

function renderChat(){
  return`<div class="chat-container">
    <div class="chat-suggestions" id="chat-suggestions">${['📤 Upload my notes','📊 Percentage shortcuts','🎯 Exam strategy','📅 Study plan','⚡ Quick tricks','💪 Motivate me','📋 Exam pattern'].map(s=>`<button class="suggestion-chip" onclick="sendChat('${s.slice(2).trim()}')">${s}</button>`).join('')}</div>
    <div class="chat-messages" id="chat-messages"></div>
    <div class="chat-input-area">
      <button class="icon-btn" onclick="handleFileUpload()" title="Upload file"><span class="material-icons-round">attach_file</span></button>
      <input type="text" class="chat-input" id="chat-input" placeholder="Ask anything..." onkeypress="if(event.key==='Enter')sendChat()">
      <button class="chat-send" onclick="sendChat()"><span class="material-icons-round">send</span></button>
    </div></div>`;
}

function renderTopicList(cat,topics,emojis,color){
  const em=emojis.match(/./gu)||[];const qs=QUESTIONS.filter(q=>q.category===cat);
  return`<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px">
      <h2 style="font-size:22px;font-weight:700">${cat[0].toUpperCase()+cat.slice(1)}</h2>
      <span style="background:${color}15;color:${color};padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600">${topics.length} Topics • ${qs.length} Qs</span></div>
    ${topics.map((t,i)=>{const tQs=qs.filter(q=>q.topic===t);return`
      <div class="card card-clickable" onclick="startTopicQuiz('${cat}','${t}','${color}')"><div class="topic-item">
        <div class="topic-icon" style="background:${color}12">${em[i%em.length]||'📝'}</div>
        <div class="topic-info"><div class="topic-name">${t}</div><div class="topic-meta">${tQs.length} questions</div></div>
        <span class="material-icons-round" style="color:var(--text-secondary);font-size:16px">arrow_forward_ios</span>
      </div></div>`;}).join('')}`;
}

function renderCurrentAffairs(){
  const cats=['All','National','International','Tamil Nadu','Sports','Science'];
  return`<div class="tab-bar">${cats.map((c,i)=>`<button class="tab ${i===0?'active':''}" onclick="filterAffairs('${c}')">${c}</button>`).join('')}</div>
    ${CURRENT_AFFAIRS.map((a,i)=>`<div class="card card-clickable affair-item" data-cat="${a.category}" onclick="showAffairDetail(${i})">
      <div style="display:flex;justify-content:space-between;margin-bottom:8px"><span style="font-size:11px;font-weight:600;color:var(--primary)">${a.category}</span><span style="font-size:11px;color:var(--text-secondary)">${a.date}</span></div>
      <h4 style="font-weight:600;font-size:15px;margin-bottom:6px">${a.title}</h4>
      <p style="font-size:13px;color:var(--text-secondary);line-height:1.4;overflow:hidden;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical">${a.content}</p>
    </div>`).join('')}`;
}

function renderMockTestConfig(){
  return`
    <div class="card gradient-card" style="text-align:center;padding:28px;border-radius:20px;margin-bottom:20px">
      <div style="font-size:48px">📋</div><h2 style="font-size:24px;font-weight:700;margin:12px 0">Mock Test</h2>
      <p style="opacity:0.7">${Auth.getExamInfo()?.name||'Competitive'} Exam Simulation</p>
    </div>
    <h3 class="section-header">Select Categories</h3>
    <div class="chip-group" id="cat-chips">
      <button class="chip chip-cat active" data-cat="aptitude" onclick="toggleTestCat(this)">📊 Aptitude</button>
      <button class="chip chip-cat active" data-cat="reasoning" onclick="toggleTestCat(this)">🧩 Reasoning</button>
      <button class="chip chip-cat active" data-cat="verbal" onclick="toggleTestCat(this)">📝 Verbal</button>
      <button class="chip chip-cat active" data-cat="gk" onclick="toggleTestCat(this)">🌍 GK</button>
    </div>
    <h3 class="section-header">Difficulty Level</h3>
    <div class="chip-group" id="diff-chips">
      <button class="chip active" onclick="selectDifficulty('all',this)">🎯 All Levels</button>
      <button class="chip" onclick="selectDifficulty(1,this)">🟢 Easy</button>
      <button class="chip" onclick="selectDifficulty(2,this)">🟡 Medium</button>
      <button class="chip" onclick="selectDifficulty(3,this)">🔴 Hard</button>
    </div>
    <h3 class="section-header">Number of Questions</h3>
    <div class="chip-group" id="count-chips">
      ${[10,25,50,75,100,150].map(n=>`<button class="chip ${n===10?'active':''}" onclick="selectTestCount(${n},this)">${n}</button>`).join('')}
    </div>
    <div class="info-box info"><span class="material-icons-round" style="color:var(--info)">timer</span><span id="test-time-info">Time: 10 minutes (1 min/question)</span></div>
    <div class="info-box warn"><span class="material-icons-round" style="color:var(--warning)">info</span><span>Answers revealed only AFTER submission. Questions are replaced each test!</span></div>
    <button class="btn btn-primary" style="margin-top:8px" onclick="startMockTest()"><span class="material-icons-round">play_arrow</span> Start Mock Test</button>`;
}

async function renderProgress(){
  const stats=await db.getStats();const catCounts={};const catColors={aptitude:'var(--aptitude)',reasoning:'var(--reasoning)',verbal:'var(--verbal)'};
  stats.answers.forEach(a=>{catCounts[a.category]=(catCounts[a.category]||0)+1;});
  return`
    <div class="stats-row">
      <div class="card stat-card"><div class="stat-emoji">📊</div><div class="stat-value" style="color:var(--aptitude)">${stats.totalAnswered}</div><div class="stat-label">Answered</div></div>
      <div class="card stat-card"><div class="stat-emoji">🎯</div><div class="stat-value" style="color:var(--success)">${stats.accuracy}%</div><div class="stat-label">Accuracy</div></div>
      <div class="card stat-card"><div class="stat-emoji">📋</div><div class="stat-value" style="color:var(--mock-test)">${stats.totalTests}</div><div class="stat-label">Tests</div></div>
    </div>
    <div class="card" style="display:flex;align-items:center;gap:20px;padding:20px">
      <div class="progress-ring-container"><svg width="100" height="100" viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="42" fill="none" stroke="var(--border)" stroke-width="8"/>
        <circle cx="50" cy="50" r="42" fill="none" stroke="${stats.accuracy>70?'var(--success)':stats.accuracy>40?'var(--warning)':'var(--error)'}" stroke-width="8" stroke-linecap="round" stroke-dasharray="${2*Math.PI*42}" stroke-dashoffset="${2*Math.PI*42*(1-stats.accuracy/100)}" transform="rotate(-90 50 50)"/>
      </svg><div class="progress-ring-text">${stats.accuracy}%</div></div>
      <div><h3 style="font-weight:600">Overall Accuracy</h3><p style="font-size:13px;color:var(--text-secondary)">${stats.totalCorrect} correct of ${stats.totalAnswered}</p></div>
    </div>
    ${Object.keys(catCounts).length>0?`<h3 class="section-header">Category Breakdown</h3>${Object.entries(catCounts).map(([cat,count])=>{const total=Object.values(catCounts).reduce((a,b)=>a+b,0);const pct=Math.round((count/total)*100);return`<div class="card" style="display:flex;align-items:center;gap:12px"><div style="width:6px;height:36px;border-radius:3px;background:${catColors[cat]||'var(--info)'}"></div><div style="flex:1"><div style="font-weight:600;text-transform:capitalize">${cat}</div><div class="progress-bar" style="margin-top:6px"><div class="progress-bar-fill" style="width:${pct}%;background:${catColors[cat]||'var(--info)'}"></div></div></div><span style="font-weight:700;color:${catColors[cat]||'var(--info)'}">${count}</span></div>`;}).join('')}`:''}
    ${stats.recentTests.length>0?`<h3 class="section-header">Recent Tests</h3>${stats.recentTests.map(t=>`<div class="card"><div style="display:flex;align-items:center;gap:14px"><div style="width:48px;height:48px;border-radius:14px;display:flex;align-items:center;justify-content:center;background:${t.score>=70?'rgba(0,200,83,0.08)':'rgba(255,179,0,0.08)'}"><span style="font-weight:700;color:${t.score>=70?'var(--success)':'var(--warning)'}">${t.score}%</span></div><div><div style="font-weight:600">${t.testName||'Mock Test'}</div><div style="font-size:12px;color:var(--text-secondary)">${t.correct}/${t.total} correct</div></div></div></div>`).join('')}`:''}
    ${stats.totalAnswered===0?'<div style="text-align:center;padding:40px"><div style="font-size:64px">📈</div><h3 style="margin:16px 0">No data yet!</h3><p style="color:var(--text-secondary)">Start practicing to see progress</p></div>':''}`;
}

function renderUploadPage(){
  const rem=AIService.getRemainingUploads();const today=AIService.getUploadsToday();
  return`
    <div class="card gradient-card" style="text-align:center;padding:24px"><div style="font-size:40px">📤</div><h2 style="font-size:22px;font-weight:700;margin:8px 0">Upload & Learn</h2><p style="opacity:0.7">Upload study material → AI generates questions</p></div>
    <div style="display:flex;justify-content:space-between;align-items:center;margin:16px 0"><span style="font-weight:600">Today's Uploads</span><span class="upload-count" style="background:${rem>5?'rgba(0,200,83,0.1)':'rgba(255,82,82,0.1)'};color:${rem>5?'var(--success)':'var(--error)'}">${rem}/20 remaining</span></div>
    <div class="upload-zone" onclick="handleFileUpload()">
      <span class="material-icons-round" style="font-size:48px;color:var(--primary);opacity:0.4">cloud_upload</span>
      <h3 style="margin:12px 0;font-size:16px">Tap to Upload</h3>
      <p style="font-size:13px;color:var(--text-secondary)">📄 .txt, .md, .csv, .json<br>📑 .pdf, .doc, .docx<br>🖼️ .jpg, .png, .webp</p>
    </div>
    ${uploadedDocs.length>0||today.length>0?`<h3 class="section-header">Uploaded Documents</h3>
    ${(uploadedDocs.length>0?uploadedDocs:today).map((d,i)=>`<div class="card"><div style="display:flex;align-items:center;gap:12px;margin-bottom:8px"><span class="material-icons-round" style="color:var(--error)">description</span><div style="flex:1"><div style="font-weight:600;font-size:14px">${d.filename}</div><div style="font-size:11px;color:var(--text-secondary)">${new Date(d.date).toLocaleDateString()}</div></div></div>
      ${d.summary?`<p style="font-size:13px;color:var(--text-secondary);margin:4px 0">📝 ${d.summary.substring(0,120)}...</p>`:''}
      <button class="btn btn-gold btn-sm" style="margin-top:8px" onclick="practiceUploadedQuestions(${i})"><span class="material-icons-round" style="font-size:16px">quiz</span> Practice Questions</button></div>`).join('')}`:''}
    <div class="info-box info" style="margin-top:16px"><span class="material-icons-round" style="color:var(--info)">lightbulb</span><div><strong>Supported formats:</strong><br>• Text files → Full AI analysis & questions<br>• PDF/Word → Best results with .txt export<br>• Images → Describe content in chat for help</div></div>`;
}

async function renderSettings(){
  const isDark=document.documentElement.getAttribute('data-theme')==='dark';
  const user=Auth.currentUser||{};const examInfo=Auth.getExamInfo();
  return`
    <div class="card" style="display:flex;align-items:center;gap:16px;padding:20px">
      <div style="width:60px;height:60px;border-radius:18px;background:linear-gradient(135deg,var(--primary),var(--primary-lighter));display:flex;align-items:center;justify-content:center;font-size:24px;color:#fff">${(user.name||'S')[0].toUpperCase()}</div>
      <div style="flex:1"><h3 style="font-size:20px;font-weight:700">${user.name||'Student'}</h3><p style="color:var(--text-secondary);font-size:13px">${user.email||''}</p></div>
    </div>
    <h3 class="section-header">Exam Preparation</h3>
    <div class="card card-clickable" onclick="changeExam()"><div class="setting-item"><div class="setting-icon" style="background:rgba(26,35,126,0.08)"><span style="font-size:20px">${examInfo?.icon||'🎯'}</span></div><div class="setting-info"><div class="setting-title">${examInfo?.name||'Select Exam'}</div><div class="setting-sub">Tap to change exam group</div></div><span class="material-icons-round" style="color:var(--text-secondary)">arrow_forward_ios</span></div></div>
    <h3 class="section-header">Appearance</h3>
    <div class="card"><div class="setting-item"><div class="setting-icon"><span class="material-icons-round">${isDark?'dark_mode':'light_mode'}</span></div><div class="setting-info"><div class="setting-title">Dark Mode</div><div class="setting-sub">Toggle theme</div></div><button class="toggle ${isDark?'active':''}" onclick="toggleTheme()"></button></div></div>
    <h3 class="section-header">AI & Data</h3>
    <div class="card"><div class="setting-item"><div class="setting-icon"><span class="material-icons-round">upload_file</span></div><div class="setting-info"><div class="setting-title">Upload Limit</div><div class="setting-sub">${AIService.getRemainingUploads()}/20 remaining today</div></div></div></div>
    <div class="card card-clickable" onclick="clearAllData()"><div class="setting-item"><div class="setting-icon" style="background:rgba(255,82,82,0.1);color:var(--error)"><span class="material-icons-round">delete_outline</span></div><div class="setting-info"><div class="setting-title">Clear All Data</div><div class="setting-sub">Reset progress & chat</div></div></div></div>
    <h3 class="section-header">Account</h3>
    <div class="card card-clickable" onclick="doLogout()"><div class="setting-item"><div class="setting-icon" style="background:rgba(255,82,82,0.1);color:var(--error)"><span class="material-icons-round">logout</span></div><div class="setting-info"><div class="setting-title">Logout</div><div class="setting-sub">Sign out of your account</div></div></div></div>
    <div style="text-align:center;padding:24px"><div style="font-size:28px">🎓</div><p style="font-weight:600;margin-top:6px">ExamAI v2.0</p><p style="font-size:12px;color:var(--text-secondary)">TNPSC • SSC • RRB • UPSC • Banking</p></div>`;
}
