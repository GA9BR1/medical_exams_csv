# Rebase Labs

Uma app web para listagem de exames médicos.

---

### Tech Stack

* Docker
* Ruby
* Javascript
* HTML
* CSS
* PostregreSQL
* VueJs
* Sidekiq
---
### Um pouco sobre as funcionalidades
A aplicação é bem dinâmica, visto que é construída em Vue.js. Ao enviar um arquivo csv na aplicação para que ele seja importado, o arquivo será enfileirado pelo Sidekiq e assim que possível será processado, assim que o processamento for concluído, a aplicação avisará e automaticamente carregará os novos dados importados. Também é possível ver os detalhes do exame através do botão mais detalhes, os cards abrem e fecham dinamicamente. É possível relizar pesquisas de exames pelo seu Token, data do resultado ou CPF do paciente. A aplicação conta também com paginação para os exames, tornando a página mais concisa.

### Instruções para rodar o projeto

* É necessário ter o Docker instalado na sua máquina

Rode o seguinte comando
```
docker compose up
```
Essa linha de comando sobe os containers do Docker configurados no arquivo docker-compose.yml, após todas as configurações iniciais,
os 3 containers estarão rodando e aplicação estará no ar.

### Instruções para rodar os testes
Rode o seguinte comando para subir a aplicação de testes
```
docker compose -f docker-compose-test.yml up
```
Depois que os containers forem inicializados rode o seguinte comando
para rodar os testes
```
docker exec -it medical_exams_csv-ruby-api-1 rspec
```

#### Deseja limpar os volumes ?
Os volumes são armazenamentos do docker, que nessa situação mantêm o dados do banco de dados salvos quando um container é derrubado,
também armazena as gems utilizadas na aplicação.

Use o seguinte comando para limpar todos os volumes da app
```
docker compose down --volumes
```
Use o seguinte comando para limpar todos os volumes da app de testes
```
docker compose -f docker-compose-test.yml down --volumes
```

---
### Estrutura do banco de dados
![estrutura_1](https://github.com/GA9BR1/medical_exams_csv/assets/91296759/bfd09f62-7f96-435e-bdd9-a6ccca3914f4)

OBS: O VARCHAR utilizado não tem o limite de 45 caracteres.
