Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A36394293
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhE1MgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:36:12 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15485 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbhE1MgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622205273; x=1653741273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IhzM4SXuYd3c0BHLyCBAIrIHkW0Oss4EiXGbDIRG1qY=;
  b=N0lFWGi8oaZBWPWwupGxpys4yMN5Dze/s987rpdLRyHNOdVgJcejlgyy
   5BxhoMI+EiGjUnqk/m0ElqSRrL0Ya7HLhd64vaEeqokc3C3avTsM4b6tQ
   kW8qmbSlFCYVUWXFgnQ0ZSRHL7HDGRcv4l9R1i6L3JTfz8g03GLI9pPqE
   4cZiX2Wy0/chkbxPKEM1rM5MErWx6+wm7j0lMz67OXiafjg0yENvQhmuc
   zMd3iapjL4ThRMo1llCnOO7Txrx0QvC9+XHX3YWJc8B4erHhLNgKD7NY4
   n3qrgJ4nhxTxteSwLPZnupC3Ray2j2QosNa/rm/FiUD+XY5eWS+eJP2Nm
   w==;
IronPort-SDR: YfnvBnJGoza9xgyJsp31dAIYpMIJaxX3PuwKRwtBpd7rpJ7c6UtzQ5cgB54VqqWvhEQet33HJT
 scI13G3/7iL1XG1FBcbsi2+VbKoZzH4r9dcMlaSAKfCXbt0AG/8I2p1kvbTfC8bNuTm+eUIanD
 5DV3HIRGQ9w0C1cSeyB/t9hzMQTE0p00FjyHUD9lbgZdrQZq1N1c+P/OfXmRfv2xEXdAAJcFKO
 tTsEnr5IcK+CxLfyRI3bYybwPz5N6+Tvc0S0GvM/dhxQGEqXESEdErwp5HW1xxtxBi+420t7EL
 nvo=
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="122757449"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 May 2021 05:34:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 05:34:31 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 05:34:26 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 01/10] dt-bindings: net: sparx5: Add sparx5-switch bindings
Date:   Fri, 28 May 2021 14:34:10 +0200
Message-ID: <20210528123419.1142290-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528123419.1142290-1-steen.hegelund@microchip.com>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the Sparx5 switch device driver bindings

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/microchip,sparx5-switch.yaml | 226 ++++++++++++++++++
 1 file changed, 226 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
new file mode 100644
index 000000000000..347b912a46bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -0,0 +1,226 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/microchip,sparx5-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip Sparx5 Ethernet switch controller
+
+maintainers:
+  - Steen Hegelund <steen.hegelund@microchip.com>
+  - Lars Povlsen <lars.povlsen@microchip.com>
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
+    items:
+      - description: cpu target
+      - description: devices target
+      - description: general control block target
+
+  reg-names:
+    items:
+      - const: cpu
+      - const: devices
+      - const: gcb
+
+  interrupts:
+    minItems: 1
+    items:
+      - description: register based extraction
+      - description: frame dma based extraction
+
+  interrupt-names:
+    minItems: 1
+    items:
+      - const: xtr
+      - const: fdma
+
+  resets:
+    items:
+      - description: Reset controller used for switch core reset (soft reset)
+
+  reset-names:
+    items:
+      - const: switch
+
+  mac-address: true
+
+  ethernet-ports:
+    type: object
+    patternProperties:
+      "^port@[0-9a-f]+$":
+        type: object
+
+        properties:
+          '#address-cells':
+            const: 1
+          '#size-cells':
+            const: 0
+
+          reg:
+            description: Switch port number
+
+          phys:
+            maxItems: 1
+            description:
+              phandle of a Ethernet SerDes PHY.  This defines which SerDes
+              instance will handle the Ethernet traffic.
+
+          phy-mode:
+            description:
+              This specifies the interface used by the Ethernet SerDes towards
+              the PHY or SFP.
+
+          microchip,bandwidth:
+            description: Specifies bandwidth in Mbit/s allocated to the port.
+            $ref: "/schemas/types.yaml#/definitions/uint32"
+            maximum: 25000
+
+          phy-handle:
+            description:
+              phandle of a Ethernet PHY.  This is optional and if provided it
+              points to the cuPHY used by the Ethernet SerDes.
+
+          sfp:
+            description:
+              phandle of an SFP.  This is optional and used when not specifying
+              a cuPHY.  It points to the SFP node that describes the SFP used by
+              the Ethernet SerDes.
+
+          managed: true
+
+          microchip,sd-sgpio:
+            description:
+              Index of the ports Signal Detect SGPIO in the set of 384 SGPIOs
+              This is optional, and only needed if the default used index is
+              is not correct.
+            $ref: "/schemas/types.yaml#/definitions/uint32"
+            minimum: 0
+            maximum: 383
+
+        required:
+          - reg
+          - phys
+          - phy-mode
+          - microchip,bandwidth
+
+        oneOf:
+          - required:
+              - phy-handle
+          - required:
+              - sfp
+              - managed
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+  - resets
+  - reset-names
+  - ethernet-ports
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    switch: switch@600000000 {
+      compatible = "microchip,sparx5-switch";
+      reg =  <0 0x401000>,
+             <0x10004000 0x7fc000>,
+             <0x11010000 0xaf0000>;
+      reg-names = "cpu", "devices", "gcb";
+      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+      interrupt-names = "xtr";
+      resets = <&reset 0>;
+      reset-names = "switch";
+      ethernet-ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port0: port@0 {
+          reg = <0>;
+          microchip,bandwidth = <1000>;
+          phys = <&serdes 13>;
+          phy-handle = <&phy0>;
+          phy-mode = "qsgmii";
+        };
+        /* ... */
+        /* Then the 25G interfaces */
+        port60: port@60 {
+          reg = <60>;
+          microchip,bandwidth = <25000>;
+          phys = <&serdes 29>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth60>;
+          managed = "in-band-status";
+          microchip,sd-sgpio = <365>;
+        };
+        port61: port@61 {
+          reg = <61>;
+          microchip,bandwidth = <25000>;
+          phys = <&serdes 30>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth61>;
+          managed = "in-band-status";
+          microchip,sd-sgpio = <369>;
+        };
+        port62: port@62 {
+          reg = <62>;
+          microchip,bandwidth = <25000>;
+          phys = <&serdes 31>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth62>;
+          managed = "in-band-status";
+          microchip,sd-sgpio = <373>;
+        };
+        port63: port@63 {
+          reg = <63>;
+          microchip,bandwidth = <25000>;
+          phys = <&serdes 32>;
+          phy-mode = "10gbase-r";
+          sfp = <&sfp_eth63>;
+          managed = "in-band-status";
+          microchip,sd-sgpio = <377>;
+        };
+        /* Finally the Management interface */
+        port64: port@64 {
+          reg = <64>;
+          microchip,bandwidth = <1000>;
+          phys = <&serdes 0>;
+          phy-handle = <&phy64>;
+          phy-mode = "sgmii";
+          mac-address = [ 00 00 00 01 02 03 ];
+        };
+      };
+    };
+
+...
+#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
-- 
2.31.1

