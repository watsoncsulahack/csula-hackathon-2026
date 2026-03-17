const fs = require('fs');
const PptxGenJS = require('pptxgenjs');

const md = fs.readFileSync('slides/SERP-Hackathon-Deck.md', 'utf8');
const rawSlides = md.split('\n---\n').map(s => s.trim()).filter(Boolean);

const slides = rawSlides
  .map(s => s.replace(/^---[\s\S]*?---\s*/,'').trim())
  .filter(s => s.length>0)
  .map(s => s.split('\n').filter(l=>l.trim().length>0));

const pptx = new PptxGenJS();
pptx.layout = 'LAYOUT_WIDE';
pptx.author = 'OpenClaw';
pptx.title = 'SERP Hackathon Deck';

slides.forEach((lines, idx) => {
  const slide = pptx.addSlide();
  slide.background = { color: 'F4F4F4' };
  let title = lines.find(l=>l.startsWith('#')) || `Slide ${idx+1}`;
  title = title.replace(/^#+\s*/,'').trim();
  const body = lines.filter(l=>!l.startsWith('#')).join('\n').replace(/\*\*/g,'').replace(/`/g,'');

  slide.addText(title, {x:0.5, y:0.5, w:12.3, h:0.8, fontSize:32, bold:true, color:'0F62FE'});
  slide.addShape(pptx.ShapeType.roundRect, {x:0.5, y:1.5, w:12.3, h:5.2, radius:0.08, fill:{color:'FFFFFF'}, line:{color:'DDE1E6'}});
  slide.addText(body || ' ', {x:0.8, y:1.9, w:11.7, h:4.6, fontSize:18, color:'161616', breakLine:true});
});

pptx.writeFile({ fileName: 'slides/SERP-Hackathon-Deck.pptx' });
