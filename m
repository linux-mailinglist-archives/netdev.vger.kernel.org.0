Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5EE438BDA
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhJXUrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhJXUrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E938C061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMK-0006Fd-FC
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:48 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2E46569C621
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 15D4169C5AC;
        Sun, 24 Oct 2021 20:43:32 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fc55d58e;
        Sun, 24 Oct 2021 20:43:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Michal Simek <michal.simek@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/15] can: xilinx_can: remove repeated word from the kernel-doc
Date:   Sun, 24 Oct 2021 22:43:24 +0200
Message-Id: <20211024204325.3293425-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

Trivial patch. Issue is reported by checkpatch.

Link: https://lore.kernel.org/all/267c11097c90debbb5b1efebbeabc98161177def.1632306843.git.michal.simek@xilinx.com
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 3b883e607d8b..85c2ed5df4c7 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -516,8 +516,7 @@ static int xcan_chip_start(struct net_device *ndev)
  * @ndev:	Pointer to net_device structure
  * @mode:	Tells the mode of the driver
  *
- * This check the drivers state and calls the
- * the corresponding modes to set.
+ * This check the drivers state and calls the corresponding modes to set.
  *
  * Return: 0 on success and failure value on error
  */
@@ -982,7 +981,7 @@ static void xcan_update_error_state_after_rxtx(struct net_device *ndev)
  * @isr:	interrupt status register value
  *
  * This is the CAN error interrupt and it will
- * check the the type of error and forward the error
+ * check the type of error and forward the error
  * frame to upper layers.
  */
 static void xcan_err_interrupt(struct net_device *ndev, u32 isr)
-- 
2.33.0


