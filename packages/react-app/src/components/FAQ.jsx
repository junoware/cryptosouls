import React from "react";
import { Collapse } from "antd";

const { Panel } = Collapse;

export default function FAQ() {
  return (
    <div className="faq-section">
      <h4>Frequently Asked Questions</h4>
      <div className="faq-section-accordian">
        <Collapse accordion>
          <Panel header="This is panel header 1" key="1">
            <p>This is text</p>
          </Panel>
          <Panel header="This is panel header 2" key="2">
            <p>This is text</p>
          </Panel>
          <Panel header="This is panel header 3" key="3">
            <p>This is text</p>
          </Panel>
        </Collapse>
      </div>
    </div>
  );
}
