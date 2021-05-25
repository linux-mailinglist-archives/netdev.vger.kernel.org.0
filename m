Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D730390399
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhEYONI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:13:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6708 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhEYOMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:12:33 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FqG9k4GgxzlYM8;
        Tue, 25 May 2021 22:07:22 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:58 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/6] net: wan: add blank line after declarations
Date:   Tue, 25 May 2021 22:07:54 +0800
Message-ID: <1621951678-23466-3-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/n2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index dd39789ebfa0..5ad8c5032900 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -143,6 +143,7 @@ static __inline__ u8 sca_get_page(card_t *card)
 static __inline__ void openwin(card_t *card, u8 page)
 {
 	u8 psr = inb(card->io + N2_PSR);
+
 	outb((psr & ~PSR_PAGEBITS) | page, card->io + N2_PSR);
 }
 
@@ -283,6 +284,7 @@ static void n2_destroy_card(card_t *card)
 	for (cnt = 0; cnt < 2; cnt++)
 		if (card->ports[cnt].card) {
 			struct net_device *dev = port_to_dev(&card->ports[cnt]);
+
 			unregister_hdlc_device(dev);
 		}
 
@@ -522,6 +524,7 @@ static void __exit n2_cleanup(void)
 
 	while (card) {
 		card_t *ptr = card;
+
 		card = card->next_card;
 		n2_destroy_card(ptr);
 	}
-- 
2.8.1

