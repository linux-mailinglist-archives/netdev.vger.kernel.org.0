Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8D1192C9
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 21:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfEITUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 15:20:53 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:53620 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727038AbfEITUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 15:20:53 -0400
X-IronPort-AV: E=Sophos;i="5.60,450,1549897200"; 
   d="scan'208";a="15462925"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 10 May 2019 04:20:50 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 72D2F415F3D5;
        Fri, 10 May 2019 04:20:47 +0900 (JST)
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
Subject: [PATCH repost 5/5] dt-bindings: can: rcar_canfd: document r8a774c0 support
Date:   Thu,  9 May 2019 20:20:22 +0100
Message-Id: <1557429622-31676-6-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the support for rcar_canfd on R8A774C0 SoC devices.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
index 41049fe..32f051f 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
@@ -3,7 +3,8 @@ Renesas R-Car CAN FD controller Device Tree Bindings
 
 Required properties:
 - compatible: Must contain one or more of the following:
-  - "renesas,rcar-gen3-canfd" for R-Car Gen3 compatible controller.
+  - "renesas,rcar-gen3-canfd" for R-Car Gen3 and RZ/G2 compatible controllers.
+  - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
   - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
   - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.
   - "renesas,r8a77965-canfd" for R8A77965 (R-Car M3-N) compatible controller.
@@ -28,12 +29,13 @@ The name of the child nodes are "channel0" and "channel1" respectively. Each
 child node supports the "status" property only, which is used to
 enable/disable the respective channel.
 
-Required properties for "renesas,r8a7795-canfd", "renesas,r8a7796-canfd",
-"renesas,r8a77965-canfd" and "renesas,r8a77990-canfd" compatible:
-In R8A7795, R8A7796, R8A77965 and R8A77990 SoCs, canfd clock is a div6 clock
-and can be used by both CAN and CAN FD controller at the same time. It needs
-to be scaled to maximum frequency if any of these controllers use it. This is
-done using the below properties:
+Required properties for "renesas,r8a774c0-canfd", "renesas,r8a7795-canfd",
+"renesas,r8a7796-canfd", "renesas,r8a77965-canfd", and "renesas,r8a77990-canfd"
+compatible:
+In R8A774C0, R8A7795, R8A7796, R8A77965, and R8A77990 SoCs, canfd clock is a
+div6 clock and can be used by both CAN and CAN FD controller at the same time.
+It needs to be scaled to maximum frequency if any of these controllers use it.
+This is done using the below properties:
 
 - assigned-clocks: phandle of canfd clock.
 - assigned-clock-rates: maximum frequency of this clock.
-- 
2.7.4

