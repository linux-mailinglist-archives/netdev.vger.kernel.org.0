Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8C52D7AA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241077AbiESPdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbiESPcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:32:48 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE251606E4;
        Thu, 19 May 2022 08:32:43 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E76ACFF80F;
        Thu, 19 May 2022 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652974361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KzRgECeLg8b+JOftEd+lYLYrupVVTVJ7ZgWpmv64DfU=;
        b=B7XNeeqkkxFJgvseWqzReiqJqz98UoEV0tB65KjxFAWnnFt8GijfDc70bCGguEwTvIKk4n
        WZ5ySVEkYmMNhVRg9ZCJylJ3LliqbeAAXqbAISAVgD49w5Ja8jlyOpsZT8lFQfpyDlIVae
        MILlGbERi4P1mqOzQeZ2eQayMKII1E1ImhgqxWCB5oUs8wmB3seXhTtmmu25V1j6TVpzUS
        0ETUjMXwzDREkPkxRQy6XtanTIdFKwZG1l3bX13G7xzwLj2RR4lCLQGHwtkpAArp+a2Z9w
        HAT96ugGxygZU0eNerjUNW7VzCxEFLd5y7kZNmufqvRamElJAj2Fi4WSEGKKzw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v5 06/13] dt-bindings: net: dsa: add bindings for Renesas RZ/N1 Advanced 5 port switch
Date:   Thu, 19 May 2022 17:31:00 +0200
Message-Id: <20220519153107.696864-7-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519153107.696864-1-clement.leger@bootlin.com>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
This company does not exists anymore and has been bought by Synopsys.
Since this IP can't be find anymore in the Synospsy portfolio, lets use
Renesas as the vendor compatible for this IP.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 131 ++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
new file mode 100644
index 000000000000..e3ab1cf1575d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -0,0 +1,131 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/renesas,rzn1-a5psw.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas RZ/N1 Advanced 5 ports ethernet switch
+
+maintainers:
+  - Clément Léger <clement.leger@bootlin.com>
+
+description: |
+  The advanced 5 ports switch is present on the Renesas RZ/N1 SoC family and
+  handles 4 ports + 1 CPU management port.
+
+allOf:
+  - $ref: dsa.yaml#
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - renesas,r9a06g032-a5psw
+      - const: renesas,rzn1-a5psw
+
+  reg:
+    maxItems: 1
+
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
+
+  clocks:
+    items:
+      - description: AHB clock used for the switch register interface
+      - description: Switch system clock
+
+  clock-names:
+    items:
+      - const: hclk
+      - const: clk
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
+      "^(ethernet-)?port@[0-4]$":
+        type: object
+        description: Ethernet switch ports
+
+        properties:
+          pcs-handle:
+            description:
+              phandle pointing to a PCS sub-node compatible with
+              renesas,rzn1-miic.yaml#
+            $ref: /schemas/types.yaml#/definitions/phandle
+
+unevaluatedProperties: false
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+
+    switch@44050000 {
+        compatible = "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
+        reg = <0x44050000 0x10000>;
+        clocks = <&sysctrl R9A06G032_HCLK_SWITCH>, <&sysctrl R9A06G032_CLK_SWITCH>;
+        clock-names = "hclk", "clk";
+        pinctrl-names = "default";
+        pinctrl-0 = <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>;
+
+        dsa,member = <0 0>;
+
+        ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            port@0 {
+                reg = <0>;
+                label = "lan0";
+                phy-handle = <&switch0phy3>;
+                pcs-handle = <&mii_conv4>;
+            };
+
+            port@1 {
+                reg = <1>;
+                label = "lan1";
+                phy-handle = <&switch0phy1>;
+                pcs-handle = <&mii_conv3>;
+            };
+
+            port@4 {
+                reg = <4>;
+                ethernet = <&gmac1>;
+                label = "cpu";
+                fixed-link {
+                  speed = <1000>;
+                  full-duplex;
+                };
+            };
+        };
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            reset-gpios = <&gpio0a 2 GPIO_ACTIVE_HIGH>;
+            reset-delay-us = <15>;
+            clock-frequency = <2500000>;
+
+            switch0phy1: ethernet-phy@1{
+                reg = <1>;
+            };
+
+            switch0phy3: ethernet-phy@3{
+                reg = <3>;
+            };
+        };
+    };
-- 
2.36.0

