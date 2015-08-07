class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?" {
            constraints {
                // apply constraints here
            }
        }

        "/"(action: "index", controller: "ServerLogin")
        "/Home"(action: "home", controller: "ServerLogin")
        "500"(view: '/error')
    }
}
