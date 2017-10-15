unit MainUnit;

interface

uses
  GraphABC,GraphUnit;
  
  type
  BD = record
    num, artikul, quantity: integer;
    name: string[50];
    value, Full_value: real;
  end;
  poisk = record
    flag: boolean;
    search: integer;
  end;
var
  k: integer := 0;
  stroka: string;//для хранения введенной строки 
  ActRegionText: byte = 1;//флаг выделеной области
  RecAdd: BD;//переменная для записи 
  mas_zapis: array of BD;
  list:integer = 0;
  err: boolean;//ошибка ввода
  error_mas: array of boolean;//для нескольких полей ввода 
  search_name: string;//имя для поиска в бд 
  delite: byte;//номер записи для удаления 
  f: file of BD;//файловая переменная 
  
  //-----------------Алфовит-----------------//
  mas_l: array of string = ('Ф', 'И', 'С', 'В', 'У', 'А', 'П', 'Р', 
                            'Ш', 'О', 'Л', 'Д', 'Ь', 'Т', 'Щ', 'З', 
                            'Й', 'К', 'Ы', 'Е', 'Г', 'М', 'Ц', 'Ч', 
                            'Н', 'Я', '0', '1', '2', '3', '4', '5', 
                            '6', '7', '8', '9', 'Б', 'Ж', 'Ю', 'Х', 'Ъ', 'Э');
  
  mas_n: array of byte = (65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 
                          75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 
                          85, 86, 87, 88, 89, 90, 48, 49, 50, 51, 
                          52, 53, 54, 55, 56, 57, 188, 186, 190, 219, 221, 222);
 //---------------Алфовит-end---------------//

///обработчик событий на мышь
procedure MouseDown(x, y, mb: integer);
///обработчик событий на клавиши
procedure KeyDown(Key: integer);

procedure Entry(st: BD; Act: boolean; y: integer);
implementation

procedure Entry(st: BD; Act: boolean; y: integer);
begin
  Button(0, y, 49, y + 20, IntToStr(st.num), 9, clWhite, clBlack, clBlack, psClear);
  Button(52, y, 149, y + 20, IntToStr(st.artikul), 9, clWhite, clBlack, clBlack, psClear);
  Button(152, y, 349, y + 20, st.name, 9, clWhite, clBlack, clBlack, psClear);
  Button(352, y, 449, y + 20, IntToStr(st.quantity), 9, clWhite, clBlack, clBlack, psClear);
  Button(452, y, 619, y + 20, FloatToStr(st.value), 9, clWhite, clBlack, clBlack, psClear);
  Button(622, y, 799, y + 20, FloatToStr(st.Full_value), 9, clWhite, clBlack, clBlack, psClear);
end;

//------------------------------------------//
///Функция для подсчета полной стоимости 
function FValue(kol: integer; value: double): double;
begin
  result := value * kol;
end;
//------------------------------------------//

//------------------------------------------//
///Отчистка строки 
procedure NullStr(var str: BD);
begin
  str.artikul := 0;
  str.name := '';
  str.value := 0;
  str.quantity := 0;
end;
//------------------------------------------//

//------------------------------------------//
///Алфавит
procedure WriteText(key: integer; var s: string);
begin
  case key of
    48..57, 65..90, 188, 186, 190, 219, 221, 222: 
      for var i := 0 to 41 do 
        if mas_n[i] = key then s += mas_l[i]; 
  end;
end;
//------------------------------------------//

//------------------------------------------//
///удаляем последний символ
procedure Beckspace_Text(x1, y1, x2, y2, x, y: integer; var s: string);
begin
  Delete(s, Length(s), 1);
  SetBrushColor(clWhite);
  SetFontColor(clBlack);
  SetPenColor(clWhite);
  Rectangle(x1, y1, x2, y2);
  TextOut(x, y, s);
end;
//------------------------------------------//

//------------------------------------------//
/// процедура ограничения изменения клавишь. указать количество всех клавишь и переменную в которую вернуть значение 
procedure limitation(n: byte; var Akey: byte);
begin
  if Akey = 0 then Akey := n;
  if Akey = n + 1 then Akey := 1;
end;
//------------------------------------------//

//------------------------------------------//
///конвертация строки в число, если строка не число то вернет 0. так же выводит крестик 
function TestStrinig(y1, y2: integer; str: string): integer;
begin
  try
    Result := StrToInt64(str); 
    error_mas[ActRegionText-1] := false;
    SetBrushColor(Main_Color);
    SetPenColor(Main_Color);
    Rectangle(320, y1, 345, y2);
  except
    Result := 0;
    error_mas[ActRegionText-1] := true;
    pic2 := Picture.Create(25, 25);
    pic2.Load('2.png');
    pic2.Draw(320, y1, 25, 25);
  end;
  for var i := 0 to 3 do 
    if error_mas[i] = true then 
    begin
    err:=true;
    break;
    end else err:= false;
    
end;
//------------------------------------------//

//------------------------------------------//
///добавление записи в бд
procedure addStr(var st: BD);
var
  temp: BD;
  i: integer = 0;
begin
  Assign(f, 'БД\' + BDUser + '.dat');
  Reset(f);
  while not EoF(f) do
  begin
    Read(f, temp);
    Inc(i);
  end;
  Inc(i);
  st.num := i;
  st.Full_value := FValue(st.quantity, st.value);
  Seek(f, filesize(f));
  write(f, st);
  Close(f);
end;
//------------------------------------------//

//------------------------------------------//
///поиск по файлу по имени 
function Search(name: string): poisk;
var
  list: BD;
  i: integer;
begin
  Assign(f, 'БД\' + BDUser + '.dat');
  reset(f);
  i := 0;
  while not EoF(f) do
  begin
    read(f, list);
    if list.name = name then 
    begin
      Result.flag := true;
      Result.search := i;
      break;
    end
      else
    begin
      inc(i);
      Result.flag := false;
    end;
  end;
  close(f);    
end;
//------------------------------------------//

//------------------------------------------//
procedure DelStr(Nstr: byte);
var
  temp_p: BD;
begin
  Assign(f, 'БД\' + BDUser + '.dat');
  reset(f);
  if FileSize(f) >= Nstr then
  begin
    seek(f, Nstr - 1);
    for var i := Nstr - 1 to filesize(f) - 2 do
    begin
      seek(f, i + 1);
      read(f, temp_p);
      temp_p.num := i + 1;
      seek(f, i);
      write(f, temp_p);
    end;
    seek(f, filesize(f) - 1);
    truncate(f);
  end;
  close(f);
end;
//------------------------------------------//

//------------------------------------------//
///создает файл с имене name
procedure BDCreate(name: string);
begin
  Assign(f, 'БД\' + name + '.dat');
  Rewrite(f); 
  Close(f);
end;
//------------------------------------------//

//------------------------------------------//
///вывод бд
//procedure BDWrite2(name: string);
//var
 // i: integer;
//begin
 // Assign(f, 'БД\' + name + '.dat');
 // Reset(f);
 // while not EoF(f) do
 // begin
 //   read(f, RecAdd);
 //   Inc(i);
 //   Entry(RecAdd, false, 40 + i * 20);
 // end;
 // Close(f);
//end;
//------------------------------------------//

procedure razdelenie_str(mas: array of BD; str:word);
begin 
  for var i:= Str * 23 to (str +1)* 23 do 
  begin 
  try 
    Entry(mas[i], false, 40 + (i - str * 23 + 1) * 20);
  except
    break;
  end;
  end;
end;

procedure BDWrite(name:string);
begin
  Assign(f, 'БД\' + name + '.dat');
  Reset(f);
  k:=0;
   while not EoF(f) do
  begin
    read(f, RecAdd);
    Inc(k);
  end;
  SetLength(mas_zapis,k);
  k:=0;
  Seek(f,0);
  while not EoF(f) do
  begin
    read(f, RecAdd);
    
    mas_zapis[k]:=RecAdd;
    Inc(k);
  end;
  RecAdd.artikul:=0;
  RecAdd.Full_value:=0;
  RecAdd.name:='';
  RecAdd.num:=k;
  RecAdd.quantity:=0;
  RecAdd.value:=0;
  razdelenie_str(mas_zapis, list);
  Close(f);
end;
//------------------------------------------//
procedure Key_08(var str: string);
begin
  case ActRegionText of //проверка на активную область
    1:
      begin
        Beckspace_Text(50, 60, 300, 85, 50, 63, str); 
        if ActiveWindow = 3 then RecAdd.artikul := TestStrinig(60, 85, str); 
        if ActiveWindow = 4 then search_name := str; 
        if ActiveWindow = 5 then delite := TestStrinig(60, 85, str); 
      end;
    2:
      begin
        Beckspace_Text(50, 120, 300, 145, 50, 123, str); 
        RecAdd.name := stroka; 
      end;
    3:
      begin
        Beckspace_Text(50, 180, 300, 205, 50, 183, str);
        RecAdd.quantity := TestStrinig(180, 205, str);  
      end;
    4:
      begin
        Beckspace_Text(50, 240, 300, 265, 50, 243, str);
        RecAdd.value := TestStrinig(240, 265, str); 
      end;
  end; 
end;
//------------------------------------------//

//------------------------------------------//
procedure Key_Text(var str: string);
begin
  case ActRegionText of //проверка на активную область
    1: 
      begin
        TextOut(50, 63, str); 
        if ActiveWindow = 3 then RecAdd.artikul := TestStrinig(60, 85, str);
        if ActiveWindow = 4 then begin TextOut(50, 63, stroka);  search_name := stroka; end;
        if ActiveWindow = 5 then begin TextOut(50, 63, stroka); delite := TestStrinig(60, 85, stroka); end;
      end;
    2: 
      begin
        TextOut(50, 123, str); 
        RecAdd.name := str; 
      end;
    3: 
      begin
        TextOut(50, 183, str);
        RecAdd.quantity := TestStrinig(180, 205, str); 
      end;
    4:
      begin
        TextOut(50, 243, str); 
        RecAdd.value := TestStrinig(240, 265, str); 
      end;
  end;
end;
//------------------------------------------//

//------------------------------------------//
procedure KeyDown(Key: integer);
begin
  case ActiveWindow of //проверка активного окна
    1:
      begin
        if Length(stroka) <= 12 then //ограничение на количество символов 
        begin
          WriteText(Key, stroka); //заполняем строку
          BDUser := stroka; //присваивание значение переменной с именем файла
          SetBrushColor(clWhite);
          SetFontColor(clBlack);
          TextOut(Window.Center.X - 100, Window.Center.Y - 50, stroka);//вывод 
        end;
        if Key = 08 then //если нажат Backspace 
          Beckspace_Text(Window.Center.X - 100, Window.Center.Y - 60, Window.Center.X + 100, Window.Center.Y - 25, Window.Center.X - 100, Window.Center.Y - 50, stroka);
        if Key = 13 then //если enter
        begin
          WindowMain(800, 600, BDUser);//загружаем основное окно программы 
          stroka := ''; //обнуляем строку
          if FileExists('БД\' + BDUser + '.dat') then //проверка на существование 
            BDWrite(BDUser) else File_off();
        end;
      end;
    2: begin 
          case key of
          VK_Left: 
            begin
              list-=1;
              if list < 0 then  list := 0 ;
              WindowMain(800, 600, BDUser);
              razdelenie_str(mas_zapis, list);
              
            end;
            
          VK_Right: 
            begin
              list+=1;
              if list > (k div 24) then  list := 0;
            WindowMain(800, 600, BDUser);
            razdelenie_str(mas_zapis, list);
            end;
        end;
       end;
    3:
      begin
        case key of
          //------изминение выделеной строки------//
          VK_Up: 
            begin
              stroka := ''; 
              Dec(ActRegionText); 
              limitation(4, ActRegionText); 
            end;
          VK_Down: 
            begin
              stroka := ''; 
              Inc(ActRegionText); 
              limitation(4, ActRegionText); 
            end;
          //----изминение выделеной строки end----// 
          48..57, 65..90, 188, 186, 190, 219, 221, 222, 08:  
            begin
              if Length(stroka) <= 15 then
              begin
                WriteText(Key, stroka);
                SetBrushColor(clWhite);
                SetFontColor(clBlack);
                Key_Text(stroka);
              end;
              
              if Key = 08 then Key_08(stroka);//если нажат Backspace
            end; 
        
        end;
        
        if Key = 13 then
          if err = false then 
          begin
            if not FileExists('БД\' + BDUser + '.dat') then  
              BDCreate(BDUser); 
            
            addStr(RecAdd); 
            WindowMain(800, 600, BDUser);
            BDWrite(BDUser);
            stroka := '';
            ActRegionText := 1;
            NullStr(RecAdd);
          end;
      end;
    
    4:
      begin
        if Length(stroka) <= 15 then 
        begin
          WriteText(Key, stroka);
          SetBrushColor(clWhite);
          SetFontColor(clBlack);
          Key_Text(stroka);
        end;
        if Key = 08 then Key_08(stroka);
        
        if Key = 13 then 
        begin
          var temp_p: poisk;
          
          temp_p := Search(search_name);
          WindowMain(800, 600, BDUser);
          if temp_p.flag = true then 
          begin
            Assign(f, 'БД\' + BDUser + '.dat');
            Reset(f);
            Seek(f, temp_p.search);
            Read(f, RecAdd);
            Close(f);
            Entry(RecAdd, false, 60); 
          end;
          stroka := '';
          ActRegionText := 1;
          NullStr(RecAdd);
        end;
      end;
    
    5:
      begin
        if Length(stroka) <= 15 then 
        begin
          WriteText(Key, stroka);
          SetBrushColor(clWhite);
          SetFontColor(clBlack);
          Key_Text(stroka);
        end;
        
        if Key = 08 then Key_08(stroka);
        if Key = 13 then
          if (delite < 25) and (delite > 0) then 
          begin
            stroka := '';
            ActRegionText := 1;
            WindowMain(800, 600, BDUser);
            DelStr(delite);
            BDWrite(BDUser);
            NullStr(RecAdd);
          end;
        
      end;
  end;
end;
//------------------------------------------//

//------------------------------------------//
///функция проверки области, если x0 лежит в промежутке от x1 до x2 вернет true
function Active_area(x0, x1, x2: integer): boolean;
begin
  if ((x0 > x1) and (x0 < x2)) then Result := true else
    Result := false;
end;
//------------------------------------------//

//------------------------------------------//
procedure MouseDown(x, y, mb: integer);
begin
  if mb = 1 then//если нажата левая клавиша мыши
    case ActiveWindow of 
      1: 
        begin
          if Active_area(x, Window.Center.X - 80, Window.Center.X + 80) and Active_area(y, Window.Center.Y, Window.Center.Y + 30) then
          begin
            WindowMain(800, 600, BDUser); 
            stroka := ''; 
            BDWrite(BDUser);
          end;
        end;
      
      2: 
        begin
          if Active_area(y, 560, 585) then
          begin
            if Active_area(x, 20, 100) then AddWindow(800, 600);
            if Active_area(x, 120, 200) then SearchWindow(800, 600);
            if Active_area(x, 220, 300) then delWindow(800, 600);
          end;
        end;
        
      3, 4, 5:
        begin
          if Active_area(y, 340, 360) then
          begin
            if Active_area(x, 50, 550) then 
            begin
              WindowMain(800, 600, BDUser);
              if FileExists('БД\' + BDUser + '.dat') then begin  //проверка на существование 
                SetLength(mas_zapis,0);
                BDWrite(BDUser); end else File_off();
              stroka := '';
              ActRegionText := 1;
              NullStr(RecAdd);
            end;
          end;
          
          if Active_area(y, 300, 320) then
          begin
            
            if Active_area(x, 50, 550) then
            begin
              if ActiveWindow = 3 then
                if err = false then 
                begin
                  if not FileExists('БД\' + BDUser + '.dat') then  
                    BDCreate(BDUser); 
                  
                  addStr(RecAdd); 
                  WindowMain(800, 600, BDUser);
                  SetLength(mas_zapis,0);
                  BDWrite(BDUser);
                  stroka := '';
                  ActRegionText := 1;
                  NullStr(RecAdd);
                end;
              
              if ActiveWindow = 4 then
              begin
                var temp_p: poisk;
                
                temp_p := Search(search_name);
                WindowMain(800, 600, BDUser);
                if temp_p.flag = true then 
                begin
                  Assign(f, 'БД\' + BDUser + '.dat');
                  Reset(f);
                  Seek(f, temp_p.search);
                  Read(f, RecAdd);
                  Close(f);
                  Entry(RecAdd, false, 60); 
                end;
                stroka := '';
                ActRegionText := 1;
                NullStr(RecAdd);
              end;
              
              if ActiveWindow = 5 then
                begin
                  stroka := '';
                  ActRegionText := 1;
                  WindowMain(800, 600, BDUser);
                  DelStr(delite);
                  SetLength(mas_zapis,0);
                  BDWrite(BDUser);
                end;
                
            end;
            
          end;
        end;
    end;
end;
//------------------------------------------//

begin 
SetLength(error_mas,4);
for var i :=0 to 3 do 
error_mas[i]:=false;
end.