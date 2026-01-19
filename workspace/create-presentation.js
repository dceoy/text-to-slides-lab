const pptxgen = require("pptxgenjs");
const html2pptx = require("/Users/dceoy/util/text-to-slides-lab/.claude/skills/pptx/scripts/html2pptx.js");
const path = require("path");

async function createPresentation() {
  const pptx = new pptxgen();
  pptx.layout = "LAYOUT_16x9";
  pptx.author = "GitHub CI/CD and AI Coding";
  pptx.title = "AI coding with CI/CD on GitHub";

  const slidesDir = path.join(__dirname, "slides");
  const slideFiles = [
    "slide01.html",
    "slide02.html",
    "slide03.html",
    "slide04.html",
    "slide05.html",
    "slide06.html",
    "slide07.html",
    "slide08.html",
    "slide09.html",
    "slide10.html",
    "slide11.html",
    "slide12.html",
    "slide13.html",
    "slide14.html",
  ];

  for (const file of slideFiles) {
    const htmlPath = path.join(slidesDir, file);
    console.log(`Processing ${file}...`);
    await html2pptx(htmlPath, pptx);
  }

  const outputPath = path.join(__dirname, "github-actions-copilot.pptx");
  await pptx.writeFile({ fileName: outputPath });
  console.log(`Presentation created: ${outputPath}`);
}

createPresentation().catch(console.error);
