// Botão Edit Profile com exemplo de ação (adicionar guard clause)
const editButton = document.getElementById("editButton");
if (editButton) {
    editButton.addEventListener("click", function() {
        alert("Função de edição de perfil ainda não implementada.");
    });
}

// Animação suave ao carregar
window.addEventListener("load", () => {
    document.body.style.opacity = "1";
});


// Helpers para carregar projectos (usa backend se disponível, senão fallback localStorage)
async function fetchJSON(url, opts) {
    try {
        const res = await fetch(url, opts);
        if (!res.ok) throw new Error('bad response');
        return await res.json();
    } catch (e) {
        return null;
    }
}

function renderProjectCard(p) {
    const members = (p.members || []).map(m => `${m.name}${m.is_leader ? ' (Líder)' : ''}`).join(', ');
    const defendedBadge = p.defended ? `<span class="badge bg-success ms-2">Defendido</span>` : '';
    const defenseInfo = p.defense_date ? `<div class="text-muted small">Data de defesa: ${p.defense_date}</div>` : '';
    return `
    <div class="card mb-3">
      <div class="card-body">
        <h5 class="card-title">${p.name} ${defendedBadge}</h5>
        <h6 class="card-subtitle mb-2 text-muted">${p.course || ''} — ${p.year || ''}</h6>
        <p class="mb-1">Orientador: ${p.advisor || '—'}</p>
        <p class="mb-1"><strong>Alunos:</strong> ${members || '—'}</p>
        ${defenseInfo}
                <div class="mt-2"><a href="project-details.html?id=${p.id}" class="btn btn-sm btn-brand">Ver detalhes</a></div>
      </div>
    </div>`;
}

async function loadDefendedProjects() {
    const target = document.getElementById('defendedProjectsList');
    if (!target) return;
    const json = await fetchJSON('backend/list_defended_projects.php');
    if (json && json.success) {
        target.innerHTML = json.projects.length ? json.projects.map(renderProjectCard).join('') : '<p class="text-muted">Sem projectos defendidos.</p>';
        return;
    }
    // fallback: try localStorage.mockProjects
    const mock = JSON.parse(localStorage.getItem('mockProjects') || '[]');
    const defended = mock.filter(p => p.defended);
    target.innerHTML = defended.length ? defended.map(renderProjectCard).join('') : '<p class="text-muted">Sem dados locais de projectos defendidos.</p>';
}

async function loadMyProjects() {
    const target = document.getElementById('myProjectsList');
    if (!target) return;
    // try to get currentUser from localStorage (demo)
    const currentUser = JSON.parse(localStorage.getItem('currentUser') || 'null');
    let userId = currentUser && currentUser.id ? currentUser.id : null;

    if (userId) {
        const json = await fetchJSON(`backend/user_projects.php?user_id=${encodeURIComponent(userId)}`);
        if (json && json.success) {
            target.innerHTML = json.projects.length ? json.projects.map(renderProjectCard).join('') : '<p class="text-muted">Não tem projectos atribuídos.</p>';
            return;
        }
    }

    // fallback: search mockProjects by email
    const mockUsers = JSON.parse(localStorage.getItem('mockUsers') || '[]');
    const mockProjects = JSON.parse(localStorage.getItem('mockProjects') || '[]');
    if (currentUser && mockProjects.length) {
        const my = mockProjects.filter(p => (p.members || []).some(m => m.email === currentUser.email));
        target.innerHTML = my.length ? my.map(renderProjectCard).join('') : '<p class="text-muted">Não encontrou projectos no modo demo.</p>';
        return;
    }

    target.innerHTML = '<p class="text-muted">Não há dados de utilizador. Entre ou registe-se para ver os seus projectos.</p>';
}

// Carregar listas ao iniciar
window.addEventListener('load', () => {
    loadMyProjects();
    loadDefendedProjects();
});

