Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3BE28A3C8
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389996AbgJJWz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731208AbgJJTxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:53:43 -0400
X-Greylist: delayed 2064 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 10 Oct 2020 10:21:09 PDT
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC35C08EA74;
        Sat, 10 Oct 2020 10:21:09 -0700 (PDT)
Received: from p548da7b6.dip0.t-ipconnect.de ([84.141.167.182] helo=kmk0.Speedport_W_724V_09011603_06_006); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kRI11-0004hK-8M; Sat, 10 Oct 2020 18:46:39 +0200
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kurt@linutronix.de,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Drop old bindings
Date:   Sat, 10 Oct 2020 18:46:27 +0200
Message-Id: <20201010164627.9309-3-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010164627.9309-1-kurt@kmk-computers.de>
References: <20201010164627.9309-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1602350469;957663e4;
X-HE-SMSGID: 1kRI11-0004hK-8M
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device tree bindings have been converted to YAML. No need to keep
the text file around. Update MAINTAINERS file accordingly.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 .../devicetree/bindings/net/dsa/b53.txt       | 149 ------------------
 MAINTAINERS                                   |   2 +-
 2 files changed, 1 insertion(+), 150 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
deleted file mode 100644
index f1487a751b1a..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/b53.txt
+++ /dev/null
@@ -1,149 +0,0 @@
-Broadcom BCM53xx Ethernet switches
-==================================
-
-Required properties:
-
-- compatible: For external switch chips, compatible string must be exactly one
-  of: "brcm,bcm5325"
-      "brcm,bcm53115"
-      "brcm,bcm53125"
-      "brcm,bcm53128"
-      "brcm,bcm5365"
-      "brcm,bcm5395"
-      "brcm,bcm5389"
-      "brcm,bcm5397"
-      "brcm,bcm5398"
-
-  For the BCM11360 SoC, must be:
-      "brcm,bcm11360-srab" and the mandatory "brcm,cygnus-srab" string
-
-  For the BCM5310x SoCs with an integrated switch, must be one of:
-      "brcm,bcm53010-srab"
-      "brcm,bcm53011-srab"
-      "brcm,bcm53012-srab"
-      "brcm,bcm53018-srab"
-      "brcm,bcm53019-srab" and the mandatory "brcm,bcm5301x-srab" string
-
-  For the BCM5831X/BCM1140x SoCs with an integrated switch, must be one of:
-      "brcm,bcm11404-srab"
-      "brcm,bcm11407-srab"
-      "brcm,bcm11409-srab"
-      "brcm,bcm58310-srab"
-      "brcm,bcm58311-srab"
-      "brcm,bcm58313-srab" and the mandatory "brcm,omega-srab" string
-
-  For the BCM585xx/586XX/88312 SoCs with an integrated switch, must be one of:
-      "brcm,bcm58522-srab"
-      "brcm,bcm58523-srab"
-      "brcm,bcm58525-srab"
-      "brcm,bcm58622-srab"
-      "brcm,bcm58623-srab"
-      "brcm,bcm58625-srab"
-      "brcm,bcm88312-srab" and the mandatory "brcm,nsp-srab string
-
-  For the BCM63xx/33xx SoCs with an integrated switch, must be one of:
-      "brcm,bcm3384-switch"
-      "brcm,bcm6328-switch"
-      "brcm,bcm6368-switch" and the mandatory "brcm,bcm63xx-switch"
-
-Required properties for BCM585xx/586xx/88312 SoCs:
-
- - reg: a total of 3 register base addresses, the first one must be the
-   Switch Register Access block base, the second is the port 5/4 mux
-   configuration register and the third one is the SGMII configuration
-   and status register base address.
-
- - interrupts: a total of 13 interrupts must be specified, in the following
-   order: port 0-5, 7-8 link status change, then the integrated PHY interrupt,
-   then the timestamping interrupt and the sleep timer interrupts for ports
-   5,7,8.
-
-Optional properties for BCM585xx/586xx/88312 SoCs:
-
-  - reg-names: a total of 3 names matching the 3 base register address, must
-    be in the following order:
-	"srab"
-	"mux_config"
-	"sgmii_config"
-
-  - interrupt-names: a total of 13 names matching the 13 interrupts specified
-    must be in the following order:
-	"link_state_p0"
-	"link_state_p1"
-	"link_state_p2"
-	"link_state_p3"
-	"link_state_p4"
-	"link_state_p5"
-	"link_state_p7"
-	"link_state_p8"
-	"phy"
-	"ts"
-	"imp_sleep_timer_p5"
-	"imp_sleep_timer_p7"
-	"imp_sleep_timer_p8"
-
-See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
-required and optional properties.
-
-Examples:
-
-Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
-
-	eth0: ethernet@10001000 {
-		compatible = "brcm,unimac";
-		reg = <0x10001000 0x1000>;
-
-		fixed-link {
-			speed = <1000>;
-			full-duplex;
-		};
-	};
-
-	mdio0: mdio@10000000 {
-		compatible = "brcm,unimac-mdio";
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		switch0: ethernet-switch@1e {
-			compatible = "brcm,bcm53125";
-			reg = <30>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				port0@0 {
-					reg = <0>;
-					label = "lan1";
-				};
-
-				port1@1 {
-					reg = <1>;
-					label = "lan2";
-				};
-
-				port5@5 {
-					reg = <5>;
-					label = "cable-modem";
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-					phy-mode = "rgmii-txid";
-				};
-
-				port8@8 {
-					reg = <8>;
-					label = "cpu";
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-					phy-mode = "rgmii-txid";
-					ethernet = <&eth0>;
-				};
-			};
-		};
-	};
diff --git a/MAINTAINERS b/MAINTAINERS
index 14c2b168e077..79dca6ec803d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3393,7 +3393,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	netdev@vger.kernel.org
 L:	openwrt-devel@lists.openwrt.org (subscribers-only)
 S:	Supported
-F:	Documentation/devicetree/bindings/net/dsa/b53.txt
+F:	Documentation/devicetree/bindings/net/dsa/b53.yaml
 F:	drivers/net/dsa/b53/*
 F:	include/linux/platform_data/b53.h
 
-- 
2.26.2

