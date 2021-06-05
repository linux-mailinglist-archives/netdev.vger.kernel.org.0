Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A441A39C681
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFEHH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:07:58 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4316 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEHH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:07:57 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FxrC43HqZz1BG7l;
        Sat,  5 Jun 2021 15:01:20 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/8] net: hd64570: fix the comments style issue
Date:   Sat, 5 Jun 2021 15:00:27 +0800
Message-ID: <1622876429-47278-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
References: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
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

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index 0297fbe..c6605ea 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -507,9 +507,9 @@ static void sca_open(struct net_device *dev)
 	sca_out(0x14, msci + TRC1, card); /* +1=TXRDY/DMA deactiv condition */
 
 /* We're using the following interrupts:
-   - TXINT (DMAC completed all transmisions, underrun or DCD change)
-   - all DMA interrupts
-*/
+ * - TXINT (DMAC completed all transmisions, underrun or DCD change)
+ * - all DMA interrupts
+ */
 	sca_set_carrier(port);
 
 	/* MSCI TX INT and RX INT A IRQ enable */
-- 
2.8.1

