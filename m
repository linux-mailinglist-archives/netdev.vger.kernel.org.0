Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F7F390392
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhEYOMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:12:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5703 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbhEYOMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:12:32 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FqGBc1qJrz1BRFT;
        Tue, 25 May 2021 22:08:08 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:59 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/6] net: wan: add spaces required around that ':' and '+'
Date:   Tue, 25 May 2021 22:07:58 +0800
Message-ID: <1621951678-23466-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
References: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
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

This patch adds spaces required around that ':' and '+'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/n2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index 76ef808c2769..bdb6dc2409bc 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -195,7 +195,8 @@ static int n2_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
 	int io = port->card->io;
-	u8 mcr = inb(io + N2_MCR) | (port->phy_node ? TX422_PORT1:TX422_PORT0);
+	u8 mcr = inb(io + N2_MCR) |
+		(port->phy_node ? TX422_PORT1 : TX422_PORT0);
 	int result;
 
 	result = hdlc_open(dev);
@@ -216,7 +217,8 @@ static int n2_close(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
 	int io = port->card->io;
-	u8 mcr = inb(io+N2_MCR) | (port->phy_node ? TX422_PORT1 : TX422_PORT0);
+	u8 mcr = inb(io + N2_MCR) |
+		(port->phy_node ? TX422_PORT1 : TX422_PORT0);
 
 	sca_close(dev);
 	mcr |= port->phy_node ? DTR_PORT1 : DTR_PORT0; /* set DTR OFF */
-- 
2.8.1

