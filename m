Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C6397422
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhFAN2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:28:22 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2826 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbhFAN2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:28:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvXqr527gzWqcX;
        Tue,  1 Jun 2021 21:21:44 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:26:26 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:26:26 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/7] net: hdlc: fix an code style issue about EXPORT_SYMBOL(foo)
Date:   Tue, 1 Jun 2021 21:23:19 +0800
Message-ID: <1622553802-19903-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622553802-19903-1-git-send-email-huangguangbin2@huawei.com>
References: <1622553802-19903-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

According to the chackpatch.pl,
EXPORT_SYMBOL(foo); should immediately follow its function/variable.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 3cdb641..13388ba 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -73,6 +73,7 @@ netdev_tx_t hdlc_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	return hdlc->xmit(skb, dev); /* call hardware driver directly */
 }
+EXPORT_SYMBOL(hdlc_start_xmit);
 
 static inline void hdlc_proto_start(struct net_device *dev)
 {
@@ -170,6 +171,7 @@ int hdlc_open(struct net_device *dev)
 	spin_unlock_irq(&hdlc->state_lock);
 	return 0;
 }
+EXPORT_SYMBOL(hdlc_open);
 
 /* Must be called by hardware driver when HDLC device is being closed */
 void hdlc_close(struct net_device *dev)
@@ -191,6 +193,7 @@ void hdlc_close(struct net_device *dev)
 	if (hdlc->proto->close)
 		hdlc->proto->close(dev);
 }
+EXPORT_SYMBOL(hdlc_close);
 
 int hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
@@ -215,6 +218,7 @@ int hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL(hdlc_ioctl);
 
 static const struct header_ops hdlc_null_ops;
 
@@ -255,6 +259,7 @@ struct net_device *alloc_hdlcdev(void *priv)
 		dev_to_hdlc(dev)->priv = priv;
 	return dev;
 }
+EXPORT_SYMBOL(alloc_hdlcdev);
 
 void unregister_hdlc_device(struct net_device *dev)
 {
@@ -263,6 +268,7 @@ void unregister_hdlc_device(struct net_device *dev)
 	unregister_netdevice(dev);
 	rtnl_unlock();
 }
+EXPORT_SYMBOL(unregister_hdlc_device);
 
 int attach_hdlc_protocol(struct net_device *dev, struct hdlc_proto *proto,
 			 size_t size)
@@ -287,6 +293,7 @@ int attach_hdlc_protocol(struct net_device *dev, struct hdlc_proto *proto,
 
 	return 0;
 }
+EXPORT_SYMBOL(attach_hdlc_protocol);
 
 int detach_hdlc_protocol(struct net_device *dev)
 {
@@ -312,6 +319,7 @@ int detach_hdlc_protocol(struct net_device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(detach_hdlc_protocol);
 
 void register_hdlc_protocol(struct hdlc_proto *proto)
 {
@@ -320,6 +328,7 @@ void register_hdlc_protocol(struct hdlc_proto *proto)
 	first_proto = proto;
 	rtnl_unlock();
 }
+EXPORT_SYMBOL(register_hdlc_protocol);
 
 void unregister_hdlc_protocol(struct hdlc_proto *proto)
 {
@@ -334,22 +343,12 @@ void unregister_hdlc_protocol(struct hdlc_proto *proto)
 	*p = proto->next;
 	rtnl_unlock();
 }
+EXPORT_SYMBOL(unregister_hdlc_protocol);
 
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("HDLC support module");
 MODULE_LICENSE("GPL v2");
 
-EXPORT_SYMBOL(hdlc_start_xmit);
-EXPORT_SYMBOL(hdlc_open);
-EXPORT_SYMBOL(hdlc_close);
-EXPORT_SYMBOL(hdlc_ioctl);
-EXPORT_SYMBOL(alloc_hdlcdev);
-EXPORT_SYMBOL(unregister_hdlc_device);
-EXPORT_SYMBOL(register_hdlc_protocol);
-EXPORT_SYMBOL(unregister_hdlc_protocol);
-EXPORT_SYMBOL(attach_hdlc_protocol);
-EXPORT_SYMBOL(detach_hdlc_protocol);
-
 static struct packet_type hdlc_packet_type __read_mostly = {
 	.type = cpu_to_be16(ETH_P_HDLC),
 	.func = hdlc_rcv,
-- 
2.8.1

