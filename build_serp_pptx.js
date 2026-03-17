const PptxGenJS = require('pptxgenjs');
const pptx = new PptxGenJS();
pptx.layout = 'LAYOUT_WIDE';
pptx.author = 'OpenClaw + watsonx Orchestrate';
pptx.subject = 'Smart Emergency Routing storyboard';
pptx.title = 'SER Mock UI Storyboard';

const slides = [
  ['Smart Emergency Routing Platform','Right ambulance. Right hospital. Right now.'],
  ['Incident Capture','Multi-modal intake: phone, SMS, IoT, app. Live transcript + confidence.'],
  ['AI-Driven Triage','Severity/type classification with confidence gauge and action options.'],
  ['Resource Availability','Live inventory of ambulances and hospitals with status + ETA.'],
  ['Optimization Engine','Best response bundle selected under ETA/cost/capability constraints.'],
  ['Dispatch Console','Human-in-the-loop review, approve/override, full audit log.'],
  ['Live Tracking','Real-time responder map, ETA updates, and incident progression.'],
  ['Post-Event Analytics','Response metrics, heatmaps, and AI-generated learning summary.'],
  ['Security & Compliance','RBAC, encryption, auditability, and policy compliance.'],
  ['Next Steps','Pilot rollout, integration points, and execution roadmap.']
];

slides.forEach((s, i) => {
  const slide = pptx.addSlide();
  slide.background = { color: 'F4F4F4' };
  slide.addText(`Slide ${i+1}`, { x:0.4, y:0.2, w:1.5, h:0.3, fontSize:12, color:'5A5A5A' });
  slide.addText(s[0], { x:0.6, y:0.8, w:12.0, h:0.7, fontSize:34, bold:true, color:'0F62FE' });
  slide.addShape(pptx.ShapeType.roundRect, { x:0.6, y:1.8, w:12.0, h:3.8, radius:0.08, fill:{color:'FFFFFF'}, line:{color:'DDE1E6'} });
  slide.addText(s[1], { x:0.9, y:2.2, w:11.4, h:1.4, fontSize:20, color:'161616' });
  slide.addText('Mock UI render storyboard generated from Orchestrate coordination output (Round 2).', { x:0.9, y:4.5, w:11.4, h:0.6, fontSize:13, color:'525252' });
});

pptx.writeFile({ fileName: 'slides/SERP-Mock-UI-Storyboard.pptx' });
