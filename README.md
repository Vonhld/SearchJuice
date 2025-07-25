<!-- Hello, this repository refers to the Helpjuice internship challenge. Feel free to study or use it.

Problema principal: Usar uma caixa de busca em tempo real para gerar análises sobre os usuários e suas pesquisas.

Obtetivo: armazenar o input dado em tempo real e trazer informações sobre o que as pessoas estão pesquisando isso em um banco de dados de artigos

Desafios:
Problema da pyramid:
ao escrever "Hello world how are you?", o sistema interpreta fatias dessas informações e salva independentemente, exemplo:
Hello
Hello world
Hello world how
Hello world how are
Hello world how are you?
O correto seria salvar apenas a frase completa, ou seja, "Hello world how are you?"

Scalabilidade:
Ao se deparar com esse problema, o redis aparenta ser a melhor forma de se lidar com uma grande escalabilidade, porém com uma complexidade superior ao pensar em hosting, em junção do sidekiq. Com isso em mente, foi decido utilizar apenas o postgresql, que já fornece uma base sólida para este problema.


What has been implemented?


Core Features
Real-Time Article Search: Instantly searches across article titles, summaries, and authors as the user types.

Intelligent Search Analytics: A client-side algorithm captures the user's final, intended search query, filtering out intermediate fragments and handling edge cases like inactivity, deletions, and race conditions.Aqui foi utilizado 2 funções asincronas, levando em conta inatividade ( 4 segundos ) e o usuário apagar o conteúdo da barra de pesquisa ( salva a ultima string mais completa ) e além, ao clicar em um dos artigos exibidos abaixo, ele salva o titulo do artigo como pesquisa, visto que entende-se que o usuário queria pesquisar tal artigo.

resumindo, salvamos a query em 3 situações:
caso exista 4 segundos de inatividade
caso o usuário apague todo o texto da busca,
caso o usuário clique em um dos artigos ( salva o titulo do artigo como query )
lembrando que o token minimo para ser salvo é 3 caracteres

Global & User-Specific Analytics Pages: Dedicated dashboards to view search trends for all users and for the current user.

Interactive Word Cloud: A visual representation of the most frequently searched words, with hover effects.

Test Suite: End-to-end system tests (using RSpec, Capybara, and Selenium) that validate the user flow, including the JavaScript-driven analytics logic and some special cases for the search.


Technical Stack
Backend: Ruby 2.7.6, Ruby on Rails 6.1.7

Frontend: Stimulus.js, wordcloud2.js

Database: PostgreSQL

Testing: RSpec, Capybara, Selenium WebDriver

Styling: Bootstrap (Theme: AdminLTE3)


Prerequisites
Ruby 2.7.6

Node.js & Yarn

PostgreSQL

Google Chrome (for system tests) -->

# Helpjuice Challenge: Real-Time Search Analytics Engine

This repository contains the solution for the Helpjuice internship challenge. The goal is to build a real-time search box for articles, with a primary focus on generating analytics about what users are searching for, rather than just the search results themselves.

The core of this project is the algorithm designed to intelligently interpret user input in real-time to capture their final, intended search queries for analysis.

## Core Features

* **Real-Time Article Search**: Instantly searches across article titles, summaries, and authors as the user types, using PostgreSQL's Full-Text Search.
* **Intelligent Search Analytics**: A client-side algorithm captures the user's final, intended search query, filtering out intermediate fragments and handling edge cases like inactivity, deletions, and race conditions.
* **Global & User-Specific Analytics Pages**: Dedicated dashboards to view search trends for all users (globally) and for the current user (tracked by IP address).
* **Interactive Word Cloud**: A visual representation of the most frequently searched words, with hover effects to show search frequency.
* **Robust Test Suite**: System tests (using RSpec, Capybara, and Selenium) that validate the user flow, including the JavaScript-driven analytics logic.

## The Core Challenge: Solving the "Pyramid Problem"

A naive implementation of real-time logging would save every intermediate fragment of a user's typing. For instance, a search for "Hello world" would incorrectly log "H", "He", "Hel", "Hello", "Hello ", "Hello w", and so on. This floods the analytics data with useless, incomplete fragments.

### Our Solution: A Client-Side State Machine

To solve this, I implemented a robust state machine in a **Stimulus.js controller** on the client side. This approach intelligently determines the user's *final intended query* before sending a single, clean request to the backend for logging. A query is saved to the analytics database only in one of the following **three scenarios**:

1.  **User Inactivity**: After the user stops typing for **4 seconds**. A timer is reset with every keystroke.
2.  **Input Clear**: When the user clears the search input field. The algorithm saves the longest version of the query (`CompleteQuery`) typed during that session just before it was cleared.
3.  **Result Click**: When the user clicks on a search result. The **title of the clicked article** is saved as the final query, as this is a strong signal of user intent.

Furthermore, a minimum length of **3 characters** is enforced to prevent saving trivial or accidental inputs.

### Scalability 

When faced with this problem, Redis appears to be the best way to deal with high-scalability scenarios, but with greater complexity when considering hosting, in conjunction with Sidekiq. With this in mind, it was decided to use only postgresql, which already provides a solid foundation for this problem.

## Technical Stack

* **Backend**: Ruby `2.7.6`, Ruby on Rails `6.1.7`
* **Frontend**: Stimulus.js, `wordcloud2.js`, `lodash.debounce`
* **Database**: PostgreSQL
* **Testing**: RSpec, Capybara, Selenium WebDriver
* **Styling**: Bootstrap (Theme: AdminLTE3)

## Getting Started

### Prerequisites

* Ruby `2.7.6`
* Node.js & Yarn
* PostgreSQL
* Google Chrome (for running system tests)

### Setup Instructions

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    cd <project-directory>
    ```

2.  **Install dependencies:**
    ```sh
    bundle install
    yarn install
    rails webpacker:install
    ```

3.  **Set up the database:**
    ```sh
    rails db:create
    rails db:migrate
    rails db:seed # Populate articles
    ```

4.  **Run the application:**
    ```sh
    rails s
    ```

    The application will be available at `http://localhost:3000`.

## Running the Tests

The test suite uses RSpec. To run all tests, execute:
```sh
bundle exec rspec
```