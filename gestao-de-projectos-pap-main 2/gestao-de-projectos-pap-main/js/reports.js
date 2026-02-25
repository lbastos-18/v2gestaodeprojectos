// reports.js - Gestão de relatórios e análises
(function() {
  'use strict';

  // INICIALIZAR CHARTS
  function initCharts() {
    const ctx1 = document.getElementById('chartCourses');
    const ctx2 = document.getElementById('chartTimeline');
    const ctx3 = document.getElementById('chartStatus');

    if (ctx1) {
      new Chart(ctx1, {
        type: 'doughnut',
        data: {
          labels: ['Informática', 'Gestão Empresarial', 'Enfermagem', 'Contabilidade'],
          datasets: [{
            data: [34, 28, 31, 31],
            backgroundColor: [
              '#0284c7',
              '#16a34a',
              '#ea580c',
              '#7c3aed'
            ],
            borderColor: 'white',
            borderWidth: 2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: {
                font: { size: 12 },
                padding: 15,
                usePointStyle: true
              }
            }
          }
        }
      });
    }

    if (ctx2) {
      new Chart(ctx2, {
        type: 'line',
        data: {
          labels: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'],
          datasets: [{
            label: 'Projectos Submetidos',
            data: [12, 19, 15, 25, 22, 30],
            borderColor: '#0284c7',
            backgroundColor: 'rgba(2, 132, 199, 0.1)',
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#0284c7',
            pointBorderColor: 'white',
            pointBorderWidth: 2,
            pointRadius: 4
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: false
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              max: 35
            }
          }
        }
      });
    }

    if (ctx3) {
      new Chart(ctx3, {
        type: 'pie',
        data: {
          labels: ['Concluído', 'Em Revisão', 'Pendente'],
          datasets: [{
            data: [45, 32, 47],
            backgroundColor: [
              '#16a34a',
              '#ea580c',
              '#0284c7'
            ],
            borderColor: 'white',
            borderWidth: 2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: {
                font: { size: 12 },
                padding: 15,
                usePointStyle: true
              }
            }
          }
        }
      });
    }
  }

  // FILTER HANDLERS
  const applyFilters = document.getElementById('applyFilters');
  const resetFilters = document.getElementById('resetFilters');

  if (applyFilters) {
    applyFilters.addEventListener('click', function() {
      const year = document.getElementById('filterYear').value;
      const course = document.getElementById('filterCourse').value;
      const type = document.getElementById('filterType').value;

      console.log('Filtros aplicados:', { year, course, type });
      showNotification('Filtros aplicados! Relatórios atualizados.', 'success');
    });
  }

  if (resetFilters) {
    resetFilters.addEventListener('click', function() {
      document.getElementById('filterYear').value = document.querySelector('#filterYear option').value;
      document.getElementById('filterCourse').value = '';
      document.getElementById('filterType').value = 'Todos';
      showNotification('Filtros reestabelecidos', 'info');
    });
  }

  // EXPORT HANDLERS
  const exportButtons = document.querySelectorAll('.export-btn');
  exportButtons.forEach(btn => {
    btn.addEventListener('click', function() {
      const format = this.querySelector('span').textContent;
      console.log('Exportando em:', format);
      showNotification(`Relatório sendo gerado em ${format}...`, 'info');
      
      // Simular download
      setTimeout(() => {
        showNotification(`Relatório em ${format} pronto para download!`, 'success');
      }, 1500);
    });
  });

  // DOWNLOAD BUTTONS (nos cards)
  const downloadButtons = document.querySelectorAll('.report-header .btn-outline-primary');
  downloadButtons.forEach(btn => {
    btn.addEventListener('click', function() {
      showNotification('Relatório sendo descarregado...', 'info');
      
      setTimeout(() => {
        showNotification('Download concluído!', 'success');
      }, 1000);
    });
  });

  // TABELA - EDITAR/DELETAR
  const editButtons = document.querySelectorAll('.table .btn-outline-secondary');
  const deleteButtons = document.querySelectorAll('.table .btn-outline-danger');

  editButtons.forEach(btn => {
    btn.addEventListener('click', function() {
      showNotification('Abrindo formulário de edição...', 'info');
    });
  });

  deleteButtons.forEach(btn => {
    btn.addEventListener('click', function() {
      if (confirm('Tem a certeza que deseja cancelar esta defesa?')) {
        this.closest('tr').style.opacity = '0.5';
        showNotification('Defesa cancelada com sucesso', 'success');
      }
    });
  });

  // PROGRAMAR DEFESA
  const scheduleBtn = document.querySelector('.section-header .btn-primary');
  if (scheduleBtn) {
    scheduleBtn.addEventListener('click', function(e) {
      e.preventDefault();
      showNotification('Abrindo formulário para programar defesa...', 'info');
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

  // SIDEBAR TOGGLE
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

  // RESPONSIVIDADE - Sidebar automática em mobile
  function handleResize() {
    if (window.innerWidth < 768 && sidebar) {
      sidebar.classList.add('collapsed');
    }
  }

  window.addEventListener('resize', handleResize);
  handleResize();

  // INICIALIZAR TUDO
  document.addEventListener('DOMContentLoaded', function() {
    initCharts();
  });

  // Se os charts já estão prontos quando o script carrega
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initCharts);
  } else {
    initCharts();
  }

})();
