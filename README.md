# KZ ItemEP

Addon para **WoW 1.12.1 (Vanilla)** que exibe o valor de **Equipment Points (EP)** dos itens diretamente no tooltip, com pesos de stats customizaveis por classe e spec.

Desenvolvido para o servidor **SandWorlds** (interface 11200 / build 5875).

---

## O que esta incluido

| Addon | Funcao |
|---|---|
| `KZ_BonusScanner` | Escaneia e soma os bonus dos itens equipados — **obrigatorio** |
| `KZ_ItemEP` | Exibe EP no tooltip + Hub com Comparador, Spec EP e Proc EP |

---

## Funcionalidades

### Tooltip de EP
O EP de cada item aparece automaticamente quando voce passa o mouse, calculado com base nos pesos da sua spec ativa. Para armas, exibe os valores como **MH** e **OH** separadamente.

### Hub unificado (botao do minimapa / `/kzc`)
Um unico frame com 3 abas:

| Aba | Funcao |
|---|---|
| **Comparar** | Compara dois itens lado a lado com EP por spec |
| **Spec EP** | Seleciona qual spec usar para o calculo do tooltip |
| **Proc EP** | Gerencia EP manual de procs de itens (eg. Alcor's Sunrazor) |

### Comparador de Itens
- Cada painel tem seletor de spec independente (`<` `>`)
- Exibe EP como **MH** e **OH** para armas de uma mao
- Linha de comparacao separada: `MH: A +42.05 EP` / `OH: B +33.88 EP`
- Stats coloridos: branco para dano, verde para bonus de atributo, dourado para Equip:, laranja para procs

### Proc EP
- Armazena EP manual por item (sem distincao de spec — o proc e o mesmo)
- Migra automaticamente salvas antigas no formato antigo

---

## Como usar

### Abrir o Hub
- **Clique esquerdo** no icone do minimapa → aba Comparar
- **Clique direito** no icone do minimapa → aba Proc EP
- `/kzc` ou `/kzcompare` → abre/fecha o Comparador

### Macros recomendadas
Crie duas macros com os comandos abaixo e coloque-as na sua barra de acoes:

```
/kzca
```
> Passa o mouse sobre um item e aperta a macro para capturar no **Slot A**

```
/kzcb
```
> Passa o mouse sobre um item e aperta a macro para capturar no **Slot B**

**Exemplo de uso:**
1. Passe o mouse na sua arma atual → `/kzca`
2. Passe o mouse no item do loot → `/kzcb`
3. Abra o comparador (`/kzc`) e veja qual e melhor e para qual mao

### Selecionar Spec
1. Clique no icone do minimapa (esquerdo) ou abra a aba **Spec EP**
2. Clique na sua spec → o EP do tooltip atualiza automaticamente

### Adicionar Proc EP manual
1. Passe o mouse no item com proc
2. Abra a aba **Proc EP** (clique direito no minimapa)
3. Clique em **+ Capturar item do tooltip atual**
4. Ajuste o valor com os botoes +/- e clique **Salvar**

---

## Instalacao via GitAddonsManager (Recomendado)

Baixe o **GitAddonsManager** em:
> https://woblight.gitlab.io/overview/gitaddonsmanager/

Configure a pasta do WoW e clique em **+**, colando a URL:
```
https://github.com/worldkkevin-boop/KZ_ItemEP.git
```

Ambos os addons (`KZ_BonusScanner` e `KZ_ItemEP`) serao instalados automaticamente.

---

## Instalacao Manual

1. Baixe o ZIP: **Code > Download ZIP**
2. Extraia as pastas `KZ_BonusScanner` e `KZ_ItemEP` para:
```
WoW\Interface\AddOns\
```
3. Ative ambos os addons na tela de selecao de personagem

---

## Requisitos

- World of Warcraft **1.12.1** (cliente Vanilla)
- Servidor compativel com interface **11200**
- Testado no servidor **SandWorlds**

---

## Apoie o Projeto

### PIX

**Kevin Schwanke Sousa Da Rocha**

```
00020126990014br.gov.bcb.pix0136e5c7ef8d-248d-45c1-a349-0b61f044d7b70237Cofrinho de Kevin Schwanke Sousa Da R5204000053039865802BR5925Kevin Schwanke Sousa Da R6015Laranjal do Jar61086892000062270523COFRNjc2MjA5MjkwMDAwMDg6304A421
```

### Ko-fi

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/worldkkevingmailcom)

---

## Autores

- **Kevinzinho & Antigravity** — adaptacao e manutencao para SandWorlds
- Base: crowley@headshot.de (BonusScanner) e Kylosandrax (VanillaRatingBuster)

---

## Licenca

Uso livre para fins educacionais e em servidores privados de WoW Vanilla.
