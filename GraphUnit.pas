unit GraphUnit;

interface

uses
  GraphABC;

var
  ActiveWindow: integer;
  Main_Color: Color = RGB(175, 185, 255);
  pic, pic2: Picture;
  BDUser: string;
procedure File_off();
procedure SearchWindow(Width, Height: word);
procedure delWindow(Width, Height: word);
procedure AddWindow(Width, Height: word);
///поле ввода 
procedure Entry_field(x1, y1, x2, y2: integer; Color_fon, Color_Pen: Color; s_text: string );
///Начальное окно авторизации 
procedure WindowUser(Width, Height: word);
///Основное окно программы
procedure WindowMain(Width, Height: word; name: string);
///Кнопка
procedure Button(x1, y1, x2, y2: integer; s_text: string; text_size: word; Color_fon, Color_text, color_pen: Color; StylePera: DashStyle);
implementation


//------------------------------------------//
procedure Entry_field(x1, y1, x2, y2: integer; Color_fon, Color_Pen: Color; s_text: string );
begin
  SetBrushColor(Color_fon);
  SetPenColor(color_pen);
  SetFontColor(clBlack);
  Pen.Width := 2;
  Rectangle(x1, y1, x2, y2);//поле ввода отрисовка
  DrawTextCentered(x1, y1, x2, y2, s_text);//пишем в нем текст 
end;
//------------------------------------------//

//------------------------------------------//
procedure WindowUser(Width, Height: word);
begin
  ActiveWindow := 1;
  Window.SetSize(Width, Height);
  Window.CenterOnScreen();
  Window.IsFixedSize := true;
  Window.Clear(Main_Color);//красим графическое окно
  SetFontColor(clWhite);
  SetFontSize(14);
  //выделяем окно авторизации (белый прямоугольник вокруг)
  SetPenColor(clWhite);
  Rectangle(0, 10, Window.Width, 30);
  Rectangle(0, 580, Window.Width, 590);
  Pen.Width := 3;
  SetBrushColor(Main_Color);
  Rectangle(Window.Center.X - 150, Window.Center.Y - 120, Window.Center.X + 150, Window.Center.Y + 60);
  //надпись "авторизация"
  TextOut(Window.Center.X - 78, Window.Center.Y - 100, 'Имя базы данных:');
  //поле ввода
  SetBrushColor(clWhite);
  Rectangle(Window.Center.X - 100, Window.Center.Y - 60, Window.Center.X + 100, Window.Center.Y - 25);
  //кнопка "Ок"
  Button(Window.Center.X - 80, Window.Center.Y, Window.Center.X + 80, Window.Center.Y + 30, 'Ок', 12, Main_Color, clWhite, clWhite, psSolid);
end;
//------------------------------------------//

//------------------------------------------//
procedure WindowMain(Width, Height: word; name: string);
begin
  Window.SetSize(Width, Height);
  Window.CenterOnScreen();
  Window.IsFixedSize := true;
  Window.Clear(Main_Color);//очищаем графическое окно
  ActiveWindow := 2;//меняем активное окно 
  BDUser := name;
  //if not FileExists(BDUser) then
  //begin end;
  SetBrushColor(Main_Color);
  SetFontSize(14);
  SetFontColor(clBlack);
  TextOut(10, 10, 'База:  ' + name);//вывод имени пользователя
  SetBrushColor(clWhite);
  SetPenColor(clWhite);
  //Rectangle(0, 0, Window.Width, 30);//белая полоса вверху
  SetFontSize(14);
  SetFontColor(clBlack);
  Rectangle(0, 60, Window.Width, 550);
  SetPenStyle(psClear);
  SetBrushColor(clSilver);
  Rectangle(0, 40, Window.Width, 60);
  SetFontSize(10);
  TextOut(20, 40, '№          Артикул                     Наименование                   Количество                      Цена,1шт                               Цена');
  SetPenStyle(psSolid);
  SetPenColor(clBlack);
  SetPenWidth(1);
  Line(50, 40, 50, 550);
  Line(150, 40, 150, 550);
  Line(350, 40, 350, 550);
  Line(450, 40, 450, 550);
  Line(620, 40, 620, 550);
  Button(20, 560, 100, 585, 'Добавить', 10, Main_Color, clBlue, clBlue, psSolid);
  Button(120, 560, 200, 585, 'Найти', 10, Main_Color, clBlue, clBlue, psSolid);
  Button(220, 560, 300, 585, 'Удалить', 10, Main_Color, clBlue, clBlue, psSolid);
end;
//------------------------------------------//

//------------------------------------------//
procedure AddWindow(Width, Height: word);
begin
  Window.SetSize(Width, Height);
  Window.CenterOnScreen();
  Window.IsFixedSize := true;
  ActiveWindow := 3;//меняем активное окно 
  SetBrushColor(Main_Color);
  SetPenColor(Main_Color);
  Rectangle(0, 0, Window.Width, 600);
  SetFontSize(16);
  SetFontColor(clBlack);
  TextOut(10, 10, 'Добавление');
  SetBrushColor(clWhite);
  SetPenColor(clWhite);
  Rectangle(50, 60, 300, 85);
  Rectangle(50, 120, 300, 145);
  Rectangle(50, 180, 300, 205);
  Rectangle(50, 240, 300, 265);
  
  SetBrushColor(Main_Color);
  SetFontSize(10);
  TextOut(50, 40, 'Артикул');
  TextOut(50, 100, 'Наименование');
  TextOut(50, 160, 'Количество');
  TextOut(50, 220, 'Стоимость');
  
  Button(50, 300, 550, 320, 'Добавить', 12, clWhite, clBlack, clWhite, psSolid);
  Button(50, 340, 550, 360, 'Назад', 12, clWhite, clBlack, clWhite, psSolid);
  
  pic := Picture.Create(200, 200);
  pic.Load('1.png');
  pic.Draw(350, 50, 200, 200);
end;
//------------------------------------------//

procedure SearchWindow(Width, Height: word);
begin
  Window.SetSize(Width, Height);
  Window.CenterOnScreen();
  Window.IsFixedSize := true;
  ActiveWindow := 4;//меняем активное окно 
  SetBrushColor(Main_Color);
  SetPenColor(Main_Color);
  Rectangle(0, 0, Window.Width, 600);
  SetFontSize(16);
  SetFontColor(clBlack);
  TextOut(10, 10, 'Поиск');
  SetBrushColor(clWhite);
  SetPenColor(clWhite);
  Rectangle(50, 60, 300, 85);
  
  SetBrushColor(Main_Color);
  SetFontSize(10);
  TextOut(50, 40, 'По наименование');
  
  
  Button(50, 300, 550, 320, 'Найти', 12, clWhite, clBlack, clWhite, psSolid);
  Button(50, 340, 550, 360, 'Назад', 12, clWhite, clBlack, clWhite, psSolid);
  
  pic := Picture.Create(200, 200);
  pic.Load('1.png');
  pic.Draw(350, 50, 200, 200);
end;

procedure delWindow(Width, Height: word);
begin
  Window.SetSize(Width, Height);
  Window.CenterOnScreen();
  Window.IsFixedSize := true;
  ActiveWindow := 5;//меняем активное окно 
  SetBrushColor(Main_Color);
  SetPenColor(Main_Color);
  Rectangle(0, 0, Window.Width, 600);
  SetFontSize(16);
  SetFontColor(clBlack);
  TextOut(10, 10, 'Удаление');
  SetBrushColor(clWhite);
  SetPenColor(clWhite);
  Rectangle(50, 60, 300, 85);
  
  SetBrushColor(Main_Color);
  SetFontSize(10);
  TextOut(50, 40, 'Номер записи');
  
  
  Button(50, 300, 550, 320, 'Удалить', 12, clWhite, clBlack, clWhite, psSolid);
  Button(50, 340, 550, 360, 'Назад', 12, clWhite, clBlack, clWhite, psSolid);
  
  pic := Picture.Create(200, 200);
  pic.Load('1.png');
  pic.Draw(350, 50, 200, 200);
end;

//------------------------------------------//
procedure Button(x1, y1, x2, y2: integer; s_text: string; text_size: word; Color_fon, Color_text, color_pen: Color; StylePera: DashStyle);
begin
  SetBrushColor(Color_fon);
  SetFontColor(Color_text);
  SetPenStyle(StylePera);
  SetPenColor(color_pen);
  SetFontSize(text_size);
  Pen.Width := 3;
  rectangle(x1, y1, x2, y2);//ресуем кнопку по координатам 
  DrawTextCentered(x1, y1, x2, y2, s_text);//надпись в кнопке 
end;
//------------------------------------------//
procedure File_off();
begin
  SetBrushColor(clTransparent);
  SetFontColor(clRed);
  SetFontSize(20);
  TextOut(Window.Center.X - 300, Window.Center.Y - 30, 'Бд не существует, для создания добавьте запись');
  SetFontColor(clBlack);
end;
end.