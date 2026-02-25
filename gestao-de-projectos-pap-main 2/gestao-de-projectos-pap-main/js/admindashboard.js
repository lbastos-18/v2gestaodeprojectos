document.addEventListener("DOMContentLoaded", () => {

  /* =====================
     SIDEBAR
  ===================== */
  const sidebar = document.getElementById("sidebar");
  const collapseBtn = document.getElementById("collapseBtn");
  const mobileToggle = document.getElementById("mobileToggle");

  collapseBtn?.addEventListener("click", () => {
    sidebar.classList.toggle("collapsed");
  });

  mobileToggle?.addEventListener("click", () => {
    sidebar.classList.toggle("collapsed");
  });

  /* =====================
     DASHBOARD CARDS
  ===================== */
  const cardsRow = document.getElementById("cardsRow");

  const stats = [
    {
      title: "Projetos Defendidos",
      value: 128,
      icon: '<i class="bi bi-folder"></i>',
      sub: "Total geral"
    },
    {
      title: "Orientadores",
      value: 24,
      icon: '<i class="bi bi-person-badge"></i>',
      sub: "Professores envolvidos"
    },
    {
      title: "Alunos que Defenderam",
      value: 392,
      icon: '<i class="bi bi-mortarboard"></i>',
      sub: "Membros de grupos"
    },
    {
      title: "Cursos",
      value: 4,
      icon: '<i class="bi bi-building"></i>',
      sub: "Cursos activos"
    }
  ];

  cardsRow.innerHTML = stats.map(stat => `
    <div class="stat-card">
      <div class="icon">${stat.icon}</div>
      <div class="stat-title">${stat.title}</div>
      <div class="stat-value">${stat.value}</div>
      <div class="stat-sub">${stat.sub}</div>
    </div>
  `).join("");

});
/* =====================
   PROJECTS TABLE
===================== */

const projectsTableBody = document.querySelector("#projectsTable tbody");

/* dados simulados (PHP depois substitui) */
const projects = [
  {
    id: 1,
    name: "Sistema de Gestão Escolar",
    course: "Informática",
    type: "Programação",
    advisor: "Prof. João Silva",
    members: 3,
    year: 2024
  },
  {
    id: 2,
    name: "Rede Hospitalar",
    course: "Informática",
    type: "Redes",
    advisor: "Eng. Paulo Costa",
    members: 4,
    year: 2023
  },
  {
    id: 3,
    name: "Plano de Negócios",
    course: "Gestão Empresarial",
    type: "-",
    advisor: "Prof. Ana Miguel",
    members: 2,
    year: 2024
  }
];

function renderProjectsTable(data) {
  projectsTableBody.innerHTML = data.map(p => `
    <tr>
      <td>${p.name}</td>
      <td>${p.course}</td>
      <td>${p.type}</td>
      <td>${p.advisor}</td>
      <td>${p.members}</td>
      <td>${p.year}</td>
      <td>
        <div class="table-actions d-flex">
          <a href="project-details.html?id=${p.id}" class="btn btn-sm btn-brand me-1" aria-label="Ver projeto"><i class="bi bi-eye"></i></a>
          <a href="#" data-admin-only class="btn btn-sm ghost me-1" aria-label="Editar projeto"><i class="bi bi-pencil"></i></a>
          <a href="#" data-admin-only class="btn btn-sm btn-danger" aria-label="Eliminar projecto"><i class="bi bi-trash"></i></a>
        </div>
      </td>
    </tr>
  `).join("");
}

renderProjectsTable(projects);

