Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42B739741B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhFAN2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:28:12 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3323 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhFAN2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:28:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvXqr3mpLz1BGlW;
        Tue,  1 Jun 2021 21:21:44 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:26:26 +0800
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
Subject: [PATCH net-next 2/7] net: hdlc: add blank line after declarations
Date:   Tue, 1 Jun 2021 21:23:17 +0800
Message-ID: <1622553802-19903-3-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 0883302..6199a70 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -77,6 +77,7 @@ netdev_tx_t hdlc_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static inline void hdlc_proto_start(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+
 	if (hdlc->proto->start)
 		hdlc->proto->start(dev);
 }
@@ -84,6 +85,7 @@ static inline void hdlc_proto_start(struct net_device *dev)
 static inline void hdlc_proto_stop(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+
 	if (hdlc->proto->stop)
 		hdlc->proto->stop(dev);
 }
@@ -150,6 +152,7 @@ int hdlc_open(struct net_device *dev)
 
 	if (hdlc->proto->open) {
 		int result = hdlc->proto->open(dev);
+
 		if (result)
 			return result;
 	}
@@ -245,6 +248,7 @@ static void hdlc_setup(struct net_device *dev)
 struct net_device *alloc_hdlcdev(void *priv)
 {
 	struct net_device *dev;
+
 	dev = alloc_netdev(sizeof(struct hdlc_device), "hdlc%d",
 			   NET_NAME_UNKNOWN, hdlc_setup);
 	if (dev)
-- 
2.8.1

