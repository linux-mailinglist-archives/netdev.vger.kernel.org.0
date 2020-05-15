Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA811D5369
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgEOPJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:09:57 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:2033 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgEOPJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:09:56 -0400
X-IronPort-AV: E=Sophos;i="5.73,395,1583161200"; 
   d="scan'208";a="46974832"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 16 May 2020 00:09:53 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C23B640065C1;
        Sat, 16 May 2020 00:09:49 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 05/17] mmc: renesas_sdhi_sys_dmac: Add support for r8a7742 SoC
Date:   Fri, 15 May 2020 16:08:45 +0100
Message-Id: <1589555337-5498-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for r8a7742 SoC. Renesas RZ/G1H (R8A7742) SDHI is identical to
the R-Car Gen2 family.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
---
 drivers/mmc/host/renesas_sdhi_sys_dmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/renesas_sdhi_sys_dmac.c b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
index 13ff023..dbfcbc2 100644
--- a/drivers/mmc/host/renesas_sdhi_sys_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
@@ -75,6 +75,7 @@ static const struct of_device_id renesas_sdhi_sys_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s72100", .data = &of_rz_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7778", .data = &of_rcar_gen1_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7779", .data = &of_rcar_gen1_compatible, },
+	{ .compatible = "renesas,sdhi-r8a7742", .data = &of_rcar_gen2_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7743", .data = &of_rcar_gen2_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7745", .data = &of_rcar_gen2_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7790", .data = &of_rcar_gen2_compatible, },
-- 
2.7.4

