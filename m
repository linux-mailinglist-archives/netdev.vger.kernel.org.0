Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A103D425652
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242337AbhJGPOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:14:16 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8130 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhJGPOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633619540; x=1665155540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R2AV0VMA0ah/ycAIwG+xrvSmjr+YGix7RHnWT/qgg2E=;
  b=QFcnFNc9ZZoGKBdTigkl0JE4EtHN5PtHlCSIxtCzEOoBXQgeomN22fsL
   8KIr5lse1Ik/PKW3UjZZiGSMVxhfX8R77SGXla77VS8ELYl4A2BLm2gTV
   nEZzLO3JuPE7ChixhFZQVtkolVKc//uI7lGnuv4e6OvvBx7OGv/MJfqvl
   mTYU7XnOAzkrv+CDQpUxVcH+dxzPWzDfRCFPZLeaD/OKwx/fTdfInu4LY
   rfbV3Z5Hzcp9A4HNuBg23UTGkbeFGXv+GZt9M71Dlv9YQKSwb7tLWDs08
   kdP1Wnh52o8SFxcjVYOz4/Q5rmkizxq1S7GrLvotomQkW1lwtiQH47E5Q
   A==;
IronPort-SDR: IVF/j0OpxJ9XQKm+PLmcRjC8SNiEnLfwhYYhK4++B6jUaUtW7LMpkDRs7E5d9qWqDfamw6nVWZ
 9NmM8GHwitHvVec5j1Pq51qvnJi0GLq9pM7f4wWimGf4UjRz7Gy3VxH2s5snY1JAwETr1C1oh7
 oTZsd96hDSZAaXOzfVq/fcJnoftCqHy23rhiv3uOmMSApVhr52pnEiKWcfFRZQOKz106PGIzso
 RYjZcR0IKLz2kazKBWkLwNIMDq09GgSUIPF+8qvZ8dIwUEdjkELFMoqli2C9m2cfKZ5cd/i1tv
 7gs2MB1BYMzrhGuUBRZtBbuQ
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="139411984"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 08:12:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 08:12:19 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 7 Oct 2021 08:12:13 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v4 net-next 01/10] dt-bindings: net: dsa: dt bindings for microchip lan937x
Date:   Thu, 7 Oct 2021 20:41:51 +0530
Message-ID: <20211007151200.748944-2-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation in .yaml format and updates to the MAINTAINERS
Also 'make dt_binding_check' is passed.

Introduced rx-internal-delay-ps & tx-internal-delay-ps for RGMII
internal delay along with min/max values. This is to address the
Vladimir proposal from the previous revision.

Hence Reviewed-by tag is not added as it needs a review again.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 .../bindings/net/dsa/microchip,lan937x.yaml   | 160 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
new file mode 100644
index 000000000000..71851893f956
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
+  rx-internal-delay-ps:
+    description: Delay is in pico seconds
+    minimum: 2170
+    maximum: 4000
+    default: 0
+
+  tx-internal-delay-ps:
+    description: Delay is in pico seconds
+    minimum: 2170
+    maximum: 4000
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
index 76e0fdcdd877..8b42761aaaa1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12286,6 +12286,7 @@ M:	UNGLinuxDriver@microchip.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
-- 
2.27.0

