const project = JSON.parse(localStorage.getItem("selectedProject"));

if (!project) {
  alert("Projeto não encontrado");
}

document.querySelector(".project-title").textContent = project.title;
document.querySelector(".project-subtitle").textContent =
  "Projeto académico defendido no Instituto Técnico Médio Privado Santa Ana & Noesa";

document.querySelector(".meta-item:nth-child(1) .value").textContent = project.course;
document.querySelector(".meta-item:nth-child(2) .value").textContent = project.type;
document.querySelector(".meta-item:nth-child(3) .value").textContent = project.year;
document.querySelector(".meta-item:nth-child(4) .value").textContent = project.advisor;

// membros
const membersList = document.querySelector(".members-list");
membersList.innerHTML = "";
project.members.forEach(m => {
  const li = document.createElement("li");
  li.textContent = m;
  membersList.appendChild(li);
});

// resumo e descrição
document.querySelectorAll(".project-section p")[0].textContent = project.summary;
document.querySelectorAll(".project-section p")[1].textContent = project.description;

// pdf
document.querySelector(".download-btn").href = project.pdf;
