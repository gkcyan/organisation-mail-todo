# mails-demandes-vers-todo

Skill pour Claude qui transforme les mails Outlook (Microsoft 365) contenant une demande en tâches Microsoft To Do, rangées par thème et triées par date de réception.

Auteur : Yannick GOUEDE

## Ce que fait la skill

- crée dans To Do une liste par thème, calquée sur les dossiers de la messagerie ;
- crée un flux Power Automate : chaque nouveau mail « demande » devient une tâche, rangée dans la bonne liste, avec un lien vers le mail et une échéance égale à la date de réception + 1 jour ;
- rattrape les mails récents en les marquant d'un indicateur ;
- trie chaque liste de la tâche la plus récente à la plus ancienne.

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

Demander par exemple : « crée une tâche To Do pour chaque mail où j'ai une demande ». Claude recueille vos thèmes et mots-clés, puis met en place les listes, le flux et le tri.

## Limites

- le flux ne lit que l'objet du mail, pas le corps ;
- un mail déplacé par une règle Outlook avant la boîte de réception peut ne pas créer de tâche ;
- deux mails reçus le même jour ont la même échéance ;
- les tâches anciennes s'affichent « en retard », puisque l'échéance sert de date de réception.
