import React from "react";
import { Card, Col, Row } from "antd";

const soulImage = "images/soul-white.png";
const battleImage = "images/swords.png";
const trophyImage = "images/trophy.png";

export default function AppSteps() {
  return (
    <div className="site-card-wrapper">
      <h1 className="section-header-title">How It Works</h1>
      <Row gutter={16}>
        <Col span={8}>
          <Card
            cover={
              <img
                alt="example"
                src={soulImage}
                style={{ objectFit: "contain", maxWidth: 200, padding: "10px", margin: "auto" }}
                className="icon-circle"
              />
            }
            bordered={false}
            className="step-card"
          >
            <h4>Mint NFT Souls</h4>
            <p className="app-step-card-description">Minted with Provably-Random Stats for Battle</p>
          </Card>
        </Col>
        <Col span={8}>
          <Card
            cover={
              <img
                alt="example"
                src={battleImage}
                style={{ objectFit: "contain !important", maxWidth: 200, padding: "10px", margin: "auto" }}
                className="icon-circle"
              />
            }
            bordered={false}
            className="step-card"
          >
            <h4>Battle in the Arena</h4>
            <p className="app-step-card-description">Pit your Souls against Others for Prizes</p>
          </Card>
        </Col>
        <Col span={8}>
          <Card
            cover={
              <img
                alt="example"
                src={trophyImage}
                style={{ objectFit: "contain", maxWidth: 200, padding: "10px", margin: "auto" }}
                className="icon-circle"
              />
            }
            bordered={false}
            className="step-card"
          >
            <h4>Win Bounties</h4>
            <p className="app-step-card-description">Victorious Souls are Rewarded with Tokens</p>
          </Card>
        </Col>
      </Row>
    </div>
  );
}
