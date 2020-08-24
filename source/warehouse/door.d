/** door.d **/
module ontariows.warehouse.door;
import std.conv;

/* Standard door setup:
 * A door is referenced by integer, but written as "DORxxx", where x is a 3-digit integer.
 */
class Door { 
	public int doorNum;
	public int doorType;
	public string doorStr;
	this(int doorNum, int doorType) {
		this.doorNum = doorNum;
		this.doorType = doorType;
		this.doorStr = "DOR" ~ to!string(doorNum);
	}
}