#!/usr/bin/env bash
# Installe ou met à jour la skill organisation-mail-todo pour Claude Code (macOS, Linux).
# Usage : curl -fsSL https://raw.githubusercontent.com/gkcyan/organisation-mail-todo/main/install.sh | bash

set -euo pipefail

name="organisation-mail-todo"
tar_url="https://github.com/gkcyan/$name/archive/refs/heads/main.tar.gz"
skills="$HOME/.claude/skills"
dest="$skills/$name"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Téléchargement de la skill $name..."
curl -fsSL "$tar_url" | tar -xz -C "$tmp"

source_dir="$tmp/$name-main/$name"
if [ ! -f "$source_dir/SKILL.md" ]; then
  echo "SKILL.md introuvable dans l'archive téléchargée." >&2
  exit 1
fi

mkdir -p "$skills"
if [ -e "$dest" ]; then
  # Conserve la version précédente à côté, sans rien supprimer définitivement
  # (hors du dossier skills, pour ne pas être chargée comme une seconde skill)
  mkdir -p "$HOME/.claude/skills-sauvegardes"
  backup="$HOME/.claude/skills-sauvegardes/$name-$(date +%Y%m%d-%H%M%S)"
  mv "$dest" "$backup"
  echo "Version précédente conservée dans : $backup"
fi
cp -R "$source_dir" "$dest"

echo "Skill installée dans : $dest"
echo "Relancez Claude Code, puis tapez / pour vérifier que $name apparaît."
