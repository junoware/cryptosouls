import { PageHeader } from "antd";
import React from "react";

// displays a page header

const soulIcon = "images/soul.png";

export default function Header() {
  return (
    <span>
      <a href="./" rel="noopener noreferrer" style={{ float: "left" }}>
        <PageHeader
          avatar={{ src: soulIcon, size: 60 }}
          title="CryptoSouls"
          subTitle=" "
          style={{ cursor: "pointer" }}
        />
      </a>
    </span>
  );
}
