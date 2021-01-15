Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0042F7D57
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbhAONzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:55:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:20417 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732000AbhAONzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610718932; x=1642254932;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N+WsVRlfuZPXh733S8xEiaNyBd44yJ7u+0MR1dah0qc=;
  b=UGcID3xHKblqXH2iKE0lQYnbT5P6HoEResMKpoHZspJ0sNeIHfV67iMa
   F2hOpoMDzDw/IMVVom02Ucz7u2VlVMWCeJCRHz8AymH7kVNIH05GVRFFX
   MbMWWNTpo84OFYhSq0nYSfRYtXVCIhZonlPdNMuUflVRMqlIdTrOCwi/I
   ZkIe9O3YgVgJVtXgkb/6kD7V2qQQYUDWOZlKvbchIpzEr9S2JzM47GSx0
   KQpktFuP17ZaaS1y5CZV10YZYPGCsUXfiAmTWsRh/rD32oKjyJ1+trcJV
   COxJz0FANHb+Q7TQ6mNEycMzPebNF6omGAtUOccfdzMyAaCPioJlcRai9
   g==;
IronPort-SDR: i6uM1WIyJkC3Y8Ld1qDMR1Nk/53B7toqU4BlF3hr3EdpBXRjMWkyLoVcGseidzye8VQ21ObB7D
 r45/uidmwqs8OeAgP95fZ8poD397EWrqBBRZN47BZw4fUOYrAnR51gc2NQnOpsmjBpRYp2uyYb
 mf6eF+qVoDLarUsAV+Tm7tXPYxKe8AJMAOmiC7yoHtJYknYNB4fUluAx2zmwgHrwhc9Jl4Bnwu
 +LhzALvyuhXtgRJY5jv6kYVQ/WXKIUgt7jbG/XUFKqPR9tNoyZvYxDU1K24k+93Z/Ps86jGBFU
 g5w=
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="103001381"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 06:53:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 06:53:57 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 15 Jan 2021 06:53:53 -0700
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
Subject: [RFC PATCH v3 1/8] dt-bindings: net: sparx5: Add sparx5-switch bindings
Date:   Fri, 15 Jan 2021 14:53:32 +0100
Message-ID: <20210115135339.3127198-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115135339.3127198-1-steen.hegelund@microchip.com>
References: <20210115135339.3127198-1-steen.hegelund@microchip.com>
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
 .../bindings/net/microchip,sparx5-switch.yaml | 211 ++++++++++++++++++
 1 file changed, 211 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
new file mode 100644
index 000000000000..479a36874fe5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -0,0 +1,211 @@
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
+    items:
+      - const: devices
+      - const: gcb
+
+  interrupts:
+    maxItems: 1
+    description: Interrupt used for reception of packets to the CPU
+
+  mac-address:
+    maxItems: 1
+    description:
+      Specifies the MAC address that is used as the template for the MAC
+      addresses assigned to the ports provided by the driver.  If not provided
+      a randomly generated MAC address will be used.
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
+          bandwidth:
+            maxItems: 1
+            $ref: /schemas/types.yaml#definitions/uint32
+            description: Specifies bandwidth in Mbit/s allocated to the port.
+
+          phys:
+            maxItems: 1
+            description:
+              phandle of a Ethernet SerDes PHY.  This defines which SerDes
+              instance will handle the Ethernet traffic.
+
+          phy-handle:
+            maxItems: 1
+            description:
+               phandle of a Ethernet PHY.  This is optional and if provided it
+               points to the cuPHY used by the Ethernet SerDes.
+
+          phy-mode:
+            maxItems: 1
+            description:
+              This specifies the interface used by the Ethernet SerDes towards the
+              phy or SFP.
+
+          sfp:
+            maxItems: 1
+            description:
+              phandle of an SFP.  This is optional and used when not specifying
+              a cuPHY.  It points to the SFP node that describes the SFP used by
+              the Ethernet SerDes.
+
+          managed:
+            maxItems: 1
+            description:
+              SFP management. This must be provided when specifying an SFP.
+
+          sd_sgpio:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            maxItems: 1
+            description:
+              Index of the ports Signal Detect SGPIO in the set of 384 SGPIOs
+              This is optional, and only needed if the default used index is
+              is not correct.
+
+        required:
+          - reg
+          - bandwidth
+          - phys
+          - phy-mode
+
+        oneOf:
+          - required:
+              - phy-handle
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
+          bandwidth = <1000>;
+          phys = <&serdes 13>;
+          phy-handle = <&phy0>;
+          phy-mode = "qsgmii";
+        };
+        /* ... */
+        /* Then the 25G interfaces */
+        port60: port@60 {
+          reg = <60>;
+          bandwidth = <25000>;
+          phys = <&serdes 29>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth60>;
+          managed = "in-band-status";
+        };
+        port61: port@61 {
+          reg = <61>;
+          bandwidth = <25000>;
+          phys = <&serdes 30>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth61>;
+          managed = "in-band-status";
+        };
+        port62: port@62 {
+          reg = <62>;
+          bandwidth = <25000>;
+          phys = <&serdes 31>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth62>;
+          managed = "in-band-status";
+        };
+        port63: port@63 {
+          reg = <63>;
+          bandwidth = <25000>;
+          phys = <&serdes 32>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth63>;
+          managed = "in-band-status";
+        };
+        /* Finally the Management interface */
+        port64: port@64 {
+          reg = <64>;
+          bandwidth = <1000>;
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

