import 'dart:math' as math;
import 'package:flutter/material.dart';
void main()=>runApp(const GenesisOffice());
const bg=Color(0xFF101825),panel=Color(0xFF192838),mint=Color(0xFF76DDBC),gold=Color(0xFFF2C37C);
class Agent {
 final String name,role;
 final Color color;
 final double x,y;
 const Agent(this.name,this.role,this.color,this.x,this.y);
}
const team=<Agent>[
 Agent('Gerente','Coordenação',gold,.80,.22),
 Agent('Prospecção','Pesquisa comercial',Color(0xFF78D1D2),.14,.68),
 Agent('Vendas 1','Primeiro contato',Color(0xFF83ABEE),.24,.68),
 Agent('Vendas 2','Qualificação',Color(0xFFB7A2ED),.31,.78),
 Agent('Marketing','Campanhas',Color(0xFFF4A1BC),.17,.24),
 Agent('Desenvolvimento','Soluções',Color(0xFF93D993),.52,.72),
 Agent('Finanças','Indicadores',Color(0xFFECD17C),.79,.69),
 Agent('Negócios','Estratégia',Color(0xFFF0AA86),.86,.79),
];
class GenesisOffice extends StatelessWidget {
 const GenesisOffice({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'Gênesis Virtual Office',theme:ThemeData(useMaterial3:true,brightness:Brightness.dark,scaffoldBackgroundColor:bg,colorScheme:ColorScheme.fromSeed(seedColor:mint,brightness:Brightness.dark)),home:const OfficeHome());
}
class OfficeHome extends StatefulWidget {const OfficeHome({super.key});@override State<OfficeHome> createState()=>_OfficeHomeState();}
class _OfficeHomeState extends State<OfficeHome> with SingleTickerProviderStateMixin {
 late final AnimationController animation;
 final Map<String,List<String>> chats={for(final a in team)a.name:<String>[]};
 int screen=0; bool running=true;
 @override void initState(){super.initState();animation=AnimationController(vsync:this,duration:const Duration(seconds:5))..repeat();}
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
          onPressed: () => setState(() => running = !running),
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
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) => CustomPaint(
                painter: OfficePainter(running ? animation.value : 0),
                child: Stack(children: [
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
  void rect(Canvas c, double x, double y, double w, double h, Color color) {
    c.drawRect(Rect.fromLTWH(x,y,w,h),Paint()..color=color);
  }
  void stroke(Canvas c,double x,double y,double w,double h,Color color,double width){
    c.drawRect(Rect.fromLTWH(x,y,w,h),Paint()..color=color..style=PaintingStyle.stroke..strokeWidth=width);
  }
  void caption(Canvas c,String value,double x,double y,double scale){
    final p=TextPainter(text:TextSpan(text:value,style:TextStyle(fontSize:scale,color:const Color(0xFFF7E9CA),fontWeight:FontWeight.w900,backgroundColor:const Color(0xFF263743))),textDirection:TextDirection.ltr)..layout();
    p.paint(c,Offset(x-p.width/2,y));
  }
  @override void paint(Canvas canvas,Size size){
    final c=canvas;
    final w=size.width,h=size.height;
    c.save();
    c.scale(w/1000,h/650);
    const wall=Color(0xFF34424B),floor=Color(0xFFD5C6A7),floor2=Color(0xFFE2D5B9),grass=Color(0xFF587D5B),wood=Color(0xFF9C6946),screen=Color(0xFF283C4B);
    rect(c,0,0,1000,650,grass);
    final random=math.Random(12);
    for(var i=0;i<150;i++){
      final x=random.nextDouble()*1000,y=random.nextDouble()*650;
      rect(c,x,y,3,3,const Color(0xFF739568));
    }
    // Building footprint and tilework.
    rect(c,65,55,870,525,wall);
    rect(c,74,64,852,507,floor);
    for(var row=0;row<24;row++){
      for(var col=0;col<40;col++){
        if((row+col).isEven)rect(c,74+col*22,64+row*22,22,22,floor2);
      }
    }
    // Corridors and room partitions.
    rect(c,74,288,852,52,const Color(0xFFACB5AF));
    rect(c,74,294,852,40,const Color(0xFFC4CBC5));
    rect(c,350,64,9,224,wall);rect(c,680,64,9,224,wall);
    rect(c,350,340,9,231,wall);rect(c,680,340,9,231,wall);rect(c,800,340,9,231,wall);
    rect(c,74,55,852,12,wall);rect(c,74,565,852,13,wall);
    rect(c,65,64,12,507,wall);rect(c,925,64,12,507,wall);
    // Room windows.
    for(final x in <double>[140,410,755]){
      rect(c,x,55,100,10,const Color(0xFF7FC6D4));
      rect(c,x+45,55,7,10,const Color(0xFF304D60));
    }
    // Doors in partitions.
    for(final y in [248.0,340.0]){
      rect(c,350,y,9,35,floor);
      rect(c,680,y,9,35,floor);
    }
    // Reception desk and waiting area.
    rect(c,100,112,155,23,wood);rect(c,100,134,155,9,const Color(0xFF603E2E));
    rect(c,115,100,48,25,screen);rect(c,124,105,31,14,const Color(0xFF75B4C5));
    for(final x in [110.0,165.0,220.0]){
      rect(c,x,214,35,22,const Color(0xFF617E8B));
      rect(c,x+5,234,25,8,wall);
    }
    // Conference room, central upper.
    rect(c,412,137,215,80,wood);
    rect(c,426,150,187,54,const Color(0xFFB68155));
    for(final x in [434.0,486.0,538.0,590.0]){
      rect(c,x,121,30,15,screen);rect(c,x,218,30,15,screen);
    }
    // Manager's private room.
    rect(c,752,137,130,52,wood);
    rect(c,766,117,70,24,screen);rect(c,776,122,50,13,const Color(0xFF75B4C5));
    rect(c,770,205,48,22,const Color(0xFF55748D));
    rect(c,834,205,48,22,const Color(0xFF55748D));
    // Departments: banks of desks.
    for(final x in [105.0,230.0,390.0,520.0,720.0,840.0]){
      for(final y in [398.0,490.0]){
        rect(c,x,y,76,39,wood);
        rect(c,x+7,y+5,32,22,screen);
        rect(c,x+11,y+8,24,14,const Color(0xFF6CB1BE));
        rect(c,x+46,y+8,21,16,const Color(0xFFDBD4BE));
        rect(c,x+22,y+41,34,12,const Color(0xFF56718A));
      }
    }
    // Potted plants and decorative cabinets.
    for(final p in [const Offset(93,86),const Offset(327,87),const Offset(378,254),const Offset(659,254),const Offset(903,88),const Offset(903,540),const Offset(93,545)]){
      rect(c,p.dx-10,p.dy+10,20,15,const Color(0xFF98684C));
      rect(c,p.dx-15,p.dy-8,30,25,const Color(0xFF3B855F));
      rect(c,p.dx-7,p.dy-15,14,17,const Color(0xFF65AA69));
    }
    rect(c,389,242,68,19,const Color(0xFF657E8A));
    rect(c,470,242,68,19,const Color(0xFF657E8A));
    rect(c,551,242,68,19,const Color(0xFF657E8A));
    // Labels use actual functional departments.
    caption(c,'MARKETING',213,78,13);
    caption(c,'SALA DE REUNIÕES',519,78,13);
    caption(c,'GERENTE',803,78,13);
    caption(c,'VENDAS + PROSPECÇÃO',210,352,13);
    caption(c,'DESENVOLVIMENTO',518,352,13);
    caption(c,'FINANCEIRO',742,352,12);caption(c,'NEGÓCIOS',861,352,12);
    // Avatars remain anchored to their original clickable positions.
    for(var i=0;i<team.length;i++){
      final a=team[i];
      final x=a.x*1000,y=a.y*650;
      final dx=math.sin(t*math.pi*2+i*1.7)*7;
      final dy=math.cos(t*math.pi*2+i*2.1)*5;
      final px=x+dx,py=y+dy;
      rect(c,px-13,py+15,26,5,const Color(0x77404C53));
      rect(c,px-11,py-19,22,18,const Color(0xFFE3B68E));
      rect(c,px-13,py-23,26,9,const Color(0xFF342A30));
      rect(c,px-15,py,30,20,a.color);
      rect(c,px-13,py+20,10,12,screen);
      rect(c,px+3,py+20,10,12,screen);
      caption(c,a.name,x,y+34,12);
    }
    // Sidewalk and road at building entrance.
    rect(c,0,586,1000,16,const Color(0xFFC4B7A0));
    rect(c,0,603,1000,47,const Color(0xFF394752));
    for(var x=30.0;x<1000;x+=105)rect(c,x,626,53,3,const Color(0xFFE2CF9E));
    c.restore();
  }
  @override bool shouldRepaint(covariant OfficePainter old)=>old.t!=t;
}
