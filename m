Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0588241123C
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhITJxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:38 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:37452 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhITJxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131498; x=1663667498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v2p9zB2T0M+VqtAMlG8d1u3L/QbMvNcyT4xgvitDt3Q=;
  b=qv7IesJ5oO2JlwNLiJpQF9Ffs4YxjBd5fhk0H6pI2Dda0bxH7kNU9Q86
   GEG9hOw6ZhD41ZMAev7WR1gNavWCpO02MdRxqf/0qIm0gzueemNrZobzB
   /h+zcakiyi1Z2gZoVul0B2oxxXycIv8RRH2OQDKaJG++0DNvL9vbOc1yV
   sxdQ60+7o4yzIRjA83hPFoZAUrQtrSf2nkUDPQjkxfzDNybO5pqap6QIr
   +r9xCzMbYvM7GqmQTRrw2CmneMC05/6l1ugsr7cRHnaiFbMWVQNCgj4bw
   UHnCZbCVsyiqofzP7Jh6gVOCIFrV7eWFe3G/NSRRyRXCLhPyKKYaHtTnf
   Q==;
IronPort-SDR: ycOvQIoYZElp25Zole7n3xeYbOUN6GvZTQAkvL1FUfLT6CfHv2SK/9PN0hoWCidP+u6hIfqA51
 NDpIfYetjSjwwwdWbCet425cXbXwVmXDl5Vncg35v1kX1io5LfkaF6VsRCtPcRhNeH2j2EE0ou
 CXGROvBg5WsPb3e56V6ebzv92Jh+fn5rRwRJ8yVFSVfjIHUAZbq/c3veGRKM5WQQ7pPc69VO8y
 gkMfnhko+4smU5okFlSJPnWrzx02ZK89x1dRJyrzvnEx1EhPXm4fZbB2tQAYbZRYJrvzpw5gSa
 2BpE1XI450dVyMb5SCyD2x7q
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="129913585"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:38 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 08/12] dt-bindings: net: lan966x: Add lan966x-switch bindings
Date:   Mon, 20 Sep 2021 11:52:14 +0200
Message-ID: <20210920095218.1108151-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the lan966x switch device driver bindings

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/microchip,lan966x-switch.yaml         | 114 ++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
new file mode 100644
index 000000000000..53d72a65c168
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -0,0 +1,114 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/microchip,lan966x-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip Lan966x Ethernet switch controller
+
+maintainers:
+  - Horatiu Vultur <horatiu.vultur@microchip.com>
+  - UNGLinuxDriver@microchip.com
+
+description: |
+  The Lan966x Enterprise Ethernet switch family provides a rich set of
+  Enterprise switching features such as advanced TCAM-based VLAN and
+  QoS processing enabling delivery of differentiated services, and
+  security through TCAM-based frame processing using versatile content
+  aware processor (VCAP).
+
+properties:
+  $nodename:
+    pattern: "^switch@[0-9a-f]+$"
+
+  compatible:
+    const: microchip,lan966x-switch
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
+
+  interrupt-names:
+    minItems: 1
+    items:
+      - const: xtr
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
+          phy-mode:
+            description:
+              This specifies the interface used by the Ethernet SerDes towards
+              the PHY or SFP.
+
+          phy-handle:
+            description:
+              phandle of a Ethernet PHY.
+
+        required:
+          - reg
+          - phy-mode
+          - phy-handle
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+  - ethernet-ports
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    switch: switch@600000000 {
+      compatible = "microchip,lan966x-switch";
+      reg =  <0 0x401000>,
+             <0x10004000 0x7fc000>,
+             <0x11010000 0xaf0000>;
+      reg-names = "cpu", "devices", "gcb";
+      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+      interrupt-names = "xtr";
+      ethernet-ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port0: port@0 {
+          reg = <0>;
+          phy-handle = <&phy0>;
+          phy-mode = "gmii";
+        };
+      };
+    };
+
+...
+#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
-- 
2.31.1

