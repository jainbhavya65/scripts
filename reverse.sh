sed -i -e "s|// apiUrl: 'http://localhost:7000/'|apiUrl: 'http://localhost:7000/'|" -e "s|apiUrl: 'https://crm-api.iface.io/'|// apiUrl: 'https://crm-api.iface.io/'|" config.development.ts
sed -i "s|process.env.NODE_ENV = 'production'|process.env.NODE_ENV = 'development'|" server.js
