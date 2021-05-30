Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E722B394FC4
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhE3G3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:20 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2542 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhE3G3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ft7gr1vsdzYrwW;
        Sun, 30 May 2021 14:24:56 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:37 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 02/10] net: sealevel: add blank line after declarations
Date:   Sun, 30 May 2021 14:24:26 +0800
Message-ID: <1622355874-18933-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
References: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/sealevel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 62cc59892d1e..829e9bc01a49 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -174,6 +174,7 @@ static const struct net_device_ops sealevel_ops = {
 static int slvl_setup(struct slvl_device *sv, int iobase, int irq)
 {
 	struct net_device *dev = alloc_hdlcdev(sv);
+
 	if (!dev)
 		return -1;
 
@@ -334,6 +335,7 @@ static void __exit slvl_shutdown(struct slvl_board *b)
 
 	for (u = 0; u < 2; u++) {
 		struct net_device *d = b->dev[u].chan->netdevice;
+
 		unregister_hdlc_device(d);
 		free_netdev(d);
 	}
-- 
2.8.1

