// IndexedDB wrapper for offline storage
const DB_NAME = 'tnpsc_ai_db';
const DB_VERSION = 1;

class AppDatabase {
  constructor() { this.db = null; }

  async init() {
    return new Promise((resolve, reject) => {
      const req = indexedDB.open(DB_NAME, DB_VERSION);
      req.onupgradeneeded = (e) => {
        const db = e.target.result;
        if (!db.objectStoreNames.contains('chat_messages'))
          db.createObjectStore('chat_messages', { keyPath: 'id', autoIncrement: true });
        if (!db.objectStoreNames.contains('user_answers'))
          db.createObjectStore('user_answers', { keyPath: 'id', autoIncrement: true }).createIndex('question_idx', 'questionIdx');
        if (!db.objectStoreNames.contains('mock_tests'))
          db.createObjectStore('mock_tests', { keyPath: 'id', autoIncrement: true });
        if (!db.objectStoreNames.contains('bookmarks'))
          db.createObjectStore('bookmarks', { keyPath: 'id', autoIncrement: true });
        if (!db.objectStoreNames.contains('settings'))
          db.createObjectStore('settings', { keyPath: 'key' });
      };
      req.onsuccess = (e) => { this.db = e.target.result; resolve(); };
      req.onerror = () => reject(req.error);
    });
  }

  async add(store, data) {
    return new Promise((resolve, reject) => {
      const tx = this.db.transaction(store, 'readwrite');
      const req = tx.objectStore(store).add({ ...data, createdAt: new Date().toISOString() });
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => reject(req.error);
    });
  }

  async getAll(store) {
    return new Promise((resolve, reject) => {
      const tx = this.db.transaction(store, 'readonly');
      const req = tx.objectStore(store).getAll();
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => reject(req.error);
    });
  }

  async clear(store) {
    return new Promise((resolve, reject) => {
      const tx = this.db.transaction(store, 'readwrite');
      const req = tx.objectStore(store).clear();
      req.onsuccess = () => resolve();
      req.onerror = () => reject(req.error);
    });
  }

  async setSetting(key, value) {
    return new Promise((resolve, reject) => {
      const tx = this.db.transaction('settings', 'readwrite');
      const req = tx.objectStore('settings').put({ key, value });
      req.onsuccess = () => resolve();
      req.onerror = () => reject(req.error);
    });
  }

  async getSetting(key) {
    return new Promise((resolve, reject) => {
      const tx = this.db.transaction('settings', 'readonly');
      const req = tx.objectStore('settings').get(key);
      req.onsuccess = () => resolve(req.result?.value);
      req.onerror = () => reject(req.error);
    });
  }

  async getStats() {
    const answers = await this.getAll('user_answers');
    const tests = await this.getAll('mock_tests');
    const correct = answers.filter(a => a.isCorrect).length;
    return {
      totalAnswered: answers.length,
      totalCorrect: correct,
      accuracy: answers.length > 0 ? Math.round((correct / answers.length) * 100) : 0,
      totalTests: tests.length,
      recentTests: tests.slice(-5).reverse(),
      answers
    };
  }
}

const db = new AppDatabase();
