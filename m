Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A05B396A22
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 01:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhEaXtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 19:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhEaXtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 19:49:24 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E356C061574;
        Mon, 31 May 2021 16:47:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id jt22so18831136ejb.7;
        Mon, 31 May 2021 16:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nye33/azhY989fSWfDH7wtSEsC0TAbGD11w81JUZxGE=;
        b=MZb9AkEXGg8B+vuB5Ox/rWWo8pI+apxYeG6/xMNneCyZvWdUuj6h2F8wgggSRCExA8
         odJt0E1a5TISxeerM5jDT8vaCkjLgCXNLKhyMuzYImoXpKZhrBEYOFKUFw8uUyp86P4N
         xTgaZNnZpOou+hcOqeIsSHqJ4X7BiR6gLr1LiRwwA+7eXiuf6fFnZ9C++IrMusNP4kIo
         GtcdUKNNGXmw7Mn+/CuYgV+XNpx/RefKIyY+1vbaFxS+kUrtNWEaolgZAFbHcmDUGPRb
         sebGlY+JZs2WL4ve7Sa8E8etWVWOoswX7+NA+tG08261iAXdV3ta3/1arR4f2PHNJy5N
         nxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nye33/azhY989fSWfDH7wtSEsC0TAbGD11w81JUZxGE=;
        b=scKh/ZojHPQk1bbS+i1hLptf6AacjkQNsgcY0VlIGD6TLZSiop+Q1h1yVBTUOu2eoI
         pX96RpKMKiINxf/pi+do6xUiSo2YhRf4KvkAdVZpAT4lZAwIJ76Qi2Rq6CkWhpFxc61D
         +ZsnkozNSBa740KZpMORQOiQXVi47gamZzbdcOAj9lrsoCB+It19VfHv6g18fN67I3RY
         V10P8r4BMWLScuB2HH0cYKEBdO30qKpHyYl6DHmcBXH6CUudj3nk9srKAM1PK5BRySPC
         whrHuSqvKkQYT1OyxDx8k8U0gggWLdIuMxxPRr5sO0Iowmr81UKBGGFCYByK29kyf5GA
         92sQ==
X-Gm-Message-State: AOAM5311C7BAQjcpBjuE1J2hOF/LwXsgSVjBJdntAGBZBpWxc7lvIdTX
        hKF1t8H6luNkmeiovNL7Xd0=
X-Google-Smtp-Source: ABdhPJwrfEM1+PCKlvcFKnJ2L+EXEx1iN/afVIrMCo9Qw2yPbWxIKObVtxnSVETPIchvgva6+rflyQ==
X-Received: by 2002:a17:906:bb0e:: with SMTP id jz14mr25124027ejb.285.1622504859889;
        Mon, 31 May 2021 16:47:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id um5sm3342658ejb.109.2021.05.31.16.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 16:47:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] dt-bindings: net: dsa: sja1105: convert to YAML schema
Date:   Tue,  1 Jun 2021 02:47:35 +0300
Message-Id: <20210531234735.1582031-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The following issues exist with the device-specific sja1105,role-mac and
sja1105,role-phy:

(a) the "sja1105" is not a valid vendor prefix and should probably have
    been "nxp", but
(b) as per the discussion with Florian here:
    https://lore.kernel.org/netdev/20210201214515.cx6ivvme2tlquge2@skbuf/
    more phy-mode values similar to "revmii" can be added which denote
    that the port is in the role of a PHY (such as "revrmii"), making
    the sja1105,role-phy redundant. Because there are no upstream users
    (or any users at all, to my knowledge) of these properties, they
    could even be removed in a future commit as far as I am concerned.
(c) when I force-add sja1105,role-phy to a device tree for testing, the
    patternProperties matching does not work, it results in the following
    error:

ethernet-switch@2: ethernet-ports:port@1: 'sja1105,role-phy' does not match any of the regexes: 'pinctrl-[0-9]+'
        From schema: Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml

But what's even more interesting is that if I remove the
"additionalProperties: true" that dsa.yaml has, I get even more
validation errors coming from patternProperties not matching either,
from spi-controller.yaml:

ethernet-switch@2: 'compatible', 'mdio', 'reg', 'spi-cpol', 'spi-max-frequency' do not match any of the regexes: '^(ethernet-)?ports$', 'pinctrl-[0-9]+'

So... it is probably broken. Rob Herring says here:
https://lore.kernel.org/linux-spi/20210324181037.GB3320002@robh.at.kernel.org/

  I'm aware of the issue, but I don't have a solution for this situation.
  It's a problem anywhere we have a parent or bus binding defining
  properties for child nodes. For now, I'd just avoid it in the examples
  and we'll figure out how to deal with actual dts files later.

So that's what I did.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../bindings/net/dsa/nxp,sja1105.yaml         | 128 ++++++++++++++
 .../devicetree/bindings/net/dsa/sja1105.txt   | 156 ------------------
 2 files changed, 128 insertions(+), 156 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
new file mode 100644
index 000000000000..312f859cc40c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -0,0 +1,128 @@
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
+patternProperties:
+  "^(ethernet-)?ports$":
+    type: object
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        type: object
+        properties:
+
+          # By default (unless otherwise specified) a port is configured as MAC
+          # if it is driving a PHY (phy-handle is present) or as PHY if it is
+          # PHY-less (fixed-link specified, presumably because it is connected
+          # to a MAC). It is suggested to not use these bindings unless an
+          # explicit override is necessary (for example, if SJA1105 ports are at
+          # both ends of a MII/RMII PHY-less setup. In that case, one end would
+          # need to have sja1105,role-mac, and the other sja1105,role-phy).
+          sja1105,role-mac:
+            $ref: /schemas/types.yaml#/definitions/flag
+            description: |
+                Specifies whether the SJA1105 port is a clock source or sink
+                for this interface, according to the applicable standard
+                (applicable for MII and RMII, but not applicable for RGMII
+                where there are separate TX and RX clocks). In the case of
+                RGMII it affects the behavior regarding internal delays.
+                If the port is configured in the role of an RGMII MAC, it will
+                let the PHY apply internal RGMII delays according to the
+                phy-mode property, otherwise it will apply the delays itself.
+
+          sja1105,role-phy:
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+                See sja1105,role-mac.
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
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-switch@1 {
+            reg = <0x1>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+            compatible = "nxp,sja1105t";
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    phy-handle = <&rgmii_phy6>;
+                    phy-mode = "rgmii-id";
+                    reg = <0>;
+                    /* Implicit "sja1105,role-mac;" */
+                };
+
+                port@1 {
+                    phy-handle = <&rgmii_phy3>;
+                    phy-mode = "rgmii-id";
+                    reg = <1>;
+                    /* Implicit "sja1105,role-mac;" */
+                };
+
+                port@2 {
+                    phy-handle = <&rgmii_phy4>;
+                    phy-mode = "rgmii-id";
+                    reg = <2>;
+                    /* Implicit "sja1105,role-mac;" */
+                };
+
+                port@3 {
+                    phy-mode = "rgmii-id";
+                    reg = <3>;
+                };
+
+                port@4 {
+                    ethernet = <&enet2>;
+                    phy-mode = "rgmii";
+                    reg = <4>;
+                    /* Implicit "sja1105,role-phy;" */
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/dsa/sja1105.txt b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
deleted file mode 100644
index 13fd21074d48..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/sja1105.txt
+++ /dev/null
@@ -1,156 +0,0 @@
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
-Optional properties:
-
-- sja1105,role-mac:
-- sja1105,role-phy:
-	Boolean properties that can be assigned under each port node. By
-	default (unless otherwise specified) a port is configured as MAC if it
-	is driving a PHY (phy-handle is present) or as PHY if it is PHY-less
-	(fixed-link specified, presumably because it is connected to a MAC).
-	The effect of this property (in either its implicit or explicit form)
-	is:
-	- In the case of MII or RMII it specifies whether the SJA1105 port is a
-	  clock source or sink for this interface (not applicable for RGMII
-	  where there is a Tx and an Rx clock).
-	- In the case of RGMII it affects the behavior regarding internal
-	  delays:
-	  1. If sja1105,role-mac is specified, and the phy-mode property is one
-	     of "rgmii-id", "rgmii-txid" or "rgmii-rxid", then the entity
-	     designated to apply the delay/clock skew necessary for RGMII
-	     is the PHY. The SJA1105 MAC does not apply any internal delays.
-	  2. If sja1105,role-phy is specified, and the phy-mode property is one
-	     of the above, the designated entity to apply the internal delays
-	     is the SJA1105 MAC (if hardware-supported). This is only supported
-	     by the second-generation (P/Q/R/S) hardware. On a first-generation
-	     E or T device, it is an error to specify an RGMII phy-mode other
-	     than "rgmii" for a port that is in fixed-link mode. In that case,
-	     the clock skew must either be added by the MAC at the other end of
-	     the fixed-link, or by PCB serpentine traces on the board.
-	These properties are required, for example, in the case where SJA1105
-	ports are at both ends of a MII/RMII PHY-less setup. One end would need
-	to have sja1105,role-mac, while the other sja1105,role-phy.
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
-				/* Implicit "sja1105,role-mac;" */
-			};
-			port@1 {
-				/* ETH2 written on chassis */
-				label = "swp2";
-				phy-handle = <&rgmii_phy3>;
-				phy-mode = "rgmii-id";
-				reg = <1>;
-				/* Implicit "sja1105,role-mac;" */
-			};
-			port@2 {
-				/* ETH3 written on chassis */
-				label = "swp3";
-				phy-handle = <&rgmii_phy4>;
-				phy-mode = "rgmii-id";
-				reg = <2>;
-				/* Implicit "sja1105,role-mac;" */
-			};
-			port@3 {
-				/* ETH4 written on chassis */
-				phy-handle = <&rgmii_phy5>;
-				label = "swp4";
-				phy-mode = "rgmii-id";
-				reg = <3>;
-				/* Implicit "sja1105,role-mac;" */
-			};
-			port@4 {
-				/* Internal port connected to eth2 */
-				ethernet = <&enet2>;
-				phy-mode = "rgmii";
-				reg = <4>;
-				/* Implicit "sja1105,role-phy;" */
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

