// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Search controller connected!")
  }

  search() {
    console.log("Search triggered!")
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      console.log("Submitting form...")
      this.element.requestSubmit()
    }, 300) // debounce 300ms
  }
}
