const params = new URLSearchParams(window.location.search);
const projectId = params.get('id');

const projects = {
  1: {
    title: "Sistema de Gestão Escolar",
    course: "Informática",
    type: "Programação",
    year: "2025",
    advisor: "Prof. João Silva",
    members: ["Ana", "Carlos", "Mário"],
    summary: "Sistema web para gestão académica.",
    description: "Projeto desenvolvido para facilitar o controlo escolar.",
    pdf: "docs/projeto1.pdf"
  },
  2: {
    title: "Rede Hospitalar",
    course: "Informática",
    type: "Redes",
    year: "2024",
    advisor: "Eng. Paulo Costa",
    members: ["Luciana", "Pedro", "José", "Rui"],
    summary: "Infraestrutura de rede hospitalar.",
    description: "Projeto de redes para hospitais.",
    pdf: "docs/projeto2.pdf"
  }
};

const project = projects[projectId];

if (project) {
  document.getElementById("projectTitle").textContent = project.title;
  document.getElementById("course").textContent = project.course;
  document.getElementById("type").textContent = project.type;
  document.getElementById("year").textContent = project.year;
  document.getElementById("advisor").textContent = project.advisor;
  document.getElementById("summary").textContent = project.summary;
  document.getElementById("description").textContent = project.description;
  document.getElementById("pdfLink").href = project.pdf;

  const membersList = document.getElementById("members");
  project.members.forEach(name => {
    const li = document.createElement("li");
    li.textContent = name;
    membersList.appendChild(li);
  });
}
