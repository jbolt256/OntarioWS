module ontariows.speedreader;
import std.file;
import std.stdio;
import std.array;
/** SpeedReader
 * The one-stop-shop for parsing .ws files!
 * A .ws file is simply a .csv file in disguise, with the notable distinction that the .ws files
 * use a the ASCII record separator (^^) as a delimeter. 
 *
 * Each SpeedReader instance refers to a file. As such, no static methods should be used.
 */
class SpeedReader { 
	private int size;
	private string text;
	private string lines;
	private bool valid;
	/**
	  * constructor
	  * Reads file text into handler, given that the file exists, and the size of the file is fewer
	  * than 16,000 bytes (64KB). This limitation is introduced to keep the overall memory footprint
	  * of the program to under 64MB.
	  */
	this(string filename) {
		if ( std.file.exists(filename) ) {
			this.size = std.file.exists(filename);
			if ( this.size > 64000 ) {
				writeln("Error: File size greater than 8000 bytes.");
			} else {
				this.text = std.file.readText(filename);
				this.valid = true;
			}
		} else {
			writeln("Error: File does not exist.");
		}
	}
	
	/**
	 * Returns an array with all the lines, split by new-line character.
	 */
	public string[] byLines() {
		string[] lines;
		if ( this.valid ) {
			lines = this.text.split("\n");
		}
		return lines;
	}
	
	/** 
	  * Returns an array, with each element containing an array of the values split by the delimeter.
	  */
	public string[][] byLinesColumns() {
		string[][] lineCols;
		string[] lines;
		if ( this.valid ) {
			lines = this.text.split("\n");
			foreach ( string l; lines ) {
				lineCols = lineCols ~ l.split("^^");
			}
		}
		return lineCols;
	}
	
}
	