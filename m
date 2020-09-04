Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D32225D160
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgIDG3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:29:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58774 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgIDG2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:28:09 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599200887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFt6GdZKxXVNkygdt0pTgRmnYHuzdaXIHEYjNFB3SK8=;
        b=S6vJFGYkGJRyfBoHvh4tsoGiwQfmrxkCm5tvdcyGlA8HXMjFL4UxNZXPoxSQ71pYkCPm1h
        EI0odXXEzFqqo3NWlbHFlD0NNjfDA8Aq6Onr/4qHyAKtA5IplCQWfuoj785sKRb2sDc2nY
        c7uqS88ys6G3cB4ONtCetlUF7E1iPsAjHmoULf0yBryK0mmMKbP71pKzYHudPHK+Lkz+yU
        UVBDWTftjZVaJ/mAasDVxYUDUdQqWoK9qO9tF0DH75scuJT1sJw57UrTx/krIGkt8HfDyc
        mgTLDzTmapYfFSZFugL8rmJx8GFxqzSAmt1UgSR99JlyWc9PsIzkth5tWnZlcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599200887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFt6GdZKxXVNkygdt0pTgRmnYHuzdaXIHEYjNFB3SK8=;
        b=m8BcgdpsnMl+cKBYGtM8QhU0j73uWAS3P/6ReE4wocYzxXtFDCzKjRNq2+fuqCu+m2iVr1
        4swBs1d6A2tmp4Cw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 7/7] dt-bindings: net: dsa: Add documentation for Hellcreek switches
Date:   Fri,  4 Sep 2020 08:27:39 +0200
Message-Id: <20200904062739.3540-8-kurt@linutronix.de>
In-Reply-To: <20200904062739.3540-1-kurt@linutronix.de>
References: <20200904062739.3540-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic documentation and example.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/dsa/hellcreek.yaml           | 127 ++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
new file mode 100644
index 000000000000..e26c5a2a360b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
@@ -0,0 +1,127 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/hellcreek.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Kurt Kanzenbach <kurt@linutronix.de>
+
+description:
+  The Hellcreek TSN Switch IP is a 802.1Q Ethernet compliant switch. It supports
+  the Precision Time Protocol, Hardware Timestamping as well the Time Aware
+  Shaper.
+
+properties:
+  compatible:
+    items:
+      - const: hirschmann,hellcreek-de1soc-r1
+
+  reg:
+    description:
+      The physical base address and size of TSN and PTP memory base
+    minItems: 2
+    maxItems: 2
+
+  reg-names:
+    items:
+      - const: tsn
+      - const: ptp
+
+  leds:
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^led@[01]$":
+          type: object
+          description: Hellcreek leds
+          $ref: ../../leds/common.yaml#
+
+          properties:
+            reg:
+              items:
+                - enum: [0, 1]
+              description: Led number
+
+            label: true
+
+            default-state: true
+
+          required:
+            - reg
+
+          additionalProperties: false
+
+    additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - ethernet-ports
+  - leds
+
+unevaluatedProperties: false
+
+examples:
+  - |
+        switch0: switch@ff240000 {
+            compatible = "hirschmann,hellcreek-de1soc-r1";
+            reg = <0xff240000 0x1000>,
+                  <0xff250000 0x1000>;
+            reg-names = "tsn", "ptp";
+            dsa,member = <0 0>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "cpu";
+                    ethernet = <&gmac0>;
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan0";
+                    phy-handle = <&phy1>;
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan1";
+                    phy-handle = <&phy2>;
+                };
+            };
+
+            leds {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                led@0 {
+                    reg = <0>;
+                    label = "sync_good";
+                    default-state = "on";
+                };
+
+                led@1 {
+                    reg = <1>;
+                    label = "is_gm";
+                    default-state = "off";
+                };
+            };
+        };
-- 
2.20.1

