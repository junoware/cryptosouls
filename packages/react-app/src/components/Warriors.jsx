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
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>Genghis Khan</h3>
              <p className="carousel-description">Though mild in manner, he was very fierce in battle.</p>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior2Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>Musashi</h3>
              <p className="carousel-description">Though mild in manner, he was very fierce in battle.</p>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior3Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>William Wallace</h3>
              <p className="carousel-description">Though mild in manner, he was very fierce in battle.</p>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior4Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>Achilles</h3>
              <p className="carousel-description">Though mild in manner, he was very fierce in battle.</p>
            </Col>
          </Row>
        </div>
      </Carousel>
    </div>
  );
}
