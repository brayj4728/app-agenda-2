const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'backend', 'Solar_Rosette_Backend_V3.json');
const rawData = fs.readFileSync(filePath);
let workflow = JSON.parse(rawData);

workflow.name = "Solar Rosette Backend V3.3 (Modern Code Nodes)";

workflow.nodes = workflow.nodes.map(node => {
    if (node.type === 'n8n-nodes-base.function') {
        // Upgrade to Code Node
        node.type = 'n8n-nodes-base.code';
        node.typeVersion = 2; // Standard for Code node

        // Rename functionCode to jsCode
        let code = node.parameters.functionCode;

        // Ensure $getWorkflowStaticData syntax (Code nodes use $)
        // My previous fix removed $, so I put it back.
        code = code.replace(/getWorkflowStaticData/g, '$getWorkflowStaticData');
        // Fix double $$ if it existed (just in case)
        code = code.replace(/\$\$getWorkflowStaticData/g, '$getWorkflowStaticData');

        node.parameters = {
            jsCode: code
        };
    }
    return node;
});

// Update standard responses to be identical to valid V3.1 but ensuring they use $json
// Respond nodes don't need changes, they are respondToWebhook.

fs.writeFileSync(filePath, JSON.stringify(workflow, null, 2));
console.log("Successfully upgraded to Code nodes (V3.3)");
