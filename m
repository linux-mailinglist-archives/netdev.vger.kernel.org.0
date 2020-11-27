Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4520C2C66EE
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgK0Nd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 08:33:29 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11776 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgK0Nd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 08:33:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606484007; x=1638020007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0dOf69sGzmS56bmRLRipVRoXtXx280gHYbVkjGeTXvA=;
  b=pNnYK/Q+C5YbaXP/YQP1e2Bw+VWIksyDsXp0UzUNLdrs9W3PAYW7H0YM
   8Rfi6JV34jbFaYLZSLLD/41hQFf3bd7woATtxvdue+K1VtcPVQdC3OqAr
   b2yUWDJ0DF+Yf+t/UtFX2rtfGimL9ta7YvSQgji+O9LLRw6V5JYXOhlWL
   ZYHzTAfeZrAj3osu0XJ8PLG0Dyjbj45wi2bHmXdTYanvs51GBqlErOg8J
   C7GMTYChAP7/YMcSq0zDMoQwlswW8pos8o2OC3SNZnIDBz15puiAACGPl
   JXrH9LUr5Bh7vwRLIvkGLPHPNbqTM3Hn3fSW2NrRXEn/4Z7/XZkA0MRDl
   g==;
IronPort-SDR: DiambrVqpZSJbhtQ+uz9UDnxd7Py4NVNO3T4nDCSaU0xTPitpxZ4rVmxxdDz7nrg955kL4x5hJ
 UnRmNd8EtzJVBIItljDrfbkI9ckXX6m23bJ8B5blKONb4mhNPs5pIMfPmdH0gL74oU2WyzmlDB
 rZskdC4fv0A1Bu7dVmT0cSy5kxh7i3LhDbY/sVENWxBgA2yA9a5jzeNjcLlrlJAykprYYl495D
 y0C2Tyl5L93FdRQ73/AS6KtummQVz+h+lkM3s/k2tf91X35FbHfd+u8/gQU8OG79+GJ7odR1r/
 59w=
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="97796848"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Nov 2020 06:33:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 27 Nov 2020 06:33:26 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 27 Nov 2020 06:33:23 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH 1/3] dt-bindings: net: sparx5: Add sparx5-switch bindings
Date:   Fri, 27 Nov 2020 14:33:05 +0100
Message-ID: <20201127133307.2969817-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127133307.2969817-1-steen.hegelund@microchip.com>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the Sparx5 switch device driver bindings

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../bindings/net/microchip,sparx5-switch.yaml | 633 ++++++++++++++++++
 1 file changed, 633 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
new file mode 100644
index 000000000000..34af605af533
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -0,0 +1,633 @@
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
+    minItems: 153
+
+  reg-names:
+    minItems: 153
+    items:
+      - const: dev2g5_0
+      - const: dev5g_0
+      - const: pcs5g_br_0
+      - const: dev2g5_1
+      - const: dev5g_1
+      - const: pcs5g_br_1
+      - const: dev2g5_2
+      - const: dev5g_2
+      - const: pcs5g_br_2
+      - const: dev2g5_6
+      - const: dev5g_6
+      - const: pcs5g_br_6
+      - const: dev2g5_7
+      - const: dev5g_7
+      - const: pcs5g_br_7
+      - const: dev2g5_8
+      - const: dev5g_8
+      - const: pcs5g_br_8
+      - const: dev2g5_9
+      - const: dev5g_9
+      - const: pcs5g_br_9
+      - const: dev2g5_10
+      - const: dev5g_10
+      - const: pcs5g_br_10
+      - const: dev2g5_11
+      - const: dev5g_11
+      - const: pcs5g_br_11
+      - const: dev2g5_12
+      - const: dev10g_0
+      - const: pcs10g_br_0
+      - const: dev2g5_14
+      - const: dev10g_2
+      - const: pcs10g_br_2
+      - const: dev2g5_15
+      - const: dev10g_3
+      - const: pcs10g_br_3
+      - const: dev2g5_16
+      - const: dev2g5_17
+      - const: dev2g5_18
+      - const: dev2g5_19
+      - const: dev2g5_20
+      - const: dev2g5_21
+      - const: dev2g5_22
+      - const: dev2g5_23
+      - const: dev2g5_32
+      - const: dev2g5_33
+      - const: dev2g5_34
+      - const: dev2g5_35
+      - const: dev2g5_36
+      - const: dev2g5_37
+      - const: dev2g5_38
+      - const: dev2g5_39
+      - const: dev2g5_40
+      - const: dev2g5_41
+      - const: dev2g5_42
+      - const: dev2g5_43
+      - const: dev2g5_44
+      - const: dev2g5_45
+      - const: dev2g5_46
+      - const: dev2g5_47
+      - const: dev2g5_57
+      - const: dev25g_1
+      - const: pcs25g_br_1
+      - const: dev2g5_59
+      - const: dev25g_3
+      - const: pcs25g_br_3
+      - const: dev2g5_60
+      - const: dev25g_4
+      - const: pcs25g_br_4
+      - const: dev2g5_64
+      - const: dev5g_64
+      - const: pcs5g_br_64
+      - const: port_conf
+      - const: dev2g5_3
+      - const: dev5g_3
+      - const: pcs5g_br_3
+      - const: dev2g5_4
+      - const: dev5g_4
+      - const: pcs5g_br_4
+      - const: dev2g5_5
+      - const: dev5g_5
+      - const: pcs5g_br_5
+      - const: dev2g5_13
+      - const: dev10g_1
+      - const: pcs10g_br_1
+      - const: dev2g5_24
+      - const: dev2g5_25
+      - const: dev2g5_26
+      - const: dev2g5_27
+      - const: dev2g5_28
+      - const: dev2g5_29
+      - const: dev2g5_30
+      - const: dev2g5_31
+      - const: dev2g5_48
+      - const: dev10g_4
+      - const: pcs10g_br_4
+      - const: dev2g5_49
+      - const: dev10g_5
+      - const: pcs10g_br_5
+      - const: dev2g5_50
+      - const: dev10g_6
+      - const: pcs10g_br_6
+      - const: dev2g5_51
+      - const: dev10g_7
+      - const: pcs10g_br_7
+      - const: dev2g5_52
+      - const: dev10g_8
+      - const: pcs10g_br_8
+      - const: dev2g5_53
+      - const: dev10g_9
+      - const: pcs10g_br_9
+      - const: dev2g5_54
+      - const: dev10g_10
+      - const: pcs10g_br_10
+      - const: dev2g5_55
+      - const: dev10g_11
+      - const: pcs10g_br_11
+      - const: dev2g5_56
+      - const: dev25g_0
+      - const: pcs25g_br_0
+      - const: dev2g5_58
+      - const: dev25g_2
+      - const: pcs25g_br_2
+      - const: dev2g5_61
+      - const: dev25g_5
+      - const: pcs25g_br_5
+      - const: dev2g5_62
+      - const: dev25g_6
+      - const: pcs25g_br_6
+      - const: dev2g5_63
+      - const: dev25g_7
+      - const: pcs25g_br_7
+      - const: dsm
+      - const: asm
+      - const: gcb
+      - const: qs
+      - const: ana_acl
+      - const: lrn
+      - const: vcap_super
+      - const: qsys
+      - const: qfwd
+      - const: xqs
+      - const: clkgen
+      - const: ana_ac_pol
+      - const: qres
+      - const: eacl
+      - const: ana_cl
+      - const: ana_l3
+      - const: hsch
+      - const: rew
+      - const: ana_l2
+      - const: ana_ac
+      - const: vop
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
+      reg = <0x10004000 0x4000>, /* dev2g5_0 */
+        <0x10008000 0x4000>, /* dev5g_0 */
+        <0x1000c000 0x4000>, /* pcs5g_br_0 */
+        <0x10010000 0x4000>, /* dev2g5_1 */
+        <0x10014000 0x4000>, /* dev5g_1 */
+        <0x10018000 0x4000>, /* pcs5g_br_1 */
+        <0x1001c000 0x4000>, /* dev2g5_2 */
+        <0x10020000 0x4000>, /* dev5g_2 */
+        <0x10024000 0x4000>, /* pcs5g_br_2 */
+        <0x10028000 0x4000>, /* dev2g5_6 */
+        <0x1002c000 0x4000>, /* dev5g_6 */
+        <0x10030000 0x4000>, /* pcs5g_br_6 */
+        <0x10034000 0x4000>, /* dev2g5_7 */
+        <0x10038000 0x4000>, /* dev5g_7 */
+        <0x1003c000 0x4000>, /* pcs5g_br_7 */
+        <0x10040000 0x4000>, /* dev2g5_8 */
+        <0x10044000 0x4000>, /* dev5g_8 */
+        <0x10048000 0x4000>, /* pcs5g_br_8 */
+        <0x1004c000 0x4000>, /* dev2g5_9 */
+        <0x10050000 0x4000>, /* dev5g_9 */
+        <0x10054000 0x4000>, /* pcs5g_br_9 */
+        <0x10058000 0x4000>, /* dev2g5_10 */
+        <0x1005c000 0x4000>, /* dev5g_10 */
+        <0x10060000 0x4000>, /* pcs5g_br_10 */
+        <0x10064000 0x4000>, /* dev2g5_11 */
+        <0x10068000 0x4000>, /* dev5g_11 */
+        <0x1006c000 0x4000>, /* pcs5g_br_11 */
+        <0x10070000 0x4000>, /* dev2g5_12 */
+        <0x10074000 0x4000>, /* dev10g_0 */
+        <0x10078000 0x4000>, /* pcs10g_br_0 */
+        <0x1007c000 0x4000>, /* dev2g5_14 */
+        <0x10080000 0x4000>, /* dev10g_2 */
+        <0x10084000 0x4000>, /* pcs10g_br_2 */
+        <0x10088000 0x4000>, /* dev2g5_15 */
+        <0x1008c000 0x4000>, /* dev10g_3 */
+        <0x10090000 0x4000>, /* pcs10g_br_3 */
+        <0x10094000 0x4000>, /* dev2g5_16 */
+        <0x10098000 0x4000>, /* dev2g5_17 */
+        <0x1009c000 0x4000>, /* dev2g5_18 */
+        <0x100a0000 0x4000>, /* dev2g5_19 */
+        <0x100a4000 0x4000>, /* dev2g5_20 */
+        <0x100a8000 0x4000>, /* dev2g5_21 */
+        <0x100ac000 0x4000>, /* dev2g5_22 */
+        <0x100b0000 0x4000>, /* dev2g5_23 */
+        <0x100b4000 0x4000>, /* dev2g5_32 */
+        <0x100b8000 0x4000>, /* dev2g5_33 */
+        <0x100bc000 0x4000>, /* dev2g5_34 */
+        <0x100c0000 0x4000>, /* dev2g5_35 */
+        <0x100c4000 0x4000>, /* dev2g5_36 */
+        <0x100c8000 0x4000>, /* dev2g5_37 */
+        <0x100cc000 0x4000>, /* dev2g5_38 */
+        <0x100d0000 0x4000>, /* dev2g5_39 */
+        <0x100d4000 0x4000>, /* dev2g5_40 */
+        <0x100d8000 0x4000>, /* dev2g5_41 */
+        <0x100dc000 0x4000>, /* dev2g5_42 */
+        <0x100e0000 0x4000>, /* dev2g5_43 */
+        <0x100e4000 0x4000>, /* dev2g5_44 */
+        <0x100e8000 0x4000>, /* dev2g5_45 */
+        <0x100ec000 0x4000>, /* dev2g5_46 */
+        <0x100f0000 0x4000>, /* dev2g5_47 */
+        <0x100f4000 0x4000>, /* dev2g5_57 */
+        <0x100f8000 0x4000>, /* dev25g_1 */
+        <0x100fc000 0x4000>, /* pcs25g_br_1 */
+        <0x10104000 0x4000>, /* dev2g5_59 */
+        <0x10108000 0x4000>, /* dev25g_3 */
+        <0x1010c000 0x4000>, /* pcs25g_br_3 */
+        <0x10114000 0x4000>, /* dev2g5_60 */
+        <0x10118000 0x4000>, /* dev25g_4 */
+        <0x1011c000 0x4000>, /* pcs25g_br_4 */
+        <0x10124000 0x4000>, /* dev2g5_64 */
+        <0x10128000 0x4000>, /* dev5g_64 */
+        <0x1012c000 0x4000>, /* pcs5g_br_64 */
+        <0x10130000 0x2d0000>, /* port_conf */
+        <0x10404000 0x4000>, /* dev2g5_3 */
+        <0x10408000 0x4000>, /* dev5g_3 */
+        <0x1040c000 0x4000>, /* pcs5g_br_3 */
+        <0x10410000 0x4000>, /* dev2g5_4 */
+        <0x10414000 0x4000>, /* dev5g_4 */
+        <0x10418000 0x4000>, /* pcs5g_br_4 */
+        <0x1041c000 0x4000>, /* dev2g5_5 */
+        <0x10420000 0x4000>, /* dev5g_5 */
+        <0x10424000 0x4000>, /* pcs5g_br_5 */
+        <0x10428000 0x4000>, /* dev2g5_13 */
+        <0x1042c000 0x4000>, /* dev10g_1 */
+        <0x10430000 0x4000>, /* pcs10g_br_1 */
+        <0x10434000 0x4000>, /* dev2g5_24 */
+        <0x10438000 0x4000>, /* dev2g5_25 */
+        <0x1043c000 0x4000>, /* dev2g5_26 */
+        <0x10440000 0x4000>, /* dev2g5_27 */
+        <0x10444000 0x4000>, /* dev2g5_28 */
+        <0x10448000 0x4000>, /* dev2g5_29 */
+        <0x1044c000 0x4000>, /* dev2g5_30 */
+        <0x10450000 0x4000>, /* dev2g5_31 */
+        <0x10454000 0x4000>, /* dev2g5_48 */
+        <0x10458000 0x4000>, /* dev10g_4 */
+        <0x1045c000 0x4000>, /* pcs10g_br_4 */
+        <0x10460000 0x4000>, /* dev2g5_49 */
+        <0x10464000 0x4000>, /* dev10g_5 */
+        <0x10468000 0x4000>, /* pcs10g_br_5 */
+        <0x1046c000 0x4000>, /* dev2g5_50 */
+        <0x10470000 0x4000>, /* dev10g_6 */
+        <0x10474000 0x4000>, /* pcs10g_br_6 */
+        <0x10478000 0x4000>, /* dev2g5_51 */
+        <0x1047c000 0x4000>, /* dev10g_7 */
+        <0x10480000 0x4000>, /* pcs10g_br_7 */
+        <0x10484000 0x4000>, /* dev2g5_52 */
+        <0x10488000 0x4000>, /* dev10g_8 */
+        <0x1048c000 0x4000>, /* pcs10g_br_8 */
+        <0x10490000 0x4000>, /* dev2g5_53 */
+        <0x10494000 0x4000>, /* dev10g_9 */
+        <0x10498000 0x4000>, /* pcs10g_br_9 */
+        <0x1049c000 0x4000>, /* dev2g5_54 */
+        <0x104a0000 0x4000>, /* dev10g_10 */
+        <0x104a4000 0x4000>, /* pcs10g_br_10 */
+        <0x104a8000 0x4000>, /* dev2g5_55 */
+        <0x104ac000 0x4000>, /* dev10g_11 */
+        <0x104b0000 0x4000>, /* pcs10g_br_11 */
+        <0x104b4000 0x4000>, /* dev2g5_56 */
+        <0x104b8000 0x4000>, /* dev25g_0 */
+        <0x104bc000 0x4000>, /* pcs25g_br_0 */
+        <0x104c4000 0x4000>, /* dev2g5_58 */
+        <0x104c8000 0x4000>, /* dev25g_2 */
+        <0x104cc000 0x4000>, /* pcs25g_br_2 */
+        <0x104d4000 0x4000>, /* dev2g5_61 */
+        <0x104d8000 0x4000>, /* dev25g_5 */
+        <0x104dc000 0x4000>, /* pcs25g_br_5 */
+        <0x104e4000 0x4000>, /* dev2g5_62 */
+        <0x104e8000 0x4000>, /* dev25g_6 */
+        <0x104ec000 0x4000>, /* pcs25g_br_6 */
+        <0x104f4000 0x4000>, /* dev2g5_63 */
+        <0x104f8000 0x4000>, /* dev25g_7 */
+        <0x104fc000 0x4000>, /* pcs25g_br_7 */
+        <0x10504000 0x4000>, /* dsm */
+        <0x10600000 0x200000>, /* asm */
+        <0x11010000 0x10000>, /* gcb */
+        <0x11030000 0x10000>, /* qs */
+        <0x11050000 0x10000>, /* ana_acl */
+        <0x11060000 0x10000>, /* lrn */
+        <0x11080000 0x10000>, /* vcap_super */
+        <0x110a0000 0x10000>, /* qsys */
+        <0x110b0000 0x10000>, /* qfwd */
+        <0x110c0000 0x10000>, /* xqs */
+        <0x11100000 0x100000>, /* clkgen */
+        <0x11200000 0x40000>, /* ana_ac_pol */
+        <0x11280000 0x40000>, /* qres */
+        <0x112c0000 0x140000>, /* eacl */
+        <0x11400000 0x80000>, /* ana_cl */
+        <0x11480000 0x80000>, /* ana_l3 */
+        <0x11580000 0x80000>, /* hsch */
+        <0x11600000 0x80000>, /* rew */
+        <0x11800000 0x100000>, /* ana_l2 */
+        <0x11900000 0x100000>, /* ana_ac */
+        <0x11a00000 0x100000>; /* vop */
+      reg-names =
+        "dev2g5_0",
+        "dev5g_0",
+        "pcs5g_br_0",
+        "dev2g5_1",
+        "dev5g_1",
+        "pcs5g_br_1",
+        "dev2g5_2",
+        "dev5g_2",
+        "pcs5g_br_2",
+        "dev2g5_6",
+        "dev5g_6",
+        "pcs5g_br_6",
+        "dev2g5_7",
+        "dev5g_7",
+        "pcs5g_br_7",
+        "dev2g5_8",
+        "dev5g_8",
+        "pcs5g_br_8",
+        "dev2g5_9",
+        "dev5g_9",
+        "pcs5g_br_9",
+        "dev2g5_10",
+        "dev5g_10",
+        "pcs5g_br_10",
+        "dev2g5_11",
+        "dev5g_11",
+        "pcs5g_br_11",
+        "dev2g5_12",
+        "dev10g_0",
+        "pcs10g_br_0",
+        "dev2g5_14",
+        "dev10g_2",
+        "pcs10g_br_2",
+        "dev2g5_15",
+        "dev10g_3",
+        "pcs10g_br_3",
+        "dev2g5_16",
+        "dev2g5_17",
+        "dev2g5_18",
+        "dev2g5_19",
+        "dev2g5_20",
+        "dev2g5_21",
+        "dev2g5_22",
+        "dev2g5_23",
+        "dev2g5_32",
+        "dev2g5_33",
+        "dev2g5_34",
+        "dev2g5_35",
+        "dev2g5_36",
+        "dev2g5_37",
+        "dev2g5_38",
+        "dev2g5_39",
+        "dev2g5_40",
+        "dev2g5_41",
+        "dev2g5_42",
+        "dev2g5_43",
+        "dev2g5_44",
+        "dev2g5_45",
+        "dev2g5_46",
+        "dev2g5_47",
+        "dev2g5_57",
+        "dev25g_1",
+        "pcs25g_br_1",
+        "dev2g5_59",
+        "dev25g_3",
+        "pcs25g_br_3",
+        "dev2g5_60",
+        "dev25g_4",
+        "pcs25g_br_4",
+        "dev2g5_64",
+        "dev5g_64",
+        "pcs5g_br_64",
+        "port_conf",
+        "dev2g5_3",
+        "dev5g_3",
+        "pcs5g_br_3",
+        "dev2g5_4",
+        "dev5g_4",
+        "pcs5g_br_4",
+        "dev2g5_5",
+        "dev5g_5",
+        "pcs5g_br_5",
+        "dev2g5_13",
+        "dev10g_1",
+        "pcs10g_br_1",
+        "dev2g5_24",
+        "dev2g5_25",
+        "dev2g5_26",
+        "dev2g5_27",
+        "dev2g5_28",
+        "dev2g5_29",
+        "dev2g5_30",
+        "dev2g5_31",
+        "dev2g5_48",
+        "dev10g_4",
+        "pcs10g_br_4",
+        "dev2g5_49",
+        "dev10g_5",
+        "pcs10g_br_5",
+        "dev2g5_50",
+        "dev10g_6",
+        "pcs10g_br_6",
+        "dev2g5_51",
+        "dev10g_7",
+        "pcs10g_br_7",
+        "dev2g5_52",
+        "dev10g_8",
+        "pcs10g_br_8",
+        "dev2g5_53",
+        "dev10g_9",
+        "pcs10g_br_9",
+        "dev2g5_54",
+        "dev10g_10",
+        "pcs10g_br_10",
+        "dev2g5_55",
+        "dev10g_11",
+        "pcs10g_br_11",
+        "dev2g5_56",
+        "dev25g_0",
+        "pcs25g_br_0",
+        "dev2g5_58",
+        "dev25g_2",
+        "pcs25g_br_2",
+        "dev2g5_61",
+        "dev25g_5",
+        "pcs25g_br_5",
+        "dev2g5_62",
+        "dev25g_6",
+        "pcs25g_br_6",
+        "dev2g5_63",
+        "dev25g_7",
+        "pcs25g_br_7",
+        "dsm",
+        "asm",
+        "gcb",
+        "qs",
+        "ana_acl",
+        "lrn",
+        "vcap_super",
+        "qsys",
+        "qfwd",
+        "xqs",
+        "clkgen",
+        "ana_ac_pol",
+        "qres",
+        "eacl",
+        "ana_cl",
+        "ana_l3",
+        "hsch",
+        "rew",
+        "ana_l2",
+        "ana_ac",
+        "vop";
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

