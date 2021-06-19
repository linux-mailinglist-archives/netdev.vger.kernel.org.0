Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9CF3AD86F
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 09:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhFSHeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 03:34:07 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7491 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbhFSHeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 03:34:04 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G6S8Q1rVQzZjwX;
        Sat, 19 Jun 2021 15:28:54 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 19 Jun 2021 15:31:51 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/3] net: c101: add blank line after declarations
Date:   Sat, 19 Jun 2021 15:28:36 +0800
Message-ID: <1624087718-26595-2-git-send-email-lipeng321@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/c101.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index 7e431e5..94b852f 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -416,6 +416,7 @@ static void __exit c101_cleanup(void)
 
 	while (card) {
 		card_t *ptr = card;
+
 		card = card->next_card;
 		unregister_hdlc_device(port_to_dev(ptr));
 		c101_destroy_card(ptr);
-- 
2.8.1

