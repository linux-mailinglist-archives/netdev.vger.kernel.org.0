Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3F449DFD0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiA0KtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiA0KtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:49:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B85DC061748
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:49:17 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kz-0007kl-3I; Thu, 27 Jan 2022 11:49:09 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kx-003lz6-J3; Thu, 27 Jan 2022 11:49:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v1 2/4] dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet controllers
Date:   Thu, 27 Jan 2022 11:49:03 +0100
Message-Id: <20220127104905.899341-3-o.rempel@pengutronix.de>
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

Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
import all currently supported USB IDs form drivers/net/usb/smsc95xx.c

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../bindings/net/microchip,lan95xx.yaml       | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
new file mode 100644
index 000000000000..b185c7068a8a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/microchip,lan95xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: The device tree bindings for the USB Ethernet controllers
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+description: |
+  Device tree properties for hard wired SMSC95xx compatible USB Ethernet
+  controller.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - usb424,9500   # SMSC9500 USB Ethernet Device
+          - usb424,9505   # SMSC9505 USB Ethernet Device
+          - usb424,9530   # SMSC LAN9530 USB Ethernet Device
+          - usb424,9730   # SMSC LAN9730 USB Ethernet Device
+          - usb424,9900   # SMSC9500 USB Ethernet Device (SAL10)
+          - usb424,9901   # SMSC9505 USB Ethernet Device (SAL10)
+          - usb424,9902   # SMSC9500A USB Ethernet Device (SAL10)
+          - usb424,9903   # SMSC9505A USB Ethernet Device (SAL10)
+          - usb424,9904   # SMSC9512/9514 USB Hub & Ethernet Device (SAL10)
+          - usb424,9905   # SMSC9500A USB Ethernet Device (HAL)
+          - usb424,9906   # SMSC9505A USB Ethernet Device (HAL)
+          - usb424,9907   # SMSC9500 USB Ethernet Device (Alternate ID)
+          - usb424,9908   # SMSC9500A USB Ethernet Device (Alternate ID)
+          - usb424,9909   # SMSC9512/9514 USB Hub & Ethernet Devic.  ID)
+          - usb424,9e00   # SMSC9500A USB Ethernet Device
+          - usb424,9e01   # SMSC9505A USB Ethernet Device
+          - usb424,9e08   # SMSC LAN89530 USB Ethernet Device
+          - usb424,ec00   # SMSC9512/9514 USB Hub & Ethernet Device
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
+            compatible = "usb424,ec00";
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
+            compatible = "usb424,9514";
+            reg = <1>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet@1 {
+               compatible = "usb424,ec00";
+               reg = <1>;
+            };
+        };
+    };
-- 
2.30.2

