Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B30745BD0
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfFNLxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:53:51 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:9077 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727217AbfFNLxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 07:53:51 -0400
X-IronPort-AV: E=Sophos;i="5.62,373,1554735600"; 
   d="scan'208";a="18675546"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 14 Jun 2019 20:53:49 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 5547940065BE;
        Fri, 14 Jun 2019 20:53:46 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/6] dt-bindings: can: rcar_canfd: document r8a774a1 support
Date:   Fri, 14 Jun 2019 12:53:29 +0100
Message-Id: <1560513214-28031-2-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560513214-28031-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1560513214-28031-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the support for rcar_canfd on R8A774A1 SoC devices.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
---
Hello Simon,

I think it would make more sense if this patch went through you as it
sits on series:
https://lkml.org/lkml/2019/5/9/941

Do you think that's doable?

Thanks,
Fab

 Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
index 32f051f..00afaff 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
@@ -4,6 +4,7 @@ Renesas R-Car CAN FD controller Device Tree Bindings
 Required properties:
 - compatible: Must contain one or more of the following:
   - "renesas,rcar-gen3-canfd" for R-Car Gen3 and RZ/G2 compatible controllers.
+  - "renesas,r8a774a1-canfd" for R8A774A1 (RZ/G2M) compatible controller.
   - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
   - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
   - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.
@@ -32,10 +33,10 @@ enable/disable the respective channel.
 Required properties for "renesas,r8a774c0-canfd", "renesas,r8a7795-canfd",
 "renesas,r8a7796-canfd", "renesas,r8a77965-canfd", and "renesas,r8a77990-canfd"
 compatible:
-In R8A774C0, R8A7795, R8A7796, R8A77965, and R8A77990 SoCs, canfd clock is a
-div6 clock and can be used by both CAN and CAN FD controller at the same time.
-It needs to be scaled to maximum frequency if any of these controllers use it.
-This is done using the below properties:
+In R8A774A1, R8A774C0, R8A7795, R8A7796, R8A77965, and R8A77990 SoCs, canfd
+clock is a div6 clock and can be used by both CAN and CAN FD controller at the
+same time. It needs to be scaled to maximum frequency if any of these
+controllers use it. This is done using the below properties:
 
 - assigned-clocks: phandle of canfd clock.
 - assigned-clock-rates: maximum frequency of this clock.
-- 
2.7.4

