Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072533F1AB6
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhHSNk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240233AbhHSNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E867C061760
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGj-0004zP-Iy
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:41 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B86FC66A885
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 144D466A821;
        Thu, 19 Aug 2021 13:39:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5cdf81dd;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Subject: [PATCH net-next 12/22] can: m_can: fix block comment style
Date:   Thu, 19 Aug 2021 15:39:03 +0200
Message-Id: <20210819133913.657715-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the commenting style in the m_can driver.

Fixes: 1be37d3b0414 ("can: m_can: fix periph RX path: use rx-offload to ensure skbs are sent from softirq context")
Fixes: df06fd678260 ("can: m_can: m_can_chip_config(): enable and configure internal timestamps")
Link: https://lore.kernel.org/r/20210819111703.599686-2-mkl@pengutronix.de
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 91351eef6bf8..47ddee80c423 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -437,7 +437,7 @@ static void m_can_clean(struct net_device *net)
  * napi. For non-peripherals, RX is done in napi already, so push
  * directly. timestamp is used to ensure good skb ordering in
  * rx-offload and is ignored for non-peripherals.
-*/
+ */
 static void m_can_receive_skb(struct m_can_classdev *cdev,
 			      struct sk_buff *skb,
 			      u32 timestamp)
@@ -946,7 +946,7 @@ static int m_can_poll(struct napi_struct *napi, int quota)
 /* Echo tx skb and update net stats. Peripherals use rx-offload for
  * echo. timestamp is used for peripherals to ensure correct ordering
  * by rx-offload, and is ignored for non-peripherals.
-*/
+ */
 static void m_can_tx_update_stats(struct m_can_classdev *cdev,
 				  unsigned int msg_mark,
 				  u32 timestamp)
@@ -1306,7 +1306,8 @@ static void m_can_chip_config(struct net_device *dev)
 	m_can_set_bittiming(dev);
 
 	/* enable internal timestamp generation, with a prescalar of 16. The
-	 * prescalar is applied to the nominal bit timing */
+	 * prescalar is applied to the nominal bit timing
+	 */
 	m_can_write(cdev, M_CAN_TSCC, FIELD_PREP(TSCC_TCP_MASK, 0xf));
 
 	m_can_config_endisable(cdev, false);
-- 
2.32.0


