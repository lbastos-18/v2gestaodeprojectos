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
      icon: "📁",
      sub: "Total geral"
    },
    {
      title: "Orientadores",
      value: 24,
      icon: "👨‍🏫",
      sub: "Professores envolvidos"
    },
    {
      title: "Alunos que Defenderam",
      value: 392,
      icon: "🎓",
      sub: "Membros de grupos"
    },
    {
      title: "Cursos",
      value: 4,
      icon: "🏫",
      sub: "Cursos ativos"
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
        <div class="table-actions">
          <a href="project-details.html?id=${p.id}" class="view">Ver</a>
          <a href="#" class="edit">Editar</a>
          <a href="#" class="delete">Eliminar</a>
        </div>
      </td>
    </tr>
  `).join("");
}

renderProjectsTable(projects);

