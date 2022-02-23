Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2C54C1EDE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbiBWWoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244379AbiBWWoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:44:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7723D3F313
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MK-0006YX-Kk
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:44 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 506713BBBD
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C0DF63BB69;
        Wed, 23 Feb 2022 22:43:33 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 49deac1c;
        Wed, 23 Feb 2022 22:43:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/36] can: bittiming: mark function arguments and local variables as const
Date:   Wed, 23 Feb 2022 23:43:04 +0100
Message-Id: <20220223224332.2965690-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223224332.2965690-1-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch marks the arguments of some functions as well as some local
variables as constant.

Link: https://lore.kernel.org/all/20220124215642.3474154-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 12 ++++++------
 include/linux/can/bittiming.h   |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 1b1d1499e2f1..2103bcca9012 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -24,7 +24,7 @@
  */
 static int
 can_update_sample_point(const struct can_bittiming_const *btc,
-			unsigned int sample_point_nominal, unsigned int tseg,
+			const unsigned int sample_point_nominal, const unsigned int tseg,
 			unsigned int *tseg1_ptr, unsigned int *tseg2_ptr,
 			unsigned int *sample_point_error_ptr)
 {
@@ -63,7 +63,7 @@ can_update_sample_point(const struct can_bittiming_const *btc,
 	return best_sample_point;
 }
 
-int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
+int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 		       const struct can_bittiming_const *btc)
 {
 	struct can_priv *priv = netdev_priv(dev);
@@ -208,10 +208,10 @@ void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
  * prescaler value brp. You can find more information in the header
  * file linux/can/netlink.h.
  */
-static int can_fixup_bittiming(struct net_device *dev, struct can_bittiming *bt,
+static int can_fixup_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 			       const struct can_bittiming_const *btc)
 {
-	struct can_priv *priv = netdev_priv(dev);
+	const struct can_priv *priv = netdev_priv(dev);
 	unsigned int tseg1, alltseg;
 	u64 brp64;
 
@@ -244,7 +244,7 @@ static int can_fixup_bittiming(struct net_device *dev, struct can_bittiming *bt,
 
 /* Checks the validity of predefined bitrate settings */
 static int
-can_validate_bitrate(struct net_device *dev, struct can_bittiming *bt,
+can_validate_bitrate(const struct net_device *dev, const struct can_bittiming *bt,
 		     const u32 *bitrate_const,
 		     const unsigned int bitrate_const_cnt)
 {
@@ -258,7 +258,7 @@ can_validate_bitrate(struct net_device *dev, struct can_bittiming *bt,
 	return -EINVAL;
 }
 
-int can_get_bittiming(struct net_device *dev, struct can_bittiming *bt,
+int can_get_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 		      const struct can_bittiming_const *btc,
 		      const u32 *bitrate_const,
 		      const unsigned int bitrate_const_cnt)
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index a81652d1c6f3..7ae21c0f7f23 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -113,7 +113,7 @@ struct can_tdc_const {
 };
 
 #ifdef CONFIG_CAN_CALC_BITTIMING
-int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
+int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 		       const struct can_bittiming_const *btc);
 
 void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
@@ -121,7 +121,7 @@ void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
 		   u32 *ctrlmode, u32 ctrlmode_supported);
 #else /* !CONFIG_CAN_CALC_BITTIMING */
 static inline int
-can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
+can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 		   const struct can_bittiming_const *btc)
 {
 	netdev_err(dev, "bit-timing calculation not available\n");
@@ -136,7 +136,7 @@ can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
 }
 #endif /* CONFIG_CAN_CALC_BITTIMING */
 
-int can_get_bittiming(struct net_device *dev, struct can_bittiming *bt,
+int can_get_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 		      const struct can_bittiming_const *btc,
 		      const u32 *bitrate_const,
 		      const unsigned int bitrate_const_cnt);
-- 
2.34.1


