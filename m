Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DDB3878CF
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 14:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349165AbhERMeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 08:34:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4732 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349177AbhERMeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 08:34:11 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkwKt4kSRzqVB0;
        Tue, 18 May 2021 20:29:22 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 20:32:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 18 May 2021 20:32:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/5] net: wan: remove redundant space
Date:   Tue, 18 May 2021 20:29:53 +0800
Message-ID: <1621340994-20760-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
References: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
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

Space prohibited before that close parenthesis ')',
so removes the redundant space.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/c101.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index 5a04f18db32a..e2ca559e6553 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -84,7 +84,7 @@ static card_t **new_card = &first_card;
 /* EDA address register must be set in EDAL, EDAH order - 8 bit ISA bus */
 #define sca_outw(value, reg, card) do { \
 	writeb(value & 0xFF, (card)->win0base + C101_SCA + (reg)); \
-	writeb((value >> 8 ) & 0xFF, (card)->win0base + C101_SCA + (reg + 1));\
+	writeb((value >> 8) & 0xFF, (card)->win0base + C101_SCA + (reg + 1));\
 } while (0)
 
 #define port_to_card(port)	   (port)
-- 
2.8.1

