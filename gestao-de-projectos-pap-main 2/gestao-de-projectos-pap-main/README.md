# 📚 Gestão de Projectos PAP

Sistema web para gestão de projectos escolares.

## 🚀 Setup Rápido

### 1. Criar Base de Dados
```bash
mysql -u root -p < backend/schema.sql
```

### 2. Configurar Credenciais
Edite `.env` com as suas credenciais MySQL:
```
DB_HOST=127.0.0.1
DB_USER=root
DB_PASS=sua_password
DB_NAME=gestao_projects
```

### 3. Criar Admin
```bash
php backend/create_admin.php
```

Isto criará um admin com:
- **Email:** admin@projectos.pt
- **Password:** Admin@123

### 4. Iniciar Servidor
```bash
php -S localhost:8000
```

Aceda a http://localhost:8000 e mude a password em **Settings → Security**

## 📖 Estrutura

```
├── index.html              # Página inicial
├── login.html              # Login
├── register.html           # Registro
├── projects.html           # Projectos
├── admindashboard.html     # Admin
├── reports.html            # Relatórios
├── settings.html           # Configurações
│
├── backend/                # APIs PHP
├── css/                    # Estilos
└── js/                     # Scripts
```

## ✨ Funcionalidades

- ✅ Autenticação com CSRF
- ✅ Roles (admin, student, advisor)
- ✅ CRUD de projectos
- ✅ Dashboard admin
- ✅ Relatórios
- ✅ Responsivo

## ⚙️ Requisitos

- PHP 7.4+
- MySQL 5.7+
