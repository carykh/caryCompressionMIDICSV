String INPUT_FILE = "../2_carycompressed_files/text2_1.txt";
String OUTPUT_FILE = "../3_reconstructed_midicsvtxt_files/reconstructed_text2_1.txt";
String OUTPUT_IMAGE = "../3_reconstructed_midicsvtxt_files/reconstructed_text2_1.png";
String[] data;
int pitchCount = 116;
Boolean[][] notes = new Boolean[20000][pitchCount];
PrintWriter output;
int multi = 40;
void setup(){
  data = loadStrings(INPUT_FILE);
  for(int i = 0; i < 20000; i++){
    for(int j = 0; j < pitchCount; j++){
      notes[i][j] = false;
    }
  }
  int pointerAt = 0;
  for(int line = 0; line < data.length; line++){
    for(int ch = 0; ch < data[line].length(); ch++){
      char c = data[line].charAt(ch);
      int pitch = (int)(c)-32-1;//+19;
      if(c == ' '){
        pointerAt++;
      }else{
        notes[pointerAt][pitch] = true;
      }
    }
  }
  pointerAt++;
  size(1920,1080);
  noStroke();
  background(0);
  fill(255);
  int shift = 960;
  for(int i = 0; i < 1000; i++){
    for(int j = 0; j < 87; j++){
      if(notes[i+shift][j]){
        rect(i*2,(86-j)*10,2,10);
      }
    }
  }
  output = createWriter(OUTPUT_FILE);
  output.println("0, 0, Header, 1, 3, 384");
  output.println("1, 0, Start_track");
  output.println("1, 0, Time_signature, 4, 2, 24, 8");
  output.println("1, 0, Tempo, 500000");
  output.println("1, "+(pointerAt*multi)+", End_track");
  output.println("2, 0, Start_track");
  output.println("2, 0, Text_t, \"random instrument: random person i dunno whatev\"");
  output.println("2, 0, Title_t, \"Track 1\"");
  for(int i = 0; i < pointerAt; i++){
    for(int j = 0; j < 87; j++){
      if(notes[i][j] && (i == 0 || !notes[i-1][j])){
        output.println("2, "+(i*multi)+", Note_on_c, 1, "+(j+21)+", 127");
      }
      if(!notes[i][j] && i >= 1 && notes[i-1][j]){
        output.println("2, "+(i*multi)+", Note_off_c, 1, "+(j+21)+", 0");
      }
    }
  }
  output.println("2, "+(pointerAt*multi)+", End_track");
  output.println("3, 0, Start_track");
  output.println("3, 0, Title_t, \"MIDI\"");
  output.println("3, 1536, End_track");
  output.println("0, 0, End_of_file");
  output.flush();
  output.close();
  saveFrame(OUTPUT_IMAGE);
}
