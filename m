Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF723A818D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhFON7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:59:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4921 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhFON7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:59:42 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G48v70qdPz702S;
        Tue, 15 Jun 2021 21:54:27 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:57:35 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/6] net: pci200syn: add necessary () to macro argument
Date:   Tue, 15 Jun 2021 21:54:22 +0800
Message-ID: <1623765263-36775-6-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
References: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Macro argument 'card' may be better as '(card)' to
avoid precedence issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/pci200syn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index ac4a599..abca13b 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -86,7 +86,7 @@ typedef struct card_s {
 	port_t ports[2];
 } card_t;
 
-#define get_port(card, port)	     (&card->ports[port])
+#define get_port(card, port)	     (&(card)->ports[port])
 #define sca_flush(card)		     (sca_in(IER0, card))
 
 static inline void new_memcpy_toio(char __iomem *dest, char *src, int length)
-- 
2.8.1

