// auth.js - Gerenciamento de autenticação com sessões server-side
(function(){
  'use strict';
  
  // Obtém CSRF token do servidor
  async function fetchCSRFToken() {
    try {
      const res = await fetch('backend/csrf-token.php', { method: 'GET' });
      if (!res.ok) throw new Error('Erro ao obter token CSRF');
      const json = await res.json();
      return json.csrf_token || null;
    } catch (err) {
      console.error('CSRF fetch error:', err);
      return null;
    }
  }
  
  // Verifica autenticação com o servidor
  async function checkAuth() {
    try {
      const res = await fetch('backend/check-auth.php', { 
        method: 'GET',
        credentials: 'include'
      });
      if (res.status === 401) return null;
      if (!res.ok) throw new Error('Erro ao verificar autenticação');
      const json = await res.json();
      return json.user || null;
    } catch (err) {
      console.error('Auth check error:', err);
      return null;
    }
  }
  
  // Verifica se está autenticado
  async function isAuthenticated() {
    const user = await checkAuth();
    return user !== null;
  }
  
  // Verifica se é admin
  async function isAdmin() {
    const user = await checkAuth();
    return user && user.role === 'admin';
  }
  
  // Requer autenticação e redireciona se necessário
  async function requireAuth(redirectTo = 'login.html') {
    const auth = await isAuthenticated();
    if (!auth) {
      window.location.href = redirectTo;
    }
    return auth;
  }
  
  // Requer admin e redireciona se necessário
  async function requireAdmin(redirectTo = 'login.html') {
    const admin = await isAdmin();
    if (!admin) {
      window.location.href = redirectTo;
    }
    return admin;
  }
  
  // Mostra/esconde elementos baseado em autorização
  async function autoHide() {
    const admin = await isAdmin();
    document.querySelectorAll('[data-admin-only]').forEach(el => {
      el.style.display = admin ? '' : 'none';
    });
    document.querySelectorAll('[data-public-only]').forEach(el => {
      el.style.display = admin ? 'none' : '';
    });
  }
  
  // Faz logout
  async function logout() {
    try {
      const csrfToken = await fetchCSRFToken();
      const res = await fetch('backend/logout.php', {
        method: 'POST',
        credentials: 'include',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'csrf_token=' + encodeURIComponent(csrfToken)
      });
      if (res.ok) {
        window.location.href = 'login.html';
      }
    } catch (err) {
      console.error('Logout error:', err);
    }
  }
  
  // Exporta funções globais
  window.Auth = {
    checkAuth,
    isAuthenticated,
    isAdmin,
    requireAuth,
    requireAdmin,
    fetchCSRFToken,
    logout
  };
  
  // Auto-hide ao carregar
  document.addEventListener('DOMContentLoaded', autoHide);
})();

