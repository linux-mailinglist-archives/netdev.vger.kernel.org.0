Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F083EC46B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbhHNSSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:18:31 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:59242 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhHNSSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:18:31 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2021 14:18:30 EDT
Received: (qmail 6036 invoked from network); 14 Aug 2021 18:11:20 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 14 Aug 2021 18:11:20 -0000
From:   David Bauer <mail@david-bauer.net>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: add RTL8152 binding documentation
Date:   Sat, 14 Aug 2021 20:11:06 +0200
Message-Id: <20210814181107.138992-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding documentation for the Realtek RTL8152 / RTL8153 USB ethernet
adapters.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 .../bindings/net/realtek,rtl8152.yaml         | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8152.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
new file mode 100644
index 000000000000..ab760000b3a6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/realtek,rtl8152.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Realtek RTL8152/RTL8153 series USB ethernet
+
+maintainers:
+  - David Bauer <mail@david-bauer.net>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - realtek,rtl8152
+              - realtek,rtl8153
+
+  reg:
+    description: The device number on the USB bus
+
+  realtek,led-data:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: Value to be written to the LED configuration register.
+
+required:
+  - compatible
+  - reg
+
+examples:
+  - |
+    usb@100 {
+      reg = <0x100 0x100>;
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      usb-eth@2 {
+        compatible = "realtek,rtl8153";
+        reg = <0x2>;
+        realtek,led-data = <0x87>;
+      };
+    };
-- 
2.32.0

