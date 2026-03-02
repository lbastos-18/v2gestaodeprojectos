const membersList = document.getElementById("membersList");
const addMemberBtn = document.getElementById("addMember");

function addMemberField() {
  const input = document.createElement("input");
  input.type = "text";
  input.placeholder = "Nome do membro";
  membersList.appendChild(input);
}

addMemberBtn.addEventListener("click", addMemberField);

// cria 1 membro por padrão
addMemberField();

document.getElementById("projectForm").addEventListener("submit", e => {
  e.preventDefault();
  alert("Projeto pronto para ser enviado ao backend (PHP)");
});
