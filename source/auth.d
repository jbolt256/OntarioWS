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
	
	bool auth(string username, string password) {
		if ( username == "admin" && password == "admin" ) {
			return true;
		}
		return false;
	}
	
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
	
	void startSession(string username, HTTPServerResponse res) {
		// Store client side cookie for session
		auto sessionID = this.genSession();
		res.setCookie("WS_SESSION", sessionID);
		// Store server side session for 10 minutes
		Session newSession = { username: username, sessionID: sessionID, expiration: (std.datetime.systime.Clock.currTime).toUnixTime()+600 };
		valid_sessions[sessionID] = newSession;		
	}
	
	static bool sessionIsValid(string sessionID) { 
		if ( sessionID in valid_sessions && valid_sessions[sessionID].expiration >= (std.datetime.systime.Clock.currTime).toUnixTime() ) {
			return true;
		} 
		return false;
	}
}