Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFA0286A47
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgJGVc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbgJGVcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D97C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:14 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2i-0005qi-OP; Wed, 07 Oct 2020 23:32:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 09/17] dt-bindings: can: rcar_can: Add r8a7742 support
Date:   Wed,  7 Oct 2020 23:31:51 +0200
Message-Id: <20201007213159.1959308-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Document RZ/G1H (r8a7742) SoC specific bindings. The R8A7742 CAN module
is identical to R-Car Gen2 family.

No driver change is needed due to the fallback compatible value
"renesas,rcar-gen2-can".

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
Link: https://lore.kernel.org/r/20200816190732.6905-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/rcar_can.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_can.txt b/Documentation/devicetree/bindings/net/can/rcar_can.txt
index 85c6551b602a..2099ce809ae7 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_can.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_can.txt
@@ -2,7 +2,8 @@ Renesas R-Car CAN controller Device Tree Bindings
 -------------------------------------------------
 
 Required properties:
-- compatible: "renesas,can-r8a7743" if CAN controller is a part of R8A7743 SoC.
+- compatible: "renesas,can-r8a7742" if CAN controller is a part of R8A7742 SoC.
+	      "renesas,can-r8a7743" if CAN controller is a part of R8A7743 SoC.
 	      "renesas,can-r8a7744" if CAN controller is a part of R8A7744 SoC.
 	      "renesas,can-r8a7745" if CAN controller is a part of R8A7745 SoC.
 	      "renesas,can-r8a77470" if CAN controller is a part of R8A77470 SoC.
-- 
2.28.0

