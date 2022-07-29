import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <span>
      <a href="./" rel="noopener noreferrer" style={{ float: "left" }}>
        <PageHeader title="CryptoSouls" subTitle="Summon Warriors and Battle for Glory" style={{ cursor: "pointer" }} />
      </a>
    </span>
  );
}
