// settings.js - Gestão de configurações do sistema
(function() {
  'use strict';

  // TAB NAVIGATION
  const tabButtons = document.querySelectorAll('.tab-btn');
  const tabContents = document.querySelectorAll('.tab-content');

  tabButtons.forEach(button => {
    button.addEventListener('click', function() {
      const tabId = this.getAttribute('data-tab');
      
      // Remove active class from all buttons and contents
      tabButtons.forEach(btn => btn.classList.remove('active'));
      tabContents.forEach(content => content.classList.remove('active'));
      
      // Add active class to clicked button and corresponding content
      this.classList.add('active');
      document.getElementById(tabId).classList.add('active');
    });
  });

  // SAVE HANDLERS
  const saveGeneral = document.getElementById('saveGeneral');
  const saveSecurity = document.getElementById('saveSecurity');
  const saveNotif = document.getElementById('saveNotif');
  const saveAdvanced = document.getElementById('saveAdvanced');

  if (saveGeneral) {
    saveGeneral.addEventListener('click', function() {
      showNotification('Configurações gerais guardadas com sucesso!', 'success');
    });
  }

  if (saveSecurity) {
    saveSecurity.addEventListener('click', function() {
      showNotification('Configurações de segurança atualizadas!', 'success');
    });
  }

  if (saveNotif) {
    saveNotif.addEventListener('click', function() {
      showNotification('Preferências de notificações guardadas!', 'success');
    });
  }

  if (saveAdvanced) {
    saveAdvanced.addEventListener('click', function() {
      showNotification('Configurações avançadas atualizadas!', 'success');
    });
  }

  // CHANGE PASSWORD
  const changePassword = document.getElementById('changePassword');
  if (changePassword) {
    changePassword.addEventListener('click', function() {
      const currentPass = document.getElementById('currentPass').value;
      const newPass = document.getElementById('newPass').value;
      const confirmPass = document.getElementById('confirmPass').value;

      if (!currentPass || !newPass || !confirmPass) {
        showNotification('Por favor, preencha todos os campos de password', 'error');
        return;
      }

      if (newPass !== confirmPass) {
        showNotification('As passwords não coincidem', 'error');
        return;
      }

      if (newPass.length < 8) {
        showNotification('A nova password deve ter pelo menos 8 caracteres', 'error');
        return;
      }

      showNotification('Password alterada com sucesso!', 'success');
      document.getElementById('currentPass').value = '';
      document.getElementById('newPass').value = '';
      document.getElementById('confirmPass').value = '';
    });
  }

  // BACKUP
  const backupBtn = document.getElementById('backupBtn');
  if (backupBtn) {
    backupBtn.addEventListener('click', function() {
      this.disabled = true;
      this.innerHTML = '<i class="bi bi-hourglass-split"></i> Processando...';
      
      setTimeout(() => {
        showNotification('Backup criado com sucesso!', 'success');
        this.disabled = false;
        this.innerHTML = '<i class="bi bi-download"></i> Fazer Backup';
      }, 2000);
    });
  }

  // OPTIMIZE DB
  const optimizeBtn = document.getElementById('optimizeBtn');
  if (optimizeBtn) {
    optimizeBtn.addEventListener('click', function() {
      this.disabled = true;
      this.innerHTML = '<i class="bi bi-hourglass-split"></i> Otimizando...';
      
      setTimeout(() => {
        showNotification('Base de dados otimizada!', 'success');
        this.disabled = false;
        this.innerHTML = '<i class="bi bi-gear"></i> Otimizar BD';
      }, 3000);
    });
  }

  // VIEW LOGS
  const viewLogsBtn = document.getElementById('viewLogsBtn');
  if (viewLogsBtn) {
    viewLogsBtn.addEventListener('click', function() {
      showNotification('Abrindo logs do sistema...', 'info');
      // Aqui abriria uma modal ou nova página com logs
    });
  }

  // CLEAR LOGS
  const clearLogsBtn = document.getElementById('clearLogsBtn');
  if (clearLogsBtn) {
    clearLogsBtn.addEventListener('click', function() {
      if (confirm('Tem a certeza que deseja limpar os logs? Esta ação não pode ser desfeita.')) {
        this.disabled = true;
        this.innerHTML = '<i class="bi bi-hourglass-split"></i> Limpando...';
        
        setTimeout(() => {
          showNotification('Logs limpos com sucesso!', 'success');
          this.disabled = false;
          this.innerHTML = '<i class="bi bi-trash"></i> Limpar Logs';
        }, 1500);
      }
    });
  }

  // RESET DEFAULT
  const resetBtn = document.getElementById('resetBtn');
  if (resetBtn) {
    resetBtn.addEventListener('click', function() {
      if (confirm('Esta ação irá reestabelecer todos os valores padrão. Tem a certeza?')) {
        this.disabled = true;
        this.innerHTML = '<i class="bi bi-hourglass-split"></i> Reestabelecendo...';
        
        setTimeout(() => {
          showNotification('Valores padrão reestabelecidos! A página será recarregada...', 'success');
          setTimeout(() => location.reload(), 1500);
        }, 2000);
      }
    });
  }

  // RESET FORM
  const resetGeneral = document.getElementById('resetGeneral');
  if (resetGeneral) {
    resetGeneral.addEventListener('click', function() {
      document.querySelectorAll('#general input, #general select').forEach(el => {
        el.value = el.defaultValue;
      });
      showNotification('Formulário recarregado', 'info');
    });
  }

  // SHOW NOTIFICATION
  function showNotification(message, type = 'info') {
    const alert = document.createElement('div');
    alert.className = `alert alert-${type} alert-dismissible fade show`;
    alert.style.position = 'fixed';
    alert.style.top = '20px';
    alert.style.right = '20px';
    alert.style.zIndex = '9999';
    alert.style.minWidth = '300px';
    alert.style.maxWidth = '500px';
    alert.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alert);
    
    setTimeout(() => {
      alert.remove();
    }, 4000);
  }

  // SIDEBAR TOGGLE (compartilhado com outras páginas)
  const mobileToggle = document.getElementById('mobileToggle');
  const sidebar = document.getElementById('sidebar');
  const collapseBtn = document.getElementById('collapseBtn');

  if (mobileToggle && sidebar) {
    mobileToggle.addEventListener('click', function() {
      sidebar.classList.toggle('collapsed');
    });
  }

  if (collapseBtn && sidebar) {
    collapseBtn.addEventListener('click', function() {
      sidebar.classList.toggle('collapsed');
    });
  }

})();
