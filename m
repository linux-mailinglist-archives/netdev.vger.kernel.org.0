Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3222E8124
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 17:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgLaQBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 11:01:03 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:40091 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727254AbgLaQBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 11:01:02 -0500
X-IronPort-AV: E=Sophos;i="5.78,464,1599490800"; 
   d="scan'208";a="67553350"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 01 Jan 2021 01:00:11 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id B5D504012A9E;
        Fri,  1 Jan 2021 01:00:08 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] can: rcar: Update help description for CAN_RCAR_CANFD config
Date:   Thu, 31 Dec 2020 15:59:56 +0000
Message-Id: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcar_canfd driver supports R-Car Gen3 and RZ/G2 SoC's, update the
description to reflect this.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/can/rcar/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/rcar/Kconfig b/drivers/net/can/rcar/Kconfig
index 6bb0e7c052ad..a669b9ac8057 100644
--- a/drivers/net/can/rcar/Kconfig
+++ b/drivers/net/can/rcar/Kconfig
@@ -10,13 +10,13 @@ config CAN_RCAR
 	  be called rcar_can.
 
 config CAN_RCAR_CANFD
-	tristate "Renesas R-Car CAN FD controller"
+	tristate "Renesas R-Car Gen3 and RZ/G2 CAN FD controller"
 	depends on ARCH_RENESAS || ARM
 	help
 	  Say Y here if you want to use CAN FD controller found on
-	  Renesas R-Car SoCs. The driver puts the controller in CAN FD only
-	  mode, which can interoperate with CAN2.0 nodes but does not support
-	  dedicated CAN 2.0 mode.
+	  Renesas R-Car Gen3 and RZ/G2 SoCs. The driver puts the
+	  controller in CAN FD only mode, which can interoperate with
+	  CAN2.0 nodes but does not support dedicated CAN 2.0 mode.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called rcar_canfd.
-- 
2.17.1

