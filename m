Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BA6192C2
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 21:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfEITUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 15:20:39 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:60226 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726995AbfEITUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 15:20:38 -0400
X-IronPort-AV: E=Sophos;i="5.60,450,1549897200"; 
   d="scan'208";a="15462910"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 10 May 2019 04:20:37 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.36.196])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id C9B51415F3F2;
        Fri, 10 May 2019 04:20:33 +0900 (JST)
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
Subject: [PATCH repost 2/5] dt-bindings: can: rcar_can: Add r8a774c0 support
Date:   Thu,  9 May 2019 20:20:19 +0100
Message-Id: <1557429622-31676-3-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document RZ/G2E (r8a774c0) SoC specific bindings.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/can/rcar_can.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_can.txt b/Documentation/devicetree/bindings/net/can/rcar_can.txt
index e0dfc7c..b463e12 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_can.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_can.txt
@@ -6,6 +6,7 @@ Required properties:
 	      "renesas,can-r8a7744" if CAN controller is a part of R8A7744 SoC.
 	      "renesas,can-r8a7745" if CAN controller is a part of R8A7745 SoC.
 	      "renesas,can-r8a774a1" if CAN controller is a part of R8A774A1 SoC.
+	      "renesas,can-r8a774c0" if CAN controller is a part of R8A774C0 SoC.
 	      "renesas,can-r8a7778" if CAN controller is a part of R8A7778 SoC.
 	      "renesas,can-r8a7779" if CAN controller is a part of R8A7779 SoC.
 	      "renesas,can-r8a7790" if CAN controller is a part of R8A7790 SoC.
-- 
2.7.4

