#ifndef DRAW_LINE_H
#define DRAW_LINE_H

#include "basic.h"


class Draw_Line:QGraphicsPathItem
{
  public:

   struct EdgeLine
   {
     QPointF pnt;
     int next_line;
     int prev_line;
   };

   Draw_Line();
   ~Draw_Line();

   //stores the intial or starting point of the polygon
   void setStartPoint(QPointF pnt);

   //stores the intial or starting point of the polygon
   void setEndPoint(QPointF pnt);

   //sets the remaing points of polygon
   void setPnt(QPointF pnt);

   //get the start and edges of polygon
   QPointF getStartPnt();
   QPointF getEndPnt();

   //set the draw mode
   void set_draw_mode(bool);

   //get draw mode
   bool get_draw_mode();

   //checking the mouse position to resize and move line
   bool isMouseClickedOnHandle(const QPointF pnt);
   bool isMouseClickedOnShape(const QPointF pnt);
   bool isMouseClickedOnRotateHandle(const QPointF pnt);
   bool isClickedOnHandleOrShape(QPointF point);

   void setTranslate(QPointF pnt,QPointF pnt1);
   void setRotate(const QPointF &pnt,const QPointF &pnt1);
   void setScale(float x,float y);

   //void translate_items(QPointF pnt,QPointF pnt1);

   virtual QPointF getTranslate(){return QPointF(0,0);}
   virtual float getRotate(float angle){return 0;}
   virtual QPointF getScale(float x,float y){return QPointF(0,0);}

   void setLine(QLineF pline);
   void setLine(int indx,QLineF pline);
   void setLines(QVector<QGraphicsLineItem*> plines);


   QGraphicsLineItem* getLine();
   QGraphicsLineItem* getLine(int indx);
   QVector<QGraphicsLineItem*> getLines();
   void clear_lines();

   QPainterPath getPolyLine();
   void drawEdges();
   QPainterPath getPolyLine(int indx,QPointF pnt1,QPointF pnt2);

   //writes the shapes and shapes attributes to an image
   void drawImage(QPainter *painter,QString &text,QPointF point);

   int getState();
   void setState(int State);

   void setPolyLineDrawn(bool draw_state)
   {
        line_draw_state=draw_state;
   }

   bool getPolyLineDrawn()
   {
        return line_draw_state;
   }

   void setPen(const QColor color);
   void setPenStyle(const int style);
   void setPenWidth(const int width);
   QPen getPen();


   //show handles
   void showHandles();
   //hide handles
   void hideHandles();

   //return the handle index
   int getHandelIndex();

   //rotate the shapes
   void rotateShape(float angle);

   QVector<QGraphicsLineItem*> lines;

   QGraphicsPathItem* item;
   QVector<QGraphicsRectItem*> edge_items;
   QGraphicsEllipseItem *Rot_Rect;

   QVector<QPointF> poly_pnts;

   QVector<EdgeLine> edgelines;

   float angle;

   bool isObjectSelected;

 private:

   void setEdgeLines();

   bool line_draw_mode,line_draw_state;
   int draw_state,handle_index;
   QGraphicsLineItem* line;
   QPen pen;
   QBrush brush;

};

#endif // DRAW_LINE_H
