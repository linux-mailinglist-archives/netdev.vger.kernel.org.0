Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F4A27F335
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgI3USw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730221AbgI3US1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EE1C0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:27 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYT-0002Qt-Cv; Wed, 30 Sep 2020 22:18:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Thomas Kopp <thomas.kopp@microchip.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 06/13] dt-binding: can: mcp251xfd: narrow down wildcards in device tree bindings to "microchip,mcp251xfd"
Date:   Wed, 30 Sep 2020 22:18:09 +0200
Message-Id: <20200930201816.1032054-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Kopp <thomas.kopp@microchip.com>

The wildcard should be narrowed down to prevent existing and future devices
that are not compatible from matching. It is very unlikely that incompatible
devices will be released that do not match the wildcard.

This is the documentation part of the commit.

Discussion Reference: https://lore.kernel.org/r/CAMuHMdVkwGjr6dJuMyhQNqFoJqbh6Ec5V2b5LenCshwpM2SDsQ@mail.gmail.com

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Thomas Kopp <thomas.kopp@microchip.com>
Link: https://lore.kernel.org/r/20200930091423.755-2-thomas.kopp@microchip.com
[mkl: rename file, too]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 ...{microchip,mcp25xxfd.yaml => microchip,mcp251xfd.yaml} | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/net/can/{microchip,mcp25xxfd.yaml => microchip,mcp251xfd.yaml} (91%)

diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml b/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
similarity index 91%
rename from Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
rename to Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
index 5beb00a614bf..2a884c1fe0e0 100644
--- a/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/net/can/microchip,mcp25xxfd.yaml#
+$id: http://devicetree.org/schemas/net/can/microchip,mcp251xfd.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title:
@@ -18,7 +18,7 @@ properties:
         description: for MCP2517FD
       - const: microchip,mcp2518fd
         description: for MCP2518FD
-      - const: microchip,mcp25xxfd
+      - const: microchip,mcp251xfd
         description: to autodetect chip variant
 
   reg:
@@ -38,7 +38,7 @@ properties:
 
   microchip,rx-int-gpios:
     description:
-      GPIO phandle of GPIO connected to to INT1 pin of the MCP25XXFD, which
+      GPIO phandle of GPIO connected to to INT1 pin of the MCP251XFD, which
       signals a pending RX interrupt.
     maxItems: 1
 
@@ -65,7 +65,7 @@ examples:
         #size-cells = <0>;
 
         can@0 {
-            compatible = "microchip,mcp25xxfd";
+            compatible = "microchip,mcp251xfd";
             reg = <0>;
             clocks = <&can0_osc>;
             pinctrl-names = "default";
-- 
2.28.0

