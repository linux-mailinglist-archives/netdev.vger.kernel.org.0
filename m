Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66013562040
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiF3Q0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiF3Q0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:26:23 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC7831DDB;
        Thu, 30 Jun 2022 09:26:21 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5FD75240006;
        Thu, 30 Jun 2022 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656606380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ub7MTUUE2hv+8hYKHLTeAm9AB3Acs240cVnO+TTjyMI=;
        b=GNQD12DMHY+Txmr6rW+F7vIEB9gkB3V5cSer0MzO7bvlfj8FUd1QlCmi5f79He1E7YNi4o
        YkBLZAZ8b9NDzZdJqBhe4ImpmAvH0nMYBg3J06mk2403U8Tmd9INinPQP8wV3zrBj4wxKK
        DiXQl5btYFpho1In9qfhI92O0b2wLAa8i0Elnq+luKCLCa/sAa7x2KXk//ByFfJdMk8b3a
        pTc4frVAMKGW3ZbqnkGTfzza0x9IBtgKGxUjnT0XY3UNMr8nEkLkogrnQEWu9HDEZxUT0D
        xYSM04sPUNf7aaEc3d5yZMQ/wppjfhT0/Jh7W4Lxwi3+QilwY+6o+EP9cnBlXg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: [PATCH net-next v2] dt-bindings: net: dsa: renesas,rzn1-a5psw: add interrupts description
Date:   Thu, 30 Jun 2022 18:25:15 +0200
Message-Id: <20220630162515.37302-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
are connected to the GIC.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
Changes in V2:
 - Fix typo in interrupt-names property.

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 103b1ef5af1b..e68c7e353100 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -26,6 +26,22 @@ properties:
   reg:
     maxItems: 1
 
+  interrupts:
+    items:
+      - description: DLR interrupt
+      - description: Switch interrupt
+      - description: PRP interrupt
+      - description: Integrated HUB module interrupt
+      - description: RX Pattern interrupt
+
+  interrupt-names:
+    items:
+      - const: dlr
+      - const: switch
+      - const: prp
+      - const: hub
+      - const: ptrn
+
   power-domains:
     maxItems: 1
 
@@ -76,6 +92,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
 
     switch@44050000 {
         compatible = "renesas,r9a06g032-a5psw", "renesas,rzn1-a5psw";
@@ -83,6 +100,12 @@ examples:
         clocks = <&sysctrl R9A06G032_HCLK_SWITCH>, <&sysctrl R9A06G032_CLK_SWITCH>;
         clock-names = "hclk", "clk";
         power-domains = <&sysctrl>;
+        interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "dlr", "switch", "prp", "hub", "ptrn";
 
         dsa,member = <0 0>;
 
-- 
2.36.1

