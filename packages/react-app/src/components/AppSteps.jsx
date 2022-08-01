import React from "react";
import { Card, Col, Row } from "antd";

const soulImage = "images/soul.png";
const battleImage = "images/swords.png";
export default function AppSteps() {
  return (
    <div className="site-card-wrapper">
      <Row gutter={16}>
        <Col span={8}>
          <Card
            cover={
              <img
                alt="example"
                src={soulImage}
                style={{ objectFit: "contain", maxWidth: 200, padding: "10px", margin: "auto" }}
              />
            }
            bordered={false}
          >
            <h4>Summon Warriors as NFTs</h4>
            <p>
              CryptoSouls are minted with{" "}
              <a target="_blank" rel="noreferrer" href="https://chain.link/solutions/chainlink-vrf">
                provably-random
              </a>{" "}
              stats in Strength, Intelligence, Endurance, Charisma and Luck
            </p>
          </Card>
        </Col>
        <Col span={8}>
          <Card
            cover={
              <img
                alt="example"
                src={battleImage}
                style={{ objectFit: "contain", maxWidth: 200, padding: "10px", margin: "auto" }}
              />
            }
            bordered={false}
          >
            <h4>Compete in the Battle Arena</h4>
            <p>CryptoSouls can compete in best-of-three battles in the Battle Arena</p>
          </Card>
        </Col>
        <Col span={8}>
          <Card
            cover={
              <img
                alt="example"
                src={battleImage}
                style={{ objectFit: "contain", maxWidth: 200, padding: "10px", margin: "auto" }}
              />
            }
            bordered={false}
          >
            <h4>Summon Warriors as NFTs</h4>
            <p>
              CryptoSouls are minted with{" "}
              <a target="_blank" rel="noreferrer" href="https://chain.link/solutions/chainlink-vrf">
                provably-random
              </a>{" "}
              stats in Strength, Intelligence, Endurance, Charisma and Luck
            </p>
          </Card>
        </Col>
      </Row>
    </div>
  );
}
