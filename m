Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47612A3D47
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgKCHLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgKCHLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:11:42 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16F3C061A4A;
        Mon,  2 Nov 2020 23:11:41 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604387500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOdndC3insAylzRsSIke11aHMe3UCW6E/WR8+TlsidI=;
        b=RziyoXHL48GZR5qUNqgkItEzRt/MgB8IWgYV7HjWEgHGaRW2lWz7skTAoyZeHX9UiXEJJl
        5ES/MIZhVjwR9IfeR57miaHFRupQFzGuM9bSwjvQsl3klnVeidadSTlPGHLSEXuGa50dbg
        OatgXIv4DdW+7Qt+RgQrEVPesH6fyv5NUy4IdOj4c4EemdpHcdFeAMYBg5deiuYyytQkeC
        d5MhGyxS15vFcUCLWXDE3rJwRro+y4XDIaXVY2NubzaEgYlD/R7yRYOF3rjmUKwTyf3V5F
        DtN2YQuXB40EEyhwnlyC/M+MNataZrQTx4O1C4MRbxaNAjgB9nJwrq5KvX6OdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604387500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOdndC3insAylzRsSIke11aHMe3UCW6E/WR8+TlsidI=;
        b=dO4DX0Bp6esAtsFdbnynB4FaSCn3XBD91G0mS2cKn69KCIf3L6uK2xW2nK4L2m+Iemk6z4
        kG1rxTGjkzBHSIBw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v8 8/8] dt-bindings: net: dsa: Add documentation for Hellcreek switches
Date:   Tue,  3 Nov 2020 08:11:01 +0100
Message-Id: <20201103071101.3222-9-kurt@linutronix.de>
In-Reply-To: <20201103071101.3222-1-kurt@linutronix.de>
References: <20201103071101.3222-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic documentation and example.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/dsa/hirschmann,hellcreek.yaml         | 127 ++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
new file mode 100644
index 000000000000..5592f58fa6f0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -0,0 +1,127 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/hirschmann,hellcreek.yaml#
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
+        type: object
+        description: Hellcreek leds
+        $ref: ../../leds/common.yaml#
+
+        properties:
+          reg:
+            items:
+              - enum: [0, 1]
+            description: Led number
+
+          label: true
+
+          default-state: true
+
+        required:
+          - reg
+
+        additionalProperties: false
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

