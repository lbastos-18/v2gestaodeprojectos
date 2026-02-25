# 📚 CSS Documentation - Gestão de Projetos PAP

Bem-vindo ao Design System da aplicação Gestão de Projetos PAP!

---

## 📋 Índice de Documentos

### 🎨 Guias Principais

1. **[DESIGN-SYSTEM.md](DESIGN-SYSTEM.md)** ⭐ COMECE AQUI
   - Visão geral completa do sistema
   - Paleta de cores
   - Sistema de tipografia
   - Grid de espaçamento
   - Componentes disponíveis
   - Exemplos de uso
   - ~200 linhas

2. **[COMPONENTS.html](COMPONENTS.html)** - Demo Visual Interativa
   - Guia visual completo
   - Cores com swatches
   - Botões em todas variantes
   - Badges, alerts, badges
   - Forms exemplos
   - Cards layouts
   - Abra no navegador para ver!

3. **[IMPLEMENTATION-REPORT.md](IMPLEMENTATION-REPORT.md)** - Relatório de Implementação
   - Estatísticas completas
   - Detalhes por página
   - Métricas de qualidade
   - Timeline de implementação
   - Benefícios realizados
   - ~300 linhas

4. **[PROGRESS.md](PROGRESS.md)** - Rastreamento de Progresso
   - Status detalhado de cada ficheiro
   - Checklist de implementação
   - Próximos passos
   - Padrões implementados
   - ~200 linhas

---

## 📁 Ficheiros CSS

| Ficheiro | Linhas | Versão | Responsividade |
|----------|--------|--------|-----------------|
| [design-system.css](design-system.css) | 600+ | 1.0 | 5 breakpoints |
| [login.css](login.css) | 115 | 1.1 | ✅ Completa |
| [projects.css](projects.css) | 250+ | 1.1 | ✅ Completa |
| [add-project.css](add-project.css) | 300+ | 1.1 | ✅ Completa |
| [admindashboard.css](admindashboard.css) | 350+ | 1.1 | ✅ Completa |
| [myprofile.css](myprofile.css) | 280+ | 1.1 | ✅ Completa |
| [users.css](users.css) | 300+ | 1.1 | ✅ Completa |
| [project-details.css](project-details.css) | 280+ | 1.1 | ✅ Completa |
| **TOTAL** | **2500+** | **1.1** | **100%** |

---

## 🎯 Quick Start (30 segundos)

### 1. Incluir Design System
```html
<head>
  <!-- Inclua SEMPRE design-system.css primeiro -->
  <link rel="stylesheet" href="css/design-system.css">
  
  <!-- Depois os CSS específicos da página -->
  <link rel="stylesheet" href="css/login.css">
</head>
```

### 2. Usar Classes Semânticas
```html
<!-- Botões -->
<button class="btn btn-primary">Clique-me</button>

<!-- Cards -->
<div class="card">
  <div class="card-body">Conteúdo</div>
</div>

<!-- Forms -->
<div class="form-group">
  <label>Email</label>
  <input type="email">
</div>

<!-- Espaçamento -->
<div class="p-6 mb-8">Conteúdo com padding e margin</div>
```

### 3. Cores e Variáveis
```css
/* Usar variáveis, não hardcode */
.meu-elemento {
  color: var(--color-primary-600);      /* Azul primário */
  background: var(--color-bg);          /* Background */
  padding: var(--spacing-6);            /* 24px */
  border-radius: var(--radius-lg);      /* Large radius */
}
```

---

## 🎨 Paleta de Cores Rápida

### Cores Primárias
- **Primary (Azul):** `--color-primary-600` → #2563eb
- **Secondary (Teal):** `--color-secondary-600` → #0891b2
- **Success (Verde):** `--color-success-600` → #16a34a
- **Warning (Laranja):** `--color-warning-600` → #ea580c
- **Danger (Vermelho):** `--color-danger-600` → #dc2626

### Neutras
- **Background:** `--color-bg` → #ffffff
- **Text:** `--color-text` → #1a1a1a
- **Border:** `--color-border` → rgba(0,0,0,0.1)

---

## 📏 Espaçamento (8px Grid)

```
--spacing-1: 4px
--spacing-2: 8px   (base)
--spacing-3: 12px
--spacing-4: 16px  (padrão inputs)
--spacing-6: 24px  (padding cards)
--spacing-8: 32px  (padding sections)
```

**Uso:** `class="p-4 mb-6"` ou `style="padding: var(--spacing-4); margin-bottom: var(--spacing-6);"`

---

## 🔤 Tipografia

| Uso | Tamanho | Peso | Classe |
|-----|---------|------|--------|
| H1 (Título) | 36px | 800 | `--font-size-4xl` |
| H2 (Subtítulo) | 30px | 700 | `--font-size-3xl` |
| H3 | 24px | 700 | `--font-size-2xl` |
| Padrão | 16px | 400 | `--font-size-base` |
| Small | 14px | 400 | `--font-size-sm` |

---

## 🔘 Componentes Chave

### Botões
```html
<button class="btn btn-primary">Primary</button>
<button class="btn btn-secondary">Secondary</button>
<button class="btn btn-success">Success</button>
<button class="btn btn-danger">Danger</button>
<button class="btn btn-outline">Outline</button>
<button class="btn btn-ghost">Ghost</button>
```

### Cards
```html
<div class="card">
  <div class="card-header"><h3>Título</h3></div>
  <div class="card-body">Conteúdo aqui</div>
  <div class="card-footer"><button class="btn btn-primary">OK</button></div>
</div>
```

### Badges
```html
<span class="badge badge-primary">Badge</span>
<span class="badge badge-success">Success</span>
<span class="badge badge-danger">Danger</span>
```

### Alerts
```html
<div class="alert alert-success">✓ Sucesso!</div>
<div class="alert alert-warning">⚠️ Atenção!</div>
<div class="alert alert-danger">✕ Erro!</div>
```

---

## 📱 Responsividade

### Breakpoints Disponíveis
```css
/* Mobile first (padrão) */
.elemento { width: 100%; }

/* Tablets pequenas (640px+) */
@media (min-width: 640px) { }

/* Tablets (768px+) */
@media (min-width: 768px) { }

/* Desktop (1024px+) */
@media (min-width: 1024px) { }

/* Desktop grande (1280px+) */
@media (min-width: 1280px) { }
```

### Grid Responsivo
```html
<div style="
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: var(--spacing-6);
">
  <!-- Items ajustam automaticamente -->
</div>
```

---

## ♿ Acessibilidade

### Features Implementados
✅ Focus states visíveis (ring 3px)  
✅ Contraste mínimo WCAG AA  
✅ Font sizes legíveis (min 14px)  
✅ Line heights adequados (1.5)  
✅ Buttons touch-friendly (44px)  

### Exemplo
```html
<!-- Input com focus state automático -->
<input type="text" placeholder="Foco aqui (use TAB)">

<!-- Será visível com ring de cor primária -->
```

---

## 🚀 Deployment

### 1. Minificar CSS (Produção)
```bash
# Usar ferramentas como:
# - cssnano
# - csso
# - YUI Compressor

# Ou online: https://cssnano.co/
```

### 2. Incluir no HTML
```html
<!-- Produção -->
<link rel="stylesheet" href="css/design-system.min.css">
<link rel="stylesheet" href="css/login.min.css">
```

### 3. Caching
```html
<!-- Com versioning para cache busting -->
<link rel="stylesheet" href="css/design-system.css?v=1.0">
```

---

## 🔧 Manutenção

### Adicionar uma Nova Cor
1. Abrir [design-system.css](design-system.css)
2. Adicionar em `:root { ... }`
```css
--color-pink-600: #ec4899;
--color-pink-500: #f43f5e;
```
3. Usar em qualquer lugar: `color: var(--color-pink-600)`

### Modificar Espaçamento
1. Abrir [design-system.css](design-system.css)
2. Localizar `--spacing-X`
3. Ajustar valor (em múltiplos de 4px)
4. Todas as páginas serão atualizadas automaticamente

### Adicionar Novo Componente
1. Definir estilos em [design-system.css](design-system.css)
2. Documentar em [DESIGN-SYSTEM.md](DESIGN-SYSTEM.md)
3. Adicionar exemplo em [COMPONENTS.html](COMPONENTS.html)

---

## 📊 Estatísticas

```
Total CSS Variables:  50+
Total Components:     20+
Total Breakpoints:    5
Ficheiros CSS:        8
Linhas de CSS:        2500+
WCAG Compliance:      AA+
```

---

## 💡 Best Practices

### ✅ Fazer
```css
/* BOM: usar variáveis */
.card {
  padding: var(--spacing-6);
  border-radius: var(--radius-lg);
  color: var(--color-primary-600);
}
```

### ❌ Não Fazer
```css
/* RUIM: hardcode values */
.card {
  padding: 24px;
  border-radius: 12px;
  color: #2563eb;
}
```

---

## 🆘 Troubleshooting

### Cores não aparecem?
- [ ] Design-system.css está incluído PRIMEIRO?
- [ ] Classe correcta? (`.btn-primary` vs `.btn--primary`)
- [ ] Variável existe? (verificar design-system.css)

### Layout não responsive?
- [ ] Media queries corretas? (640px, 768px, 1024px)
- [ ] Mobile-first approach? (padrão é mobile)
- [ ] Grid/flex correto? (auto-fit minmax)

### Fonts estranhas?
- [ ] Font-family correcto? (usar `var(--font-family-base)`)
- [ ] Font size mínimo 14px?
- [ ] Line-height adequado? (min 1.5)

---

## 📞 Contacto & Suporte

**Documentação:**
- Design System Guide: [DESIGN-SYSTEM.md](DESIGN-SYSTEM.md)
- Relatório: [IMPLEMENTATION-REPORT.md](IMPLEMENTATION-REPORT.md)
- Demo Visual: [COMPONENTS.html](COMPONENTS.html)

**Versão Actual:** 1.1  
**Última Atualização:** 25 de fevereiro de 2026  
**Manutenedor:** Design System Team

---

## 📜 Licença

Este Design System é parte do projeto Gestão de Projetos PAP.
Uso interno apenas.

---

**Dicas:**
- Comece pelo [DESIGN-SYSTEM.md](DESIGN-SYSTEM.md) para aprender o sistema
- Use [COMPONENTS.html](COMPONENTS.html) para ver exemplos visuais
- Referencia [design-system.css](design-system.css) para variáveis
- Mantenha este README.md como ponto de entrada

**Happy Styling! 🎨**
