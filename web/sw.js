const CACHE_NAME = 'examai-v3';
const ASSETS = [
  'index.html','css/styles.css',
  'js/data.js','js/database.js','js/auth.js','js/lessons.js',
  'js/ai-service.js','js/screens.js','js/quiz-engine.js','js/app.js',
  'manifest.json'
];

self.addEventListener('install', e => {
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(ASSETS)));
});

self.addEventListener('fetch', e => {
  e.respondWith(
    fetch(e.request).catch(() => caches.match(e.request).then(r => r || caches.match('index.html')))
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});
