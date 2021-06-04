Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA88139BA7B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 16:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFDOEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 10:04:51 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:33605 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhFDOEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 10:04:47 -0400
Received: by mail-ed1-f50.google.com with SMTP id f5so6270881eds.0;
        Fri, 04 Jun 2021 07:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CdwRMB28kWkqo/GirWTGo187wSfdCIuXbPUz3JKOzRk=;
        b=RsS2vaKlFfWrKaaTaCnFK0aFrlYXJQDthsaAr2yK5NXmRT+yEX1Vq1tUciL9qFjmYD
         l5jXpYT0eGK9HAS2IUfYQbH9W2OZCsUfYb74yWS0szkj1V2SqEeVtoymBgGhcBBvpoch
         1KWXQ5VnpLOwYUM6j1DCebJqh0cyVwHAvZNh6PmLIQ/TEbGQQCIYEykgvcvz7UxVAqGH
         hKs37GfLg/zRBbrwPq9nvAsWlG2ERuWqGj0HAdofTbC7O7O5dgK3fpUQly5GuUt97VbU
         RJInx/wk15Dv34vXqdQED9w5Wz36BQc/UR2xHZlUHlTk6h/WK3QQ7ScA2ee9oB/s5pq2
         rkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CdwRMB28kWkqo/GirWTGo187wSfdCIuXbPUz3JKOzRk=;
        b=hAtVCS0skd/K3ORi9ru4WuU5+sQfvFQdBAyoJHzF4l8hofiia8kQGmoE/l1GIAzjOw
         kfjDCG6K8gxZz3N8blx0rJIcr+fckg5v4uPpMuuqZimo5ygFvreAexeyVfceC9ymc6Bi
         NbHEAFl6xfgqoHRzvgPMsLvnW2T1Fjb27RIw0rlzl/BktQQn2ATxY1ScFvFMXHFFjMVV
         N8Rf2zQiZOSR25ze8gZh7tthewelUV2jOAmkHDtksxyMomX8BVhY63kCGw1F4nzH+yQY
         SkEaPLAzB0scercyXtAhUkj8iWkMkkuwthfXZrynnVmKaSdz9Mh4Vf5Vi86jjRABHoc+
         wO1Q==
X-Gm-Message-State: AOAM5304XHj78xcpV3z3iy+2Dg51Afrh0tJRGmbIlhcdZL3xuJjD8+zg
        PUmLOIyXnAOSM+LE292X1W1ry/besfk=
X-Google-Smtp-Source: ABdhPJyuqQdSu1dhzxXcW1rDdvbggDHZCAL34ldPk2FHQFYOFOFFvU/N5NsBuxfzXP+4x5SLDRAtLg==
X-Received: by 2002:aa7:dc4c:: with SMTP id g12mr4951565edu.258.1622815320231;
        Fri, 04 Jun 2021 07:02:00 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id a22sm2804513ejv.67.2021.06.04.07.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 07:01:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 4/4] dt-bindings: net: dsa: sja1105: convert to YAML schema
Date:   Fri,  4 Jun 2021 17:01:51 +0300
Message-Id: <20210604140151.2885611-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210604140151.2885611-1-olteanv@gmail.com>
References: <20210604140151.2885611-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the sja1105 driver no longer has any custom device tree
properties, the conversion is trivial.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../bindings/net/dsa/nxp,sja1105.yaml         |  89 +++++++++++++
 .../devicetree/bindings/net/dsa/sja1105.txt   | 121 ------------------
 2 files changed, 89 insertions(+), 121 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
new file mode 100644
index 000000000000..d6ac9a0c1b04
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -0,0 +1,89 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/nxp,sja1105.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP SJA1105 Automotive Ethernet Switch Family Device Tree Bindings
+
+description:
+  The SJA1105 SPI interface requires a CS-to-CLK time (t2 in UM10944.pdf) of at
+  least one half of t_CLK. At an SPI frequency of 1MHz, this means a minimum
+  cs_sck_delay of 500ns. Ensuring that this SPI timing requirement is observed
+  depends on the SPI bus master driver.
+
+allOf:
+  - $ref: "dsa.yaml#"
+
+maintainers:
+  - Vladimir Oltean <vladimir.oltean@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,sja1105e
+      - nxp,sja1105t
+      - nxp,sja1105p
+      - nxp,sja1105q
+      - nxp,sja1105r
+      - nxp,sja1105s
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    spi {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet-switch@1 {
+                    reg = <0x1>;
+                    compatible = "nxp,sja1105t";
+
+                    ethernet-ports {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            port@0 {
+                                    phy-handle = <&rgmii_phy6>;
+                                    phy-mode = "rgmii-id";
+                                    reg = <0>;
+                            };
+
+                            port@1 {
+                                    phy-handle = <&rgmii_phy3>;
+                                    phy-mode = "rgmii-id";
+                                    reg = <1>;
+                            };
+
+                            port@2 {
+                                    phy-handle = <&rgmii_phy4>;
+                                    phy-mode = "rgmii-id";
+                                    reg = <2>;
+                            };
+
+                            port@3 {
+                                    phy-mode = "rgmii-id";
+                                    reg = <3>;
+                            };
+
+                            port@4 {
+                                    ethernet = <&enet2>;
+                                    phy-mode = "rgmii";
+                                    reg = <4>;
+
+                                    fixed-link {
+                                            speed = <1000>;
+                                            full-duplex;
+                                    };
+                            };
+                    };
+            };
+    };
diff --git a/Documentation/devicetree/bindings/net/dsa/sja1105.txt b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
deleted file mode 100644
index dcf3b2c1d26b..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/sja1105.txt
+++ /dev/null
@@ -1,121 +0,0 @@
-NXP SJA1105 switch driver
-=========================
-
-Required properties:
-
-- compatible:
-	Must be one of:
-	- "nxp,sja1105e"
-	- "nxp,sja1105t"
-	- "nxp,sja1105p"
-	- "nxp,sja1105q"
-	- "nxp,sja1105r"
-	- "nxp,sja1105s"
-
-	Although the device ID could be detected at runtime, explicit bindings
-	are required in order to be able to statically check their validity.
-	For example, SGMII can only be specified on port 4 of R and S devices,
-	and the non-SGMII devices, while pin-compatible, are not equal in terms
-	of support for RGMII internal delays (supported on P/Q/R/S, but not on
-	E/T).
-
-See Documentation/devicetree/bindings/net/dsa/dsa.txt for the list of standard
-DSA required and optional properties.
-
-Other observations
-------------------
-
-The SJA1105 SPI interface requires a CS-to-CLK time (t2 in UM10944) of at least
-one half of t_CLK. At an SPI frequency of 1MHz, this means a minimum
-cs_sck_delay of 500ns. Ensuring that this SPI timing requirement is observed
-depends on the SPI bus master driver.
-
-Example
--------
-
-Ethernet switch connected via SPI to the host, CPU port wired to enet2:
-
-arch/arm/boot/dts/ls1021a-tsn.dts:
-
-/* SPI controller of the LS1021 */
-&dspi0 {
-	sja1105@1 {
-		reg = <0x1>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nxp,sja1105t";
-		spi-max-frequency = <4000000>;
-		fsl,spi-cs-sck-delay = <1000>;
-		fsl,spi-sck-cs-delay = <1000>;
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			port@0 {
-				/* ETH5 written on chassis */
-				label = "swp5";
-				phy-handle = <&rgmii_phy6>;
-				phy-mode = "rgmii-id";
-				reg = <0>;
-			};
-			port@1 {
-				/* ETH2 written on chassis */
-				label = "swp2";
-				phy-handle = <&rgmii_phy3>;
-				phy-mode = "rgmii-id";
-				reg = <1>;
-			};
-			port@2 {
-				/* ETH3 written on chassis */
-				label = "swp3";
-				phy-handle = <&rgmii_phy4>;
-				phy-mode = "rgmii-id";
-				reg = <2>;
-			};
-			port@3 {
-				/* ETH4 written on chassis */
-				phy-handle = <&rgmii_phy5>;
-				label = "swp4";
-				phy-mode = "rgmii-id";
-				reg = <3>;
-			};
-			port@4 {
-				/* Internal port connected to eth2 */
-				ethernet = <&enet2>;
-				phy-mode = "rgmii";
-				reg = <4>;
-
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-				};
-			};
-		};
-	};
-};
-
-/* MDIO controller of the LS1021 */
-&mdio0 {
-	/* BCM5464 */
-	rgmii_phy3: ethernet-phy@3 {
-		reg = <0x3>;
-	};
-	rgmii_phy4: ethernet-phy@4 {
-		reg = <0x4>;
-	};
-	rgmii_phy5: ethernet-phy@5 {
-		reg = <0x5>;
-	};
-	rgmii_phy6: ethernet-phy@6 {
-		reg = <0x6>;
-	};
-};
-
-/* Ethernet master port of the LS1021 */
-&enet2 {
-	phy-connection-type = "rgmii";
-	status = "ok";
-	fixed-link {
-		speed = <1000>;
-		full-duplex;
-	};
-};
-- 
2.25.1

