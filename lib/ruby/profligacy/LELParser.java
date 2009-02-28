// line 1 "lib/profligacy/LELParser.rl"
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

  // line 49 "lib/profligacy/LELParser.rl"


  
// line 27 "lib/profligacy/LELParser.java"
private static void init__LayoutExpressionLanguage_actions_0( byte[] r )
{
	r[0]=0; r[1]=1; r[2]=1; r[3]=1; r[4]=2; r[5]=1; r[6]=3; r[7]=1; 
	r[8]=4; r[9]=1; r[10]=5; r[11]=1; r[12]=6; r[13]=1; r[14]=9; r[15]=1; 
	r[16]=10; r[17]=1; r[18]=11; r[19]=2; r[20]=0; r[21]=7; r[22]=2; r[23]=0; 
	r[24]=8; r[25]=2; r[26]=4; r[27]=1; r[28]=2; r[29]=4; r[30]=5; 
}

private static byte[] create__LayoutExpressionLanguage_actions( )
{
	byte[] r = new byte[31];
	init__LayoutExpressionLanguage_actions_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_actions[] = create__LayoutExpressionLanguage_actions();


private static void init__LayoutExpressionLanguage_key_offsets_0( byte[] r )
{
	r[0]=0; r[1]=0; r[2]=4; r[3]=18; r[4]=20; r[5]=24; r[6]=35; r[7]=47; 
	r[8]=52; r[9]=66; r[10]=68; r[11]=72; r[12]=83; r[13]=95; r[14]=99; r[15]=101; 
	r[16]=104; r[17]=106; r[18]=109; 
}

private static byte[] create__LayoutExpressionLanguage_key_offsets( )
{
	byte[] r = new byte[19];
	init__LayoutExpressionLanguage_key_offsets_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_key_offsets[] = create__LayoutExpressionLanguage_key_offsets();


private static void init__LayoutExpressionLanguage_trans_keys_0( char[] r )
{
	r[0]=32; r[1]=91; r[2]=9; r[3]=13; r[4]=32; r[5]=40; r[6]=42; r[7]=46; 
	r[8]=60; r[9]=62; r[10]=94; r[11]=95; r[12]=9; r[13]=13; r[14]=65; r[15]=90; 
	r[16]=97; r[17]=122; r[18]=48; r[19]=57; r[20]=41; r[21]=44; r[22]=48; r[23]=57; 
	r[24]=40; r[25]=42; r[26]=46; r[27]=60; r[28]=62; r[29]=94; r[30]=95; r[31]=65; 
	r[32]=90; r[33]=97; r[34]=122; r[35]=32; r[36]=93; r[37]=95; r[38]=124; r[39]=9; 
	r[40]=13; r[41]=48; r[42]=57; r[43]=65; r[44]=90; r[45]=97; r[46]=122; r[47]=32; 
	r[48]=93; r[49]=124; r[50]=9; r[51]=13; r[52]=32; r[53]=40; r[54]=42; r[55]=46; 
	r[56]=60; r[57]=62; r[58]=94; r[59]=95; r[60]=9; r[61]=13; r[62]=65; r[63]=90; 
	r[64]=97; r[65]=122; r[66]=48; r[67]=57; r[68]=41; r[69]=44; r[70]=48; r[71]=57; 
	r[72]=40; r[73]=42; r[74]=46; r[75]=60; r[76]=62; r[77]=94; r[78]=95; r[79]=65; 
	r[80]=90; r[81]=97; r[82]=122; r[83]=32; r[84]=93; r[85]=95; r[86]=124; r[87]=9; 
	r[88]=13; r[89]=48; r[90]=57; r[91]=65; r[92]=90; r[93]=97; r[94]=122; r[95]=32; 
	r[96]=93; r[97]=9; r[98]=13; r[99]=48; r[100]=57; r[101]=41; r[102]=48; r[103]=57; 
	r[104]=48; r[105]=57; r[106]=41; r[107]=48; r[108]=57; r[109]=32; r[110]=91; r[111]=9; 
	r[112]=13; r[113]=0; 
}

private static char[] create__LayoutExpressionLanguage_trans_keys( )
{
	char[] r = new char[114];
	init__LayoutExpressionLanguage_trans_keys_0( r );
	return r;
}

private static final char _LayoutExpressionLanguage_trans_keys[] = create__LayoutExpressionLanguage_trans_keys();


private static void init__LayoutExpressionLanguage_single_lengths_0( byte[] r )
{
	r[0]=0; r[1]=2; r[2]=8; r[3]=0; r[4]=2; r[5]=7; r[6]=4; r[7]=3; 
	r[8]=8; r[9]=0; r[10]=2; r[11]=7; r[12]=4; r[13]=2; r[14]=0; r[15]=1; 
	r[16]=0; r[17]=1; r[18]=2; 
}

private static byte[] create__LayoutExpressionLanguage_single_lengths( )
{
	byte[] r = new byte[19];
	init__LayoutExpressionLanguage_single_lengths_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_single_lengths[] = create__LayoutExpressionLanguage_single_lengths();


private static void init__LayoutExpressionLanguage_range_lengths_0( byte[] r )
{
	r[0]=0; r[1]=1; r[2]=3; r[3]=1; r[4]=1; r[5]=2; r[6]=4; r[7]=1; 
	r[8]=3; r[9]=1; r[10]=1; r[11]=2; r[12]=4; r[13]=1; r[14]=1; r[15]=1; 
	r[16]=1; r[17]=1; r[18]=1; 
}

private static byte[] create__LayoutExpressionLanguage_range_lengths( )
{
	byte[] r = new byte[19];
	init__LayoutExpressionLanguage_range_lengths_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_range_lengths[] = create__LayoutExpressionLanguage_range_lengths();


private static void init__LayoutExpressionLanguage_index_offsets_0( byte[] r )
{
	r[0]=0; r[1]=0; r[2]=4; r[3]=16; r[4]=18; r[5]=22; r[6]=32; r[7]=41; 
	r[8]=46; r[9]=58; r[10]=60; r[11]=64; r[12]=74; r[13]=83; r[14]=87; r[15]=89; 
	r[16]=92; r[17]=94; r[18]=97; 
}

private static byte[] create__LayoutExpressionLanguage_index_offsets( )
{
	byte[] r = new byte[19];
	init__LayoutExpressionLanguage_index_offsets_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_index_offsets[] = create__LayoutExpressionLanguage_index_offsets();


private static void init__LayoutExpressionLanguage_indicies_0( byte[] r )
{
	r[0]=0; r[1]=2; r[2]=0; r[3]=1; r[4]=3; r[5]=4; r[6]=5; r[7]=6; 
	r[8]=7; r[9]=7; r[10]=6; r[11]=8; r[12]=3; r[13]=8; r[14]=8; r[15]=1; 
	r[16]=9; r[17]=1; r[18]=10; r[19]=11; r[20]=12; r[21]=1; r[22]=4; r[23]=5; 
	r[24]=6; r[25]=7; r[26]=7; r[27]=6; r[28]=8; r[29]=8; r[30]=8; r[31]=1; 
	r[32]=13; r[33]=15; r[34]=14; r[35]=16; r[36]=13; r[37]=14; r[38]=14; r[39]=14; 
	r[40]=1; r[41]=17; r[42]=18; r[43]=19; r[44]=17; r[45]=1; r[46]=20; r[47]=21; 
	r[48]=22; r[49]=23; r[50]=24; r[51]=24; r[52]=23; r[53]=25; r[54]=20; r[55]=25; 
	r[56]=25; r[57]=1; r[58]=26; r[59]=1; r[60]=27; r[61]=28; r[62]=29; r[63]=1; 
	r[64]=21; r[65]=22; r[66]=23; r[67]=24; r[68]=24; r[69]=23; r[70]=25; r[71]=25; 
	r[72]=25; r[73]=1; r[74]=30; r[75]=15; r[76]=31; r[77]=16; r[78]=30; r[79]=31; 
	r[80]=31; r[81]=31; r[82]=1; r[83]=32; r[84]=18; r[85]=32; r[86]=1; r[87]=33; 
	r[88]=1; r[89]=34; r[90]=35; r[91]=1; r[92]=36; r[93]=1; r[94]=37; r[95]=38; 
	r[96]=1; r[97]=39; r[98]=2; r[99]=39; r[100]=1; r[101]=0; 
}

private static byte[] create__LayoutExpressionLanguage_indicies( )
{
	byte[] r = new byte[102];
	init__LayoutExpressionLanguage_indicies_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_indicies[] = create__LayoutExpressionLanguage_indicies();


private static void init__LayoutExpressionLanguage_trans_targs_wi_0( byte[] r )
{
	r[0]=1; r[1]=0; r[2]=2; r[3]=2; r[4]=3; r[5]=5; r[6]=5; r[7]=5; 
	r[8]=6; r[9]=4; r[10]=5; r[11]=16; r[12]=4; r[13]=7; r[14]=6; r[15]=18; 
	r[16]=8; r[17]=7; r[18]=18; r[19]=8; r[20]=8; r[21]=9; r[22]=11; r[23]=11; 
	r[24]=11; r[25]=12; r[26]=10; r[27]=11; r[28]=14; r[29]=10; r[30]=13; r[31]=12; 
	r[32]=13; r[33]=15; r[34]=11; r[35]=15; r[36]=17; r[37]=5; r[38]=17; r[39]=18; 
}

private static byte[] create__LayoutExpressionLanguage_trans_targs_wi( )
{
	byte[] r = new byte[40];
	init__LayoutExpressionLanguage_trans_targs_wi_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_trans_targs_wi[] = create__LayoutExpressionLanguage_trans_targs_wi();


private static void init__LayoutExpressionLanguage_trans_actions_wi_0( byte[] r )
{
	r[0]=0; r[1]=0; r[2]=3; r[3]=0; r[4]=0; r[5]=13; r[6]=5; r[7]=11; 
	r[8]=17; r[9]=15; r[10]=19; r[11]=19; r[12]=0; r[13]=7; r[14]=0; r[15]=28; 
	r[16]=25; r[17]=0; r[18]=9; r[19]=1; r[20]=0; r[21]=0; r[22]=13; r[23]=5; 
	r[24]=11; r[25]=17; r[26]=15; r[27]=19; r[28]=19; r[29]=0; r[30]=7; r[31]=0; 
	r[32]=0; r[33]=15; r[34]=22; r[35]=0; r[36]=15; r[37]=22; r[38]=0; r[39]=0; 
}

private static byte[] create__LayoutExpressionLanguage_trans_actions_wi( )
{
	byte[] r = new byte[40];
	init__LayoutExpressionLanguage_trans_actions_wi_0( r );
	return r;
}

private static final byte _LayoutExpressionLanguage_trans_actions_wi[] = create__LayoutExpressionLanguage_trans_actions_wi();


static final int LayoutExpressionLanguage_start = 1;
static final int LayoutExpressionLanguage_error = 0;

static final int LayoutExpressionLanguage_en_main = 1;

// line 52 "lib/profligacy/LELParser.rl"

  public int cs, p = 0, pe = 0;

  public boolean scan(String input, LELEventListener listener) {
    int tk_start = 0;
    p = 0;
    String tk = null;

    
// line 223 "lib/profligacy/LELParser.java"
	{
	cs = LayoutExpressionLanguage_start;
	}
// line 61 "lib/profligacy/LELParser.rl"

    pe = input.length();
    char data[] = input.toCharArray();

    
// line 233 "lib/profligacy/LELParser.java"
	{
	int _klen;
	int _trans;
	int _acts;
	int _nacts;
	int _keys;

	if ( p != pe ) {
	if ( cs != 0 ) {
	_resume: while ( true ) {
	_again: do {
	_match: do {
	_keys = _LayoutExpressionLanguage_key_offsets[cs];
	_trans = _LayoutExpressionLanguage_index_offsets[cs];
	_klen = _LayoutExpressionLanguage_single_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + _klen - 1;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( data[p] < _LayoutExpressionLanguage_trans_keys[_mid] )
				_upper = _mid - 1;
			else if ( data[p] > _LayoutExpressionLanguage_trans_keys[_mid] )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				break _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _LayoutExpressionLanguage_range_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + (_klen<<1) - 2;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( data[p] < _LayoutExpressionLanguage_trans_keys[_mid] )
				_upper = _mid - 2;
			else if ( data[p] > _LayoutExpressionLanguage_trans_keys[_mid+1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				break _match;
			}
		}
		_trans += _klen;
	}
	} while (false);

	_trans = _LayoutExpressionLanguage_indicies[_trans];
	cs = _LayoutExpressionLanguage_trans_targs_wi[_trans];

	if ( _LayoutExpressionLanguage_trans_actions_wi[_trans] == 0 )
		break _again;

	_acts = _LayoutExpressionLanguage_trans_actions_wi[_trans];
	_nacts = (int) _LayoutExpressionLanguage_actions[_acts++];
	while ( _nacts-- > 0 )
	{
		switch ( _LayoutExpressionLanguage_actions[_acts++] )
		{
	case 0:
// line 25 "lib/profligacy/LELParser.rl"
	{ tk = input.substring(tk_start, p); }
	break;
	case 1:
// line 26 "lib/profligacy/LELParser.rl"
	{ listener.col(); }
	break;
	case 2:
// line 27 "lib/profligacy/LELParser.rl"
	{ listener.ltab(); }
	break;
	case 3:
// line 28 "lib/profligacy/LELParser.rl"
	{ listener.valign(input.substring(p,p+1)); }
	break;
	case 4:
// line 29 "lib/profligacy/LELParser.rl"
	{ listener.id(input.substring(tk_start, p)); }
	break;
	case 5:
// line 30 "lib/profligacy/LELParser.rl"
	{ listener.row(); }
	break;
	case 6:
// line 31 "lib/profligacy/LELParser.rl"
	{ listener.align(input.substring(p, p+1)); }
	break;
	case 7:
// line 32 "lib/profligacy/LELParser.rl"
	{ listener.setwidth(Integer.parseInt(tk)); }
	break;
	case 8:
// line 33 "lib/profligacy/LELParser.rl"
	{ listener.setheight(Integer.parseInt(tk)); }
	break;
	case 9:
// line 34 "lib/profligacy/LELParser.rl"
	{ listener.expand(); }
	break;
	case 10:
// line 42 "lib/profligacy/LELParser.rl"
	{ tk_start = p; }
	break;
	case 11:
// line 45 "lib/profligacy/LELParser.rl"
	{tk_start = p;}
	break;
// line 354 "lib/profligacy/LELParser.java"
		}
	}

	} while (false);
	if ( cs == 0 )
		break _resume;
	if ( ++p == pe )
		break _resume;
	}
	}	}
	}
// line 66 "lib/profligacy/LELParser.rl"


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
