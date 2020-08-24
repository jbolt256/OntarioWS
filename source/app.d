module ontariows.main;

import std.stdio;
import vibe.vibe;
import ontariows.auth;


/** OntarioWS - Ontario Warehouse System
 * Main entry point is here.
 */
 
void index(HTTPServerRequest req, HTTPServerResponse res)
{
	res.render!("index.dt", req);
}

void admin(HTTPServerRequest req, HTTPServerResponse res)
{
	// Verify session is marked correctly
	if ( req.cookies.get("WS_SESSION") != null && Authenticate.sessionIsValid(req.cookies.get("WS_SESSION")) ) {
		res.render!("admin.dt", req);		
	} else {
		res.writeBody("Invalid session.");
	}
}

void login(HTTPServerRequest req, HTTPServerResponse res)
{
	auto username = req.form.get("ws_username", "NotFound");
	auto password = req.form.get("ws_password", "NotFound");
	auto Auth = new Authenticate;
	if ( username == "NotFound" || password == "NotFound" ) {
		res.writeBody("Invalid login attempt: too few parameters provided.");
	}
	
	if ( Auth.auth(username, password) ) {
		Auth.startSession(username, res);
		res.render!("admin.dt", req);
	} else {
		res.writeBody("Invalid login attempt.");
	}
	
}

void main()
{
	auto router = new URLRouter;
	
	router.get("/", &index);
	router.get("/admin", &admin);
	router.post("/login", &login);
	router.post("/go", &go);
	
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	
	listenHTTP(settings, router);
	
	runApplication();
}