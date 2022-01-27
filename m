Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA22649DFC5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbiA0KtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239657AbiA0KtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:49:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840C5C06174E
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:49:17 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kz-0007kk-2z; Thu, 27 Jan 2022 11:49:09 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kx-003lyx-FC; Thu, 27 Jan 2022 11:49:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v1 1/4] dt-bindings: net: add schema for ASIX USB Ethernet controllers
Date:   Thu, 27 Jan 2022 11:49:02 +0100
Message-Id: <20220127104905.899341-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127104905.899341-1-o.rempel@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create initial schema for ASIX USB Ethernet controllers and import all
currently supported USB IDs form drivers/net/usb/asix_devices.c

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/asix,ax88178.yaml | 100 ++++++++++++++++++
 1 file changed, 100 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
new file mode 100644
index 000000000000..74b6806006e3
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
@@ -0,0 +1,100 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/asix,ax88178.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: The device tree bindings for the USB Ethernet controllers
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+description: |
+  Device tree properties for hard wired USB Ethernet devices.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - usb411,3d     # Buffalo LUA-U2-KTX
+          - usb411,6e     # Buffalo LUA-U2-GT 10/100/1000
+          - usb4bb,930    # IO-DATA ETG-US2
+          - usb4f1,3008   # JVC MP-PRX1 Port Replicator
+          - usb50d,5055   # Belkin F5D5055
+          - usb557,2009   # ATEN UC210T
+          - usb5ac,1402   # Apple USB Ethernet Adapter
+          - usb66b,20f9   # USBLINK HG20F9
+          - usb77b,2226   # Linksys USB200M
+          - usb789,160    # Logitec LAN-GTJ/U2A
+          - usb7aa,17     # corega FEther USB2-TX
+          - usb7b8,420a   # Hawking UF200, TrendNet TU2-ET100
+          - usb7d1,3c05   # DLink DUB-E100 H/W Ver B1
+          - usb846,1040   # Netgear FA120
+          - usb8dd,114    # Billionton Systems, GUSB2AM-1G-B
+          - usb8dd,90ff   # Billionton Systems, USB2AR
+          - usbb95,1720   # Intellinet, ST Lab USB Ethernet
+          - usbb95,172a   # ASIX 88172a demo board
+          - usbb95,1780   # ASIX AX88178 10/100/1000
+          - usbb95,7720   # ASIX AX88772 10/100
+          - usbb95,772a   # Cables-to-Go USB Ethernet Adapter
+          - usbb95,772b   # ASIX AX88772B 10/100
+          - usbb95,7e2b   # Asus USB Ethernet Adapter
+          - usbdb0,a877   # ASIX 88772a
+          - usbdf6,56     # Sitecom LN-031
+          - usbdf6,61c    # Sitecom LN-028
+          - usb1189,893   # Surecom EP-1427X-2
+          - usb13b1,18    # Linksys USB200M Rev 2
+          - usb14ea,ab11  # ABOCOM for pci
+          - usb1557,7720  # 0Q0 cable ethernet
+          - usb1631,6200  # goodway corp usb gwusb2e
+          - usb1737,39    # Linksys USB1000
+          - usb17ef,7203  # Lenovo U2L100P 10/100
+          - usb2001,1a00  # DLink DUB-E100
+          - usb2001,1a02  # DLink DUB-E100 H/W Ver C1
+          - usb2001,3c05  # DLink DUB-E100 H/W Ver B1 Alternate
+          - usb6189,182d  # Sitecom LN-029
+
+  reg: true
+  local-mac-address: true
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    usb@11270000 {
+        reg = <0x11270000 0x1000>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@1 {
+            compatible = "usbdb0,a877";
+            reg = <1>;
+            local-mac-address = [00 00 00 00 00 00];
+        };
+    };
+  - |
+    usb@11270000 {
+        reg = <0x11270000 0x1000>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        usb1@1 {
+            compatible = "usb1234,5678";
+            reg = <1>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet@1 {
+               compatible = "usbdb0,a877";
+               reg = <1>;
+            };
+        };
+    };
-- 
2.30.2

