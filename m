Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB72BAB41
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgKTNdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbgKTNda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75919C061A47
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:30 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XX-0006Fn-3e; Fri, 20 Nov 2020 14:33:27 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 13/25] dt-bindings: can: fsl,flexcan: fix fsl,clk-source property
Date:   Fri, 20 Nov 2020 14:33:06 +0100
Message-Id: <20201120133318.3428231-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

Correct fsl,clk-source example since flexcan driver uses "of_property_read_u8"
to get this property.

Fixes: 9d733992772d ("dt-bindings: can: flexcan: add PE clock source property to device tree")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20201106105627.31061-2-qiangqing.zhang@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 0133d777e78e..0d2df30f19db 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -100,7 +100,7 @@ properties:
       by default.
       0: clock source 0 (oscillator clock)
       1: clock source 1 (peripheral clock)
-    $ref: /schemas/types.yaml#/definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint8
     default: 1
     minimum: 0
     maximum: 1
@@ -125,7 +125,7 @@ examples:
         interrupts = <48 0x2>;
         interrupt-parent = <&mpic>;
         clock-frequency = <200000000>;
-        fsl,clk-source = <0>;
+        fsl,clk-source = /bits/ 8 <0>;
     };
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-- 
2.29.2

