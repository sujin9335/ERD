package com.codvill.comm;

public class Utils {

    public static String nvl(String str, String def){
		if(str == null){
			return def;
		}
		else{
			return str;
		}
	}
    
}
