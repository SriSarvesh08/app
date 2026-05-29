// TNPSC AI - Quiz, Mock Test, Upload & Results Engine

// ===== TOPIC QUIZ (No immediate answers) =====
function startTopicQuiz(category,topic,color){
  let qs=QUESTIONS.filter(q=>q.category===category&&q.topic===topic);
  if(qs.length===0)qs=QUESTIONS.filter(q=>q.category===category);
  if(qs.length===0){alert('No questions available yet!');return;}
  qs=shuffle(qs).slice(0,Math.min(10,qs.length));
  quizState={questions:qs,answers:{},index:0,color,topic,category,startTime:Date.now()};
  pageHistory.push(currentPage);currentPage='topic-quiz';
  document.getElementById('page-title').textContent=topic;
  document.getElementById('back-btn').classList.remove('hidden');
  document.getElementById('bottom-nav').classList.add('hidden');
  renderQuizQuestion();
}

function renderQuizQuestion(){
  const{questions:qs,index:i,answers,color}=quizState;const q=qs[i];
  const c=document.getElementById('page-container');
  c.innerHTML=`
    <div class="progress-bar" style="margin-bottom:12px"><div class="progress-bar-fill" style="width:${((i+1)/qs.length)*100}%;background:${color}"></div></div>
    <div style="display:flex;justify-content:space-between;margin-bottom:16px">
      <span style="font-size:13px;color:var(--text-secondary)">Question ${i+1} of ${qs.length}</span>
      <span style="font-weight:600;color:${color}">${Object.keys(answers).length}/${qs.length} answered</span>
    </div>
    <div class="question-box">${esc(q.question)}</div>
    ${q.options.map((opt,oi)=>{
      const sel=answers[i]===oi;
      return`<button class="option-btn ${sel?'selected':''}" onclick="selectQuizAnswer(${oi})">
        <div class="option-letter" style="background:${sel?color:'rgba(108,99,255,0.1)'};color:${sel?'#fff':color}">${'ABCD'[oi]}</div>
        <span>${esc(opt)}</span></button>`;
    }).join('')}
    <div class="btn-row">
      ${i>0?'<button class="btn btn-outline" onclick="quizNav(-1)"><span class="material-icons-round">arrow_back</span> Prev</button>':''}
      ${i<qs.length-1?`<button class="btn btn-primary" onclick="quizNav(1)">Next <span class="material-icons-round">arrow_forward</span></button>`
        :`<button class="btn btn-success" onclick="submitQuiz()"><span class="material-icons-round">check_circle</span> Submit</button>`}
    </div>
    <div class="q-navigator" style="margin-top:20px">${qs.map((_,qi)=>
      `<button class="q-nav-btn ${qi===i?'current':''} ${answers[qi]!==undefined?'answered':''}" onclick="quizState.index=${qi};renderQuizQuestion()">${qi+1}</button>`
    ).join('')}</div>`;
}

function selectQuizAnswer(oi){quizState.answers[quizState.index]=oi;renderQuizQuestion();}
function quizNav(dir){quizState.index+=dir;renderQuizQuestion();}

function submitQuiz(){
  const{questions:qs,answers,category,topic,startTime}=quizState;
  const unanswered=qs.length-Object.keys(answers).length;
  if(unanswered>0&&!confirm(`You have ${unanswered} unanswered question(s). Submit anyway?`))return;
  let correct=0,wrong=0,skipped=0;const details=[];
  qs.forEach((q,i)=>{
    const ans=answers[i];const isCorrect=ans===q.correct;
    if(ans===undefined){skipped++;details.push({q,userAns:null,status:'skipped'});}
    else if(isCorrect){correct++;details.push({q,userAns:ans,status:'correct'});}
    else{wrong++;details.push({q,userAns:ans,status:'wrong'});}
    if(ans!==undefined)db.add('user_answers',{category,topic:q.topic,selected:ans,isCorrect,time:new Date()});
  });
  const score=Math.round((correct/qs.length)*100);
  const timeTaken=Math.round((Date.now()-startTime)/1000);
  showResultSheet({total:qs.length,correct,wrong,skipped,score,timeTaken,details,category,topic,type:'practice'});
}

// ===== MOCK TEST (Up to 150 Qs, no immediate answers) =====
function toggleTestCat(btn){
  btn.classList.toggle('active');
  const active=document.querySelectorAll('.chip-cat.active');
  if(active.length===0)btn.classList.add('active');
  testConfig.categories=[...active].map(b=>b.dataset.cat);
}
function selectTestCount(n,btn){
  document.querySelectorAll('#count-chips .chip').forEach(c=>c.classList.remove('active'));
  btn.classList.add('active');testConfig.count=n;
  document.getElementById('test-time-info').textContent=`Time: ${n} minutes (1 min/question) • ${Math.floor(n/60)}h ${n%60}m`;
}
function selectDifficulty(d,btn){
  document.querySelectorAll('#diff-chips .chip').forEach(c=>c.classList.remove('active'));
  btn.classList.add('active');testConfig.difficulty=d;
}

function startMockTest(){
  let pool=QUESTIONS.filter(q=>testConfig.categories.includes(q.category));
  if(testConfig.difficulty!=='all')pool=pool.filter(q=>q.difficulty===testConfig.difficulty);
  pool=shuffle(pool).slice(0,testConfig.count);
  if(pool.length===0){alert('No questions available!');return;}
  if(pool.length<testConfig.count)alert(`Only ${pool.length} questions available. Starting with ${pool.length}.`);
  testState={questions:pool,answers:{},review:new Set(),index:0,totalTime:pool.length*60,remaining:pool.length*60,startTime:Date.now()};
  pageHistory.push(currentPage);currentPage='test-active';
  document.getElementById('bottom-nav').classList.add('hidden');
  document.getElementById('back-btn').classList.remove('hidden');
  testTimer=setInterval(tickTimer,1000);
  renderTestQuestion();
}

function tickTimer(){
  testState.remaining--;
  const el=document.getElementById('test-timer');
  if(el){
    const cls=testState.remaining<60?'timer-low':testState.remaining<300?'timer-warn':'timer-ok';
    el.className=`timer-badge ${cls}`;
    el.innerHTML=`<span class="material-icons-round" style="font-size:16px">timer</span> ${fmtTime(testState.remaining)}`;
  }
  if(testState.remaining<=0)submitMockTest();
}

function renderTestQuestion(){
  const{questions:qs,index:i,answers,review}=testState;const q=qs[i];
  const c=document.getElementById('page-container');
  document.getElementById('page-title').textContent=`Q ${i+1}/${qs.length}`;
  const isLow=testState.remaining<60;const isWarn=testState.remaining<300;
  c.innerHTML=`
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
      <span style="font-size:13px;color:var(--text-secondary)">${Object.keys(answers).length} answered • ${review.size} marked</span>
      <span class="timer-badge ${isLow?'timer-low':isWarn?'timer-warn':'timer-ok'}" id="test-timer"><span class="material-icons-round" style="font-size:16px">timer</span> ${fmtTime(testState.remaining)}</span>
    </div>
    <div class="progress-bar" style="margin-bottom:16px"><div class="progress-bar-fill" style="width:${((i+1)/qs.length)*100}%;background:var(--mock-test)"></div></div>
    <div class="question-box">${esc(q.question)}</div>
    ${q.options.map((opt,oi)=>{
      const sel=answers[i]===oi;
      return`<button class="option-btn ${sel?'selected':''}" onclick="selectTestAnswer(${oi})">
        <div class="option-letter" style="background:${sel?'var(--primary)':'rgba(124,77,255,0.1)'};color:${sel?'#fff':'var(--mock-test)'}">${'ABCD'[oi]}</div>
        <span>${esc(opt)}</span></button>`;
    }).join('')}
    <div style="display:flex;gap:8px;margin-top:12px">
      <button class="btn btn-outline btn-sm" style="flex:0" onclick="toggleReview(${i})">
        <span class="material-icons-round" style="font-size:16px">${review.has(i)?'bookmark':'bookmark_border'}</span> ${review.has(i)?'Marked':'Mark'}
      </button>
      <button class="btn btn-outline btn-sm" style="flex:0" onclick="clearTestAnswer(${i})">
        <span class="material-icons-round" style="font-size:16px">clear</span> Clear
      </button>
    </div>
    <div class="btn-row">
      ${i>0?'<button class="btn btn-outline" onclick="testNav(-1)"><span class="material-icons-round">arrow_back</span></button>':''}
      ${i<qs.length-1?'<button class="btn btn-primary" onclick="testNav(1)">Next <span class="material-icons-round">arrow_forward</span></button>'
        :'<button class="btn btn-success" onclick="submitMockTest()"><span class="material-icons-round">check_circle</span> Submit Test</button>'}
    </div>
    <details style="margin-top:16px"><summary style="cursor:pointer;font-weight:600;font-size:14px;color:var(--text-secondary)">📋 Question Navigator (${Object.keys(answers).length}/${qs.length})</summary>
    <div class="q-navigator" style="margin-top:8px">${qs.map((_,qi)=>
      `<button class="q-nav-btn ${qi===i?'current':''} ${answers[qi]!==undefined?'answered':''} ${review.has(qi)?'review':''}" onclick="testState.index=${qi};renderTestQuestion()">${qi+1}</button>`
    ).join('')}</div>
    <div style="display:flex;gap:12px;margin-top:8px;font-size:11px;color:var(--text-secondary)">
      <span>🔵 Current</span><span>🟢 Answered</span><span>🟡 Marked</span><span>⚪ Not visited</span>
    </div></details>`;
}

function selectTestAnswer(oi){testState.answers[testState.index]=oi;renderTestQuestion();}
function clearTestAnswer(i){delete testState.answers[i];renderTestQuestion();}
function toggleReview(i){if(testState.review.has(i))testState.review.delete(i);else testState.review.add(i);renderTestQuestion();}
function testNav(dir){testState.index+=dir;renderTestQuestion();}

function submitMockTest(){
  const unanswered=testState.questions.length-Object.keys(testState.answers).length;
  if(unanswered>0&&!confirm(`${unanswered} unanswered question(s). Submit anyway?`))return;
  clearInterval(testTimer);testTimer=null;
  const{questions:qs,answers,totalTime,remaining}=testState;
  let correct=0,wrong=0,skipped=0;const details=[];const catStats={};
  qs.forEach((q,i)=>{
    const ans=answers[i];const isCorrect=ans===q.correct;
    if(!catStats[q.category])catStats[q.category]={total:0,correct:0,wrong:0};
    catStats[q.category].total++;
    if(ans===undefined){skipped++;details.push({q,userAns:null,status:'skipped'});}
    else if(isCorrect){correct++;catStats[q.category].correct++;details.push({q,userAns:ans,status:'correct'});}
    else{wrong++;catStats[q.category].wrong++;details.push({q,userAns:ans,status:'wrong'});}
    if(ans!==undefined)db.add('user_answers',{category:q.category,topic:q.topic,selected:ans,isCorrect,time:new Date()});
  });
  const score=Math.round((correct/qs.length)*100);
  const timeTaken=totalTime-remaining;
  db.add('mock_tests',{testName:'Mock Test',total:qs.length,correct,wrong,skipped,score,timeTaken});
  showResultSheet({total:qs.length,correct,wrong,skipped,score,timeTaken,details,catStats,type:'mock'});
}

// ===== DETAILED RESULT SHEET =====
function showResultSheet(r){
  currentPage='test-result';
  document.getElementById('bottom-nav').classList.remove('hidden');
  document.getElementById('page-title').textContent='Results';
  let grade,emoji,color;
  if(r.score>=90){grade='Excellent!';emoji='🏆';color='var(--success)';}
  else if(r.score>=70){grade='Great Job!';emoji='🌟';color='var(--info)';}
  else if(r.score>=50){grade='Good Effort!';emoji='👍';color='var(--warning)';}
  else{grade='Keep Practicing!';emoji='💪';color='var(--error)';}

  // Weakness analysis
  const topicStats={};
  r.details.forEach(d=>{
    const t=d.q.topic;if(!topicStats[t])topicStats[t]={total:0,correct:0,wrong:0};
    topicStats[t].total++;
    if(d.status==='correct')topicStats[t].correct++;
    if(d.status==='wrong')topicStats[t].wrong++;
  });
  const weakTopics=Object.entries(topicStats).map(([t,s])=>({topic:t,accuracy:s.total>0?Math.round((s.correct/s.total)*100):0,...s})).sort((a,b)=>a.accuracy-b.accuracy);

  const c=document.getElementById('page-container');
  c.innerHTML=`
    <div class="result-hero">
      <div class="emoji">${emoji}</div><div class="grade">${grade}</div>
      <div style="margin:20px auto"><svg width="120" height="120" viewBox="0 0 120 120">
        <circle cx="60" cy="60" r="50" fill="none" stroke="rgba(255,255,255,0.15)" stroke-width="10"/>
        <circle cx="60" cy="60" r="50" fill="none" stroke="#fff" stroke-width="10" stroke-linecap="round" stroke-dasharray="${2*Math.PI*50}" stroke-dashoffset="${2*Math.PI*50*(1-r.score/100)}" transform="rotate(-90 60 60)"/>
      </svg><div style="margin-top:-85px;font-size:30px;font-weight:700">${r.score}%</div><div style="height:48px"></div></div>
      <div style="opacity:0.7">⏱ Time: ${fmtTime(r.timeTaken)} | ${r.type==='mock'?'Mock Test':'Practice'}</div>
    </div>
    <div class="result-stats-grid">
      <div class="result-stat-card" style="background:rgba(0,200,83,0.06);border:1px solid rgba(0,200,83,0.15);border-radius:12px"><div style="font-size:20px">✅</div><div class="val" style="color:var(--success)">${r.correct}</div><div class="lbl">Correct</div></div>
      <div class="result-stat-card" style="background:rgba(255,82,82,0.06);border:1px solid rgba(255,82,82,0.15);border-radius:12px"><div style="font-size:20px">❌</div><div class="val" style="color:var(--error)">${r.wrong}</div><div class="lbl">Wrong</div></div>
      <div class="result-stat-card" style="background:rgba(255,179,0,0.06);border:1px solid rgba(255,179,0,0.15);border-radius:12px"><div style="font-size:20px">⏭️</div><div class="val" style="color:var(--warning)">${r.skipped}</div><div class="lbl">Skipped</div></div>
      <div class="result-stat-card" style="background:rgba(68,138,255,0.06);border:1px solid rgba(68,138,255,0.15);border-radius:12px"><div style="font-size:20px">📊</div><div class="val" style="color:var(--info)">${r.total}</div><div class="lbl">Total</div></div>
    </div>

    <div class="card"><div style="display:flex;align-items:center;gap:8px;margin-bottom:12px"><span class="material-icons-round" style="color:var(--error)">warning</span><strong>⚠️ Key Areas for Improvement</strong></div>
    ${weakTopics.filter(t=>t.accuracy<100).slice(0,5).map(t=>`
      <div class="weakness-item">
        <span style="font-size:13px;font-weight:500;min-width:100px">${t.topic}</span>
        <div class="weakness-bar"><div class="weakness-bar-track"><div class="weakness-bar-fill" style="width:${t.accuracy}%;background:${t.accuracy>=70?'var(--success)':t.accuracy>=40?'var(--warning)':'var(--error)'}"></div></div></div>
        <span style="font-weight:700;font-size:13px;color:${t.accuracy>=70?'var(--success)':t.accuracy>=40?'var(--warning)':'var(--error)'};min-width:40px;text-align:right">${t.accuracy}%</span>
      </div>`).join('')}
    ${weakTopics.filter(t=>t.accuracy<100).length===0?'<p style="color:var(--success)">🎉 Perfect score! No weak areas!</p>':''}
    </div>

    ${r.catStats?`<div class="card"><strong>📊 Category Performance</strong>
    ${Object.entries(r.catStats).map(([cat,s])=>{const acc=Math.round((s.correct/s.total)*100);return`
      <div style="display:flex;align-items:center;gap:12px;margin-top:12px">
        <span style="font-weight:500;min-width:80px;text-transform:capitalize">${cat}</span>
        <div style="flex:1"><div class="progress-bar"><div class="progress-bar-fill" style="width:${acc}%;background:${acc>=70?'var(--success)':'var(--warning)'}"></div></div></div>
        <span style="font-weight:700;font-size:13px">${s.correct}/${s.total}</span>
      </div>`;}).join('')}</div>`:''}

    <div class="card"><div style="display:flex;align-items:center;gap:8px;margin-bottom:12px"><span class="material-icons-round" style="color:var(--primary)">smart_toy</span><strong>AI Feedback</strong></div>
    <p style="line-height:1.6">${getAIFeedback(r)}</p></div>

    <details class="card" style="cursor:pointer"><summary style="font-weight:600">📝 Detailed Answer Sheet (${r.total} Questions)</summary>
    <div style="margin-top:12px">${r.details.map((d,i)=>`
      <div class="answer-row">
        <div class="answer-num ${d.status==='correct'?'answer-correct':d.status==='wrong'?'answer-wrong':'answer-skip'}">${i+1}</div>
        <div style="flex:1">
          <div style="font-weight:500;margin-bottom:4px">${esc(d.q.question)}</div>
          <div style="font-size:12px">
            ${d.userAns!==null?`<span style="color:${d.status==='correct'?'var(--success)':'var(--error)'}">Your: ${d.q.options[d.userAns]}</span> | `:'<span style="color:var(--warning)">Skipped</span> | '}
            <span style="color:var(--success)">Correct: ${d.q.options[d.q.correct]}</span>
          </div>
          ${d.q.explanation?`<div style="font-size:12px;color:var(--text-secondary);margin-top:4px">💡 ${d.q.explanation}</div>`:''}
        </div>
      </div>`).join('')}</div></details>

    <div class="btn-row" style="margin-top:16px">
      <button class="btn btn-primary" onclick="navigateTo('mock-test')"><span class="material-icons-round">refresh</span> New Test</button>
      <button class="btn btn-outline" onclick="navigateTo('dashboard')">Dashboard</button>
    </div>`;
}

function getAIFeedback(r){
  if(r.score>=90)return'🎉 Outstanding! You have excellent command over these topics. Focus on maintaining speed and accuracy. Consider attempting harder difficulty levels.';
  if(r.score>=70)return`👏 Strong performance! Review the ${r.wrong} wrong answers carefully — understanding WHY you got them wrong is more valuable than the score itself. Focus on your weak topics listed above.`;
  if(r.score>=50)return`📚 Decent attempt! Your foundation is there but needs strengthening. Spend 30 minutes daily on your weakest topics. Use the AI assistant to understand concepts deeply, not just memorize.`;
  return`💪 Don't give up! Every expert was once a beginner. Start with easy-level questions, master the basics, then gradually increase difficulty. Upload your study material and let me help you learn systematically.`;
}

// ===== UPLOAD PRACTICE =====
function practiceUploadedQuestions(idx){
  const doc=AIService.uploadedDocs[idx]||uploadedDocs[idx];
  if(!doc||!doc.questions||doc.questions.length===0){alert('No questions generated from this document yet.');return;}
  quizState={questions:doc.questions,answers:{},index:0,color:'var(--info)',topic:doc.filename,category:'uploaded',startTime:Date.now()};
  pageHistory.push(currentPage);currentPage='topic-quiz';
  document.getElementById('page-title').textContent=doc.filename;
  document.getElementById('back-btn').classList.remove('hidden');
  document.getElementById('bottom-nav').classList.add('hidden');
  renderQuizQuestion();
}

// Current Affairs
function filterAffairs(cat){
  document.querySelectorAll('.tab').forEach(t=>t.classList.toggle('active',t.textContent===cat));
  document.querySelectorAll('.affair-item').forEach(el=>{el.style.display=(cat==='All'||el.dataset.cat===cat)?'':'none';});
}
function showAffairDetail(idx){
  const a=CURRENT_AFFAIRS[idx];const ov=document.createElement('div');ov.className='modal-overlay';ov.onclick=(e)=>{if(e.target===ov)ov.remove();};
  ov.innerHTML=`<div class="modal-sheet"><div class="modal-handle"></div><span style="font-weight:600;color:var(--primary)">${a.category}</span><h2 style="font-size:22px;font-weight:700;margin:8px 0">${a.title}</h2><p style="color:var(--text-secondary);margin-bottom:20px">${a.date}</p><p style="font-size:15px;line-height:1.7">${a.content}</p></div>`;
  document.body.appendChild(ov);
}
