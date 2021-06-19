Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0F53AD94A
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 12:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhFSKCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 06:02:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5054 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbhFSKCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 06:02:01 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G6WNg4bBSzXhCC;
        Sat, 19 Jun 2021 17:54:43 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 7/8] net: at91_can: remove redundant space
Date:   Sat, 19 Jun 2021 17:56:28 +0800
Message-ID: <1624096589-13452-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
References: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

According to the chackpatch.pl, no space before tabs.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/can/at91_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 5d984a448de4..0e6ed59a763d 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -163,7 +163,7 @@ static const struct can_bittiming_const at91_bittiming_const = {
 	.tseg2_min	= 2,
 	.tseg2_max	= 8,
 	.sjw_max	= 4,
-	.brp_min 	= 2,
+	.brp_min	= 2,
 	.brp_max	= 128,
 	.brp_inc	= 1,
 };
-- 
2.8.1

