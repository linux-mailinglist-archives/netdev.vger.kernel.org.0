Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289C75E66FF
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiIVPYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiIVPYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:24:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1322B1AF;
        Thu, 22 Sep 2022 08:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663860281; x=1695396281;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+K1IIKBAColBuSmX3F5oRjok4O1iU/y3CYweE7B1otI=;
  b=hcNv8atFbuE16HLM/ZbRdsRU58seN3CXw6JK9f5mW4Qhun+WOYWW1olY
   SEJjJZVhbMxJCkAV/bm22HgE51waf58kiORwV6vmL9ckytNmfotkyYIAs
   FxvYj8xjsXm8knIhKGouXlz2kmTx8Z906rO0wDRFLD0UIsTGEntlB3pFp
   LnT4AscYwzvtNWUByAkkDYVBe/cj4QVPqzsythLQ0yV4oVATXO2qhCRC/
   6FbMt4snvJds4PnRuCaq4S3VZQqsqViqutzp8MpXomSYhMf+lpxRiidkp
   ahU5Yaydq3sHpWYp4V9PX53sfIdWMmyJu36lUXUugtPGd6dxyCsJTQvHv
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="192053280"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2022 08:24:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 22 Sep 2022 08:24:40 -0700
Received: from ATX-DK-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 22 Sep 2022 08:24:38 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [internal][PATCH] dt-bindings: dsa: lan9303: Add lan9303 yaml
Date:   Thu, 22 Sep 2022 10:24:38 -0500
Message-ID: <20220922152438.350-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the dt binding yaml for the lan9303 3-port ethernet switch.
The microchip lan9354 3-port ethernet switch will also use the
same binding.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 .../devicetree/bindings/net/dsa/lan9303.txt   | 100 +-----------
 .../bindings/net/dsa/microchip,lan9303.yaml   | 143 ++++++++++++++++++
 MAINTAINERS                                   |   8 +
 3 files changed, 152 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/lan9303.txt b/Documentation/devicetree/bindings/net/dsa/lan9303.txt
index 464d6bf87605..44d1882530b1 100644
--- a/Documentation/devicetree/bindings/net/dsa/lan9303.txt
+++ b/Documentation/devicetree/bindings/net/dsa/lan9303.txt
@@ -1,102 +1,4 @@
 SMSC/MicroChip LAN9303 three port ethernet switch
 -------------------------------------------------
 
-Required properties:
-
-- compatible: should be
-  - "smsc,lan9303-i2c" for I2C managed mode
-    or
-  - "smsc,lan9303-mdio" for mdio managed mode
-
-Optional properties:
-
-- reset-gpios: GPIO to be used to reset the whole device
-- reset-duration: reset duration in milliseconds, defaults to 200 ms
-
-Subnodes:
-
-The integrated switch subnode should be specified according to the binding
-described in dsa/dsa.txt. The CPU port of this switch is always port 0.
-
-Note: always use 'reg = <0/1/2>;' for the three DSA ports, even if the device is
-configured to use 1/2/3 instead. This hardware configuration will be
-auto-detected and mapped accordingly.
-
-Example:
-
-I2C managed mode:
-
-	master: masterdevice@X {
-
-		fixed-link { /* RMII fixed link to LAN9303 */
-			speed = <100>;
-			full-duplex;
-		};
-	};
-
-	switch: switch@a {
-		compatible = "smsc,lan9303-i2c";
-		reg = <0xa>;
-		reset-gpios = <&gpio7 6 GPIO_ACTIVE_LOW>;
-		reset-duration = <200>;
-
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			port@0 { /* RMII fixed link to master */
-				reg = <0>;
-				label = "cpu";
-				ethernet = <&master>;
-			};
-
-			port@1 { /* external port 1 */
-				reg = <1>;
-				label = "lan1";
-			};
-
-			port@2 { /* external port 2 */
-				reg = <2>;
-				label = "lan2";
-			};
-		};
-	};
-
-MDIO managed mode:
-
-	master: masterdevice@X {
-		phy-handle = <&switch>;
-
-		mdio {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			switch: switch-phy@0 {
-				compatible = "smsc,lan9303-mdio";
-				reg = <0>;
-				reset-gpios = <&gpio7 6 GPIO_ACTIVE_LOW>;
-				reset-duration = <100>;
-
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-						label = "cpu";
-						ethernet = <&master>;
-					};
-
-					port@1 { /* external port 1 */
-						reg = <1>;
-						label = "lan1";
-					};
-
-					port@2 { /* external port 2 */
-						reg = <2>;
-						label = "lan2";
-					};
-				};
-			};
-		};
-	};
+See Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml for the documentation.
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
new file mode 100644
index 000000000000..aefec1dad601
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
@@ -0,0 +1,143 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/microchip,lan9303.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: LAN9303 Ethernet Switch Series Tree Bindings
+
+allOf:
+  - $ref: "dsa.yaml#"
+
+maintainers:
+  - UNGLinuxDriver@microchip.com
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - smsc,lan9303-mdio
+          - microchip,lan9354-mdio
+      - enum:
+          - smsc,lan9303-i2c
+
+  reg:
+    maxItems: 1
+
+  reset-gpios:
+    description: Optional gpio specifier for a reset line
+    maxItems: 1
+
+  reset-duration:
+    description: Reset duration in milliseconds, defaults to 200 ms
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
+    //Ethernet switch connected via mdio to the host
+    ethernet0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy-handle = <&lan9303switch>;
+        phy-mode = "rmii";
+        fixed-link {
+            speed = <100>;
+            full-duplex;
+        };
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            lan9303switch: switch@0 {
+                compatible = "smsc,lan9303-mdio";
+                dsa,member = <0 0>;
+                reg = <0>;
+                ethernet-ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                        port@0 {
+                            reg = <0>;
+                            phy-mode = "rmii";
+                            ethernet = <&ethernet>;
+                            label = "cpu";
+                            fixed-link {
+                                speed = <100>;
+                                full-duplex;
+                            };
+                        };
+                        port@1 {
+                            reg = <1>;
+                            label = "lan1";
+                        };
+                        port@2 {
+                            reg = <2>;
+                            label = "lan2";
+                        };
+                    };
+                };
+            };
+        };
+
+    //Ethernet switch connected via i2c to the host
+    ethernet1 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy-mode = "rmii";
+        fixed-link {
+            speed = <100>;
+            full-duplex;
+        };
+    };
+
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        lan9303: switch@0 {
+            compatible = "smsc,lan9303-i2c";
+            reg = <0>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                port@0 {
+                    reg = <0>;
+                    label = "cpu";
+                    phy-mode = "rmii";
+                    ethernet = <&ethernet>;
+                    fixed-link {
+                        speed = <100>;
+                        full-duplex;
+                    };
+                };
+                port@1 {
+                    reg = <1>;
+                    label = "lan1";
+                };
+                port@2 {
+                    reg = <2>;
+                    label = "lan2";
+                };
+            };
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                phy0: ethernet-switch@0{
+                    reg = <0x0>;
+                };
+                phy1: ethernet-switch@1{
+                    reg = <0x1>;
+                };
+                phy2: ethernet-switch@2{
+                    reg = <0x2>;
+                };
+            };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 74036b51911d..d9abe66092be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13385,6 +13385,14 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/microchip/lan743x_*
 
+MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
+M:	Jerry Ray <jerry.ray@microchip.com>
+M:	UNGLinuxDriver@microchip.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
+F:	drivers/net/dsa/lan9303*
+
 MICROCHIP LAN966X ETHERNET DRIVER
 M:	Horatiu Vultur <horatiu.vultur@microchip.com>
 M:	UNGLinuxDriver@microchip.com
-- 
2.25.1

