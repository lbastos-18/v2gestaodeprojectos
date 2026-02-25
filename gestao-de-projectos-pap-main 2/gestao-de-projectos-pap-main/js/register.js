// register.js - Registo de novos utilizadores
(function() {
  'use strict';
  
  const registerForm = document.getElementById('registerForm');
  if (!registerForm) return;
  
  // Carrega CSRF token
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
  
  document.addEventListener('DOMContentLoaded', loadCSRFToken);
  
  // Submissão
  registerForm.addEventListener('submit', async function (e) {
    e.preventDefault();
    
    const form = e.target;
    const submitBtn = form.querySelector('button[type="submit"]');
    
    // Validações
    const name = form.querySelector('input[name="name"]').value.trim();
    const email = form.querySelector('input[name="email"]').value.trim();
    const password = form.querySelector('input[name="password"]').value;
    
    if (!name || name.length < 2) {
      showError('Nome deve ter no mínimo 2 caracteres');
      return;
    }
    
    if (!email || !email.includes('@')) {
      showError('Email inválido');
      return;
    }
    
    if (!password || password.length < 6) {
      showError('Password deve ter no mínimo 6 caracteres');
      return;
    }
    
    // Desabilita botão
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Registando...';
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
        // Registo bem-sucedido
        const redirectUrl = json.role === 'admin' ? 'admindashboard.html' : 'index.html';
        window.location.href = redirectUrl;
      } else {
        showError(json.error || 'Erro no registo');
      }
    } catch (err) {
      console.error('Register error:', err);
      showError('Erro de conexão. Tente novamente.');
    } finally {
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="bi bi-person-plus"></i> Registar';
      }
    }
  });
  
  function showError(message) {
    const existingAlert = registerForm.querySelector('.alert');
    if (existingAlert) existingAlert.remove();
    
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger';
    alertDiv.innerHTML = `<strong>Erro:</strong> ${message}`;
    registerForm.insertBefore(alertDiv, registerForm.firstChild);
    
    setTimeout(() => alertDiv.remove(), 5000);
  }
})();