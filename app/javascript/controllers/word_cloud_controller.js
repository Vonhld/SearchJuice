import { Controller } from "@hotwired/stimulus"

import WordCloud from 'wordcloud'
export default class extends Controller {
  static values = { list: Array }

  // Variável para guardar qual palavra está atualmente sob o mouse
  activeWord = null;

  connect() {
    // listener for the 'mouseout'event.
    this.element.addEventListener('mouseout', () => {
      this.activeWord = null;
    });

    this.drawCloud();
  }

  drawCloud() {
    // Check WordCloud availability and data length
    if (typeof WordCloud === 'undefined' || this.listValue.length === 0) {
      console.error("WordCloud library not found or no data.");
      return;
    }

    const options = {
      list: this.listValue,
      gridSize: 10,
      fontFamily: 'Arial, sans-serif',
      backgroundColor: '#f8f9fa',
      rotateRatio: 0.5,
      minSize: 5,
      // Normalization factor for word weight
      weightFactor: (size) =>{
        return Math.pow(size, 0.6) * 8;
      },

      // Paint the hovered word
      color: (word) => {
        return word === this.activeWord ? '#007bff' : '#212529'; // Azul de destaque e preto padrão
      },

      hover: (item) => {
        const newActiveWord = item ? item[0] : null;

        // Logic to redraw only if the hovered word changes
        if (newActiveWord !== this.activeWord) {
          this.activeWord = newActiveWord; 
          this.drawCloud();
        }
      }
    };

    WordCloud(this.element, options);
  }
  
  disconnect() {
    this.element.removeEventListener('mouseout', () => {});
  }
}