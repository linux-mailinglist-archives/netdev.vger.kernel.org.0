Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3946A33B
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbhLFRpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:45:31 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:38857 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244866AbhLFRpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:45:24 -0500
Received: by mail-oi1-f181.google.com with SMTP id r26so22830581oiw.5;
        Mon, 06 Dec 2021 09:41:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iJa24hh6sDEUpEz26btAdpVnkRSWQr1kx84SVvqDXJo=;
        b=NGw4RnJgWAwNO6S8Cy3slj8i5ee+kfz5AB1o3oNtYombAPd71Yp1lV1HpPCVgfmEe4
         6D2SVsAsXzR8IGbjYCA42Ol/NNgPSNttDwQKnCiJreKK3rcgHVzQoQO8trbRr9sj6nE1
         ydEMt19i1VxMp6F9njIEHPD5LnjqImVGUzhiGO/GIkEgrol3syiUwTGC7eCw4CH4aS0P
         SLQf6cl0d5+xA/gSzPyTX7x+Lonc1RZjDflrwV+qU2MPuKqW2XAGGZMkIVp1GguQZMYQ
         maJgwFWgXXcumnTleadS+GAqHsHnNqR8aHrnDA/iOR7Rg3DiGDAi3YHnl84D0iUdR4GX
         2vXg==
X-Gm-Message-State: AOAM532+B+2din8ugcTKADOZoKOt/UOp+GxRvzox0ZcPuTcrS3U+7IgA
        46pScDNq90vw6rt/2RBJpA==
X-Google-Smtp-Source: ABdhPJwCOBxPc6keMUGzARcRIl4lodA3f7cfPdab0zIok2z2RMJGpP+DSzeGEUCy3de/yvSDymwccA==
X-Received: by 2002:a05:6808:649:: with SMTP id z9mr24422724oih.125.1638812515071;
        Mon, 06 Dec 2021 09:41:55 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id bj8sm2965511oib.51.2021.12.06.09.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:41:54 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: Add missing properties used in examples
Date:   Mon,  6 Dec 2021 11:41:52 -0600
Message-Id: <20211206174153.2296977-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With 'unevaluatedProperties' support implemented, the following warnings
are generated in the net bindings:

Documentation/devicetree/bindings/net/actions,owl-emac.example.dt.yaml: ethernet@b0310000: Unevaluated properties are not allowed ('mdio' was unexpected)
Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dt.yaml: ethernet@3a000000: Unevaluated properties are not allowed ('snps,pbl', 'mdio0' were unexpected)
Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: ethernet@19000000: Unevaluated properties are not allowed ('qca,ethcfg' was unexpected)
Documentation/devicetree/bindings/net/qca,ar71xx.example.dt.yaml: ethernet@1a000000: Unevaluated properties are not allowed ('mdio' was unexpected)
Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40028000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl' were unexpected)
Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: mdio@1000: Unevaluated properties are not allowed ('clocks', 'clock-names' were unexpected)
Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: mdio@f00: Unevaluated properties are not allowed ('clocks', 'clock-names' were unexpected)

Add the missing properties/nodes as necessary.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "Andreas Färber" <afaerber@suse.de>
Cc: Manivannan Sadhasivam <mani@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc: "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Christophe Roullier <christophe.roullier@foss.st.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-actions@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/actions,owl-emac.yaml          | 3 +++
 .../devicetree/bindings/net/intel,dwmac-plat.yaml          | 2 +-
 Documentation/devicetree/bindings/net/qca,ar71xx.yaml      | 5 ++++-
 Documentation/devicetree/bindings/net/stm32-dwmac.yaml     | 6 ++++++
 Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml | 7 +++++++
 .../devicetree/bindings/net/toshiba,visconti-dwmac.yaml    | 5 ++++-
 6 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
index 1626e0a821b0..e9c0d6360e74 100644
--- a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
+++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
@@ -51,6 +51,9 @@ properties:
     description:
       Phandle to the device containing custom config.
 
+  mdio:
+    type: object
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
index 08a3f1f6aea2..52a7fa4f49a4 100644
--- a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
+++ b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
@@ -117,7 +117,7 @@ examples:
         snps,mtl-tx-config = <&mtl_tx_setup>;
         snps,tso;
 
-        mdio0 {
+        mdio {
             #address-cells = <1>;
             #size-cells = <0>;
             compatible = "snps,dwmac-mdio";
diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
index cf4d35edaa1b..f2bf1094d887 100644
--- a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
+++ b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
@@ -62,6 +62,10 @@ properties:
       - const: mac
       - const: mdio
 
+
+  mdio:
+    type: object
+
 required:
   - compatible
   - reg
@@ -85,7 +89,6 @@ examples:
         reset-names = "mac", "mdio";
         clocks = <&pll 1>, <&pll 2>;
         clock-names = "eth", "mdio";
-        qca,ethcfg = <&ethcfg>;
         phy-mode = "mii";
         phy-handle = <&phy_port4>;
     };
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index 577f4e284425..86632e9d987e 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -44,6 +44,12 @@ properties:
               - st,stm32-dwmac
           - const: snps,dwmac-3.50a
 
+  reg: true
+
+  reg-names:
+    items:
+      - const: stmmaceth
+
   clocks:
     minItems: 3
     items:
diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
index 5728fe23f530..dbfca5ee9139 100644
--- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
@@ -37,6 +37,13 @@ properties:
     maximum: 2500000
     description: MDIO Bus frequency
 
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: fck
+
   ti,hwmods:
     description: TI hwmod name
     deprecated: true
diff --git a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
index 59724d18e6f3..f5bec97460e4 100644
--- a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
@@ -42,6 +42,9 @@ properties:
       - const: stmmaceth
       - const: phy_ref_clk
 
+  mdio:
+    type: object
+
 required:
   - compatible
   - reg
@@ -71,7 +74,7 @@ examples:
             phy-mode = "rgmii-id";
             phy-handle = <&phy0>;
 
-            mdio0 {
+            mdio {
                 #address-cells = <0x1>;
                 #size-cells = <0x0>;
                 compatible = "snps,dwmac-mdio";
-- 
2.32.0

