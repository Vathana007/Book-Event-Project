import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time"]

  connect() {
    this.updateTime()
    this.timer = setInterval(() => this.updateTime(), 1000)
  }
  
  disconnect() {
    clearInterval(this.timer)
  }
  
  updateTime() {
    const now = new Date()
    const options = { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
      hour12: true
    }
    this.timeTarget.textContent = now.toLocaleString('en-US', options)
  }
}