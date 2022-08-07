import { PageHeader } from "antd";
import React from "react";

// displays a page header

const soulIcon = "images/soul.png";

export default function Header() {
  return (
    <span>
      <a href="./" rel="noopener noreferrer" style={{ float: "left" }}>
        <PageHeader
          avatar={{ src: soulIcon, size: 40 }}
          title="Souls Arena"
          subTitle=" "
          style={{ cursor: "pointer", color: "#BBBCBD !important", fontWeight: "700px !important" }}
        />
      </a>
    </span>
  );
}
