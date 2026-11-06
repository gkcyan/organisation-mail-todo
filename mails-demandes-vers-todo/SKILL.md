---
name: mails-demandes-vers-todo
description: Transforme les mails Outlook (Microsoft 365) contenant une demande en tâches Microsoft To Do, rangées dans des listes par thème et triées par date de réception. Met en place les listes To Do, un flux Power Automate (nouveau mail → tâche avec lien vers le mail et échéance = réception + 1 jour), le marquage des mails récents et le tri des listes. À utiliser dès que l'utilisateur demande de créer des tâches To Do à partir de ses mails, de suivre les demandes reçues par mail, d'organiser To Do comme sa messagerie, ou de créer/modifier/tester le flux « Mails avec demande vers To Do ».
metadata:
  author: Yannick GOUEDE
  version: "1.0"
---

# Mails avec demande → tâches Microsoft To Do

Auteur : Yannick GOUEDE

Cette skill met en place, pour un compte professionnel Microsoft 365, un suivi des demandes reçues par mail dans Microsoft To Do :

1. des listes To Do calquées sur les dossiers thématiques de la messagerie ;
2. un flux Power Automate qui crée une tâche pour chaque nouveau mail « demande » ;
3. un rattrapage des mails récents par drapeau (indicateur) ;
4. un tri de chaque liste par date de réception, la plus récente en haut.

Tout se fait par le web, dans le navigateur de l'utilisateur (extension Claude in Chrome ou équivalent) :

- Outlook : https://outlook.cloud.microsoft/mail/
- To Do : https://to-do.office.com/tasks/
- Power Automate : https://make.powerautomate.com/

## Règles à respecter

- Travailler dans un onglet séparé, ne pas toucher aux onglets de l'utilisateur, fermer l'onglet à la fin.
- Ne jamais saisir de mot de passe. Si la session a expiré, demander à l'utilisateur de se reconnecter.
- Ne rien supprimer définitivement (mails, tâches, listes). Pour « vider » : retirer l'indicateur d'un mail ou marquer la tâche terminée ; laisser l'utilisateur supprimer lui-même.
- Demander l'accord avant d'envoyer un mail (y compris un mail de test à soi-même), de créer une connexion ou d'accorder une autorisation.
- Dire clairement ce qui a été vérifié et ce qui ne l'a pas été.

## Étape 0 — Recueillir les paramètres

Demander ou déduire de la messagerie :

| Paramètre | Exemple |
|---|---|
| Adresse du compte | prenom.nom@entreprise.com |
| Thèmes (= listes To Do) | 01 Carburant, 04 Véhicules et engins, 06 Achats… |
| Mots-clés par thème (cherchés dans l'objet, en minuscules) | carburant, gasoil / panne, engin / facture, devis… |
| Mots déclencheurs d'une « demande » | demande, besoin, urgent, relance, rappel, validation |
| Période de rattrapage | 30 derniers jours |
| Décalage d'échéance | réception + 1 jour |

Si la messagerie a déjà des dossiers thématiques, reprendre leurs noms pour les listes. Pour les mots-clés avec accent, utiliser un fragment sans accent (`hicule` pour véhicule, `cong` pour congé).

## Étape 1 — Créer les listes To Do

Dans To Do, « Nouvelle liste » pour chaque thème. Les listes s'affichent dans l'ordre de création : créer de la première à la dernière pour un affichage croissant. Ne pas toucher aux listes existantes de l'utilisateur.

## Étape 2 — Créer le flux Power Automate

Flux de cloud automatisé, nommé « Mails avec demande vers To Do ».

**Déclencheur** : Office 365 Outlook « À l'arrivée d'un nouvel e-mail (V3) », dossier Boîte de réception, champ « À » = adresse du compte. Dans l'onglet Configuration, ajouter une condition de déclenchement (adapter les mots) :

```
@or(contains(toLower(triggerBody()?['subject']),'demande'),contains(toLower(triggerBody()?['subject']),'besoin'),contains(toLower(triggerBody()?['subject']),'urgent'),contains(toLower(triggerBody()?['subject']),'relance'),contains(toLower(triggerBody()?['subject']),'rappel'),contains(toLower(triggerBody()?['subject']),'validation'))
```

**Action** : Microsoft To-Do (usage professionnel) « Ajouter une tâche (V3) ».

- **Titre** : `Mail : ` + contenu dynamique Objet.
- **Date d'échéance** (expression) : `addDays(triggerBody()?['receivedDateTime'],1)`
- **Corps** : `Demande reçue par mail de : ` + contenu dynamique De, suivi de l'expression :

```
concat(' - Recu le ', formatDateTime(triggerBody()?['receivedDateTime'],'dd/MM/yyyy HH:mm'), ' - Ouvrir le mail : https://outlook.office365.com/owa/?ItemID=', encodeUriComponent(triggerBody()?['id']), '&exvsurl=1&viewmodel=ReadMessageItem')
```

L'heure est en UTC ; ajouter `convertFromUtc(…, '<fuseau>')` si le fuseau de l'utilisateur n'est pas UTC.

- **Liste de tâches** : routage par thème avec une expression.
  1. Relever l'identifiant de chaque liste : la choisir dans le menu déroulant, lire `folderId` dans l'onglet « Vue Code », noter, recommencer. Les identifiants partagent un long préfixe commun ; seuls les derniers caractères changent.
  2. Remplacer la valeur par une expression de cette forme (un `if` imbriqué par thème, la liste par défaut « Tâches » en dernier) :

```
concat('<PREFIXE_COMMUN>', if(or(contains(toLower(triggerBody()?['subject']),'carburant'),contains(toLower(triggerBody()?['subject']),'gasoil')),'<SUFFIXE_LISTE_1>', if(or(contains(toLower(triggerBody()?['subject']),'panne'),contains(toLower(triggerBody()?['subject']),'engin')),'<SUFFIXE_LISTE_2>','<SUFFIXE_LISTE_PAR_DEFAUT>')))
```

Enregistrer, puis vérifier en Vue Code que `folderId`, `body/title`, `body/dueDateTime/dateTime` et `body/body/content` contiennent bien les expressions.

### Astuces du nouveau concepteur

- Dans un champ, taper `/` ou cliquer le bouton `fx` pour insérer un contenu dynamique ou une expression.
- L'éditeur d'expression (Monaco) ferme automatiquement parenthèses et guillemets : ne pas taper une longue expression au clavier. Cliquer dans l'éditeur puis insérer le texte d'un bloc avec `document.execCommand('insertText', false, expr)`.
- Après cette insertion, « Ajouter » répond souvent « L'expression n'est pas valide ». Cliquer dans l'éditeur, aller à la fin (Ctrl+Fin), taper une espace puis Retour arrière au clavier réel, attendre deux secondes, recliquer « Ajouter ».
- Après l'ouverture du flux, attendre le chargement complet avant de cliquer sur une action.

## Étape 3 — Rattraper les mails récents

1. Dans Outlook, repérer les mails de la période qui contiennent une vraie demande adressée à l'utilisateur. Exclure les mails en copie, déjà traités, les notifications et les convocations. Annoncer les limites du repérage (onglet « Autres », mails jugés sur l'aperçu…).
2. Poser un drapeau sur chacun : il apparaît dans To Do, liste « Courrier avec indicateur ».
3. Dans To Do (vue Liste, pas Grille), déplacer chaque tâche vers sa liste thématique : clic droit réel sur la tâche → « Déplacer la tâche vers… » → nom de la liste.

### Astuces Outlook web

- Avant de taper dans la barre de recherche, vérifier que `document.activeElement` est bien le champ de recherche (cliquer deux fois si besoin). Sinon la frappe déclenche des raccourcis clavier.
- Recherches utiles : `isflagged:true`, `subject:"…"`, portée « Tous les dossiers ».
- Lignes de la liste : `[role=option][data-convid]`. Le bouton drapeau de chaque ligne a pour titre « Marquer ce message d'un indicateur » ou « Supprimer l'indicateur de ce message » et se clique par JavaScript.
- La liste est virtualisée : faire défiler le conteneur pour charger toutes les lignes ; découper les traitements en petits lots (les scripts longs expirent).

## Étape 4 — Trier par date de réception

To Do n'a pas de champ « date de réception », et une tâche issue d'un mail marqué garde comme date de création le jour du premier marquage (retirer puis reposer l'indicateur restaure la même tâche, dans la même liste, avec la même date). Le tri par date de création est donc faux pour les mails marqués. La solution retenue : **échéance = date de réception + 1 jour**, et tri sur l'échéance.

Prévenir l'utilisateur des contreparties avant d'appliquer : les tâches anciennes s'affichent « en retard » en rouge, apparaissent dans « Planifié », et l'échéance ne sert plus de vrai délai.

1. Relever la date de réception de chaque mail marqué (recherche `isflagged:true` dans Outlook).
2. Poser l'échéance sur chaque tâche existante (voir ci-dessous).
3. Dans chaque liste : « Trier » → « Date d'échéance », puis cliquer la flèche « Inverser l'ordre de tri » à gauche de « Trié par date d'échéance » pour avoir la plus récente en haut. Vérifier l'ordre obtenu.

### Poser une échéance passée dans To Do web

Le calendrier de To Do web désactive les dates passées, mais le service les accepte. Méthode :

1. Ouvrir le détail de la tâche (clic réel, ou séquence d'événements `pointerdown`, `mousedown`, `pointerup`, `mouseup`, `click` sur `.taskItem-titleWrapper`).
2. Dans le panneau de détail, cliquer `button.section-innerClick` dont le texte est « Ajouter une date d'échéance », puis l'élément de menu « Choisir une date ».
3. Passer la date directement au composant calendrier, puis enregistrer :

```js
const g = document.querySelector('[role=grid]');
const k = Object.keys(g).find(k => k.startsWith('__reactFiber'));
let f = g[k];
while (f && !(f.type && f.type.displayName == 'CalendarBase')) f = f.return;
f.memoizedProps.onSelectDate(new Date(annee, mois - 1, jour));
// puis cliquer le bouton « Enregistrer »
```

4. Vérifier que la ligne de la tâche affiche la date voulue.

Attention : le bouton calendrier de la barre « Ajoutez une tâche » porte le même libellé ; ne viser que celui du panneau de détail.

## Étape 5 — Tester

Avec l'accord de l'utilisateur, envoyer depuis Outlook web un mail à sa propre adresse (seul destinataire), objet contenant un mot déclencheur et un mot-clé de thème, par exemple « Demande de carburant - test du flux ». Attendre une à deux minutes, puis vérifier dans To Do : tâche dans la bonne liste, échéance au lendemain, note avec expéditeur, date et lien. Signaler que le mail et la tâche de test restent à enlever par l'utilisateur, et que seuls les thèmes testés sont confirmés.

## Limites à annoncer

- Le flux ne lit que l'objet du mail, pas le corps.
- Un mail déplacé par une règle Outlook avant d'atteindre la boîte de réception peut ne pas déclencher le flux.
- Chaque réponse « RE: Demande… » crée une nouvelle tâche.
- Deux mails reçus le même jour ont la même échéance : leur ordre entre eux n'est pas garanti.
- Un mail marqué à la main par la suite n'a pas d'échéance automatique : il faut lui en donner une pour qu'il prenne sa place dans le tri.

## Compte rendu final

Donner : le nom du flux et ce qu'il fait, les listes créées et leur contenu, le nombre de mails marqués, le réglage de tri, ce qui a été vérifié ou non, et les traces laissées (mail de test, tâche de test).
