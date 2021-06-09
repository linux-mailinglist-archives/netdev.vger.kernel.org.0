Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36AE3A1074
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhFIJpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:45:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5468 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238243AbhFIJp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:45:28 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0MXq4TlMzZfcL;
        Wed,  9 Jun 2021 17:40:27 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/9] net: lapbether: fix the comments style issue
Date:   Wed, 9 Jun 2021 17:39:52 +0800
Message-ID: <1623231595-33851-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
References: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Networking block comments don't use an empty /* line,
use /* Comment...

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/lapbether.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 705a898..60628aa 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -44,7 +44,8 @@
 static const u8 bcast_addr[6] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /* If this number is made larger, check that the temporary string buffer
- * in lapbeth_new_device is large enough to store the probe device name.*/
+ * in lapbeth_new_device is large enough to store the probe device name.
+ */
 #define MAXLAPBDEV 100
 
 struct lapbethdev {
@@ -64,8 +65,7 @@ static void lapbeth_disconnected(struct net_device *dev, int reason);
 
 /* ------------------------------------------------------------------------ */
 
-/*
- *	Get the LAPB device for the ethernet device
+/*	Get the LAPB device for the ethernet device
  */
 static struct lapbethdev *lapbeth_get_x25_dev(struct net_device *dev)
 {
@@ -105,8 +105,7 @@ static int lapbeth_napi_poll(struct napi_struct *napi, int budget)
 	return processed;
 }
 
-/*
- *	Receive a LAPB frame via an ethernet interface.
+/*	Receive a LAPB frame via an ethernet interface.
  */
 static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *ptype, struct net_device *orig_dev)
 {
@@ -179,8 +178,7 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 	return NET_RX_SUCCESS;
 }
 
-/*
- *	Send a LAPB frame via an ethernet interface
+/*	Send a LAPB frame via an ethernet interface
  */
 static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
@@ -296,8 +294,7 @@ static void lapbeth_disconnected(struct net_device *dev, int reason)
 	napi_schedule(&lapbeth->napi);
 }
 
-/*
- *	Set AX.25 callsign
+/*	Set AX.25 callsign
  */
 static int lapbeth_set_mac_address(struct net_device *dev, void *addr)
 {
@@ -316,8 +313,7 @@ static const struct lapb_register_struct lapbeth_callbacks = {
 	.data_transmit           = lapbeth_data_transmit,
 };
 
-/*
- * open/close a device
+/* open/close a device
  */
 static int lapbeth_open(struct net_device *dev)
 {
@@ -376,8 +372,7 @@ static void lapbeth_setup(struct net_device *dev)
 	dev->addr_len        = 0;
 }
 
-/*
- *	Setup a new device.
+/*	Setup a new device.
  */
 static int lapbeth_new_device(struct net_device *dev)
 {
@@ -428,8 +423,7 @@ static int lapbeth_new_device(struct net_device *dev)
 	goto out;
 }
 
-/*
- *	Free a lapb network device.
+/*	Free a lapb network device.
  */
 static void lapbeth_free_device(struct lapbethdev *lapbeth)
 {
@@ -438,8 +432,7 @@ static void lapbeth_free_device(struct lapbethdev *lapbeth)
 	unregister_netdevice(lapbeth->axdev);
 }
 
-/*
- *	Handle device status changes.
+/*	Handle device status changes.
  *
  * Called from notifier with RTNL held.
  */
-- 
2.8.1

