Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC4F39741F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhFAN2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:28:17 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2824 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhFAN2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:28:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvXqr0xB4zWqcR;
        Tue,  1 Jun 2021 21:21:44 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:26:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:26:25 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/7] net: hdlc: remove redundant blank lines
Date:   Tue, 1 Jun 2021 21:23:16 +0800
Message-ID: <1622553802-19903-2-git-send-email-huangguangbin2@huawei.com>
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

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 1bdd3df..0883302 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <net/net_namespace.h>
 
-
 static const char* version = "HDLC support module revision 1.22";
 
 #undef DEBUG_LINK
@@ -82,8 +81,6 @@ static inline void hdlc_proto_start(struct net_device *dev)
 		hdlc->proto->start(dev);
 }
 
-
-
 static inline void hdlc_proto_stop(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -91,8 +88,6 @@ static inline void hdlc_proto_stop(struct net_device *dev)
 		hdlc->proto->stop(dev);
 }
 
-
-
 static int hdlc_device_event(struct notifier_block *this, unsigned long event,
 			     void *ptr)
 {
@@ -141,8 +136,6 @@ static int hdlc_device_event(struct notifier_block *this, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-
-
 /* Must be called by hardware driver when HDLC device is being opened */
 int hdlc_open(struct net_device *dev)
 {
@@ -175,8 +168,6 @@ int hdlc_open(struct net_device *dev)
 	return 0;
 }
 
-
-
 /* Must be called by hardware driver when HDLC device is being closed */
 void hdlc_close(struct net_device *dev)
 {
@@ -198,8 +189,6 @@ void hdlc_close(struct net_device *dev)
 		hdlc->proto->close(dev);
 }
 
-
-
 int hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct hdlc_proto *proto = first_proto;
@@ -271,8 +260,6 @@ void unregister_hdlc_device(struct net_device *dev)
 	rtnl_unlock();
 }
 
-
-
 int attach_hdlc_protocol(struct net_device *dev, struct hdlc_proto *proto,
 			 size_t size)
 {
@@ -297,7 +284,6 @@ int attach_hdlc_protocol(struct net_device *dev, struct hdlc_proto *proto,
 	return 0;
 }
 
-
 int detach_hdlc_protocol(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -323,7 +309,6 @@ int detach_hdlc_protocol(struct net_device *dev)
 	return 0;
 }
 
-
 void register_hdlc_protocol(struct hdlc_proto *proto)
 {
 	rtnl_lock();
@@ -332,7 +317,6 @@ void register_hdlc_protocol(struct hdlc_proto *proto)
 	rtnl_unlock();
 }
 
-
 void unregister_hdlc_protocol(struct hdlc_proto *proto)
 {
 	struct hdlc_proto **p;
@@ -347,8 +331,6 @@ void unregister_hdlc_protocol(struct hdlc_proto *proto)
 	rtnl_unlock();
 }
 
-
-
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("HDLC support module");
 MODULE_LICENSE("GPL v2");
@@ -369,12 +351,10 @@ static struct packet_type hdlc_packet_type __read_mostly = {
 	.func = hdlc_rcv,
 };
 
-
 static struct notifier_block hdlc_notifier = {
 	.notifier_call = hdlc_device_event,
 };
 
-
 static int __init hdlc_module_init(void)
 {
 	int result;
@@ -386,14 +366,11 @@ static int __init hdlc_module_init(void)
 	return 0;
 }
 
-
-
 static void __exit hdlc_module_exit(void)
 {
 	dev_remove_pack(&hdlc_packet_type);
 	unregister_netdevice_notifier(&hdlc_notifier);
 }
 
-
 module_init(hdlc_module_init);
 module_exit(hdlc_module_exit);
-- 
2.8.1

