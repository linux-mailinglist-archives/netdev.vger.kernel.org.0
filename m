Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE0255FB8A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiF2JOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiF2JOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:14:00 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D356720F46;
        Wed, 29 Jun 2022 02:13:57 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AF7EA24000A;
        Wed, 29 Jun 2022 09:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656494036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rDHvQvZTZ+R6+aUdOzyCj3VSYkqM3jPLAofXVQtDdKs=;
        b=bydiXHqeu+ipQRkYLeFH2JmHxjH2WIGFKp3qA2p8qTs6a7F26ADptQeOoLq2C0Fpn6/OsY
        RH/OZ56cmcDgYw3ABqTGhrukKF/i70oh7D2Qe54WuPO/M1hGw41LBL/j36W/ixGKt7mLGx
        M4S3FMhE4QvMqyi5rMGcfDcTa/U2nSxTE2G1W570/nsTzP9XBnJ1SDQIizh+1WIabXS4sC
        wkPDB1ZWxn1S9Lq9B/xveASOcGrUVdEH5ymjgnQcX7Dl/lAMR1oyoRl/0Waiq9pPvp32gZ
        7yb621L4HpCDyzIVlZfIxTJqoXcIZx/oWa6hQTZDxv1l2yHkMluV2KTcOzSwnQ==
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
Subject: [PATCH net-next] dt-bindings: net: dsa: renesas,rzn1-a5psw: add interrupts description
Date:   Wed, 29 Jun 2022 11:13:04 +0200
Message-Id: <20220629091305.125291-1-clement.leger@bootlin.com>
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
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 103b1ef5af1b..51f274c16ed1 100644
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
+  interrupts-names:
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
+        interrupts-name = "dlr", "switch", "prp", "hub", "ptrn";
 
         dsa,member = <0 0>;
 
-- 
2.36.1

