Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEDC192D5
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 21:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfEITUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 15:20:37 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:7654 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726989AbfEITUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 15:20:36 -0400
X-IronPort-AV: E=Sophos;i="5.60,450,1549897200"; 
   d="scan'208";a="15257452"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 10 May 2019 04:20:33 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 1559F415F3F2;
        Fri, 10 May 2019 04:20:29 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH repost 1/5] dt-bindings: can: rcar_can: Fix RZ/G2 CAN clocks
Date:   Thu,  9 May 2019 20:20:18 +0100
Message-Id: <1557429622-31676-2-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the latest information, the clock options for CAN on RZ/G2
are the same as the ones available on R-Car Gen3

Fixes: 868b7c0f43e6 ("dt-bindings: can: rcar_can: Add r8a774a1 support")
Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/can/rcar_can.txt | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_can.txt b/Documentation/devicetree/bindings/net/can/rcar_can.txt
index 9936b9e..e0dfc7c 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_can.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_can.txt
@@ -27,13 +27,8 @@ Required properties:
 
 - reg: physical base address and size of the R-Car CAN register map.
 - interrupts: interrupt specifier for the sole interrupt.
-- clocks: phandles and clock specifiers for 2 CAN clock inputs for RZ/G2
-	  devices.
-	  phandles and clock specifiers for 3 CAN clock inputs for every other
-	  SoC.
-- clock-names: 2 clock input name strings for RZ/G2: "clkp1", "can_clk".
-	       3 clock input name strings for every other SoC: "clkp1", "clkp2",
-	       "can_clk".
+- clocks: phandles and clock specifiers for 3 CAN clock inputs.
+- clock-names: 3 clock input name strings: "clkp1", "clkp2", and "can_clk".
 - pinctrl-0: pin control group to be used for this controller.
 - pinctrl-names: must be "default".
 
@@ -49,8 +44,7 @@ using the below properties:
 Optional properties:
 - renesas,can-clock-select: R-Car CAN Clock Source Select. Valid values are:
 			    <0x0> (default) : Peripheral clock (clkp1)
-			    <0x1> : Peripheral clock (clkp2) (not supported by
-				    RZ/G2 devices)
+			    <0x1> : Peripheral clock (clkp2)
 			    <0x3> : External input clock
 
 Example
-- 
2.7.4

