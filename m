Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681152E8127
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 17:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgLaQBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 11:01:06 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:50233 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727254AbgLaQBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 11:01:05 -0500
X-IronPort-AV: E=Sophos;i="5.78,464,1599490800"; 
   d="scan'208";a="67335976"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 01 Jan 2021 01:00:13 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 8029340127B5;
        Fri,  1 Jan 2021 01:00:11 +0900 (JST)
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
Subject: [PATCH] can: rcar: Update help description for CAN_RCAR config
Date:   Thu, 31 Dec 2020 15:59:57 +0000
Message-Id: <20201231155957.31165-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcar_can driver supports R-Car Gen{1,2,3} and RZ/G{1,2} SoC's, update
the description to reflect this.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/can/rcar/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/Kconfig b/drivers/net/can/rcar/Kconfig
index 8d36101b78e3..6bb0e7c052ad 100644
--- a/drivers/net/can/rcar/Kconfig
+++ b/drivers/net/can/rcar/Kconfig
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 config CAN_RCAR
-	tristate "Renesas R-Car CAN controller"
+	tristate "Renesas R-Car Gen{1,2,3} and RZ/G{1,2} CAN controller"
 	depends on ARCH_RENESAS || ARM
 	help
 	  Say Y here if you want to use CAN controller found on Renesas R-Car
-	  SoCs.
+	  Gen{1,2,3} and RZ/G{1,2} SoCs.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called rcar_can.
-- 
2.17.1

