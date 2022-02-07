Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C294AC760
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377266AbiBGR1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346068AbiBGRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A7BC0401DC;
        Mon,  7 Feb 2022 09:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644254609; x=1675790609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eZychptXoH+ychXe9Jw+hRlk0fakUZ3gzxL+NSx7waw=;
  b=NcYGNdhQYUbahV+5hsmHLyfP/K9WBh4Ef3cQH79mE5YB23NpHdUfzb30
   eUMePjwRVLRK3JwoeEKd/TtHIZC7lnByARmpChVxDIk+S21yogD63wTgF
   yKFI0qxktIK2Wx1R/TrG3pQIpToLRA6PggUh1JXDpBXNpW5Pugacxy8tS
   Mob53YTem6aNgyX3Yo5R+/rMG3bhxZ27Pcr3m9PpGGwVoe/0pL7mWtXiq
   M20RRO23aSMS7gGaIl0DPynhPZbviqyIaPJQRs+ayqMEcWulj8jb/X6Xk
   zrC/mnnDLd3aJy9vTwTgHeLcmQP5rG4+Xh5D680ddamPPe4QTRWUne2jg
   g==;
IronPort-SDR: Tn8Bj053obmzmBf3EdSVeXGPPDBpRgaBVaRbWimcLTqBlmOTeNRGiokbCI3D5m5LoBVvtDvjXM
 3bnoaFPsP12YM8yl9WVqIjUGyK953gqyqlNKURJkv9AeiupybgqgjtXgTzloWD5xjf5L7zd6EG
 nBXl+38pBofmd1ZpYqaHA3l4KZzdVc+rxRn9Y4uTD+0UPZZX9anStwvaGbSosJhMfxof/+vsko
 kyUt8Xe5yDUasmT87+XzpMmIGF7eP400AFKBWb5/BNkS6H8Mo5viQg/ce17MYLyTjkro8H9BzW
 +cqj5nL1L3ZrogAn0zNvQtyC
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="84924991"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2022 10:22:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Feb 2022 10:22:25 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Feb 2022 10:22:19 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v8 net-next 01/10] dt-bindings: net: dsa: dt bindings for microchip lan937x
Date:   Mon, 7 Feb 2022 22:51:55 +0530
Message-ID: <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation in .yaml format and updates to the MAINTAINERS
Also 'make dt_binding_check' is passed.

RGMII internal delay values for the mac is retrieved from
rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
v3 patch series.
https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/

It supports only the delay value of 0ns and 2ns.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/dsa/microchip,lan937x.yaml   | 179 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 180 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
new file mode 100644
index 000000000000..5657a0b89e4e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -0,0 +1,179 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: LAN937x Ethernet Switch Series Tree Bindings
+
+maintainers:
+  - UNGLinuxDriver@microchip.com
+
+allOf:
+  - $ref: dsa.yaml#
+
+properties:
+  compatible:
+    enum:
+      - microchip,lan9370
+      - microchip,lan9371
+      - microchip,lan9372
+      - microchip,lan9373
+      - microchip,lan9374
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 50000000
+
+  reset-gpios:
+    description: Optional gpio specifier for a reset line
+    maxItems: 1
+
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    patternProperties:
+      "^(ethernet-)?port@[0-7]+$":
+        allOf:
+          - if:
+              properties:
+                phy-mode:
+                  contains:
+                    enum:
+                      - rgmii
+                      - rgmii-rxid
+                      - rgmii-txid
+                      - rgmii-id
+            then:
+              properties:
+                rx-internal-delay-ps:
+                  $ref: "#/$defs/internal-delay-ps"
+                tx-internal-delay-ps:
+                  $ref: "#/$defs/internal-delay-ps"
+
+required:
+  - compatible
+  - reg
+
+$defs:
+  internal-delay-ps:
+    description: Delay is in pico seconds
+    enum: [0, 2000]
+    default: 0
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    //Ethernet switch connected via spi to the host
+    ethernet {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      fixed-link {
+        speed = <1000>;
+        full-duplex;
+      };
+    };
+
+    spi {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      lan9374: switch@0 {
+        compatible = "microchip,lan9374";
+        reg = <0>;
+
+        spi-max-frequency = <44000000>;
+
+        ethernet-ports {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          port@0 {
+            reg = <0>;
+            label = "lan1";
+            phy-mode = "internal";
+            phy-handle = <&t1phy0>;
+          };
+          port@1 {
+            reg = <1>;
+            label = "lan2";
+            phy-mode = "internal";
+            phy-handle = <&t1phy1>;
+          };
+          port@2 {
+            reg = <2>;
+            label = "lan4";
+            phy-mode = "internal";
+            phy-handle = <&t1phy2>;
+          };
+          port@3 {
+            reg = <3>;
+            label = "lan6";
+            phy-mode = "internal";
+            phy-handle = <&t1phy3>;
+          };
+          port@4 {
+            reg = <4>;
+            phy-mode = "rgmii";
+            ethernet = <&ethernet>;
+            fixed-link {
+              speed = <1000>;
+              full-duplex;
+            };
+          };
+          port@5 {
+            reg = <5>;
+            label = "lan7";
+            phy-mode = "rgmii";
+            fixed-link {
+              speed = <1000>;
+              full-duplex;
+            };
+          };
+          port@6 {
+            reg = <6>;
+            label = "lan5";
+            phy-mode = "internal";
+            phy-handle = <&t1phy4>;
+          };
+          port@7 {
+            reg = <7>;
+            label = "lan3";
+            phy-mode = "internal";
+            phy-handle = <&t1phy5>;
+          };
+        };
+
+        mdio {
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          t1phy0: ethernet-phy@0{
+            reg = <0x0>;
+          };
+          t1phy1: ethernet-phy@1{
+            reg = <0x1>;
+          };
+          t1phy2: ethernet-phy@2{
+            reg = <0x2>;
+          };
+          t1phy3: ethernet-phy@3{
+            reg = <0x3>;
+          };
+          t1phy4: ethernet-phy@6{
+            reg = <0x6>;
+          };
+          t1phy5: ethernet-phy@7{
+            reg = <0x7>;
+          };
+        };
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index c7169da15ab4..4449cc2e9c69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12630,6 +12630,7 @@ M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
-- 
2.30.2

