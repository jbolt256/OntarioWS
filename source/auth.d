module ontariows.auth;
import std.algorithm : canFind;
import std.random;
import std.conv;
import std.stdio;
import std.datetime;
import vibe.vibe;

struct Session {
	string username;
	string sessionID;
	int expiration;
}

Session[string] valid_sessions;

class Authenticate {
	
	/* Check authorization */
	bool auth(string username, string password) {
		if ( username == "admin" && password == "admin" ) {
			return true;
		}
		return false;
	}
	
	/* Create unique session ID. 
	 * Does not check for collisions! Which is an issue even though there is only a 1 in 4.2 * 10^22 chance of a collision occurring. 
	 */
	string genSession() {
		string generated = "";

		auto rnd = Random(unpredictableSeed);
		// Generate random 16-bit string for session ID. Uses only [a-z],
		// so 26^16 complexity, or about 4.2 * 10^22. Not bad, but not very secure.
		for ( int i=0; i < 16; i++ ) {
			auto r = uniform(97, 123, rnd);
			generated = generated ~ to!string(cast(char) r);
		}

		return generated;
	}
	
	/* Start a new session */
	void startSession(string username, HTTPServerResponse res) {
		// Store client side cookie for session
		auto sessionID = this.genSession();
		res.setCookie("WS_SESSION", sessionID);
		// Store server side session for 10 minutes
		Session newSession = { username: username, sessionID: sessionID, expiration: (std.datetime.systime.Clock.currTime).toUnixTime()+600 };
		valid_sessions[sessionID] = newSession;		
	}
	
	/* 
	 * If session is valid (exists & non-expired), return true. 
	 * If session is not valid & not expired, return false.
	 * If session is not valid & expired, purge session and return false.
	 */
	static bool sessionIsValid(string sessionID) { 
		if ( sessionID in valid_sessions ) {
			if ( valid_sessions[sessionID].expiration >= (std.datetime.systime.Clock.currTime).toUnixTime() ) {
				return true;
			} else {
				valid_sessions.remove(sessionID);
			}
		} 
		return false;
	}
}