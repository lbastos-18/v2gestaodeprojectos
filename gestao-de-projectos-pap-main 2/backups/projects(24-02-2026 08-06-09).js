const project = JSON.parse(localStorage.getItem("selectedProject"));

if (!project) {
  console.warn("projects.js: nenhum 'selectedProject' em localStorage — script ignorado.");
} else {
  // só executar se estivermos numa página com os elementos esperados
  if (document.querySelector(".project-title")) {
    const titleEl = document.querySelector(".project-title");
    titleEl.textContent = project.title;
  }

  if (document.querySelector(".project-subtitle")) {
    document.querySelector(".project-subtitle").textContent =
      "Projeto académico defendido no Instituto Técnico Médio Privado Santa Ana & Noesa";
  }

  const selectors = [
    ".meta-item:nth-child(1) .value",
    ".meta-item:nth-child(2) .value",
    ".meta-item:nth-child(3) .value",
    ".meta-item:nth-child(4) .value",
  ];

  if (document.querySelector(selectors[0])) document.querySelector(selectors[0]).textContent = project.course;
  if (document.querySelector(selectors[1])) document.querySelector(selectors[1]).textContent = project.type;
  if (document.querySelector(selectors[2])) document.querySelector(selectors[2]).textContent = project.year;
  if (document.querySelector(selectors[3])) document.querySelector(selectors[3]).textContent = project.advisor;

  // membros
  const membersList = document.querySelector(".members-list");
  if (membersList && Array.isArray(project.members)) {
    membersList.innerHTML = "";
    project.members.forEach(m => {
      const li = document.createElement("li");
      li.textContent = m;
      membersList.appendChild(li);
    });
  }

  // resumo e descrição
  const sections = document.querySelectorAll(".project-section p");
  if (sections.length > 0 && project.summary) sections[0].textContent = project.summary;
  if (sections.length > 1 && project.description) sections[1].textContent = project.description;

  // pdf — preferir #pdfLink quando existir
  const pdfEl = document.querySelector("#pdfLink") || document.querySelector(".download-btn");
  if (pdfEl && project.pdf) pdfEl.href = project.pdf;
}
