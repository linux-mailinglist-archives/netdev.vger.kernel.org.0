Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18FB5638CB
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiGARxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiGARxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:53:48 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786B73AA5B;
        Fri,  1 Jul 2022 10:53:46 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A9EF71BF205;
        Fri,  1 Jul 2022 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656698024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ANua7sLiiWlgviVfQqW0rs1+s39N6me9FtrJ3TzFU+Q=;
        b=b91HGovyZaZ4+ncVRPP+QBF+8oGYi1ZQXtxudn2Sxr+1uN/wRFdlErQV2LmWXw+JT+NnMz
        AU0fLIUo73TQGKqfhNGBeCr22YHmsaEbOYewSVRmDAHEs3rd+PVT0kNunpNdRJ087nPEQ+
        RJBfZRetpREigqqFglaoxL+HCdMvqHZ7SqSdPLt6UKbzQpQpzULCTDIbp6ZN0ltuZAIBba
        A7v6TeCRjyPyo+ddytUjkqyQZTWM5tBQLGcE4PqX2xW/mAQSkKUGkL2Ul1U4XKd6t7qx0p
        8KdW56jAKDAkIlHBSRXHAlXG7f6yk6AQqH13FUZr6bAAFoEhXkxhaAtNfa7uwg==
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net-next v3] dt-bindings: net: dsa: renesas,rzn1-a5psw: add interrupts description
Date:   Fri,  1 Jul 2022 19:52:31 +0200
Message-Id: <20220701175231.6889-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
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

Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
are connected to the GIC.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Changes in V3:
 - Renamed a few interrupt description with Geert suggestions.

Changes in V2:
 - Fix typo in interrupt-names property.

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 103b1ef5af1b..4d428f5ad044 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -26,6 +26,22 @@ properties:
   reg:
     maxItems: 1
 
+  interrupts:
+    items:
+      - description: Device Level Ring (DLR) interrupt
+      - description: Switch interrupt
+      - description: Parallel Redundancy Protocol (PRP) interrupt
+      - description: Integrated HUB module interrupt
+      - description: Receive Pattern Match interrupt
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

