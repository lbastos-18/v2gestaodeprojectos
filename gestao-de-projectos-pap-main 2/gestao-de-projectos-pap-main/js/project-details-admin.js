// project-details-admin.js
// Gerencia a página de detalhes do projeto no painel admin

document.addEventListener('DOMContentLoaded', function() {
  // Get project ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  const projectId = urlParams.get('id') || '1';

  // Dados de exemplo - Em produção, estes dados viriam da API
  const projects = {
    '1': {
      id: 1,
      title: 'Sistema de Gestão de Projectos Académicos',
      subtitle: 'Projeto académico de fim de curso',
      course: 'Informática',
      type: 'Programação',
      year: 2025,
      advisor: 'Prof. João Silva',
      createdDate: '25 de Fevereiro de 2025',
      defenseDate: '20 de Março de 2025',
      memberCount: 4,
      rating: 18,
      summary: 'Este projeto consiste no desenvolvimento de uma aplicação web destinada ao gerenciamento de projetos académicos, com o objetivo de facilitar a organização, acompanhamento e consulta dos trabalhos de fim de curso. A aplicação permite que alunos, professores e gestores académicos tenham acesso centralizado às informações dos projetos defendidos.',
      description: 'A aplicação foi desenvolvida utilizando tecnologias web modernas, permitindo que alunos, professores e gestores académicos tenham acesso centralizado às informações dos projetos defendidos. O sistema contribui para a melhoria da gestão académica, organização institucional e preservação dos trabalhos científicos.',
      objectives: [
        'Desenvolver uma plataforma web intuitiva e responsiva',
        'Implementar sistema de autenticação e autorização',
        'Criar painel de controlo para gestão de projetos',
        'Permitir visualização e filtragem de projetos',
        'Gerar relatórios e estatísticas'
      ],
      duration: '3 meses',
      workHours: '120 h',
      languages: 'PHP, JavaScript, HTML/CSS',
      database: 'MySQL',
      members: [
        { name: 'Lukeny Bastos', email: 'lukeny.bastos@example.pt', number: '12345', role: 'Backend' },
        { name: 'Belmiro Damião', email: 'belmiro.damiao@example.pt', number: '12346', role: 'Frontend' },
        { name: 'Epandi Andrade', email: 'epandi.andrade@example.pt', number: '12347', role: 'Base de Dados' },
        { name: 'José André Suende', email: 'jose.suende@example.pt', number: '12348', role: 'Documentação' }
      ],
      status: 'Completo',
      files: [
        { name: 'Relatório Final', type: 'pdf', size: '2.5 MB', date: '25 fev 2025' },
        { name: 'Código Fonte', type: 'zip', size: '5.2 MB', date: '25 fev 2025' },
        { name: 'Apresentação', type: 'pptx', size: '3.1 MB', date: '25 fev 2025' },
        { name: 'Screenshots', type: 'zip', size: '8.7 MB', date: '25 fev 2025' }
      ]
    },
    '2': {
      id: 2,
      title: 'Rede Corporativa TCP/IP',
      subtitle: 'Projeto de infraestrutura de rede',
      course: 'Informática',
      type: 'Redes',
      year: 2025,
      advisor: 'Eng. Paulo Costa',
      createdDate: '10 de Fevereiro de 2025',
      defenseDate: '15 de Abril de 2025',
      memberCount: 2,
      rating: 16,
      summary: 'Projeto focado no design e implementação de uma rede corporativa utilizando protocolo TCP/IP.',
      description: 'Este projeto envolve a análise, design e implementação de uma infraestrutura de rede robusta.',
      objectives: [
        'Desenhar arquitetura de rede TCP/IP',
        'Implementar VLAN e segurança',
        'Documentar topologia e configurações',
        'Testar e validar desempenho'
      ],
      duration: '4 meses',
      workHours: '160 h',
      languages: 'Network Protocols, Cisco IOS',
      database: 'N/A',
      members: [
        { name: 'João Pedro Silva', email: 'joao.silva@example.pt', number: '12349', role: 'Network Design' },
        { name: 'Carlos Oliveira', email: 'carlos.oliveira@example.pt', number: '12350', role: 'Implementation' }
      ],
      status: 'Em Desenvolvimento',
      files: [
        { name: 'Diagrama de Rede', type: 'pdf', size: '1.8 MB', date: '20 fev 2025' },
        { name: 'Configurações', type: 'zip', size: '2.1 MB', date: '22 fev 2025' }
      ]
    },
    '3': {
      id: 3,
      title: 'App Gestão Hotelaria',
      subtitle: 'Aplicação mobile para gestão hoteleira',
      course: 'Gestão Empresarial',
      type: 'Desenvolvimento',
      year: 2025,
      advisor: 'Dr. Manuel Rocha',
      createdDate: '05 de Janeiro de 2025',
      defenseDate: '01 de Março de 2025',
      memberCount: 4,
      rating: 19,
      summary: 'Desenvolviment de uma aplicação móvel completa para gestão de operações hoteleiras.',
      description: 'Aplicação Android e iOS para controle de reservas, ocupação e operações de hotelaria.',
      objectives: [
        'Desenvolver interface intuitiva',
        'Integrar sistema de reservas',
        'Implementar módulo financeiro',
        'Sincronização em tempo real'
      ],
      duration: '5 meses',
      workHours: '200 h',
      languages: 'Java, Kotlin, Swift',
      database: 'Firebase',
      members: [
        { name: 'Ana Silva', email: 'ana.silva@example.pt', number: '12351', role: 'Frontend Mobile' },
        { name: 'Bruno Costa', email: 'bruno.costa@example.pt', number: '12352', role: 'Backend' },
        { name: 'Diana Santos', email: 'diana.santos@example.pt', number: '12353', role: 'UI/UX Design' },
        { name: 'Eduardo Ferreira', email: 'eduardo.ferreira@example.pt', number: '12354', role: 'QA Testing' }
      ],
      status: 'Pronto para Defesa',
      files: [
        { name: 'Relatório Final', type: 'pdf', size: '3.2 MB', date: '24 fev 2025' },
        { name: 'Código Fonte', type: 'zip', size: '12.5 MB', date: '25 fev 2025' },
        { name: 'APK e IPA', type: 'zip', size: '85 MB', date: '25 fev 2025' },
        { name: 'Documentação API', type: 'pdf', size: '2.8 MB', date: '23 fev 2025' }
      ]
    }
  };

  // Get project data
  const project = projects[projectId];
  
  if (!project) {
    document.body.innerHTML = '<div class="container mt-5"><div class="alert alert-danger">Projeto não encontrado</div></div>';
    return;
  }

  // Populate header
  document.getElementById('projectTitle').textContent = project.title;
  document.getElementById('projectSubtitle').textContent = project.subtitle;
  document.getElementById('projectBreadcrumb').textContent = project.title;

  // Populate badges
  document.getElementById('courseTag').innerHTML = `<i class="bi bi-book"></i> ${project.course}`;
  document.getElementById('typeTag').innerHTML = `<i class="bi bi-tag"></i> ${project.type}`;
  document.getElementById('yearTag').innerHTML = `<i class="bi bi-calendar"></i> ${project.year}`;
  document.getElementById('statusTag').innerHTML = `<i class="bi bi-check-circle"></i> ${project.status}`;

  // Update badge style based on status
  const statusTag = document.getElementById('statusTag');
  if (project.status === 'Em Desenvolvimento') {
    statusTag.className = 'badge bg-warning';
  } else if (project.status === 'Pronto para Defesa') {
    statusTag.className = 'badge bg-info';
  } else {
    statusTag.className = 'badge bg-success';
  }

  // Populate sidebar info
  document.getElementById('course').textContent = project.course;
  document.getElementById('type').textContent = project.type;
  document.getElementById('year').textContent = project.year;
  document.getElementById('advisor').textContent = project.advisor;
  document.getElementById('createdDate').textContent = project.createdDate;
  document.getElementById('defenseDate').textContent = project.defenseDate;
  document.getElementById('memberCount').textContent = project.memberCount;
  document.getElementById('rating').textContent = project.rating;
  document.getElementById('ratingBar').style.width = (project.rating / 20 * 100) + '%';

  // Populate summary tab
  document.getElementById('summaryText').textContent = project.summary;
  
  // Update summary stats
  document.querySelectorAll('.summary-stats .stat-item').forEach((item, index) => {
    const stats = [
      { label: 'Duração do Projeto', value: project.duration },
      { label: 'Horas de Trabalho', value: project.workHours },
      { label: 'Linguagens Utilizadas', value: project.languages },
      { label: 'Base de Dados', value: project.database }
    ];
    if (index < stats.length) {
      item.querySelector('.stat-label').textContent = stats[index].label;
      item.querySelector('.stat-value').textContent = stats[index].value;
    }
  });

  // Populate members tab
  const membersList = document.getElementById('membersList');
  membersList.innerHTML = project.members.map(member => `
    <tr>
      <td>${member.name}</td>
      <td>${member.email}</td>
      <td>${member.number}</td>
      <td><span class="badge bg-primary">${member.role}</span></td>
    </tr>
  `).join('');

  // Populate description tab
  document.getElementById('descriptionText').textContent = project.description;
  const objectivesList = document.getElementById('objectives');
  objectivesList.innerHTML = project.objectives.map(obj => `<li>${obj}</li>`).join('');

  // Tech stack badges
  const techBadges = document.querySelectorAll('.tech-badge');
  const techs = project.languages.split(', ').concat(project.database);
  techBadges.forEach((badge, index) => {
    if (index < techs.length) {
      badge.textContent = techs[index];
    }
  });

  // Populate files tab
  const filesList = document.querySelector('.files-list');
  filesList.innerHTML = project.files.map(file => {
    const iconMap = {
      'pdf': 'file-earmark-pdf text-danger',
      'zip': 'file-earmark-zip text-success',
      'pptx': 'file-earmark-slide text-warning',
      'image': 'image text-info'
    };
    const icon = iconMap[file.type] || 'file-earmark';
    return `
      <div class="file-item">
        <div class="file-icon">
          <i class="bi bi-${icon}"></i>
        </div>
        <div class="file-info">
          <h4>${file.name}</h4>
          <small class="text-muted">${file.type.toUpperCase()} • ${file.size} • ${file.date}</small>
        </div>
        <div class="file-actions">
          <a href="#" class="btn btn-sm btn-outline-primary">
            <i class="bi bi-download"></i> Download
          </a>
        </div>
      </div>
    `;
  }).join('');

  // Tab switching
  document.querySelectorAll('.details-tabs .tab-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      const tabName = this.getAttribute('data-tab');
      
      document.querySelectorAll('.details-tabs .tab-btn').forEach(b => b.classList.remove('active'));
      document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
      
      this.classList.add('active');
      document.getElementById(tabName).classList.add('active');
    });
  });

  // Edit button
  document.getElementById('editBtn').addEventListener('click', function() {
    window.location.href = `edit-project.html?id=${projectId}`;
  });

  // Delete button
  document.getElementById('deleteBtn').addEventListener('click', function() {
    if (confirm('Tem a certeza que deseja eliminar este projeto?')) {
      console.log('Eliminar projeto:', projectId);
      // Implement delete via API
      // window.location.href = 'projects.html';
    }
  });

  // Sidebar toggle on mobile
  const collapseBtn = document.getElementById('collapseBtn');
  const mobileToggle = document.getElementById('mobileToggle');
  const sidebar = document.getElementById('sidebar');

  if (collapseBtn) {
    collapseBtn.addEventListener('click', function() {
      sidebar.classList.toggle('collapsed');
    });
  }

  if (mobileToggle) {
    mobileToggle.addEventListener('click', function() {
      sidebar.classList.toggle('open');
    });
  }
});
