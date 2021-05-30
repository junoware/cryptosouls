import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <PageHeader
      title="CryptoSouls"
      subTitle="Resurrect NFT Warriors and Battle for Glory"
      style={{ cursor: "pointer" }}
    />
  );
}
