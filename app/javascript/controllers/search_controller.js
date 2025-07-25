import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce" // debounce event


export default class extends Controller {
// Define 'targets' for the input and the results div
  static targets = ["input", "results"];

  // Variables to store the current query and timer
  inactivityTimer = null;
  completeQuery = "";
  isFinalized = true;
  csrfToken = document.querySelector('meta[name="csrf-token"]').content;

  connect() {
    // Debounce for searching results
    this.fetchResults = debounce(this.fetchResults, 500).bind(this);
  }

  // Main method called for each key pressed
  handleInput(event) {
    // Resets the last timer.
    clearTimeout(this.inactivityTimer);

    const currentQuery = event.target.value.trim();

    // Fetch articles
    this.fetchResults(currentQuery);

    // Logic for when the user clears the search
    if (currentQuery === "") {
      // Set the finalize flag and store the most complete query if the user clears the search
      this.finalizeOnClear();
    }

    if (this.isFinalized) {
      this.startNewSearchSession(currentQuery);
    }

    // Certifies that the largest query is saved
    if (currentQuery.length > this.completeQuery.length) {
      this.completeQuery = currentQuery;
    }

    // Start a new idle timer (max is 4000ms)
    // min search: 3 tokens
    if (this.completeQuery.length > 2) {
      this.inactivityTimer = setTimeout(() => {
        console.log(`Finalizing due to inactivity. Query: "${this.completeQuery}"`);

        // Set the finalize flag and store the query after 4s of inactivity
        this.finalizeOnInactivity();
      }, 4000); // 4000ms (4 seconds delay)
    }
  }

  async fetchResults(query) {
    if (query.length < 2) {
      //Clears the results if the search is too short
      this.resultsTarget.innerHTML = "";
      return;
    }

    // Build the URL for the search
    const url = `/articles/search?query=${encodeURIComponent(query)}`;
    const response = await fetch(url);
    const articles = await response.json();

    this.displayResults(articles);
  }

  // Finalize flag logic for inactivity
  finalizeOnInactivity() {
    if (this.isFinalized) return;

    this.saveQuery(this.completeQuery);
    this.isFinalized = true;
  }
  
  // Finalize flag logic when clearing the search field
  finalizeOnClear() {
    if (this.isFinalized) return;

    this.saveQuery(this.completeQuery);
    this.isFinalized = true;
  }

  // start a new state
  startNewSearchSession(currentQuery) {

    this.isFinalized = false;
    this.completeQuery = currentQuery;
  }

  // Display search results
  displayResults(articles) {
    if (articles.length === 0) {
      this.resultsTarget.innerHTML = "<p>No results found.</p>";
      return;
    }

    // Formatting of search results
    const resultsHtml = articles.map(article => `
        <div class="result-item mt-5 d-flex flex-column mr-3 ml-3 border border-secondary rounded p-3"
          data-action="click->search#selectResult" 
          data-article-id="${article.id}"
          data-article-title="${article.title}">
        <h3 class="text-center">${article.title}</h3>
        <p>by ${article.author_name}</p>
      </div>
    `).join("");

    this.resultsTarget.innerHTML = resultsHtml;
  }

  async selectResult(event) {
    event.preventDefault();
    const element = event.currentTarget;
    const articleId = element.dataset.articleId;
    const articleTitle = element.dataset.articleTitle;

    // Store the title of an article as a query
    await this.saveQuery(articleTitle);

    // Redirects the user to the article page
    window.location.href = `/articles/${articleId}`;
  }

  // Helper function to send the search to the backend (controller)
  saveQuery(query) {
    // Ensures that we do not send anything if the complete query is empty, less than 3 tokens or missing csrf tokens.
    if (!query || query.length < 3 || !this.csrfToken) return;

    // Call to the controller logic to save the query ('return' to use await)
    return fetch('/pages/save_query', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': this.csrfToken
      },
      body: JSON.stringify({ query: query })
    });
  }
}