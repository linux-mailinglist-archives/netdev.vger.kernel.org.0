Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42852516B97
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383647AbiEBIDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383645AbiEBIC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:02:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979B72CCB5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 00:59:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlQxn-0002Y1-Vv
        for netdev@vger.kernel.org; Mon, 02 May 2022 09:59:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 48EC972E52
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:59:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DEE6472E1F;
        Mon,  2 May 2022 07:59:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 448f3b2e;
        Mon, 2 May 2022 07:59:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 8/9] can: ctucanfd: remove debug statements
Date:   Mon,  2 May 2022 09:59:13 +0200
Message-Id: <20220502075914.1905039-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502075914.1905039-1-mkl@pengutronix.de>
References: <20220502075914.1905039-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

This patch removes the debug statements from the driver to make
checkpatch.pl and patchwork happy.

Link: https://lore.kernel.org/all/1fd684bcf5ddb0346aad234072f54e976a5210fb.1650816929.git.pisa@cmp.felk.cvut.cz
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
[mkl: split into separate patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c | 26 ------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 10c2517a395b..2ada097d1ede 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -177,8 +177,6 @@ static int ctucan_reset(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int i = 100;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	ctucan_write32(priv, CTUCANFD_MODE, REG_MODE_RST);
 	clear_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags);
 
@@ -264,8 +262,6 @@ static int ctucan_set_bittiming(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	struct can_bittiming *bt = &priv->can.bittiming;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	/* Note that bt may be modified here */
 	return ctucan_set_btr(ndev, bt, true);
 }
@@ -281,8 +277,6 @@ static int ctucan_set_data_bittiming(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	struct can_bittiming *dbt = &priv->can.data_bittiming;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	/* Note that dbt may be modified here */
 	return ctucan_set_btr(ndev, dbt, false);
 }
@@ -300,8 +294,6 @@ static int ctucan_set_secondary_sample_point(struct net_device *ndev)
 	int ssp_offset = 0;
 	u32 ssp_cfg = 0; /* No SSP by default */
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	if (CTU_CAN_FD_ENABLED(priv)) {
 		netdev_err(ndev, "BUG! Cannot set SSP - CAN is enabled\n");
 		return -EPERM;
@@ -388,8 +380,6 @@ static int ctucan_chip_start(struct net_device *ndev)
 	int err;
 	struct can_ctrlmode mode;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	priv->txb_prio = 0x01234567;
 	priv->txb_head = 0;
 	priv->txb_tail = 0;
@@ -455,8 +445,6 @@ static int ctucan_do_set_mode(struct net_device *ndev, enum can_mode mode)
 {
 	int ret;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	switch (mode) {
 	case CAN_MODE_START:
 		ret = ctucan_reset(ndev);
@@ -1121,8 +1109,6 @@ static irqreturn_t ctucan_interrupt(int irq, void *dev_id)
 	u32 imask;
 	int irq_loops;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	for (irq_loops = 0; irq_loops < 10000; irq_loops++) {
 		/* Get the interrupt status */
 		isr = ctucan_read32(priv, CTUCANFD_INT_STAT);
@@ -1196,8 +1182,6 @@ static void ctucan_chip_stop(struct net_device *ndev)
 	u32 mask = 0xffffffff;
 	u32 mode;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	/* Disable interrupts and disable CAN */
 	ctucan_write32(priv, CTUCANFD_INT_ENA_CLR, mask);
 	ctucan_write32(priv, CTUCANFD_INT_MASK_SET, mask);
@@ -1220,8 +1204,6 @@ static int ctucan_open(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	ret = pm_runtime_get_sync(priv->dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
@@ -1281,8 +1263,6 @@ static int ctucan_close(struct net_device *ndev)
 {
 	struct ctucan_priv *priv = netdev_priv(ndev);
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	netif_stop_queue(ndev);
 	napi_disable(&priv->napi);
 	ctucan_chip_stop(ndev);
@@ -1308,8 +1288,6 @@ static int ctucan_get_berr_counter(const struct net_device *ndev, struct can_ber
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	ret = pm_runtime_get_sync(priv->dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n", __func__, ret);
@@ -1335,8 +1313,6 @@ int ctucan_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct ctucan_priv *priv = netdev_priv(ndev);
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
 		netif_device_detach(ndev);
@@ -1353,8 +1329,6 @@ int ctucan_resume(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct ctucan_priv *priv = netdev_priv(ndev);
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	if (netif_running(ndev)) {
-- 
2.35.1


