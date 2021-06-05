Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820F139C679
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhFEHF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:05:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4481 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhFEHFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:05:25 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxrBS5RMzzYp18;
        Sat,  5 Jun 2021 15:00:48 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/8] net: hd64570: add blank line after declarations
Date:   Sat, 5 Jun 2021 15:00:23 +0800
Message-ID: <1622876429-47278-3-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index e0266c6..cca6101 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -345,6 +345,7 @@ static inline void sca_tx_intr(port_t *port)
 
 		u32 desc_off = desc_offset(port, port->txlast, 1);
 		u32 cda = sca_inw(dmac + CDAL, card);
+
 		if ((cda >= desc_off) && (cda < desc_off + sizeof(pkt_desc)))
 			break;	/* Transmitter is/will_be sending this frame */
 
@@ -371,6 +372,7 @@ static irqreturn_t sca_intr(int irq, void* dev_id)
 		handled = 1;
 		for (i = 0; i < 2; i++) {
 			port_t *port = get_port(card, i);
+
 			if (port) {
 				if (stat & SCA_INTR_MSCI(i))
 					sca_msci_intr(port);
-- 
2.8.1

