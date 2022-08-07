import React from "react";
import { Card, Col, Row, Carousel } from "antd";

const contentStyle = {
  height: "400px",
  color: "#fff",
  lineHeight: "400px",
  textAlign: "center",
};

const warrior1Image = "images/genghis-khan.svg";
const warrior2Image = "images/musashi.svg";
const warrior3Image = "images/william-wallace.svg";
const warrior4Image = "images/achilles.svg";

const warriorCellSpan = 8;
const descriptionCellSpan = 24 - warriorCellSpan;

export default function Warriors() {
  return (
    <div className="site-card-wrapper">
      <h1 className="section-header-title">
        NFT Warriors
      </h1>
      <Carousel autoplay>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior1Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>
                NFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT Warriors NFT Warriors
              </h3>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior2Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>
                NFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT Warriors NFT Warriors
              </h3>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior3Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>
                NFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT Warriors NFT Warriors
              </h3>
            </Col>
          </Row>
        </div>
        <div>
          <Row>
            <Col span={warriorCellSpan}>
              <img className="carousel-warrior" src={warrior4Image} alt="" />
            </Col>
            <Col span={descriptionCellSpan}>
              <h3 style={contentStyle}>
                NFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT WarriorsNFT Warriors NFT Warriors
              </h3>
            </Col>
          </Row>
        </div>
      </Carousel>
    </div>
  );
}
