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
 Agent('Gerente','Coordenação',gold,.53,.32),
 Agent('Prospecção','Pesquisa comercial',Color(0xFF78D1D2),.15,.26),
 Agent('Vendas 1','Primeiro contato',Color(0xFF83ABEE),.32,.26),
 Agent('Vendas 2','Qualificação',Color(0xFFB7A2ED),.15,.67),
 Agent('Marketing','Campanhas',Color(0xFFF4A1BC),.32,.67),
 Agent('Desenvolvimento','Soluções',Color(0xFF93D993),.73,.26),
 Agent('Finanças','Indicadores',Color(0xFFECD17C),.88,.26),
 Agent('Negócios','Estratégia',Color(0xFFF0AA86),.87,.67),
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
 OfficePainter(this.t); final double t;
 void block(Canvas c,Rect r,Color color)=>c.drawRect(r,Paint()..color=color);
 void label(Canvas c,String text,double x,double y,double size){final p=TextPainter(text:TextSpan(text:text,style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:size,backgroundColor:const Color(0xDD162432))),textDirection:TextDirection.ltr)..layout();p.paint(c,Offset(x-p.width/2,y));}
 @override void paint(Canvas canvas,Size size){
  final w=size.width,h=size.height,u=math.max(3.0,math.min(w/125,h/85));
  block(canvas,Offset.zero&size,const Color(0xFF354955));
  for(var x=0;x<(w/(u*6)).ceil();x++){for(var y=0;y<(h/(u*6)).ceil();y++){if((x+y).isEven)block(canvas,Rect.fromLTWH(x*u*6,y*u*6,u*6,u*6),const Color(0xFF3D515D));}}
  block(canvas,Rect.fromLTWH(0,0,w,u*3),const Color(0xFF192833));
  block(canvas,Rect.fromLTWH(0,h*.47,w,u*3),const Color(0xFF1B2D37));
  block(canvas,Rect.fromLTWH(w*.43,0,u*3,h*.47),const Color(0xFF1B2D37));
  block(canvas,Rect.fromLTWH(w*.60,0,u*3,h*.47),const Color(0xFF1B2D37));
  block(canvas,Rect.fromLTWH(w*.44,h*.54,w*.28,h*.33),const Color(0xFF60727C));
  block(canvas,Rect.fromLTWH(w*.49,h*.67,w*.18,h*.09),const Color(0xFF946B4F));
  label(canvas,'SALA DE REUNIÃO',w*.58,h*.59,u*2.1);
  for(final p in [const Offset(.05,.1),const Offset(.95,.1),const Offset(.05,.90),const Offset(.95,.90)]){
   block(canvas,Rect.fromCenter(center:Offset(w*p.dx,h*p.dy),width:u*5,height:u*5),const Color(0xFF579560));
   block(canvas,Rect.fromCenter(center:Offset(w*p.dx,h*p.dy),width:u*2,height:u*2),const Color(0xFF9CD78A));
  }
  for(var i=0;i<team.length;i++){
   final a=team[i],px=w*a.x,py=h*a.y;
   block(canvas,Rect.fromCenter(center:Offset(px,py+u*5),width:u*12,height:u*4),const Color(0xFF936D53));
   block(canvas,Rect.fromCenter(center:Offset(px,py+u*2),width:u*6,height:u*4),const Color(0xFF182431));
   block(canvas,Rect.fromCenter(center:Offset(px,py+u*2),width:u*4,height:u*2),mint);
   final x=px+math.sin(t*math.pi*2+i*1.8)*u*2;
   final y=py+math.sin(t*math.pi*4+i)*u*.7;
   block(canvas,Rect.fromCenter(center:Offset(x,y-u*4),width:u*4,height:u*4),const Color(0xFFE2BB9A));
   block(canvas,Rect.fromCenter(center:Offset(x,y-u*6.5),width:u*5,height:u*2),const Color(0xFF29242D));
   block(canvas,Rect.fromCenter(center:Offset(x,y),width:u*6,height:u*4),a.color);
   block(canvas,Rect.fromCenter(center:Offset(x-u*1.5,y+u*3),width:u*2,height:u*3),const Color(0xFF162432));
   block(canvas,Rect.fromCenter(center:Offset(x+u*1.5,y+u*3),width:u*2,height:u*3),const Color(0xFF162432));
   label(canvas,a.name,px,py+u*9,math.max(9,u*2.0));
  }
 }
 @override bool shouldRepaint(covariant OfficePainter old)=>old.t!=t;
}
