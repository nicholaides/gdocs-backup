package profligacy;

import java.io.IOException;
import javax.swing.*;

public class LELParser {

  public interface LELEventListener {
    public void col();
    public void ltab();
    public void valign(String dir);
    public void id(String name);
    public void row();
    public void align(String dir);
    public void setwidth(int width);
    public void setheight(int height);
    public void finished(boolean error);
    public void expand();
  }

  %%{
    machine LayoutExpressionLanguage;
    alphtype char;

    action token { tk = input.substring(tk_start, fpc); }
    action col { listener.col(); }
    action ltab { listener.ltab(); }
    action valign { listener.valign(input.substring(fpc,fpc+1)); }
    action id { listener.id(input.substring(tk_start, fpc)); }
    action row { listener.row(); }
    action align { listener.align(input.substring(fpc, fpc+1)); }
    action setwidth { listener.setwidth(Integer.parseInt(tk)); }
    action setheight { listener.setheight(Integer.parseInt(tk)); }
    action expand { listener.expand(); }

    col = "|" $col;
    ltab = "[" $ltab;
    rtab = "]" $row;
    valign = ("^" | ".") $valign;
    expand = "*" $expand;
    halign = ("<" | ">") $align;
    number =  digit+ >{ tk_start = fpc; } %token;
    setw = ("(" number %setwidth ("," number %setheight)? ")") ;
    modifiers = (expand | valign | halign | setw);
    id = modifiers* ((alpha | '_')+ :>> (alnum | '_')*) >{tk_start = fpc;} %id;
    row = space* ltab space* id space* (col space* id)* space* rtab space*;

main := row+;
  }%%

  %% write data nofinal;

  public int cs, p = 0, pe = 0;

  public boolean scan(String input, LELEventListener listener) {
    int tk_start = 0;
    p = 0;
    String tk = null;

    %% write init;

    pe = input.length();
    char data[] = input.toCharArray();

    %% write exec;


    listener.finished(isInErrorState());

    if(isInErrorState()) {
      return false;
    } else {
      return true;
    }
  }

  public boolean isInErrorState() {
    return cs == LayoutExpressionLanguage_error;
  }

  public int getPosition() {
    return p;
  }
}
