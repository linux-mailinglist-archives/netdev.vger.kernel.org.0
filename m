Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E1C3AD940
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 12:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhFSKCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 06:02:05 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8283 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhFSKB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 06:01:57 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G6WNb4WKdz1BNbq;
        Sat, 19 Jun 2021 17:54:39 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/8] net: at91_can: fix the alignment issue
Date:   Sat, 19 Jun 2021 17:56:26 +0800
Message-ID: <1624096589-13452-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
References: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Alignment should match open parenthesis.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/can/at91_can.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 279878165e5b..394fc72d39ac 100644
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
@@ -1178,7 +1179,7 @@ static const struct net_device_ops at91_netdev_ops = {
 };
 
 static ssize_t at91_sysfs_show_mb0_id(struct device *dev,
-		struct device_attribute *attr, char *buf)
+				      struct device_attribute *attr, char *buf)
 {
 	struct at91_priv *priv = netdev_priv(to_net_dev(dev));
 
@@ -1189,7 +1190,8 @@ static ssize_t at91_sysfs_show_mb0_id(struct device *dev,
 }
 
 static ssize_t at91_sysfs_set_mb0_id(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
 {
 	struct net_device *ndev = to_net_dev(dev);
 	struct at91_priv *priv = netdev_priv(ndev);
-- 
2.8.1

