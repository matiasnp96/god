#!/bin/bash
# Configuración para usar un proxy SOCKS5 externo en Ubuntu

# Actualizar el sistema
apt-get update && apt-get upgrade -y

# Crear directorio para la configuración del proxy
mkdir -p /etc/proxy-config

# Guardar las credenciales del proxy
cat > /etc/proxy-config/proxy-credentials.conf << 'EOL'
# Configuración del proxy SOCKS5 externo
PROXY_URL="socks5h://user-nashe1337-country-ar:6_0QkksTV0dr0iEgaq@gate.decodo.com:7000"
PROXY_HOST="gate.decodo.com"
PROXY_PORT="7000"
PROXY_USER="user-nashe1337-country-ar"
PROXY_PASSWORD="6_0QkksTV0dr0iEgaq"
EOL

# Configurar permisos
chmod 600 /etc/proxy-config/proxy-credentials.conf
chown root:root /etc/proxy-config/proxy-credentials.conf

# Crear script para verificar el proxy
cat > /usr/local/bin/check-proxy << 'EOL'
#!/bin/bash
source /etc/proxy-config/proxy-credentials.conf
echo "Verificando conexión al proxy SOCKS5..."
echo "Proxy URL: $PROXY_URL"
curl --socks5 "$PROXY_HOST:$PROXY_PORT" -U "$PROXY_USER:$PROXY_PASSWORD" https://api.ipify.org
echo ""
EOL

# Darle permisos de ejecución al script
chmod +x /usr/local/bin/check-proxy

# Instalar curl si no está instalado
if ! command -v curl &> /dev/null; then
    apt-get install -y curl
fi

# Crear configuración global para aplicaciones que soporten variables de entorno
cat > /etc/profile.d/proxy.sh << 'EOL'
# Configuración global de proxy SOCKS5
source /etc/proxy-config/proxy-credentials.conf
export ALL_PROXY="$PROXY_URL"
export SOCKS_PROXY="$PROXY_URL"
export SOCKS5_PROXY="$PROXY_URL"
EOL

# Darle permisos al archivo
chmod +x /etc/profile.d/proxy.sh

# Crear una configuración para systemd
mkdir -p /etc/systemd/system.conf.d/
cat > /etc/systemd/system.conf.d/proxy.conf << 'EOL'
[Manager]
DefaultEnvironment="ALL_PROXY=socks5h://user-nashe1337-country-ar:6_0QkksTV0dr0iEgaq@gate.decodo.com:7000"
EOL

# Verificar que el proxy funciona
echo ""
echo "==========================="
echo "Configuración completada"
echo "==========================="
echo ""
echo "Tu proxy SOCKS5 está configurado en:"
echo "Server: gate.decodo.com"
echo "Puerto: 7000"
echo "Usuario: user-nashe1337-country-ar"
echo "Contraseña: 6_0QkksTV0dr0iEgaq"
echo ""
echo "Puedes conectarte usando el formato:"
echo "socks5h://user-nashe1337-country-ar:6_0QkksTV0dr0iEgaq@gate.decodo.com:7000"
echo ""
echo "Para verificar que el proxy está funcionando, ejecuta:"
echo "source /etc/profile.d/proxy.sh && curl https://api.ipify.org"
echo "o también:"
echo "/usr/local/bin/check-proxy"
echo ""
echo "Esta IP debería ser diferente a tu IP real y corresponder al país elegido (Argentina)"
echo ""
echo "NOTA: Para aplicar los cambios en la sesión actual, ejecuta:"
echo "source /etc/profile.d/proxy.sh"
