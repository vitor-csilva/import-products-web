const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    allowedHosts: "all", // Allows any host, fixing "Invalid Host header" error
    host: "0.0.0.0",      // Aceita conexões externas
    port: 8080,           // Porta para o frontend
  },
});
