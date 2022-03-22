Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AFB4E4701
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 20:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiCVT4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 15:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiCVT4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 15:56:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ED44DF52;
        Tue, 22 Mar 2022 12:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647978919; x=1679514919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NnKSWRsw8QIx7UpcdyM5/vxOxc+dVCgzVMlIGo5Msg0=;
  b=ddjTyca+hqoEpT2GQpkUNuAE8vMlQkQbkiXDs4wbCI48KLkjDRD4segf
   iZ733TBENZeLi77/Fy4eVO0308kxR3/PnDk7gZyp6akakuUcYp45PijPm
   KHg42liavyIpq+cPT7N+ZCNk8QqIv99BTCc7UlIcS9B0J//26dHqublJi
   exZB25yuwfaQyJXTThwp4Z/6xvp6D2vkg/Mou2EmH9ioas2ltKk3JJX6n
   HXY5i0TcPW39+pX4q25hpV/QzCztykXbFSkK/dDCrfY5oTExdqP4rhH1p
   Wf26DF69OK0pskV/ulRjetGWOruYTOaIl2qS/n4Bx1ztjr6ao6TJPI46N
   g==;
X-IronPort-AV: E=Sophos;i="5.90,202,1643698800"; 
   d="scan'208";a="152878388"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2022 12:55:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Mar 2022 12:55:17 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 22 Mar 2022 12:55:11 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH v10 net-next 02/10] dt-bindings: net: dsa: dt bindings for microchip lan937x
Date:   Wed, 23 Mar 2022 01:24:47 +0530
Message-ID: <20220322195455.703921-3-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
References: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 .../bindings/net/dsa/microchip,lan937x.yaml   | 160 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
new file mode 100644
index 000000000000..8974506d8f69
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -0,0 +1,160 @@
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
+  tx-internal-delay-ps:
+    enum: [0, 2000]
+    default: 0
+
+  rx-internal-delay-ps:
+    enum: [0, 2000]
+    default: 0
+
+required:
+  - compatible
+  - reg
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
+            phy-handle = <&t1phy6>;
+          };
+          port@7 {
+            reg = <7>;
+            label = "lan3";
+            phy-mode = "internal";
+            phy-handle = <&t1phy7>;
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
+          t1phy6: ethernet-phy@6{
+            reg = <0x6>;
+          };
+          t1phy7: ethernet-phy@7{
+            reg = <0x7>;
+          };
+        };
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index e5ce4f60786e..7d66f9f1679c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12664,6 +12664,7 @@ M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
-- 
2.30.2

