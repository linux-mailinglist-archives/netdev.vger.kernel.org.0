Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B0739B403
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhFDHhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:37:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4470 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhFDHhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 03:37:06 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxDxX027czZcmN;
        Fri,  4 Jun 2021 15:32:32 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:35:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:35:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/6] net: hdlc_x25: remove redundant blank lines
Date:   Fri, 4 Jun 2021 15:32:07 +0800
Message-ID: <1622791932-49876-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
References: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_x25.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index ba8c36c..86b88f2 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -70,22 +70,16 @@ static void x25_connect_disconnect(struct net_device *dev, int reason, int code)
 	tasklet_schedule(&x25st->rx_tasklet);
 }
 
-
-
 static void x25_connected(struct net_device *dev, int reason)
 {
 	x25_connect_disconnect(dev, reason, X25_IFACE_CONNECT);
 }
 
-
-
 static void x25_disconnected(struct net_device *dev, int reason)
 {
 	x25_connect_disconnect(dev, reason, X25_IFACE_DISCONNECT);
 }
 
-
-
 static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	struct x25_state *x25st = state(dev_to_hdlc(dev));
@@ -108,8 +102,6 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-
-
 static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -123,8 +115,6 @@ static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
 	hdlc->xmit(skb, dev); /* Ignore return value :-( */
 }
 
-
-
 static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -185,8 +175,6 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-
-
 static int x25_open(struct net_device *dev)
 {
 	static const struct lapb_register_struct cb = {
@@ -232,8 +220,6 @@ static int x25_open(struct net_device *dev)
 	return 0;
 }
 
-
-
 static void x25_close(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -247,8 +233,6 @@ static void x25_close(struct net_device *dev)
 	tasklet_kill(&x25st->rx_tasklet);
 }
 
-
-
 static int x25_rx(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
@@ -279,7 +263,6 @@ static int x25_rx(struct sk_buff *skb)
 	return NET_RX_DROP;
 }
 
-
 static struct hdlc_proto proto = {
 	.open		= x25_open,
 	.close		= x25_close,
@@ -289,7 +272,6 @@ static struct hdlc_proto proto = {
 	.module		= THIS_MODULE,
 };
 
-
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 {
 	x25_hdlc_proto __user *x25_s = ifr->ifr_settings.ifs_ifsu.x25;
@@ -380,21 +362,17 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 	return -EINVAL;
 }
 
-
 static int __init mod_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
 }
 
-
-
 static void __exit mod_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
-
 module_init(mod_init);
 module_exit(mod_exit);
 
-- 
2.8.1

