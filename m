Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6A53056E0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbhA0J1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbhA0JXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:23:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1AEC061756
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 01:22:36 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l4h23-00085V-9s
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 10:22:35 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3730A5CF0ED
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:22:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B86775CF0CF;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 47fd5774;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 02/12] can: flexcan: fix typos
Date:   Wed, 27 Jan 2021 10:22:17 +0100
Message-Id: <20210127092227.2775573-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210127092227.2775573-1-mkl@pengutronix.de>
References: <20210127092227.2775573-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes two typos found by codespell.

Fixes: 812f0116c66a ("can: flexcan: add CAN wakeup function for i.MX8QM")
Link: https://lore.kernel.org/r/20210127085529.2768537-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 5d9157c655e9..971ada36e37f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1975,14 +1975,14 @@ static int flexcan_setup_stop_mode_scfw(struct platform_device *pdev)
 	priv = netdev_priv(dev);
 	priv->scu_idx = scu_idx;
 
-	/* this function could be defered probe, return -EPROBE_DEFER */
+	/* this function could be deferred probe, return -EPROBE_DEFER */
 	return imx_scu_get_handle(&priv->sc_ipc_handle);
 }
 
 /* flexcan_setup_stop_mode - Setup stop mode for wakeup
  *
  * Return: = 0 setup stop mode successfully or doesn't support this feature
- *         < 0 fail to setup stop mode (could be defered probe)
+ *         < 0 fail to setup stop mode (could be deferred probe)
  */
 static int flexcan_setup_stop_mode(struct platform_device *pdev)
 {
-- 
2.29.2


