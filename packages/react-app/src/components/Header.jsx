import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <>
      <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
        crossOrigin="anonymous"
      />
      <PageHeader title="CryptoSouls" subTitle="Summon NFT Warriors & Battle for Glory" style={{ cursor: "pointer" }} />
    </>
  );
}
