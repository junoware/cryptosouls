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
            <h4>Summon Warriors as NFTs</h4>
            <p className="app-step-card-description">
              Souls are minted with{" "}
              <a target="_blank" rel="noreferrer" href="https://chain.link/solutions/chainlink-vrf">
                provably-random
              </a>{" "}
              stats and ready for battle
            </p>
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
            <h4>Clash in the Battle Arena</h4>
            <p className="app-step-card-description">
              Compete in the Battle Arena for glory and riches in one-on-one duels
            </p>
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
            <h4>Defeat Rivals and Win Riches</h4>
            <p className="app-step-card-description">Win ETH from the Battle Arena and summon more Souls</p>
          </Card>
        </Col>
      </Row>
    </div>
  );
}
