import React from "react";
import { Row, Col } from "antd";

// displays a page footer

const logo = "images/soul.png";
const twitterIcon = "images/twitter.png";
const discordIcon = "images/discord.png";

export default function Footer() {
  return (
    <div className="page-footer-master">
      <Row justify="left" style={{ marginBottom: 54, marginTop: 36 }}>
        <Col span={5} style={{ margin: "auto" }}>
          <a href="/">
            <img src={logo} alt="logo" style={{ height: 80 }} />
          </a>
        </Col>
        <Col span={5} style={{ margin: "auto" }}>
          <div className="left-align">Email Address</div>
          <h6 className="left-align">
            <a className="footer-link" href="mailto:contact@soulsarena.com">
              contact@soulsarena.com
            </a>
          </h6>
        </Col>
        <Col span={5} style={{ margin: "auto" }}>
          <h6 className="left-align">
            <a className="footer-link" href="/tou">
              Terms of Use
            </a>
          </h6>
        </Col>
        <Col span={5} style={{ margin: "auto" }}>
          <h6 className="left-align">
            <a className="footer-link" href="/pp">
              Privacy Policy
            </a>
          </h6>
        </Col>
      </Row>
      <div style={{ marginBottom: 24 }}>
        <a href="https://discord.gg/yHQWAnp6Y5" rel="noreferrer" target="_blank">
          <img style={{ padding: "0px 4px" }} alt="discord" height={30} src={discordIcon} />
        </a>{" "}
        <a href="https://twitter.com/cryptosoulsnfts" rel="noreferrer" target="_blank">
          <img style={{ padding: "0px 4px" }} alt="twitter" height={25} src={twitterIcon} />
        </a>
      </div>
      <div style={{ marginTop: 24 }}>© 2022 Junoware, LLC. All Rights Reserved.</div>{" "}
    </div>
  );
}
