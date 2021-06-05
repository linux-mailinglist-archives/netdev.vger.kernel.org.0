Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2039C684
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhFEHIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:08:01 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3438 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEHIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:08:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxrFC0zSHz6v5x;
        Sat,  5 Jun 2021 15:03:11 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [PATCH net-next 7/8] net: hd64570: remove redundant parentheses
Date:   Sat, 5 Jun 2021 15:00:28 +0800
Message-ID: <1622876429-47278-8-git-send-email-huangguangbin2@huawei.com>
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

Remove redundant parentheses around 'cda >= desc_off'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index c6605ea..8af647c 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -301,7 +301,7 @@ static inline void sca_rx_intr(port_t *port)
 		pkt_desc __iomem *desc;
 		u32 cda = sca_inw(dmac + CDAL, card);
 
-		if ((cda >= desc_off) && (cda < desc_off + sizeof(pkt_desc)))
+		if (cda >= desc_off && (cda < desc_off + sizeof(pkt_desc)))
 			break;	/* No frame received */
 
 		desc = desc_address(port, port->rxin, 0);
@@ -354,7 +354,7 @@ static inline void sca_tx_intr(port_t *port)
 		u32 desc_off = desc_offset(port, port->txlast, 1);
 		u32 cda = sca_inw(dmac + CDAL, card);
 
-		if ((cda >= desc_off) && (cda < desc_off + sizeof(pkt_desc)))
+		if (cda >= desc_off && (cda < desc_off + sizeof(pkt_desc)))
 			break;	/* Transmitter is/will_be sending this frame */
 
 		desc = desc_address(port, port->txlast, 1);
-- 
2.8.1

