import java.io.InputStreamReader;

String fileFolder = "../1_midicsvtxt_files/";
String OUTPUT_FOLDER = "../2_carycompressed_files/";


int pitchCount = 110;
int[][] notes = new int[150000][pitchCount];
PrintWriter listings;
String[] filenames;
int currentInstrument = -1;
int firstTrackWithNotes = -1;
float quantizationSize = 40;
int minimumPitch = 22;
Boolean[] allow = new Boolean[128];
Boolean banThisPieceOfMusic = false;
Boolean haveSetTempo = false;
int imageCount = 10000;

String[] loadStringsEncoding(String encoding, String filename) {
  try {
    /* Open a stream to a File (in your data Folder) here */
    InputStream fi = createInput(filename);   
    /* get a reader with your encoding */
    InputStreamReader input = new InputStreamReader(fi, encoding);
    BufferedReader reader = new BufferedReader(input);

    // read the file line by line
    String lines[] = {};
    String line;
    int counter = 0;
    while ((line = reader.readLine()) != null) {
      lines = append(lines, line);
      counter++; 
    }
    reader.close();
    return lines;
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  return null;
}
void setup(){
  listings = createWriter("listings.txt");
  //size(1920,1080);
  size(64,96);
  frameRate(60);
  File[] files = listFiles(fileFolder);
  filenames = new String[files.length];
  for (int i = 0; i < files.length; i++) {
    File f = files[i];
    filenames[i] = f.getName();
  }
}

int fileIndex = 0;
void draw(){
  banThisPieceOfMusic = false;
  for(int i = 0; i < 128; i++){
    allow[i] = true;
  }
  println("Starting file "+fileIndex);
  haveSetTempo = false;
  currentInstrument = -1;
  firstTrackWithNotes = -1;
  String thisFile = filenames[fileIndex];//"t"+file+".txt";//filenames[file];
  
  println(fileFolder+thisFile);
  
  String[] data = loadStrings(fileFolder+thisFile);
  for(int i = 0; i < 150000; i++){
    for(int j = 0; j < pitchCount; j++){
      notes[i][j] = 0;
    }
  }
  int maxPitch = 0;
  int minPitch = 99999;
  int finalTime = 0;
  for(int i = 0; i < data.length; i++){
    String[] parts = data[i].split(", ");
    if(parts.length >= 3 && parts[2].equals("Tempo")){
      if(haveSetTempo){ // MIDI changed "tempo", making it confusing... BAN IT
        banThisPieceOfMusic = true;
      }else{
        float division = (float)(Integer.parseInt(data[0].split(", ")[5]));
        float tempo = (float)(Integer.parseInt(parts[3]));
        quantizationSize = (50000.0/tempo)*division; //40
        println(quantizationSize);
       // haveSetTempo = true;
      }
    }
    if(parts.length >= 5){
      String s = parts[2];
      if(s.equals("Program_c")){
        currentInstrument = Integer.parseInt(parts[4]);
        allow[Integer.parseInt(parts[3])] = (currentInstrument >= 0 && currentInstrument <= 7);
      }
    }
    //if(currentInstrument >= 0 && currentInstrument <= 7 && parts.length >= 6){
    if(parts.length >= 6 && data[i].indexOf("\"") == -1){
      int thisTrack = Integer.parseInt(parts[0]);
      if(allow[Integer.parseInt(parts[3])]){
        firstTrackWithNotes = thisTrack;
        String s = parts[2];
        int time = (int)((Integer.parseInt(parts[1])/quantizationSize));
        int inst = Integer.parseInt(parts[0]);
        int pitch = Integer.parseInt(parts[4]);
        int volume = Integer.parseInt(parts[5]);
        if(time < 150000 && inst <= 8){
          if(s.equals("Note_on_c") && volume >= 1 && notes[time][pitch] == 0){ // File 988 requires volume of 100, not 127.
            notes[time][pitch] = 1;
            if(pitch > maxPitch){
              maxPitch = pitch;
            }
            if(pitch < minPitch){
              minPitch = pitch;
            }
            if(time >= finalTime){
              finalTime = time;
            }
          }else if((s.equals("Note_on_c") && volume == 0) || s.equals("Note_off_c")){
            int j = time;
            while(j >= 0 && notes[j][pitch]%2 == 0){
              j--;
            }
            if(j >= 0){
              int end = time-1;
              if(end < j+1){
                end = j+1;
              }
              for(int k = j; k < end; k++){
                notes[k][pitch] = floor(notes[k][pitch]/2)*2+2;
              }
              if(end-1 >= finalTime){
                finalTime = end-1;
              }
            }
          }
        }
      }
    }
  }
  if(banThisPieceOfMusic){
    println(thisFile+" WILL BE ABORTED");
  }else{
    /*for(int textFile = 0; textFile < 10; textFile++){
      PrintWriter output = createWriter(OUTPUT_FOLDER+"/text"+textFile+".txt");
      for(int y = 24; y < 88; y++){
        for(int x = textFile*15000; x < textFile*15000+15000; x++){
          output.print(min(max(notes[x][y],0),1));
          if(x < textFile*15000+15000-1){
            output.print(" ");
          }
        }
        if(y < 87){
          output.println("");
        }
      }
      output.flush();
      output.close();
      println("Done with "+textFile);
    }
    println("Done");*/
    boolean turnedOn = false;
    for(int transposition = 0; transposition < 6; transposition++){
      PrintWriter output = createWriter(OUTPUT_FOLDER+"/text"+fileIndex+"_"+transposition+".txt");
      for(int x = 0; x < min(150000,finalTime+24); x++){
        for(int y = 24; y < pitchCount; y++){
          if(notes[x][y] >= 1){
            int theNum = (33+(y-minimumPitch+transposition));
            if(theNum >= 33 && theNum <= 126){
              output.print((char)(theNum));
              turnedOn = true;
            }
          }
        }
        if(turnedOn){
          output.print(" ");
        }
        if(x%50 == 49){
          output.println("");
        }
      }
      output.flush();
      output.close();
    }
  }
  Boolean banned = false;
  Boolean hasNote = false;
  for(int start = 0; start < notes.length-192; start += 111){
    background(0);
    banned = false;
    hasNote = false;
    for(int x = start; x < start+192; x++){
      for(int y = 0; y < pitchCount; y++){
        if(notes[x][y] >= 1){
          if(y < 20 || y >= 116){
            banned = true;
          }else{
            int ax = x-start;
            int ay = 115-y;
            color here = get(ax/3,ay);
            color toSetTo = here;
            if(ax%3 == 0){
              toSetTo = color(255,green(here),blue(here));
            }else if(ax%3 == 1){
              toSetTo = color(red(here),255,blue(here));
            }else if(ax%3 == 2){
              toSetTo = color(red(here),green(here),255);
            }
            set(ax/3,ay,toSetTo);
            hasNote = true;
          }
        }
      }
    }
    if(!banned && hasNote){
      //saveFrame("jazzSmalls/imgs/"+imageCount+".png");
      listings.println(thisFile+"\t"+floor(start/20)+"\t"+imageCount);
      imageCount++;
    }
  }
  /*int shift = 0;
  noStroke();
  background(0);
  for(int i = shift; i < shift+2000; i++){
    for(int j = 0; j < pitchCount; j++){
      float c = notes[i][j]*255;
      fill(c,c,c);
      if(banThisPieceOfMusic){
        fill(c,0,0);
      }
      rect((i-shift)*2,1000-j*10,2,10);
    }
  }*/
  //saveFrame(thisFile+".png");

  println(thisFile+" Done");
  if(fileIndex >= filenames.length-1){
    listings.flush();
    listings.close();
    exit();
  }
  fileIndex++;
  
  
}
/*String[] data = loadStrings("C:/Users/Cary/Documents/MIDI/h.txt");
int[][] notes = new int[20000][88];
void setup(){
  for(int i = 0; i < 20000; i++){
    for(int j = 0; j < 88; j++){
      notes[i][j] = 0;
    }
  }
  for(int i = 0; i < 4000; i++){
    String[] parts = data[i].split(", ");
    if(parts.length >= 6){
      String s = parts[2];
      int time = Integer.parseInt(parts[1]);
      int pitch = Integer.parseInt(parts[4]);
      int volume = Integer.parseInt(parts[5]);
      if(time < 20000){
        if(s.equals("Note_on_c")){
          notes[time][pitch] = -volume;
        }else if(s.equals("Note_off_c")){
          int j = time-1;
          while(j >= 0 && notes[j][pitch] >= 0){
            j--;
          }
          if(j >= 0){
            int volumeToBe = -notes[j][pitch];
            for(int k = j; k < time; k++){
              notes[k][pitch] = volumeToBe;
            }
          }
        }
      }
    }
  }
  size(1920,1080);
  noStroke();
  for(int i = 0; i < 2000; i++){
    for(int j = 0; j < 88; j++){
      fill(notes[i*10][j]*2.5);
      rect(i,1000-j*10,1,10);
    }
  }
}*/
