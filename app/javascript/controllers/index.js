import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// This will automatically load all *_controller.js files in this directory
eagerLoadControllersFrom("controllers", application)