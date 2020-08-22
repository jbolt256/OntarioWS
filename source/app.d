module ontariows.main;

import std.stdio;
import vibe.vibe;


/** OntarioWS - Ontario Warehouse System
 * Main entry point is here.
 */
 
void index(HTTPServerRequest req, HTTPServerResponse res)
{
	//res.writeBody("H");
	res.render!("index.dt", req);
}

void main()
{
	auto router = new URLRouter;
	router.get("/", &index);
	
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	
	listenHTTP(settings, router);
	
	runApplication();
}