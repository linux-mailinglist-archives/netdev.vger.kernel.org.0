Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE53D5B48
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhGZNdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbhGZNdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC70C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LN-00023h-Si
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:33 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9301565826E
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A81106581D4;
        Mon, 26 Jul 2021 14:11:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0c7223a8;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 27/46] net: at91_can: fix the alignment issue
Date:   Mon, 26 Jul 2021 16:11:25 +0200
Message-Id: <20210726141144.862529-28-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Alignment should match open parenthesis.

Link: https://lore.kernel.org/r/1624096589-13452-6-git-send-email-huangguangbin2@huawei.com
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 9052c7af0f23..8fab80887117 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -281,19 +281,20 @@ static inline u32 at91_read(const struct at91_priv *priv, enum at91_reg reg)
 }
 
 static inline void at91_write(const struct at91_priv *priv, enum at91_reg reg,
-		u32 value)
+			      u32 value)
 {
 	writel_relaxed(value, priv->reg_base + reg);
 }
 
 static inline void set_mb_mode_prio(const struct at91_priv *priv,
-		unsigned int mb, enum at91_mb_mode mode, int prio)
+				    unsigned int mb, enum at91_mb_mode mode,
+				    int prio)
 {
 	at91_write(priv, AT91_MMR(mb), (mode << 24) | (prio << 16));
 }
 
 static inline void set_mb_mode(const struct at91_priv *priv, unsigned int mb,
-		enum at91_mb_mode mode)
+			       enum at91_mb_mode mode)
 {
 	set_mb_mode_prio(priv, mb, mode, 0);
 }
@@ -368,7 +369,7 @@ static int at91_set_bittiming(struct net_device *dev)
 }
 
 static int at91_get_berr_counter(const struct net_device *dev,
-		struct can_berr_counter *bec)
+				 struct can_berr_counter *bec)
 {
 	const struct at91_priv *priv = netdev_priv(dev);
 	u32 reg_ecr = at91_read(priv, AT91_ECR);
@@ -527,7 +528,7 @@ static inline void at91_activate_rx_low(const struct at91_priv *priv)
  * Reenables given mailbox for reception of new CAN messages
  */
 static inline void at91_activate_rx_mb(const struct at91_priv *priv,
-		unsigned int mb)
+				       unsigned int mb)
 {
 	u32 mask = 1 << mb;
 
@@ -570,7 +571,7 @@ static void at91_rx_overflow_err(struct net_device *dev)
  * given can frame. "mb" and "cf" must be valid.
  */
 static void at91_read_mb(struct net_device *dev, unsigned int mb,
-		struct can_frame *cf)
+			 struct can_frame *cf)
 {
 	const struct at91_priv *priv = netdev_priv(dev);
 	u32 reg_msr, reg_mid;
@@ -687,7 +688,7 @@ static int at91_poll_rx(struct net_device *dev, int quota)
 	if (priv->rx_next > get_mb_rx_low_last(priv) &&
 	    reg_sr & get_mb_rx_low_mask(priv))
 		netdev_info(dev,
-			"order of incoming frames cannot be guaranteed\n");
+			    "order of incoming frames cannot be guaranteed\n");
 
  again:
 	for (mb = find_next_bit(addr, get_mb_tx_first(priv), priv->rx_next);
@@ -720,7 +721,7 @@ static int at91_poll_rx(struct net_device *dev, int quota)
 }
 
 static void at91_poll_err_frame(struct net_device *dev,
-		struct can_frame *cf, u32 reg_sr)
+				struct can_frame *cf, u32 reg_sr)
 {
 	struct at91_priv *priv = netdev_priv(dev);
 
@@ -876,7 +877,7 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 }
 
 static void at91_irq_err_state(struct net_device *dev,
-		struct can_frame *cf, enum can_state new_state)
+			       struct can_frame *cf, enum can_state new_state)
 {
 	struct at91_priv *priv = netdev_priv(dev);
 	u32 reg_idr = 0, reg_ier = 0;
@@ -985,7 +986,7 @@ static void at91_irq_err_state(struct net_device *dev,
 }
 
 static int at91_get_state_by_bec(const struct net_device *dev,
-		enum can_state *state)
+				 enum can_state *state)
 {
 	struct can_berr_counter bec;
 	int err;
@@ -1189,7 +1190,8 @@ static ssize_t mb0_id_show(struct device *dev,
 }
 
 static ssize_t mb0_id_store(struct device *dev,
-			    struct device_attribute *attr, const char *buf, size_t count)
+			    struct device_attribute *attr,
+			    const char *buf, size_t count)
 {
 	struct net_device *ndev = to_net_dev(dev);
 	struct at91_priv *priv = netdev_priv(ndev);
-- 
2.30.2


