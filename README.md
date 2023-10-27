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
A aplicação é bem dinâmica, visto que é construída em Vue.js. Ao enviar um arquivo csv na aplicação para que ele seja importado, o arquivo será enfileirado pelo Sidekiq e assim que possível será processado, assim que o processamento for concluído, a aplicação avisará, e automaticamente carregará os novos dados importados. Também é possível ver os detalhes do exame através do botão de ver mais detalhes, os cards abrem e fecham dinamicamente. É possível relizar pesquisas de exames pelo seu Token, data do resultado ou CPF do paciente. A aplicação conta também com paginação para os exames, tornando a página mais concisa.

OBS: A cada 5 segundos é feita uma request para a API de status com os ids de jobs armazenados no LocalStorage, portanto pode haver um delay na exibição de que o arquivo foi processado, e dos novos dados.

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

### Endpoints
* /tests | server-1 -> 
Retorna um JSON com todos os exames e seus detalhes.
```
[
  {
    "result_token": "85OIFQ",
    "result_date": "2022-03-27",
    "cpf": "071.868.284-00",
    "name": "Dra. Vitória Soares",
    "email": "michale.huel@lynch.io",
    "birthday": "1963-09-29",
    "doctor": {
      "crm": "B0002W2RBG",
      "crm_state": "CE",
      "name": "Dra. Isabelly Rêgo"
    },
    "tests": [
      {
        "type": "plaquetas",
        "limits": "11-93",
        "result": 50
      },
    ...
```
---
* /tests/:token | server-1 -> 
Retorna um JSON com todas as informações de um único exame
```
{
  "result_token": "5UP5FA",
  "result_date": "2022-03-27",
  "cpf": "081.878.172-67",
  "name": "Emanuel Beltrão Neto",
  "email": "jennine@mosciski-swaniawski.co",
  "birthday": "1989-10-28",
  "doctor": {
    "crm": "B000B7CDX4",
    "crm_state": "SP",
    "name": "Sra. Calebe Louzada"
  },
  "tests": [
    {
      "type": "ácido úrico",
      "limits": "15-61",
      "result": 25
    },
    ...
```
---
* /import | server-1 -> 
Recebe um arquivo csv com um formato específico explificado abaixo,
enfilera o job no Sidekiq e retorna o status se foi ou não enfileirado no caso
de status 200 também retorna o id do job no body.

Exemplo de formato do csv
```
cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
048.973.170-88;Emilly Batista Neto;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000BJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;IQCZ17;2021-08-05;hemácias;45-52;97
```
Exemplo de uma response da api
```
97c96ea8852bf3a7270cf696
```
---
* /status | server-1 ->
Recebe um array de ids de jobs, puxa os status de cada id de job formata e responde um JSON,
contendo o status, o nome do arquivo e o id do job.

Exemplo de uma request
```
["97c96ea8852bf3a7270cf696", "010801f838df362ec7f39f7"]
```
Exemplo de response
```
[
  "[\"Completed\",\"data.csv\",\"97c96ea8852bf3a7270cf696\"]"
  "[\"Completed\",\"data2.csv\",\"3010801f838df362ec7f39f7\"]"
]
```
---
* '/' | server-2 ->
Exibe a página principal da aplicação, onde é possível interagir com as endpoints do server-1
 
![Captura de tela de 2023-10-26 23-43-36](https://github.com/GA9BR1/medical_exams_csv/assets/91296759/39e76561-dc1a-403f-8841-38407cafcd86)


---
### Estrutura do banco de dados
![estrutura_1](https://github.com/GA9BR1/medical_exams_csv/assets/91296759/bfd09f62-7f96-435e-bdd9-a6ccca3914f4)

OBS: O VARCHAR utilizado não tem o limite de 45 caracteres.
