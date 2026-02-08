#!/bin/bash

# 🚀 Script de Inicio Rápido - Solar Rosette
# Este script inicia un servidor local para desarrollo

echo "🌟 Solar Rosette - Sistema de Gestión de Citas"
echo "=============================================="
echo ""

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado"
    echo "📥 Descarga Node.js desde: https://nodejs.org"
    exit 1
fi

echo "✅ Node.js detectado: $(node --version)"
echo ""

# Verificar si http-server está instalado
if ! command -v http-server &> /dev/null; then
    echo "📦 Instalando http-server..."
    npm install -g http-server
fi

echo "🚀 Iniciando servidor local..."
echo ""
echo "📍 Abriendo en: http://localhost:8000"
echo "📂 Sirviendo desde: ./public"
echo ""
echo "💡 Presiona Ctrl+C para detener el servidor"
echo ""

# Iniciar servidor
cd public
http-server -p 8000 -o

# Nota: -o abre automáticamente el navegador
