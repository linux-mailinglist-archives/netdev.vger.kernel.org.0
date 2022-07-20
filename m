Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC2557B27C
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbiGTIMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240434AbiGTIMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:12:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EE46B767
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4ny-0000nI-Ml
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:38 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EE2B2B58AF
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 69123B5898;
        Wed, 20 Jul 2022 08:10:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id df22f7b9;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/29] can: slcan: fix whitespace issues
Date:   Wed, 20 Jul 2022 10:10:09 +0200
Message-Id: <20220720081034.3277385-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add and remove whitespace to make checkpatch happy.

Link: https://lore.kernel.org/all/20220704125954.1587880-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index ead3afefcf19..aa15c06dc198 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -74,7 +74,7 @@ module_param(maxdev, int, 0);
 MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 
 /* maximum rx buffer len: extended CAN frame with timestamp */
-#define SLC_MTU (sizeof("T1111222281122334455667788EA5F\r")+1)
+#define SLC_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
 
 #define SLC_CMD_LEN 1
 #define SLC_SFF_ID_LEN 3
@@ -624,7 +624,7 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	netif_stop_queue(sl->dev);
-	slc_encaps(sl, (struct can_frame *) skb->data); /* encaps & send */
+	slc_encaps(sl, (struct can_frame *)skb->data); /* encaps & send */
 	spin_unlock(&sl->lock);
 
 out:
@@ -804,7 +804,7 @@ static void slcan_receive_buf(struct tty_struct *tty,
 			      const unsigned char *cp, const char *fp,
 			      int count)
 {
-	struct slcan *sl = (struct slcan *) tty->disc_data;
+	struct slcan *sl = (struct slcan *)tty->disc_data;
 
 	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
 		return;
@@ -976,7 +976,7 @@ static int slcan_open(struct tty_struct *tty)
  */
 static void slcan_close(struct tty_struct *tty)
 {
-	struct slcan *sl = (struct slcan *) tty->disc_data;
+	struct slcan *sl = (struct slcan *)tty->disc_data;
 
 	/* First make sure we're connected. */
 	if (!sl || sl->magic != SLCAN_MAGIC || sl->tty != tty)
@@ -1006,7 +1006,7 @@ static void slcan_hangup(struct tty_struct *tty)
 static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 		       unsigned long arg)
 {
-	struct slcan *sl = (struct slcan *) tty->disc_data;
+	struct slcan *sl = (struct slcan *)tty->disc_data;
 	unsigned int tmp;
 
 	/* First make sure we're connected. */
-- 
2.35.1


