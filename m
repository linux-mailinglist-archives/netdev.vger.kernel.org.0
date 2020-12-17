Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE422DCD1A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 08:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgLQHxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 02:53:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:52358 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQHxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 02:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608191586; x=1639727586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RsqOUWj84D6xw7M5hhqPG9VQqaBpHLFyLmp7TjBDuOU=;
  b=hS+xyylD3BeZMqHz7Kc8OZ7N8LBgZ+NP4OqENZnw+BjbyHzKPVa7luI+
   gfGI6Q1I1kz1wMHbJAJ4R2GGtMYc52HBW4e49XRY+Zc1XF9gYsjFfwmC/
   4OCugL9EmzUwuf5emZRN0Z4JqFo41HOwlpxBWoJBaGFM0ACZQTFPwC4hZ
   ir6n8mzou6K+hprxROQg03QzlCFrlUKd0D4e61+SIgPUo4KPiWZjqL4og
   I4JWO5axcTUaPNrmlDM6oxR2YT+Pbg4soNzFdU+6AWXA/Qr7TrSPCNNqL
   B0O4/Z13S5V0M5vnqV9AeVod4pSnFDPy6E3h6JsMovvIv+b77vGEBuAHV
   w==;
IronPort-SDR: Oum7Zrdr/UWkcczJRmcbdHMxHIYbTIbc1toiQm029BwtVamsphr4+W+xZpkM1a4WdhdwurmynZ
 pJhBaa6shrhBd+mU54hixW7/vbJbVYq8oHmIffughqbOEC8xioNGAiF9WZmByWhyGpmslmovIN
 r5s6I61RY4+KJP03KfW7sjOhs5BzsAc0dpb9RraLqU28dUVF/AxSDdQ2a97Q0J4RsvP0tCOfHS
 LLTz1BHTsnTvN+uqa+HYtP1/mlyZIv+DBVxL/fqWJzbt33jmWJmdtlescApS6tNqCfoHupLRVL
 CzA=
X-IronPort-AV: E=Sophos;i="5.78,426,1599548400"; 
   d="scan'208";a="100163801"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2020 00:51:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 00:51:50 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 17 Dec 2020 00:51:46 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH v2 1/8] dt-bindings: net: sparx5: Add sparx5-switch bindings
Date:   Thu, 17 Dec 2020 08:51:27 +0100
Message-ID: <20201217075134.919699-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217075134.919699-1-steen.hegelund@microchip.com>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the Sparx5 switch device driver bindings

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../bindings/net/microchip,sparx5-switch.yaml | 178 ++++++++++++++++++
 1 file changed, 178 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
new file mode 100644
index 000000000000..6e3ef8285e9a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -0,0 +1,178 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/microchip,sparx5-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip Sparx5 Ethernet switch controller
+
+maintainers:
+  - Lars Povlsen <lars.povlsen@microchip.com>
+  - Steen Hegelund <steen.hegelund@microchip.com>
+
+description: |
+  The SparX-5 Enterprise Ethernet switch family provides a rich set of
+  Enterprise switching features such as advanced TCAM-based VLAN and
+  QoS processing enabling delivery of differentiated services, and
+  security through TCAM-based frame processing using versatile content
+  aware processor (VCAP).
+
+  IPv4/IPv6 Layer 3 (L3) unicast and multicast routing is supported
+  with up to 18K IPv4/9K IPv6 unicast LPM entries and up to 9K IPv4/3K
+  IPv6 (S,G) multicast groups.
+
+  L3 security features include source guard and reverse path
+  forwarding (uRPF) tasks. Additional L3 features include VRF-Lite and
+  IP tunnels (IP over GRE/IP).
+
+  The SparX-5 switch family targets managed Layer 2 and Layer 3
+  equipment in SMB, SME, and Enterprise where high port count
+  1G/2.5G/5G/10G switching with 10G/25G aggregation links is required.
+
+properties:
+  $nodename:
+    pattern: "^switch@[0-9a-f]+$"
+
+  compatible:
+    const: microchip,sparx5-switch
+
+  reg:
+    minItems: 2
+
+  reg-names:
+    minItems: 2
+    items:
+      - const: devices
+      - const: gcb
+
+  interrupts:
+    maxItems: 1
+    description: Interrupt used for reception of packets to the CPU
+
+  ethernet-ports:
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^port@[0-9]+$":
+        type: object
+        description: Switch ports
+
+        allOf:
+          - $ref: ethernet-controller.yaml#
+
+        properties:
+          reg:
+            description: Switch port number
+
+          max-speed:
+            maxItems: 1
+            description: Bandwidth allocated to this port
+
+          phys:
+            description: phandle of a Ethernet Serdes PHY
+
+          phy-handle:
+            description: phandle of a Ethernet PHY
+
+          phy-mode:
+            description: Interface between the serdes and the phy
+
+          sfp:
+            description: phandle of an SFP
+
+          managed:
+            maxItems: 1
+            description: SFP management
+
+        required:
+          - reg
+          - max-speed
+          - phys
+
+        oneOf:
+          - required:
+              - phy-handle
+              - phy-mode
+          - required:
+              - sfp
+              - managed
+
+        additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - ethernet-ports
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    switch: switch@600000000 {
+      compatible = "microchip,sparx5-switch";
+      reg =  <0x10000000 0x800000>,
+             <0x11010000 0x1b00000>;
+      reg-names = "devices", "gcb";
+
+      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+      ethernet-ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port0: port@0 {
+          reg = <0>;
+          max-speed = <1000>;
+          phys = <&serdes 13>;
+          phy-handle = <&phy0>;
+          phy-mode = "qsgmii";
+        };
+        /* ... */
+        /* Then the 25G interfaces */
+        port60: port@60 {
+          reg = <60>;
+          max-speed = <25000>;
+          phys = <&serdes 29>;
+          sfp = <&sfp_eth60>;
+          managed = "in-band-status";
+        };
+        port61: port@61 {
+          reg = <61>;
+          max-speed = <25000>;
+          phys = <&serdes 30>;
+          sfp = <&sfp_eth61>;
+          managed = "in-band-status";
+        };
+        port62: port@62 {
+          reg = <62>;
+          max-speed = <25000>;
+          phys = <&serdes 31>;
+          sfp = <&sfp_eth62>;
+          managed = "in-band-status";
+        };
+        port63: port@63 {
+          reg = <63>;
+          max-speed = <25000>;
+          phys = <&serdes 32>;
+          sfp = <&sfp_eth63>;
+          managed = "in-band-status";
+        };
+        /* Finally the Management interface */
+        port64: port@64 {
+          reg = <64>;
+          max-speed = <1000>;
+          phys = <&serdes 0>;
+          phy-handle = <&phy64>;
+          phy-mode = "sgmii";
+        };
+      };
+    };
+
+...
-- 
2.29.2

