Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB0E2B3743
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 18:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgKORln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 12:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbgKORlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 12:41:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A299C0613D1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 09:41:42 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1keM20-0005uQ-1u; Sun, 15 Nov 2020 18:41:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [net 07/15] can: flexcan: flexcan_setup_stop_mode(): add missing "req_bit" to stop mode property comment
Date:   Sun, 15 Nov 2020 18:41:23 +0100
Message-Id: <20201115174131.2089251-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115174131.2089251-1-mkl@pengutronix.de>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the patch

    d9b081e3fc4b ("can: flexcan: remove ack_grp and ack_bit handling from driver")

the unused ack_grp and ack_bit were removed from the driver. However in the
comment, the "req_bit" was accidentally removed, too.

This patch adds back the "req_bit" bit.

Fixes: d9b081e3fc4b ("can: flexcan: remove ack_grp and ack_bit handling from driver")
Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: http://lore.kernel.org/r/20201014114810.2911135-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 881799bd9c5e..4e8fdb6064bd 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1852,7 +1852,7 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 		return -EINVAL;
 
 	/* stop mode property format is:
-	 * <&gpr req_gpr>.
+	 * <&gpr req_gpr req_bit>.
 	 */
 	ret = of_property_read_u32_array(np, "fsl,stop-mode", out_val,
 					 ARRAY_SIZE(out_val));
-- 
2.29.2

