# organisation-mail-todo

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
- Google Chrome avec l'extension Claude in Chrome, connectée à votre compte Claude ;
- Claude Code installé (ou l'application Claude, voir la variante plus bas).

## Installation rapide (Claude Code)

Une seule commande télécharge la skill et la place dans le dossier des skills de Claude.

**Windows** — dans PowerShell :

```powershell
irm https://raw.githubusercontent.com/gkcyan/organisation-mail-todo/main/install.ps1 | iex
```

**macOS ou Linux** — dans un terminal :

```bash
curl -fsSL https://raw.githubusercontent.com/gkcyan/organisation-mail-todo/main/install.sh | bash
```

Ensuite, fermer puis relancer Claude Code. Pour vérifier, taper `/` : `organisation-mail-todo` doit apparaître dans la liste.

La commande installe la skill dans `.claude/skills/organisation-mail-todo` de votre dossier utilisateur. Si une version était déjà installée, elle est déplacée dans `.claude/skills-sauvegardes` avant d'être remplacée.

## Installation manuelle (Claude Code)

1. Sur cette page, cliquer sur « Code », puis « Download ZIP ».
2. Décompresser l'archive. Elle contient un dossier `organisation-mail-todo-main`, et à l'intérieur un dossier `organisation-mail-todo` avec `SKILL.md` et `parametrage-exemple.md`.
3. Copier ce dossier intérieur `organisation-mail-todo` dans le dossier des skills de Claude (créer le dossier `skills` s'il n'existe pas) :
   - Windows : `C:\Users\<nom d'utilisateur>\.claude\skills\`
   - macOS ou Linux : `~/.claude/skills/`
4. Fermer puis relancer Claude Code.
5. Vérifier : taper `/` dans Claude Code ; `organisation-mail-todo` doit apparaître dans la liste.

## Variante : application Claude (claude.ai ou bureau)

1. Récupérer le dossier `organisation-mail-todo` (étapes 1 et 2 de l'installation manuelle).
2. Le compresser en zip : le zip doit contenir le dossier, avec `SKILL.md` dedans.
3. Dans Claude, ouvrir les réglages, rubrique des skills, et importer ce zip.

## Première utilisation

1. Ouvrir Chrome et se connecter soi-même à Outlook web (https://outlook.cloud.microsoft/mail/). Claude ne saisit jamais de mot de passe.
2. Dans Claude, demander par exemple : « organise ma boîte mail et crée une tâche To Do pour chaque mail où j'ai une demande ».
3. Claude analyse la messagerie et propose une organisation.
4. Accepter, modifier ou remplacer la proposition ; le fichier `parametrage-exemple.md` sert de modèle. Rien n'est appliqué avant cet accord.
5. Claude range les mails, crée les règles, les listes To Do et le flux Power Automate, en demandant l'accord pour chaque action sensible (création de règle, de flux, envoi d'un mail de test).

## Mise à jour

Relancer la commande d'installation rapide (ou refaire l'installation manuelle en remplaçant le dossier), puis relancer Claude Code.

## Limites

- les règles et le flux ne lisent que l'objet et l'expéditeur, pas le corps du mail ;
- un mail déplacé par une règle Outlook avant la boîte de réception peut ne pas créer de tâche ;
- deux mails reçus le même jour ont la même échéance ;
- les tâches anciennes s'affichent « en retard », puisque l'échéance sert de date de réception.

## Licence

Licence MIT — voir le fichier [LICENSE](LICENSE). Copyright (c) 2026 Yannick GOUEDE.
