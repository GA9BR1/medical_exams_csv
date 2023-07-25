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
---
### Instruções para rodar o projeto

* É necessário ter o Docker instalado na sua máquina

Rode o seguinte comando
```
docker compose up
```
Essa linha de comando sobe os containers do Docker configurados no arquivo docker-compose.yml, após todas as configurações iniciais,
os 3 containers estarão rodando e aplicação estará no ar.

#### Deseja limpar os volumes ?
Os volumes são armazenamentos do docker, que nessa situação mantêm o dados do banco de dados salvos quando um container é derrubado,
também armazena as gems utilizadas na aplicação.

Use o seguinte comando para limpar todos os volumes
```
docker compose down --volumes
```

---
### Estrutura do banco de dados
![estrutura_1](https://github.com/GA9BR1/medical_exams_csv/assets/91296759/bfd09f62-7f96-435e-bdd9-a6ccca3914f4)

OBS: O VARCHAR utilizado não tem o limite de 45 caracteres.
