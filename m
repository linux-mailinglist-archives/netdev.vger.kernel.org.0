Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D8283198
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgJEINa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:13:30 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:21606 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgJEIN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:13:27 -0400
X-IronPort-AV: E=Sophos;i="5.77,338,1596466800"; 
   d="scan'208";a="58929001"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 05 Oct 2020 17:13:26 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id B4771400619F;
        Mon,  5 Oct 2020 17:13:23 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [RESEND PATCH v2 1/2] dt-bindings: can: rcar_canfd: Document r8a774e1 support
Date:   Mon,  5 Oct 2020 09:13:18 +0100
Message-Id: <20201005081319.29322-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005081319.29322-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20201005081319.29322-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the support for rcar_canfd on R8A774E1 SoC devices.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
index 13a4e34c0c73..22cf2a889b2c 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
@@ -7,6 +7,7 @@ Required properties:
   - "renesas,r8a774a1-canfd" for R8A774A1 (RZ/G2M) compatible controller.
   - "renesas,r8a774b1-canfd" for R8A774B1 (RZ/G2N) compatible controller.
   - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
+  - "renesas,r8a774e1-canfd" for R8A774E1 (RZ/G2H) compatible controller.
   - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
   - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.
   - "renesas,r8a77965-canfd" for R8A77965 (R-Car M3-N) compatible controller.
@@ -32,8 +33,8 @@ The name of the child nodes are "channel0" and "channel1" respectively. Each
 child node supports the "status" property only, which is used to
 enable/disable the respective channel.
 
-Required properties for R8A774A1, R8A774B1, R8A774C0, R8A7795, R8A7796,
-R8A77965, R8A77990, and R8A77995:
+Required properties for R8A774A1, R8A774B1, R8A774C0, R8A774E1, R8A7795,
+R8A7796, R8A77965, R8A77990, and R8A77995:
 In the denoted SoCs, canfd clock is a div6 clock and can be used by both CAN
 and CAN FD controller at the same time. It needs to be scaled to maximum
 frequency if any of these controllers use it. This is done using the below
-- 
2.17.1

