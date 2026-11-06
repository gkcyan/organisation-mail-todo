# mails-demandes-vers-todo

Skill pour Claude qui organise une messagerie Outlook (Microsoft 365) et la relie à Microsoft To Do, à partir d'un paramétrage choisi par l'utilisateur.

Auteur : Yannick GOUEDE

## Ce que fait la skill

1. **Connexion à la messagerie** Outlook web (vous vous connectez vous-même, aucun mot de passe n'est saisi par Claude).
2. **Analyse** des mails et **proposition d'organisation** : dossiers par thème, sous-dossiers, critères.
3. **Paramétrage à votre choix** : vous acceptez, modifiez ou remplacez la proposition (modèle dans `parametrage-exemple.md`). Rien n'est appliqué avant votre accord.
4. **Rangement** des mails existants et **règles automatiques** Outlook pour les suivants.
5. **Connexion à To Do**, création des listes et d'un flux Power Automate : chaque nouveau mail « demande » devient une tâche, avec lien vers le mail et échéance.
6. **Rangement et tri automatiques des tâches** par liste et par date de réception.

Vous pouvez ne demander qu'une partie (seulement la messagerie, ou seulement To Do).

## Prérequis

- un compte professionnel Microsoft 365 avec Outlook, To Do et Power Automate ;
- Claude avec un accès au navigateur (extension Claude in Chrome).

## Installation

**Claude Code** : copier le dossier `mails-demandes-vers-todo` (celui qui contient `SKILL.md`) dans le dossier `.claude/skills` de votre dossier utilisateur, puis relancer Claude Code.

```
git clone https://github.com/gkcyan/mails-demandes-vers-todo.git
```

Sous Windows (PowerShell) :

```
Copy-Item -Recurse mails-demandes-vers-todo\mails-demandes-vers-todo "$env:USERPROFILE\.claude\skills\"
```

Sous macOS ou Linux :

```
cp -r mails-demandes-vers-todo/mails-demandes-vers-todo ~/.claude/skills/
```

**Application Claude** : compresser le dossier `mails-demandes-vers-todo` en zip et l'importer dans les réglages, rubrique des skills.

## Utilisation

Demander par exemple : « organise ma boîte mail et crée une tâche To Do pour chaque mail où j'ai une demande ». Claude analyse la messagerie, vous propose une organisation, puis applique le paramétrage que vous validez.

## Limites

- les règles et le flux ne lisent que l'objet et l'expéditeur, pas le corps du mail ;
- un mail déplacé par une règle Outlook avant la boîte de réception peut ne pas créer de tâche ;
- deux mails reçus le même jour ont la même échéance ;
- les tâches anciennes s'affichent « en retard », puisque l'échéance sert de date de réception.
