Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571DA3AD86E
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 09:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhFSHeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 03:34:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5045 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFSHeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 03:34:04 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G6S5z2ngbzXhSq;
        Sat, 19 Jun 2021 15:26:47 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 19 Jun 2021 15:31:52 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/3] net: c101: replace comparison to NULL with "!card"
Date:   Sat, 19 Jun 2021 15:28:37 +0800
Message-ID: <1624087718-26595-3-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624087718-26595-1-git-send-email-lipeng321@huawei.com>
References: <1624087718-26595-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the chackpatch.pl, comparison to NULL could
be written "!card".

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/c101.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index 94b852f..f33192e 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -307,7 +307,7 @@ static int __init c101_run(unsigned long irq, unsigned long winbase)
 	}
 
 	card = kzalloc(sizeof(card_t), GFP_KERNEL);
-	if (card == NULL)
+	if (!card)
 		return -ENOBUFS;
 
 	card->dev = alloc_hdlcdev(card);
@@ -381,7 +381,7 @@ static int __init c101_run(unsigned long irq, unsigned long winbase)
 
 static int __init c101_init(void)
 {
-	if (hw == NULL) {
+	if (!hw) {
 #ifdef MODULE
 		pr_info("no card initialized\n");
 #endif
-- 
2.8.1

