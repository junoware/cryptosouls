import React from "react";
import { Collapse, Row, Col } from "antd";

const { Panel } = Collapse;

const faqImage = "images/faq-image.png";
const imageSpan = 6;
const gutterSpan = 2;

export default function FAQ() {
  return (
    <div className="faq-section">
      <Row gutter={gutterSpan}>
        <Col span={imageSpan}>
          <img className="faq-image" src={faqImage} alt="" />
        </Col>
        <Col span={24 - imageSpan - gutterSpan}>
          {" "}
          <h1 className="section-header-title faq-title">
            FAQ <div className="underline-div" />
          </h1>
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
              <Panel header="This is panel header 4" key="4">
                <p>This is text</p>
              </Panel>
              <Panel header="This is panel header 5" key="5">
                <p>This is text</p>
              </Panel>
              <Panel header="This is panel header 6" key="6">
                <p>This is text</p>
              </Panel>
              <Panel header="This is panel header 7" key="7">
                <p>This is text</p>
              </Panel>
            </Collapse>
          </div>
        </Col>
      </Row>
    </div>
  );
}
