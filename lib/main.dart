import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
void main()=>runApp(const GenesisOffice());
const bg=Color(0xFF101825),panel=Color(0xFF192838),mint=Color(0xFF76DDBC),gold=Color(0xFFF2C37C);
class Agent {
 final String name,role;
 final Color color;
 final double x,y;
 const Agent(this.name,this.role,this.color,this.x,this.y);
}
const team=<Agent>[
 Agent('Gerente','Coordenação',gold,0.7636,0.2657),
 Agent('Prospecção','Pesquisa comercial',Color(0xFF78D1D2),0.1391,0.6657),
 Agent('Vendas 1','Primeiro contato',Color(0xFF83ABEE),0.2491,0.6657),
 Agent('Vendas 2','Qualificação',Color(0xFFB7A2ED),0.2482,0.7857),
 Agent('Marketing','Campanhas',Color(0xFFF4A1BC),0.1427,0.2671),
 Agent('Desenvolvimento','Soluções',Color(0xFF93D993),0.4636,0.6886),
 Agent('Finanças','Indicadores',Color(0xFFECD17C),0.7109,0.6657),
 Agent('Negócios','Estratégia',Color(0xFFF0AA86),0.8645,0.7857),
];
class GenesisOffice extends StatelessWidget {
 const GenesisOffice({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'Gênesis Virtual Office',theme:ThemeData(useMaterial3:true,brightness:Brightness.dark,scaffoldBackgroundColor:bg,colorScheme:ColorScheme.fromSeed(seedColor:mint,brightness:Brightness.dark)),home:const OfficeHome());
}
class OfficeHome extends StatefulWidget {const OfficeHome({super.key});@override State<OfficeHome> createState()=>_OfficeHomeState();}
class _OfficeHomeState extends State<OfficeHome> with SingleTickerProviderStateMixin {
 late final AnimationController animation;
 late final RetroOfficeGame officeGame;
 final Map<String,List<String>> chats={for(final a in team)a.name:<String>[]};
 int screen=0; bool running=true;
 @override void initState(){super.initState();animation=AnimationController(vsync:this,duration:const Duration(seconds:5))..repeat();officeGame=RetroOfficeGame();}
 @override void dispose(){animation.dispose();super.dispose();}
 @override Widget build(BuildContext context){
  final mobile=MediaQuery.sizeOf(context).width<800;
  return Scaffold(appBar:AppBar(backgroundColor:panel,title:Row(children:[const Icon(Icons.apartment,color:mint),const SizedBox(width:9),Flexible(child:Text(mobile?'GÊNESIS':'GÊNESIS / VIRTUAL OFFICE',overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w900,letterSpacing:1.4,fontSize:16)))]),actions:[const Padding(padding:EdgeInsets.only(right:18),child:Center(child:Text('DEMO',style:TextStyle(color:gold,fontWeight:FontWeight.w900))))]),body:Column(children:[Container(width:double.infinity,color:const Color(0xFF503823),padding:const EdgeInsets.all(9),child:const Text('DEMONSTRAÇÃO: animações, chats e indicadores são ilustrativos. Nenhum agente ou serviço está conectado.',textAlign:TextAlign.center,style:TextStyle(color:Color(0xFFFFD6A0),fontSize:11))),Expanded(child:mobile?_body():Row(children:[NavigationRail(backgroundColor:panel,selectedIndex:screen,labelType:NavigationRailLabelType.all,onDestinationSelected:(i)=>setState(()=>screen=i),destinations:const [NavigationRailDestination(icon:Icon(Icons.grid_view),label:Text('Escritório')),NavigationRailDestination(icon:Icon(Icons.analytics_outlined),label:Text('Painel')),NavigationRailDestination(icon:Icon(Icons.groups),label:Text('Equipe')),NavigationRailDestination(icon:Icon(Icons.meeting_room),label:Text('Reunião'))]),Expanded(child:_body()),if(screen==0)SizedBox(width:240,child:_sidePanel())]))]),bottomNavigationBar:mobile?NavigationBar(selectedIndex:screen,onDestinationSelected:(i)=>setState(()=>screen=i),destinations:const [NavigationDestination(icon:Icon(Icons.grid_view),label:'Escritório'),NavigationDestination(icon:Icon(Icons.analytics_outlined),label:'Painel'),NavigationDestination(icon:Icon(Icons.groups),label:'Equipe'),NavigationDestination(icon:Icon(Icons.meeting_room),label:'Reunião')]):null);
 }
 Widget _body()=>switch(screen){0=>_office(),1=>_dashboard(),2=>_team(),_=>_meeting()};
 Widget _office() {
  return Column(children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ESCRITÓRIO VIRTUAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          Text('Toque em um personagem para conversar', style: TextStyle(color: Colors.white60, fontSize: 11)),
        ])),
        FilledButton.tonalIcon(
          onPressed: () => setState(() { running = !running; officeGame.running = running; }),
          icon: Icon(running ? Icons.pause : Icons.play_arrow),
          label: Text(running ? 'Pausar' : 'Iniciar'),
        ),
      ]),
    ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            color: const Color(0xFF344854),
            child: Stack(children: [
                  Positioned.fill(child: GameWidget(game: officeGame)),
                  for (final a in team)
                    Align(
                      alignment: Alignment(a.x * 2 - 1, a.y * 2 - 1),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _chat(a),
                        child: const SizedBox(width: 70, height: 75),
                      ),
                    ),
                  Positioned(
                    top: 11,
                    left: 11,
                    child: Container(
                      color: panel,
                      padding: const EdgeInsets.all(8),
                      child: const Text('GÊNESIS • HQ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                    ),
                  ),
                  const Positioned(
                    bottom: 11,
                    left: 10,
                    right: 10,
                    child: Text('Movimentação demonstrativa — aguardando telemetria real dos agentes.',
                        style: TextStyle(color: Colors.white70, fontSize: 10)),
                  ),
                ]),
          ),
        ),
      ),
    ),
  ]);
 }
 Widget _sidePanel()=>Container(color:panel,child:ListView(children:[const Padding(padding:EdgeInsets.all(18),child:Text('EQUIPE / STATUS',style:TextStyle(fontWeight:FontWeight.bold))),...team.asMap().entries.map((entry)=>ListTile(dense:true,onTap:()=>_chat(entry.value),leading:CircleAvatar(backgroundColor:entry.value.color,child:const Icon(Icons.person,color:bg,size:17)),title:Text(entry.value.name,style:const TextStyle(fontSize:12)),subtitle:Text(running&&entry.key%4!=0?'Trabalhando • demo':'Disponível • demo',style:const TextStyle(fontSize:10,color:mint))))]));
 Widget _dashboard()=>ListView(padding:const EdgeInsets.all(20),children:[const Text('PAINEL DE CONTROLE',style:TextStyle(fontWeight:FontWeight.w900,fontSize:22)),const Text('Informações ilustrativas',style:TextStyle(color:Colors.white60)),const SizedBox(height:20),Wrap(spacing:12,runSpacing:12,children:[_metric('Funcionários','8',Icons.groups),_metric('Em atividade',running?'6':'0',Icons.computer),_metric('Pendências','0',Icons.warning_amber),_metric('Expediente','08h–16h',Icons.access_time)]),const SizedBox(height:26),const Text('ATIVIDADE RECENTE',style:TextStyle(fontWeight:FontWeight.bold)),Card(color:panel,child:const ListTile(leading:Icon(Icons.info_outline,color:gold),title:Text('Ambiente demonstrativo'),subtitle:Text('Conecte a API segura e o agente local para receber eventos reais.')))]);
 Widget _metric(String title,String value,IconData icon)=>Container(width:190,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(12)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,color:mint),const SizedBox(height:12),Text(value,style:const TextStyle(fontSize:23,fontWeight:FontWeight.w900)),Text(title,style:const TextStyle(color:Colors.white60,fontSize:12))]));
 Widget _team()=>ListView(padding:const EdgeInsets.all(16),children:[const Text('SUA EQUIPE',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900)),const SizedBox(height:16),...team.map((a)=>Card(color:panel,child:ListTile(onTap:()=>_chat(a),leading:CircleAvatar(backgroundColor:a.color,child:const Icon(Icons.person,color:bg)),title:Text(a.name),subtitle:Text(a.role),trailing:const Icon(Icons.chat_outlined))))]);
 Widget _meeting()=>const Center(child:Padding(padding:EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.meeting_room_outlined,size:90,color:gold),SizedBox(height:18),Text('SALA DE REUNIÃO',style:TextStyle(fontWeight:FontWeight.w900,fontSize:22)),SizedBox(height:10),Text('Tela preparada. As reuniões multiagente reais dependem da próxima etapa de integração.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white70))])));
 void _chat(Agent agent){
  final field=TextEditingController();
  showModalBottomSheet<void>(context:context,isScrollControlled:true,backgroundColor:panel,builder:(sheet)=>StatefulBuilder(builder:(sheet,update)=>Padding(padding:EdgeInsets.only(bottom:MediaQuery.viewInsetsOf(sheet).bottom),child:SizedBox(height:math.min(MediaQuery.sizeOf(sheet).height*.8,560),child:Column(children:[ListTile(leading:CircleAvatar(backgroundColor:agent.color,child:const Icon(Icons.person,color:bg)),title:Text(agent.name),subtitle:Text(agent.role),trailing:IconButton(onPressed:()=>Navigator.pop(sheet),icon:const Icon(Icons.close))),const Divider(height:1),const Padding(padding:EdgeInsets.all(12),child:Text('CHAT DE TESTE — NÃO EXECUTA COMANDOS',style:TextStyle(fontSize:10,color:gold))),Expanded(child:ListView(padding:const EdgeInsets.all(16),children:[if(chats[agent.name]!.isEmpty)const Text('Escreva uma solicitação demonstrativa.',style:TextStyle(color:Colors.white60)),...chats[agent.name]!.map((message)=>Padding(padding:const EdgeInsets.only(bottom:12),child:Text(message)))])),Padding(padding:const EdgeInsets.all(12),child:Row(children:[Expanded(child:TextField(controller:field,decoration:const InputDecoration(border:OutlineInputBorder(),hintText:'Delegar tarefa de exemplo'))),const SizedBox(width:8),IconButton.filled(onPressed:(){final text=field.text.trim();if(text.isEmpty)return;update((){chats[agent.name]!.add('Você: $text');chats[agent.name]!.add('Resposta ilustrativa: recebi a tarefa, mas nenhuma ação real foi iniciada.');});field.clear();},icon:const Icon(Icons.send))]))])))));
 }
}
class OfficePainter extends CustomPainter {
 OfficePainter(this.t);
 final double t;
 static const ink=Color(0xFF283B40), timber=Color(0xFF805438), oak=Color(0xFFBA8250), grass=Color(0xFF5C885D);
 void tile(Canvas c,double x,double y,double w,double h,Color color){c.drawRect(Rect.fromLTWH(x,y,w,h),Paint()..color=color);}
 void border(Canvas c,double x,double y,double w,double h,Color color,double sw){c.drawRect(Rect.fromLTWH(x,y,w,h),Paint()..color=color..style=PaintingStyle.stroke..strokeWidth=sw);}
 void text(Canvas c,String value,double x,double y,double sz,{Color color=const Color(0xFFFBE5B9)}){
 final p=TextPainter(text:TextSpan(text:value,style:TextStyle(color:color,fontSize:sz,fontWeight:FontWeight.w900,letterSpacing:.4,shadows:const [Shadow(color:Colors.black,blurRadius:2,offset:Offset(1,2))])),textDirection:TextDirection.ltr)..layout();
 p.paint(c,Offset(x-p.width/2,y));
 }
 void plant(Canvas c,double x,double y,{double scale=1}){
 c.save();c.translate(x,y);c.scale(scale);
 tile(c,-8,6,16,13,const Color(0xFFB17A50));tile(c,-11,3,22,6,const Color(0xFFD6A46B));
 tile(c,-4,-14,8,23,const Color(0xFF336744));
 for(final p in [const Offset(-9,-13),const Offset(8,-16),const Offset(0,-23),const Offset(0,-8)]){
 tile(c,p.dx-7,p.dy-5,14,14,const Color(0xFF2E764C));
 tile(c,p.dx-4,p.dy-5,8,8,const Color(0xFF67B46B));
 }
 c.restore();
 }
 void computer(Canvas c,double x,double y){
 tile(c,x-18,y-13,36,26,ink);tile(c,x-14,y-9,28,17,const Color(0xFF68B5C7));
 tile(c,x-10,y-6,20,3,const Color(0xFFA2E2E2));tile(c,x-3,y+13,6,6,ink);
 tile(c,x-16,y+19,32,4,const Color(0xFF4E6067));
 }
 void desk(Canvas c,double x,double y){
 tile(c,x-45,y-20,90,47,const Color(0xFF593F32));
 tile(c,x-45,y-25,90,43,oak);
 tile(c,x-41,y-21,82,5,const Color(0xFFE4B77B));
 tile(c,x-40,y+18,12,20,timber);tile(c,x+28,y+18,12,20,timber);
 computer(c,x-13,y-6);
 tile(c,x+18,y-12,16,20,const Color(0xFFE8D7B5));
 tile(c,x+20,y-9,12,2,const Color(0xFF6D8D93));
 tile(c,x-18,y+35,36,16,const Color(0xFF4F7487));
 tile(c,x-12,y+38,24,5,const Color(0xFF8DB0B3));
 }
 void bookshelf(Canvas c,double x,double y){
 tile(c,x,y,30,66,const Color(0xFF5C4036));tile(c,x+3,y+3,24,60,const Color(0xFF8E6247));
 for(var i=0;i<4;i++){
 tile(c,x+4,y+5+i*15,22,4,const Color(0xFF4D332C));
 for(var k=0;k<5;k++){tile(c,x+5+k*4,y+9+i*15,3,8,Color.lerp(const Color(0xFF8EB1A5),const Color(0xFFE0AD77),((i+k)%5)/4)!);}
 }
 }
 void room(Canvas c,double x,double y,double w,double h,String name,Color floor){
 tile(c,x,y,w,h,floor);
 for(var iy=0;iy<h/16;iy++){for(var ix=0;ix<w/16;ix++){
 if((ix+iy)%2==0)tile(c,x+ix*16,y+iy*16,16,16,Colors.white.withValues(alpha:.09));
 }}
 tile(c,x,y,w,12,const Color(0xFF445A59));
 tile(c,x,y+12,w,8,const Color(0xFF9DAD9E));
 tile(c,x,y+h-8,w,8,const Color(0xFFB9A486));
 border(c,x,y,w,h,const Color(0xFF263C3F),6);
 tile(c,x+w/2-65,y+13,130,22,const Color(0xFF33494B));
 text(c,name,x+w/2,y+17,13);
 }
 @override void paint(Canvas c,Size size){
 c.save();c.scale(size.width/1100,size.height/700);
 tile(c,0,0,1100,700,grass);
 final random=math.Random(91);
 for(var i=0;i<400;i++){
 final x=random.nextDouble()*1100,y=random.nextDouble()*700;
 tile(c,x,y,3+random.nextInt(4).toDouble(),2,const Color(0xFF81A66B));
 }
 // Street and sidewalk with pixel details.
 tile(c,0,614,1100,18,const Color(0xFFC4B397));
 for(var x=0.0;x<1100;x+=26){tile(c,x,616,2,13,const Color(0xFF968A76));}
 tile(c,0,634,1100,66,const Color(0xFF46545B));
 for(var x=24.0;x<1100;x+=130){tile(c,x,666,66,5,const Color(0xFFE4CFA5));}
 // Outer walls and six individually enclosed offices.
 tile(c,58,45,986,563,const Color(0xFF26393C));
 room(c,70,56,275,235,'MARKETING',const Color(0xFFD3BBA0));
 room(c,351,56,344,235,'SALA DE REUNIÕES',const Color(0xFFB6C9C6));
 room(c,701,56,331,235,'GERÊNCIA',const Color(0xFFD8C7A8));
 room(c,70,348,275,248,'VENDAS + PROSPECÇÃO',const Color(0xFFD7C3A3));
 room(c,351,348,344,248,'DESENVOLVIMENTO',const Color(0xFFC3CFCD));
 room(c,701,348,163,248,'FINANCEIRO',const Color(0xFFD2C4A7));
 room(c,870,348,162,248,'NEGÓCIOS',const Color(0xFFD5C0A8));
 // Main corridor and open doors in each room.
 tile(c,70,298,962,42,const Color(0xFF9AAEAD));
 for(var x=70.0;x<1032;x+=24){tile(c,x,312,18,14,const Color(0xFFBCCAC2));}
 for(final x in <double>[192,490,820]){
 tile(c,x,281,68,14,const Color(0xFF806B53));tile(c,x+6,284,56,10,const Color(0xFFD7C4A2));
 tile(c,x,340,68,14,const Color(0xFF806B53));tile(c,x+6,340,56,11,const Color(0xFFD7C4A2));
 }
 // Windows, trim, lighting.
 for(final x in <double>[117,399,758,930]){
 tile(c,x,45,91,13,const Color(0xFF3B626A));
 tile(c,x+4,46,83,8,const Color(0xFF8BD3DC));
 tile(c,x+43,46,5,9,const Color(0xFFDFE7CF));
 }
 for(final x in <double>[96,384,731,898]){
 tile(c,x,72,24,9,const Color(0xFFE7D69D));
 tile(c,x+4,81,16,4,const Color(0xFFFFE7A2));
 }
 // Marketing: creative desks, artwork, cabinets.
 desk(c,156,166);desk(c,274,166);
 bookshelf(c,82,102);plant(c,322,258);
 tile(c,119,102,85,41,const Color(0xFF516D78));
 for(var i=0;i<5;i++){tile(c,126+i*14,110,10,24,Color.lerp(const Color(0xFF78B5B5),const Color(0xFFEEB58B),i/5)!);}
 // Conference room: table, chairs, presentation screen.
 tile(c,433,139,177,85,const Color(0xFF5C4235));
 tile(c,438,135,167,79,const Color(0xFFB98253));
 tile(c,447,142,149,9,const Color(0xFFD6A06B));
 for(final x in <double>[454,500,546,585]){
 tile(c,x,113,28,19,const Color(0xFF57717A));tile(c,x,224,28,18,const Color(0xFF57717A));
 }
 tile(c,480,91,110,17,ink);tile(c,485,93,100,11,const Color(0xFF6DA7A9));
 plant(c,663,253);
 // Management office.
 desk(c,840,164);bookshelf(c,991,110);
 tile(c,736,223,94,30,const Color(0xFF537783));
 tile(c,742,229,82,18,const Color(0xFF7598A1));
 tile(c,891,223,86,30,const Color(0xFF537783));
 plant(c,1004,254);
 // Sales, developer, finance and business furniture.
 desk(c,153,446);desk(c,274,446);desk(c,153,541);desk(c,274,541);
 desk(c,438,449);desk(c,603,449);desk(c,438,540);desk(c,603,540);
 desk(c,782,447);desk(c,782,542);
 desk(c,950,447);desk(c,950,542);
 bookshelf(c,365,385);bookshelf(c,661,385);
 plant(c,89,574);plant(c,681,571);plant(c,1014,575);
 // Agents remain stationary at their workstations until an actual task event is received.
 final places=<Offset>[const Offset(840,186),const Offset(153,466),const Offset(274,466),const Offset(273,550),const Offset(157,187),const Offset(510,482),const Offset(782,466),const Offset(951,550)];
 for(var i=0;i<team.length;i++){
 final a=team[i],home=places[i];
 final x=home.dx,y=home.dy;
 tile(c,x-11,y+19,24,5,const Color(0x77506057));
 tile(c,x-10,y-21,20,18,const Color(0xFFD7A67E));
 tile(c,x-12,y-25,24,9,const Color(0xFF3A302C));
 tile(c,x-8,y-14,3,3,ink);tile(c,x+5,y-14,3,3,ink);
 tile(c,x-13,y-2,26,22,a.color);
 tile(c,x-13,y+20,10,11,ink);tile(c,x+3,y+20,10,11,ink);
 tile(c,x-17,y+1,5,12,const Color(0xFFD7A67E));
 tile(c,x+12,y+1,5,12,const Color(0xFFD7A67E));
 tile(c,x-34,y+32,68,16,const Color(0xCC283B40));
 text(c,a.name,x,y+34,10);
 }
 c.restore();
 }
 @override bool shouldRepaint(covariant OfficePainter old)=>old.t!=t;
}
/// Flame owns the render loop; the visual map is intentionally offline/demo-only.
class RetroOfficeGame extends FlameGame {
  double elapsed = 0;
  bool running = true;
  @override
  void update(double dt) {
    super.update(dt);
    if (running) elapsed += dt;
  }
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    OfficePainter(0).paint(canvas, Size(size.x, size.y));
  }
}
