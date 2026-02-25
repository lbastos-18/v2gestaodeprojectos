document.addEventListener('DOMContentLoaded', async function () {
  const container = document.getElementById('siteNavbar');
  if (!container) return;

  // NÃO mostrar navbar em páginas admin
  if (document.body.classList.contains('admin-body')) {
    return; // Admin pages têm seu próprio sidebar/topbar
  }

  // Verifica se é admin (assíncrono)
  const isAdmin = window.Auth && await Auth.isAdmin();

  const nav = document.createElement('nav');
  nav.className = 'navbar navbar-expand-lg surface shadow-sm';
  nav.innerHTML = `
    <div class="container">
      <a class="navbar-brand brand-text" href="index.html">Gestão de Projectos</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav" aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="mainNav">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item"><a class="nav-link" href="index.html">Início</a></li>
          <li class="nav-item"><a class="nav-link" href="projects.html">Projectos</a></li>
          <li class="nav-item"><a class="nav-link" href="about.html">Sobre</a></li>
          <li class="nav-item"><a class="nav-link" href="contact.html">Contactos</a></li>
          ${isAdmin ? '<li class="nav-item"><a class="nav-link" href="admindashboard.html">🔐 Admin</a></li>' : ''}
        </ul>

        <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
          ${isAdmin ? `
            <li class="nav-item">
              <button id="logoutBtn" class="btn btn-sm btn-outline-danger">Sair</button>
            </li>
          ` : '<li class="nav-item"><a class="nav-link btn btn-sm btn-brand text-white" href="login.html">Entrar</a></li>'}
        </ul>
      </div>
    </div>
  `;

  container.replaceWith(nav);

  const logoutBtn = nav.querySelector('#logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', function () {
      if (window.Auth && window.Auth.logout) {
        window.Auth.logout();
      } else {
        window.location.href = 'index.html';
      }
    });
  }
});
