Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6902E9254
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 10:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhADJEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 04:04:31 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:62876 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbhADJEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 04:04:30 -0500
X-IronPort-AV: E=Sophos;i="5.78,473,1599490800"; 
   d="scan'208";a="67980477"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 04 Jan 2021 18:03:38 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 13D5D4003896;
        Mon,  4 Jan 2021 18:03:35 +0900 (JST)
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
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v2] can: rcar: Update help description for CAN_RCAR config
Date:   Mon,  4 Jan 2021 09:03:27 +0000
Message-Id: <20210104090327.6547-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcar_can driver also supports RZ/G SoC's, update the description to
reflect this.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v1->v2
* Dropped SoC version numbers.
---
 drivers/net/can/rcar/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/Kconfig b/drivers/net/can/rcar/Kconfig
index 5cb0892978ca..ec6e3339d048 100644
--- a/drivers/net/can/rcar/Kconfig
+++ b/drivers/net/can/rcar/Kconfig
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 config CAN_RCAR
-	tristate "Renesas R-Car CAN controller"
+	tristate "Renesas R-Car and RZ/G CAN controller"
 	depends on ARCH_RENESAS || ARM
 	help
 	  Say Y here if you want to use CAN controller found on Renesas R-Car
-	  SoCs.
+	  or RZ/G SoCs.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called rcar_can.
-- 
2.17.1

