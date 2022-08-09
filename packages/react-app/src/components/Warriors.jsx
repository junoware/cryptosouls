import React from "react";
import { Col, Row, Carousel } from "antd";

const contentStyle = {
  textAlign: "left",
  fontFamily: "Radley",
  fontStyle: "normal",
  fontWeight: "400",
  fontSize: "23px",
  lineHeight: "29px",
  /* identical to box height */
  textTransform: "uppercase",
  color: "#AEEEED",
};

const warrior1Image = "images/genghis-khan.svg";
const warrior2Image = "images/musashi.svg";
const warrior3Image = "images/william-wallace.svg";
const warrior4Image = "images/achilles.svg";

const warriorCellSpan = 10;
const gutterSpan = 2;
const descriptionCellSpan = 24 - warriorCellSpan - gutterSpan;

export default function Warriors() {
  return (
    <div className="site-card-wrapper">
      <h1 className="section-header-title">Meet Your Warriors</h1>
      <Carousel autoplay>
        <div>
          <Row gutter={gutterSpan}>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior1Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan} className="carousel-info-section">
              <h3 style={contentStyle}>Genghis Khan</h3>
              <p className="carousel-description">
                The founder and first Great Khan of the Mongol Empire, the largest contiguous empire in history. His
                exceptional military successes made Genghis Khan one of the most important conquerors of all time.
              </p>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior2Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan} className="carousel-info-section">
              <h3 style={contentStyle}>Musashi</h3>
              <p className="carousel-description">
                A swordsman, philosopher, strategist, writer and ronin, who became renowned through stories of his
                unique double-bladed swordsmanship and undefeated record in 61 duels. Musashi is considered a Kensei, a
                sword-saint of Japan.
              </p>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior3Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan} className="carousel-info-section">
              <h3 style={contentStyle}>William Wallace</h3>
              <p className="carousel-description">
                One of the main leaders during the First War of Scottish Independence. He was appointed Guardian of
                Scotland and served until his defeat at the Battle of Falkirk in July 1298.
              </p>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior4Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan} className="carousel-info-section">
              <h3 style={contentStyle}>Achilles</h3>
              <p className="carousel-description">
                Hero of the Trojan War and the greatest of all the Greek warriors. Legends state that Achilles was
                invulnerable except for one heel, because when his mother Thetis dipped him in the river Styx as an
                infant, she held him by one of his heels.
              </p>
            </Col>
          </Row>
        </div>
      </Carousel>
    </div>
  );
}
