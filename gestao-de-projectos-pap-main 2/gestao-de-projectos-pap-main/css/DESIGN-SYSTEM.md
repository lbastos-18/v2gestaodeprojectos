# 🎨 Design System - Gestão de Projetos PAP

## Overview

Um sistema de design profissional, unificado e responsivo que garante consistência visual em toda a aplicação.

---

## 📦 Ficheiro Principal

`css/design-system.css` - Contém:
- ✅ Paleta de cores professional (8 escalas de cores)
- ✅ Sistema de tipografia consistente
- ✅ Espaçamento baseado em 8px (8pt grid)
- ✅ Componentes base (buttons, cards, inputs, etc)
- ✅ Breakpoints responsivos (Mobile-first)
- ✅ Sombras, border-radius, transições

---

## 🎨 Paleta de Cores

### Cores Primárias

```css
--brand-600: #2563eb   /* Primary Button, Links, Highlights */
--brand-500: #3b82f6   /* Hover states */
--brand-400: #60a5fa   /* Light backgrounds */
--brand-100: #dbeafe   /* Very light backgrounds */
```

### Cores Funcionais

| Cor | Uso | CSS Variable |
|-----|-----|------|
| 🟢 Verde | Success, Approved | `--color-success` |
| 🟡 Amarelo | Warning, Pending | `--color-warning` |
| 🔴 Vermelho | Danger, Error | `--color-danger` |
| 🔵 Azul | Info, Secondary | `--color-secondary` |

### Cores Neutras

| Cor | Uso | CSS Variable |
|-----|-----|------|
| Branco | Background principal | `--color-bg` |
| Cinza claro | Background secundário | `--color-bg-secondary` |
| Cinza escuro | Texto principal | `--color-text` |
| Cinza médio | Texto secundário | `--color-text-secondary` |

---

## 🔤 Tipografia

### Tamanhos

```
--font-size-xs:    12px   (pequeño)
--font-size-sm:    14px   (small)
--font-size-base:  16px   (padrão)
--font-size-lg:    18px
--font-size-xl:    20px
--font-size-2xl:   24px
--font-size-3xl:   30px
--font-size-4xl:   36px   (h1)
```

### Pesos

```
400 - normal (paragraph text)
500 - medium (labels)
600 - semibold (subheadings)
700 - bold (headings)
800 - extrabold (large headings)
```

### Exemplo de Uso

```html
<h1>Título Principal</h1>          <!-- 36px, bold -->
<h2>Subtítulo</h2>                  <!-- 30px, bold -->
<p>Texto descritivo</p>             <!-- 16px, gray -->
<small>Texto pequeno</small>        <!-- 14px -->

<!-- Utilitários -->
<p class="text-primary">Texto azul</p>
<p class="text-muted">Texto cinzento</p>
<span class="font-semibold">Bold</span>
```

---

## 📏 Espaçamento (8px Grid)

```
--spacing-1: 4px      (.m-1, .p-1)
--spacing-2: 8px      (.m-2, .p-2)
--spacing-3: 12px     (.m-3, .p-3)
--spacing-4: 16px     (.m-4, .p-4)
--spacing-6: 24px     (.m-6, .p-6)
--spacing-8: 32px     (.m-8, .p-8)
--spacing-12: 48px
--spacing-16: 64px
```

### Exemplo

```html
<div class="p-4 mb-6">
  <h2 class="mb-3">Título</h2>
  <p class="mb-4">Descrição com espaço</p>
</div>
```

---

## 🔘 Componentes

### Botões

```html
<!-- Primary (Blue) -->
<button class="btn btn-primary">Enviar</button>

<!-- Secondary (Teal) -->
<button class="btn btn-secondary">Ação secundária</button>

<!-- Success (Green) -->
<button class="btn btn-success">Salvar</button>

<!-- Danger (Red) -->
<button class="btn btn-danger">Deletar</button>

<!-- Outline -->
<button class="btn btn-outline">Cancelar</button>

<!-- Ghost (Transparent) -->
<button class="btn btn-ghost">Voltar</button>

<!-- Tamanhos -->
<button class="btn btn-sm">Pequeno</button>
<button class="btn btn-primary">Padrão</button>
<button class="btn btn-lg">Grande</button>

<!-- Desabilitado -->
<button class="btn btn-primary" disabled>Enviar</button>
```

### Cards

```html
<div class="card">
  <div class="card-header">
    <h3>Título do Card</h3>
  </div>
  <div class="card-body">
    <p>Conteúdo principal</p>
  </div>
  <div class="card-footer">
    <button class="btn btn-primary">Ação</button>
  </div>
</div>

<!-- Sem header/footer -->
<div class="card">
  <p>Conteúdo simples</p>
</div>
```

### Inputs

```html
<div class="form-group">
  <label for="email">Email</label>
  <input type="email" id="email" placeholder="seu@email.com">
</div>

<div class="form-group">
  <label for="message">Mensagem</label>
  <textarea id="message" placeholder="Escreva aqui..."></textarea>
</div>

<div class="form-group">
  <label for="country">País</label>
  <select id="country">
    <option>Portugal</option>
    <option>Brasil</option>
  </select>
</div>
```

### Badges

```html
<span class="badge badge-primary">Novo</span>
<span class="badge badge-success">Completo</span>
<span class="badge badge-warning">Pendente</span>
<span class="badge badge-danger">Erro</span>
```

### Alerts

```html
<div class="alert alert-success">
  ✓ Projeto criado com sucesso!
</div>

<div class="alert alert-warning">
  ⚠️ Verifique os dados antes de prosseguir
</div>

<div class="alert alert-danger">
  ✕ Erro ao processar o pedido
</div>

<div class="alert alert-info">
  ℹ️ Informação importante
</div>
```

---

## 📱 Responsividade

### Breakpoints

```css
640px   - Tablets pequenos
768px   - Tablets
1024px  - Desktop
1280px  - Desktop grande
1536px  - Desktop extra grande
```

### Exemplo com Grid

```html
<div class="grid grid-cols-4">
  <div>Item 1</div>
  <div>Item 2</div>
  <div>Item 3</div>
  <div>Item 4</div>
</div>

<!-- Responsivo: 4 colunas (desktop) → 2 (tablet) → 1 (mobile) -->
```

### Media Queries

```css
/* Mobile-first (padrão) */
.elemento { width: 100%; }

/* Em tablets */
@media (min-width: 768px) {
  .elemento { width: 50%; }
}

/* Em desktop */
@media (min-width: 1024px) {
  .elemento { width: 25%; }
}
```

### Helper Classes

```html
<!-- Esconder em mobile -->
<div class="hidden-mobile">Visível apenas em desktop</div>

<!-- Esconder em desktop -->
<div class="hidden-desktop">Visível apenas em mobile</div>
```

---

## 🔄 Usar Design System

### 1. Incluir no HTML

```html
<!DOCTYPE html>
<html>
<head>
  <!-- Design System (inclua ANTES de outros CSS) -->
  <link rel="stylesheet" href="css/design-system.css">
  
  <!-- Outros CSS específicos da página -->
  <link rel="stylesheet" href="css/login.css">
  <link rel="stylesheet" href="css/projects.css">
</head>
<body>
  <!-- Seu conteúdo -->
</body>
</html>
```

### 2. Usar Classes Utilitárias

```html
<!-- Espaçamento -->
<div class="p-6 mb-4">Conteúdo com padding e margin-bottom</div>

<!-- Cores de texto -->
<p class="text-primary">Texto em azul</p>
<p class="text-muted">Texto em cinzento</p>

<!-- Tipografia -->
<h2 class="font-bold text-2xl">Título grande</h2>

<!-- Layout -->
<div class="flex gap-4">
  <button class="btn btn-primary">Salvar</button>
  <button class="btn btn-ghost">Cancelar</button>
</div>
```

### 3. Sobrescrever Cores (se necessário)

```html
<!-- Usar CSS custom properties -->
<style>
  :root {
    --color-primary: #ec4899; /* Pink ao invés de Blue */
  }
</style>
```

---

## ✅ Checklist de Implementação

Para cada página HTML:

- [ ] `design-system.css` incluído no `<head>`
- [ ] Usar classes semânticas (`.btn-primary`, `.card`, etc)
- [ ] Espaçamento com classes utilitárias (`.p-4`, `.mb-6`)
- [ ] Cores via variáveis CSS (not hardcoded)
- [ ] Responsividade testada em mobile/tablet/desktop
- [ ] Sem conflitos com CSS antigos

---

## 🎯 Benefícios

✅ **Consistência Visual** - Cores, espaçamento, tipografia uniformes  
✅ **Manutenção Fácil** - Alterar cores/espaçamento em um lugar  
✅ **Responsividade** - Mobile-first, testa em todos os tamanhos  
✅ **Profissionalismo** - Design moderno e clean  
✅ **Acessibilidade** - Contraste adequado, tamanhos legíveis  
✅ **Performance** - Sem imports desnecessários  

---

## 📊 Exemplo Completo

```html
<!DOCTYPE html>
<html lang="pt-PT">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Página Exemplo</title>
  
  <!-- Design System -->
  <link rel="stylesheet" href="css/design-system.css">
</head>
<body>
  <div class="container py-12">
    <!-- Cabeçalho -->
    <h1 class="mb-6">Bem-vindo ao Projecto</h1>
    <p class="text-lg text-secondary mb-12">
      Uma plataforma profissional para gestão de projetos
    </p>

    <!-- Grid de cards -->
    <div class="grid grid-cols-3 gap-6">
      <!-- Card 1 -->
      <div class="card">
        <div class="card-header">
          <h3>Projetos</h3>
        </div>
        <div class="card-body">
          <p class="mb-4">Gerencie seus projetos facilmente</p>
          <button class="btn btn-primary">Ver Projetos</button>
        </div>
      </div>

      <!-- Card 2 -->
      <div class="card">
        <div class="card-header">
          <h3>Utilizadores</h3>
        </div>
        <div class="card-body">
          <p class="mb-4">Gerencie membros da equipa</p>
          <button class="btn btn-primary">Ver Utilizadores</button>
        </div>
      </div>

      <!-- Card 3 -->
      <div class="card">
        <div class="card-header">
          <h3>Relatórios</h3>
        </div>
        <div class="card-body">
          <p class="mb-4">Veja estatísticas e progress</p>
          <button class="btn btn-primary">Ver Relatórios</button>
        </div>
      </div>
    </div>

    <!-- Form exemplo -->
    <div class="card mt-12">
      <div class="card-header">
        <h2>Novo Projeto</h2>
      </div>
      <div class="card-body">
        <form class="grid grid-cols-2 gap-6">
          <div class="form-group">
            <label for="name">Nome do Projeto</label>
            <input type="text" id="name" placeholder="Ex: Portal de Vendas">
          </div>

          <div class="form-group">
            <label for="year">Ano</label>
            <input type="number" id="year" placeholder="2024">
          </div>

          <div class="form-group col-span-2">
            <label for="desc">Descrição</label>
            <textarea id="desc" placeholder="Descreva o projeto..."></textarea>
          </div>

          <div class="flex gap-3 col-span-2">
            <button type="submit" class="btn btn-primary">Criar Projeto</button>
            <button type="reset" class="btn btn-ghost">Limpar</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</body>
</html>
```

---

## 🔧 Temas (Extensão Futura)

Para adicionar modo escuro:

```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: #1a1a1a;
    --color-text: #ffffff;
    --color-border: #333333;
    /* ... etc ... */
  }
}
```

---

## 📚 Referências

- [Tailwind CSS](https://tailwindcss.com/) - Inspiração para class utilities
- [Material Design](https://material.io/) - Paleta de cores
- [8pt Grid System](https://spec.fm/specifics/8-pt-grid) - Espaçamento
- [WCAG Contrast](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) - Acessibilidade

---

**Versão:** 1.0  
**Última atualização:** 25 de fevereiro de 2026  
**Status:** ✅ Pronto para usar
