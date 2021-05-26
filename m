Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C49391ECD
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhEZSPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:15:47 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:45916 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhEZSPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 14:15:46 -0400
Received: by mail-oi1-f177.google.com with SMTP id w127so2383906oig.12;
        Wed, 26 May 2021 11:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OdvaUNXMGSHqgSMnt5Bc+7YoJPjEja9WL1vskHcPFSQ=;
        b=OoLKFftNl+nD5m2Mgz/zV+v1u2Q9UaQXO7NmXgRy7OxSp3hYvHnnKUeqUcEhwqHMrU
         /aNlXtI+o+PQQc99wHksNAhy2x5Kj3+jBryoTiG8QfJ6Du/ESWSxun6/YbJu9bcbcS0x
         jYrL49eQufNM96C9XTCMpzYwbofhbbyLqadX/c7PJVQFDntA2Fmx6fHt9uKIVQE1vQUa
         UDlf6pePbNkxdJ4TsiUDCpF7UQU2J6wApkKDfMzfRcB9Al5aHT9aLPCnSVowhFLV9QhD
         0njZ6bcr6WR9bWR+2x426RNdpmSX1G/f5BHuyGDCFj5ODiawqC0p41sOwXz93oYoIUt+
         NMkA==
X-Gm-Message-State: AOAM5312KiW2wWk/HEVJQCr6FlouA44z2WzprgoMt71kf2czRW02x0IR
        SUyodklxpjWpu/N/DIJFIhm7wULuIQ==
X-Google-Smtp-Source: ABdhPJxpSb0mYH5J7tHLxybuEQsDF1I9C876VtubdCiUuLkux/UyewmsVADzvGghZ7ystGCbf/3Dzg==
X-Received: by 2002:aca:1b0f:: with SMTP id b15mr2736222oib.178.1622052853598;
        Wed, 26 May 2021 11:14:13 -0700 (PDT)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id o13sm4553735ote.32.2021.05.26.11.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 11:14:12 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] dt-bindings: net: Convert MDIO mux bindings to DT schema
Date:   Wed, 26 May 2021 13:14:11 -0500
Message-Id: <20210526181411.2888516-1-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the common MDIO mux bindings to DT schema.

Drop the example from mdio-mux.yaml as mdio-mux-gpio.yaml has the same one.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
 - Fix copy-n-paste error: s/I2C/MDIO/
---
 .../bindings/net/brcm,mdio-mux-iproc.txt      |   2 +-
 .../devicetree/bindings/net/mdio-mux-gpio.txt | 119 ---------------
 .../bindings/net/mdio-mux-gpio.yaml           | 135 ++++++++++++++++++
 .../bindings/net/mdio-mux-mmioreg.txt         |  75 ----------
 .../bindings/net/mdio-mux-mmioreg.yaml        |  78 ++++++++++
 .../bindings/net/mdio-mux-multiplexer.txt     |  82 -----------
 .../bindings/net/mdio-mux-multiplexer.yaml    |  82 +++++++++++
 .../devicetree/bindings/net/mdio-mux.txt      | 129 -----------------
 .../devicetree/bindings/net/mdio-mux.yaml     |  44 ++++++
 9 files changed, 340 insertions(+), 406 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-gpio.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux-mmioreg.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-mmioreg.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux-multiplexer.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-multiplexer.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
index b58843f29591..deb9e852ea27 100644
--- a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
+++ b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
@@ -17,7 +17,7 @@ Optional properties:
 - clocks: phandle of the core clock which drives the mdio block.
 
 Additional information regarding generic multiplexer properties can be found
-at- Documentation/devicetree/bindings/net/mdio-mux.txt
+at- Documentation/devicetree/bindings/net/mdio-mux.yaml
 
 
 for example:
diff --git a/Documentation/devicetree/bindings/net/mdio-mux-gpio.txt b/Documentation/devicetree/bindings/net/mdio-mux-gpio.txt
deleted file mode 100644
index 694987d3c17a..000000000000
--- a/Documentation/devicetree/bindings/net/mdio-mux-gpio.txt
+++ /dev/null
@@ -1,119 +0,0 @@
-Properties for an MDIO bus multiplexer/switch controlled by GPIO pins.
-
-This is a special case of a MDIO bus multiplexer.  One or more GPIO
-lines are used to control which child bus is connected.
-
-Required properties in addition to the generic multiplexer properties:
-
-- compatible : mdio-mux-gpio.
-- gpios : GPIO specifiers for each GPIO line.  One or more must be specified.
-
-
-Example :
-
-	/* The parent MDIO bus. */
-	smi1: mdio@1180000001900 {
-		compatible = "cavium,octeon-3860-mdio";
-		#address-cells = <1>;
-		#size-cells = <0>;
-		reg = <0x11800 0x00001900 0x0 0x40>;
-	};
-
-	/*
-	   An NXP sn74cbtlv3253 dual 1-of-4 switch controlled by a
-	   pair of GPIO lines.  Child busses 2 and 3 populated with 4
-	   PHYs each.
-	 */
-	mdio-mux {
-		compatible = "mdio-mux-gpio";
-		gpios = <&gpio1 3 0>, <&gpio1 4 0>;
-		mdio-parent-bus = <&smi1>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		mdio@2 {
-			reg = <2>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			phy11: ethernet-phy@1 {
-				reg = <1>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-			phy12: ethernet-phy@2 {
-				reg = <2>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-			phy13: ethernet-phy@3 {
-				reg = <3>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-			phy14: ethernet-phy@4 {
-				reg = <4>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-		};
-
-		mdio@3 {
-			reg = <3>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			phy21: ethernet-phy@1 {
-				reg = <1>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-			phy22: ethernet-phy@2 {
-				reg = <2>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-			phy23: ethernet-phy@3 {
-				reg = <3>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-			phy24: ethernet-phy@4 {
-				reg = <4>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/mdio-mux-gpio.yaml b/Documentation/devicetree/bindings/net/mdio-mux-gpio.yaml
new file mode 100644
index 000000000000..71c25c4580ea
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio-mux-gpio.yaml
@@ -0,0 +1,135 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mdio-mux-gpio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Properties for an MDIO bus multiplexer/switch controlled by GPIO pins.
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+
+description:
+  This is a special case of a MDIO bus multiplexer.  One or more GPIO
+  lines are used to control which child bus is connected.
+
+allOf:
+  - $ref: /schemas/net/mdio-mux.yaml#
+
+properties:
+  compatible:
+    const: mdio-mux-gpio
+
+  gpios:
+    description:
+      List of GPIOs used to control the multiplexer, least significant bit first.
+    minItems: 1
+    maxItems: 32
+
+required:
+  - compatible
+  - gpios
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    /*
+     An NXP sn74cbtlv3253 dual 1-of-4 switch controlled by a
+     pair of GPIO lines.  Child busses 2 and 3 populated with 4
+     PHYs each.
+     */
+    mdio-mux {
+        compatible = "mdio-mux-gpio";
+        gpios = <&gpio1 3 0>, <&gpio1 4 0>;
+        mdio-parent-bus = <&smi1>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio@2 {
+            reg = <2>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet-phy@1 {
+                reg = <1>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <10 8>; /* Pin 10, active low */
+            };
+            ethernet-phy@2 {
+                reg = <2>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <10 8>; /* Pin 10, active low */
+            };
+            ethernet-phy@3 {
+                reg = <3>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <10 8>; /* Pin 10, active low */
+            };
+            ethernet-phy@4 {
+                reg = <4>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <10 8>; /* Pin 10, active low */
+            };
+        };
+
+        mdio@3 {
+            reg = <3>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet-phy@1 {
+                reg = <1>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <12 8>; /* Pin 12, active low */
+            };
+            ethernet-phy@2 {
+                reg = <2>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <12 8>; /* Pin 12, active low */
+            };
+            ethernet-phy@3 {
+                reg = <3>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <12 8>; /* Pin 12, active low */
+            };
+            ethernet-phy@4 {
+                reg = <4>;
+                marvell,reg-init = <3 0x10 0 0x5777>,
+                  <3 0x11 0 0x00aa>,
+                  <3 0x12 0 0x4105>,
+                  <3 0x13 0 0x0a60>;
+                interrupt-parent = <&gpio>;
+                interrupts = <12 8>; /* Pin 12, active low */
+            };
+        };
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/mdio-mux-mmioreg.txt b/Documentation/devicetree/bindings/net/mdio-mux-mmioreg.txt
deleted file mode 100644
index 065e8bdb957d..000000000000
--- a/Documentation/devicetree/bindings/net/mdio-mux-mmioreg.txt
+++ /dev/null
@@ -1,75 +0,0 @@
-Properties for an MDIO bus multiplexer controlled by a memory-mapped device
-
-This is a special case of a MDIO bus multiplexer.  A memory-mapped device,
-like an FPGA, is used to control which child bus is connected.  The mdio-mux
-node must be a child of the memory-mapped device.  The driver currently only
-supports devices with 8, 16 or 32-bit registers.
-
-Required properties in addition to the generic multiplexer properties:
-
-- compatible : string, must contain "mdio-mux-mmioreg"
-
-- reg : integer, contains the offset of the register that controls the bus
-	multiplexer.  The size field in the 'reg' property is the size of
-	register, and must therefore be 1, 2, or 4.
-
-- mux-mask : integer, contains an eight-bit mask that specifies which
-	bits in the register control the actual bus multiplexer.  The
-	'reg' property of each child mdio-mux node must be constrained by
-	this mask.
-
-Example:
-
-The FPGA node defines a memory-mapped FPGA with a register space of 0x30 bytes.
-For the "EMI2" MDIO bus, register 9 (BRDCFG1) controls the mux on that bus.
-A bitmask of 0x6 means that bits 1 and 2 (bit 0 is lsb) are the bits on
-BRDCFG1 that control the actual mux.
-
-	/* The FPGA node */
-	fpga: board-control@3,0 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "fsl,p5020ds-fpga", "fsl,fpga-ngpixis";
-		reg = <3 0 0x30>;
-		ranges = <0 3 0 0x30>;
-
-		mdio-mux-emi2 {
-			compatible = "mdio-mux-mmioreg", "mdio-mux";
-			mdio-parent-bus = <&xmdio0>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <9 1>; // BRDCFG1
-			mux-mask = <0x6>; // EMI2
-
-			emi2_slot1: mdio@0 {	// Slot 1 XAUI (FM2)
-				reg = <0>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				phy_xgmii_slot1: ethernet-phy@0 {
-					compatible = "ethernet-phy-ieee802.3-c45";
-					reg = <4>;
-				};
-			};
-
-			emi2_slot2: mdio@2 {	// Slot 2 XAUI (FM1)
-				reg = <2>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				phy_xgmii_slot2: ethernet-phy@4 {
-					compatible = "ethernet-phy-ieee802.3-c45";
-					reg = <0>;
-				};
-			};
-		};
-	};
-
-	/* The parent MDIO bus. */
-	xmdio0: mdio@f1000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "fsl,fman-xmdio";
-		reg = <0xf1000 0x1000>;
-		interrupts = <100 1 0 0>;
-	};
diff --git a/Documentation/devicetree/bindings/net/mdio-mux-mmioreg.yaml b/Documentation/devicetree/bindings/net/mdio-mux-mmioreg.yaml
new file mode 100644
index 000000000000..3b573c95d3f5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio-mux-mmioreg.yaml
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mdio-mux-mmioreg.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Properties for an MDIO bus multiplexer controlled by a memory-mapped device
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+
+description: |+
+  This is a special case of a MDIO bus multiplexer.  A memory-mapped device,
+  like an FPGA, is used to control which child bus is connected.  The mdio-mux
+  node must be a child of the memory-mapped device.  The driver currently only
+  supports devices with 8, 16 or 32-bit registers.
+
+allOf:
+  - $ref: /schemas/net/mdio-mux.yaml#
+
+properties:
+  compatible:
+    items:
+      - const: mdio-mux-mmioreg
+      - const: mdio-mux
+
+  reg:
+    description: Contains the offset of the register that controls the bus
+      multiplexer. The size field in the 'reg' property is the size of register,
+      and must therefore be 1, 2, or 4.
+    maxItems: 1
+
+  mux-mask:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: Contains an eight-bit mask that specifies which bits in the
+      register control the actual bus multiplexer.  The 'reg' property of each
+      child mdio-mux node must be constrained by this mask.
+
+required:
+  - compatible
+  - reg
+  - mux-mask
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio-mux@9 {
+        compatible = "mdio-mux-mmioreg", "mdio-mux";
+        mdio-parent-bus = <&xmdio0>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <9 1>; // BRDCFG1
+        mux-mask = <0x6>; // EMI2
+
+        mdio@0 {  // Slot 1 XAUI (FM2)
+            reg = <0>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            phy_xgmii_slot1: ethernet-phy@0 {
+                compatible = "ethernet-phy-ieee802.3-c45";
+                reg = <4>;
+            };
+        };
+
+        mdio@2 {  // Slot 2 XAUI (FM1)
+            reg = <2>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet-phy@4 {
+                compatible = "ethernet-phy-ieee802.3-c45";
+                reg = <0>;
+            };
+        };
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/mdio-mux-multiplexer.txt b/Documentation/devicetree/bindings/net/mdio-mux-multiplexer.txt
deleted file mode 100644
index 87fd0b4f654f..000000000000
--- a/Documentation/devicetree/bindings/net/mdio-mux-multiplexer.txt
+++ /dev/null
@@ -1,82 +0,0 @@
-Properties for an MDIO bus multiplexer consumer device
-
-This is a special case of MDIO mux  when MDIO mux is defined as a consumer
-of a mux producer device. The mux producer can be of any type like mmio mux
-producer, gpio mux producer or generic register based mux producer.
-
-Required properties in addition to the MDIO Bus multiplexer properties:
-
-- compatible : should be "mmio-mux-multiplexer"
-- mux-controls : mux controller node to use for operating the mux
-- mdio-parent-bus : phandle to the parent MDIO bus.
-
-each child node of mdio bus multiplexer consumer device represent a mdio
-bus.
-
-for more information please refer
-Documentation/devicetree/bindings/mux/mux-controller.yaml
-and Documentation/devicetree/bindings/net/mdio-mux.txt
-
-Example:
-In below example the Mux producer and consumer are separate nodes.
-
-&i2c0 {
-	fpga@66 { // fpga connected to i2c
-		compatible = "fsl,lx2160aqds-fpga", "fsl,fpga-qixis-i2c",
-			     "simple-mfd";
-		reg = <0x66>;
-
-		mux: mux-controller { // Mux Producer
-			compatible = "reg-mux";
-			#mux-control-cells = <1>;
-			mux-reg-masks = <0x54 0xf8>, /* 0: reg 0x54, bits 7:3 */
-					<0x54 0x07>; /* 1: reg 0x54, bits 2:0 */
-		};
-	};
-};
-
-mdio-mux-1 { // Mux consumer
-	compatible = "mdio-mux-multiplexer";
-	mux-controls = <&mux 0>;
-	mdio-parent-bus = <&emdio1>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	mdio@0 {
-		reg = <0x0>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-	};
-
-	mdio@8 {
-		reg = <0x8>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-	};
-
-	..
-	..
-};
-
-mdio-mux-2 { // Mux consumer
-	compatible = "mdio-mux-multiplexer";
-	mux-controls = <&mux 1>;
-	mdio-parent-bus = <&emdio2>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	mdio@0 {
-		reg = <0x0>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-	};
-
-	mdio@1 {
-		reg = <0x1>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-	};
-
-	..
-	..
-};
diff --git a/Documentation/devicetree/bindings/net/mdio-mux-multiplexer.yaml b/Documentation/devicetree/bindings/net/mdio-mux-multiplexer.yaml
new file mode 100644
index 000000000000..282987074ee4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio-mux-multiplexer.yaml
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mdio-mux-multiplexer.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Properties for an MDIO bus multiplexer consumer device
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+
+description: |+
+  This is a special case of MDIO mux when MDIO mux is defined as a consumer
+  of a mux producer device. The mux producer can be of any type like mmio mux
+  producer, gpio mux producer or generic register based mux producer.
+
+
+allOf:
+  - $ref: /schemas/net/mdio-mux.yaml#
+
+properties:
+  compatible:
+    const: mdio-mux-multiplexer
+
+  mux-controls:
+    maxItems: 1
+
+required:
+  - compatible
+  - mux-controls
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mux: mux-controller { // Mux Producer
+        compatible = "reg-mux";
+        #mux-control-cells = <1>;
+        mux-reg-masks = <0x54 0xf8>, /* 0: reg 0x54, bits 7:3 */
+                        <0x54 0x07>; /* 1: reg 0x54, bits 2:0 */
+    };
+
+    mdio-mux-1 { // Mux consumer
+        compatible = "mdio-mux-multiplexer";
+        mux-controls = <&mux 0>;
+        mdio-parent-bus = <&emdio1>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio@0 {
+            reg = <0x0>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+        };
+
+        mdio@8 {
+            reg = <0x8>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+        };
+    };
+
+    mdio-mux-2 { // Mux consumer
+        compatible = "mdio-mux-multiplexer";
+        mux-controls = <&mux 1>;
+        mdio-parent-bus = <&emdio2>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio@0 {
+            reg = <0x0>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+        };
+
+        mdio@1 {
+            reg = <0x1>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+        };
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/mdio-mux.txt b/Documentation/devicetree/bindings/net/mdio-mux.txt
deleted file mode 100644
index f58571f36570..000000000000
--- a/Documentation/devicetree/bindings/net/mdio-mux.txt
+++ /dev/null
@@ -1,129 +0,0 @@
-Common MDIO bus multiplexer/switch properties.
-
-An MDIO bus multiplexer/switch will have several child busses that are
-numbered uniquely in a device dependent manner.  The nodes for an MDIO
-bus multiplexer/switch will have one child node for each child bus.
-
-Required properties:
-- #address-cells = <1>;
-- #size-cells = <0>;
-
-Optional properties:
-- mdio-parent-bus : phandle to the parent MDIO bus.
-
-- Other properties specific to the multiplexer/switch hardware.
-
-Required properties for child nodes:
-- #address-cells = <1>;
-- #size-cells = <0>;
-- reg : The sub-bus number.
-
-
-Example :
-
-	/* The parent MDIO bus. */
-	smi1: mdio@1180000001900 {
-		compatible = "cavium,octeon-3860-mdio";
-		#address-cells = <1>;
-		#size-cells = <0>;
-		reg = <0x11800 0x00001900 0x0 0x40>;
-	};
-
-	/*
-	   An NXP sn74cbtlv3253 dual 1-of-4 switch controlled by a
-	   pair of GPIO lines.  Child busses 2 and 3 populated with 4
-	   PHYs each.
-	 */
-	mdio-mux {
-		compatible = "mdio-mux-gpio";
-		gpios = <&gpio1 3 0>, <&gpio1 4 0>;
-		mdio-parent-bus = <&smi1>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		mdio@2 {
-			reg = <2>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			phy11: ethernet-phy@1 {
-				reg = <1>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-			phy12: ethernet-phy@2 {
-				reg = <2>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-			phy13: ethernet-phy@3 {
-				reg = <3>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-			phy14: ethernet-phy@4 {
-				reg = <4>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <10 8>; /* Pin 10, active low */
-			};
-		};
-
-		mdio@3 {
-			reg = <3>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			phy21: ethernet-phy@1 {
-				reg = <1>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-			phy22: ethernet-phy@2 {
-				reg = <2>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-			phy23: ethernet-phy@3 {
-				reg = <3>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-			phy24: ethernet-phy@4 {
-				reg = <4>;
-				marvell,reg-init = <3 0x10 0 0x5777>,
-					<3 0x11 0 0x00aa>,
-					<3 0x12 0 0x4105>,
-					<3 0x13 0 0x0a60>;
-				interrupt-parent = <&gpio>;
-				interrupts = <12 8>; /* Pin 12, active low */
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/mdio-mux.yaml b/Documentation/devicetree/bindings/net/mdio-mux.yaml
new file mode 100644
index 000000000000..d169adf5d9f4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio-mux.yaml
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mdio-mux.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Common MDIO bus multiplexer/switch properties.
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+
+description: |+
+  An MDIO bus multiplexer/switch will have several child busses that are
+  numbered uniquely in a device dependent manner.  The nodes for an MDIO
+  bus multiplexer/switch will have one child node for each child bus.
+
+properties:
+  $nodename:
+    pattern: '^mdio-mux[\-@]?'
+
+  mdio-parent-bus:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      The phandle of the MDIO bus that this multiplexer's master-side port is
+      connected to.
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+patternProperties:
+  '^mdio@[0-9a-f]+$':
+    type: object
+
+    properties:
+      reg:
+        maxItems: 1
+        description: The sub-bus number.
+
+additionalProperties: true
+
+...
-- 
2.27.0

