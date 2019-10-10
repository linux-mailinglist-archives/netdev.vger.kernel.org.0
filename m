Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E66D29A1
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387472AbfJJMhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:37:46 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:7227 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726923AbfJJMhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:37:45 -0400
X-IronPort-AV: E=Sophos;i="5.67,280,1566831600"; 
   d="scan'208";a="28789739"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 10 Oct 2019 21:37:43 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id DF2F24000901;
        Thu, 10 Oct 2019 21:37:39 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH net-next 1/3] dt-bindings: can: rcar_can: Add r8a774b1 support
Date:   Thu, 10 Oct 2019 13:37:27 +0100
Message-Id: <1570711049-5691-2-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570711049-5691-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1570711049-5691-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document RZ/G2N (r8a774b1) SoC specific bindings.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
---
 Documentation/devicetree/bindings/net/can/rcar_can.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_can.txt b/Documentation/devicetree/bindings/net/can/rcar_can.txt
index 19e4a7d..85c6551 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_can.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_can.txt
@@ -7,6 +7,7 @@ Required properties:
 	      "renesas,can-r8a7745" if CAN controller is a part of R8A7745 SoC.
 	      "renesas,can-r8a77470" if CAN controller is a part of R8A77470 SoC.
 	      "renesas,can-r8a774a1" if CAN controller is a part of R8A774A1 SoC.
+	      "renesas,can-r8a774b1" if CAN controller is a part of R8A774B1 SoC.
 	      "renesas,can-r8a774c0" if CAN controller is a part of R8A774C0 SoC.
 	      "renesas,can-r8a7778" if CAN controller is a part of R8A7778 SoC.
 	      "renesas,can-r8a7779" if CAN controller is a part of R8A7779 SoC.
@@ -36,8 +37,8 @@ Required properties:
 - pinctrl-0: pin control group to be used for this controller.
 - pinctrl-names: must be "default".
 
-Required properties for R8A774A1, R8A774C0, R8A7795, R8A7796, R8A77965,
-R8A77990, and R8A77995:
+Required properties for R8A774A1, R8A774B1, R8A774C0, R8A7795, R8A7796,
+R8A77965, R8A77990, and R8A77995:
 For the denoted SoCs, "clkp2" can be CANFD clock. This is a div6 clock and can
 be used by both CAN and CAN FD controller at the same time. It needs to be
 scaled to maximum frequency if any of these controllers use it. This is done
-- 
2.7.4

