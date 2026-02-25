// login.js - Login com CSRF seguro
(function() {
  'use strict';
  
  const loginForm = document.getElementById('loginForm');
  if (!loginForm) return;
  
  // Carrega CSRF token ao carregar
  async function loadCSRFToken() {
    try {
      const res = await fetch('backend/csrf-token.php', { 
        method: 'GET',
        credentials: 'include'
      });
      if (!res.ok) throw new Error('Erro ao obter CSRF token');
      const json = await res.json();
      const csrfInput = document.querySelector('input[name="csrf_token"]');
      if (csrfInput && json.csrf_token) {
        csrfInput.value = json.csrf_token;
      }
    } catch (err) {
      console.error('CSRF token error:', err);
    }
  }
  
  // Carrega CSRF ao iniciar
  document.addEventListener('DOMContentLoaded', loadCSRFToken);
  
  // Submissão do formulário
  loginForm.addEventListener('submit', async function (e) {
    e.preventDefault();
    
    const form = e.target;
    const submitBtn = form.querySelector('button[type="submit"]');
    const email = form.querySelector('input[name="email"]').value.trim();
    const password = form.querySelector('input[name="password"]').value;
    
    // Validação básica
    if (!email || !password) {
      showError('Email e password são obrigatórios');
      return;
    }
    
    // Desabilita botão
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Autenticando...';
    }
    
    try {
      const formData = new FormData(form);
      const res = await fetch(form.action, {
        method: 'POST',
        body: formData,
        credentials: 'include'
      });
      
      const json = await res.json();
      
      if (res.ok && json.success) {
        // Login bem-sucedido
        const redirectUrl = json.role === 'admin' ? 'admindashboard.html' : 'index.html';
        window.location.href = redirectUrl;
      } else {
        // Erro na autenticação
        showError(json.error || 'Falha na autenticação. Tente novamente.');
      }
    } catch (err) {
      console.error('Login error:', err);
      showError('Erro de conexão. Tente novamente.');
    } finally {
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="bi bi-box-arrow-in-right"></i> Entrar';
      }
    }
  });
  
  // Mostra mensagem de erro
  function showError(message) {
    // Remove alerts anteriores
    const existingAlert = loginForm.querySelector('.alert');
    if (existingAlert) existingAlert.remove();
    
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger';
    alertDiv.innerHTML = `<strong>Erro:</strong> ${message}`;
    loginForm.insertBefore(alertDiv, loginForm.firstChild);
    
    // Remove após 5 segundos
    setTimeout(() => alertDiv.remove(), 5000);
  }
})();

