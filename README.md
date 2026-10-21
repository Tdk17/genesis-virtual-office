# Gênesis Virtual Office

Protótipo Flutter Web interativo com escritório retrô, oito agentes, chat de demonstração, painel e sala de reunião representada.

**V0.1 — DEMO**: nenhuma ação de IA ou integração n8n/Ollama/Back4App está ativa. Os movimentos dos personagens, conversas e números são apenas ilustrativos.

## Instalação

```sh
flutter pub get
flutter run -d chrome
```

## Publicar

O GitHub Actions compila o site para GitHub Pages. Configure **Settings > Pages > Source: GitHub Actions**. O endereço, após a primeira implantação bem-sucedida, será `https://tdk17.github.io/genesis-virtual-office/`.

## Etapas seguintes

1. Autenticação segura com isolamento entre empresas.
2. Backend no Back4App para agentes, tarefas, eventos, chats e auditoria.
3. Gateway HTTPS autenticado e conector local que executa n8n e Ollama no PC ligado das 08:00 às 16:00 (dias úteis).
4. Transições reais de eventos conectadas ao movimento dos avatares, reuniões, aprovações, heartbeat e relatórios.
5. Validação comercial e conformidade com WhatsApp Business Platform e LGPD.

Nunca exponha tokens administrativos, Parse master key ou segredos de automação em código Flutter Web.
