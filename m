Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB539227C73
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgGUKEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:04:47 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:30678 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgGUKEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595325885; x=1626861885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LOmnsw9iC3qsLnhUejBW18I+VfFv6IlLy/JZ85tkXDA=;
  b=EDTaFGVEDgrugcOifNLihts2ri4uvwIj6/JueLgcpcBf6Ay+oOWEdTHf
   roQO0oFXmspxs098et9uB6QhCTYBFra3Gar/O9cM2Tg46kX6H8DU4hu0y
   M4rimjNvc10zDMbhik9P855dIhAa9VIAFl9S8Xm9fEm+XIPsCRYw3Lymz
   7AW244oejjK2zYi/DLwIb+zYx5zmA+x/KnHtXSjlfRxA+6bKukzRLFnCq
   ClDRamKtCFernY40yDNlgAQqQDCcxH4NJWrQjmQPvL6CfhufoFoYNtnUs
   CoC/EvDi0pW3v5OBDNlJNZDgLzOQRct+jSdJ5IBdziv4AApWQv1/rWBNZ
   w==;
IronPort-SDR: zZyoZ/SxVwtSNGzApPWj4oo2HX57s/YMElnbCXevHIAwb0mOZ7KGvZM+NcXWJYCBv3tYndj691
 UJuNKSpiHSrNSNx3pJvZlLaJ2XtOI08XI1gMZlTjcZ9k4w8c7k3Qm9Il1e0wvbyykEdONMCh4I
 +VQDdP3gDJrH/4BFjhueZhVjoQteMFH2EiHC2PWwUSYWRuoQfdAsF7Nv/ipWrodkqVRm9EqnE7
 TsEUfX93/yfqq0XgbsTzHlzAtTNsc6INp68WJMMPKLVzYArDPHX4UUEKmHwZfewe+GYWcNpCjY
 HAo=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="80694890"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:04:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:04:06 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:03:40 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 2/7] macb: bindings doc: use an MDIO node as a container for PHY nodes
Date:   Tue, 21 Jul 2020 13:02:29 +0300
Message-ID: <20200721100234.1302910-3-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MACB driver embeds an MDIO bus controller and for this reason there
was no need for an MDIO sub-node present to contain the PHY nodes. Adding
MDIO devies directly under an Ethernet node is deprecated, so an MDIO node
is included to contain of the PHY nodes (and other MDIO devices' nodes).

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 0b61a90f1592..88d5199c2279 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -32,6 +32,11 @@ Required properties:
 The MAC address will be determined using the optional properties
 defined in ethernet.txt.
 
+Optional subnodes:
+- mdio : specifies the MDIO bus in the MACB, used as a container for PHY nodes or other
+  nodes of devices present on the MDIO bus. Please see ethernet-phy.yaml in the same
+  directory for more details.
+
 Optional properties for PHY child node:
 - reset-gpios : Should specify the gpio for phy reset
 - magic-packet : If present, indicates that the hardware supports waking
@@ -48,8 +53,12 @@ Examples:
 		local-mac-address = [3a 0e 03 04 05 06];
 		clock-names = "pclk", "hclk", "tx_clk";
 		clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
-		ethernet-phy@1 {
-			reg = <0x1>;
-			reset-gpios = <&pioE 6 1>;
+		mdio {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ethernet-phy@1 {
+				reg = <0x1>;
+				reset-gpios = <&pioE 6 1>;
+			};
 		};
 	};
-- 
2.25.1

