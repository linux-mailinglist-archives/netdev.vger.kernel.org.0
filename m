Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA0D3AD945
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 12:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhFSKCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 06:02:00 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5404 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhFSKB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 06:01:56 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G6WQl5hJxz71TG;
        Sat, 19 Jun 2021 17:56:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:43 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/8] net: at91_can: remove redundant blank lines
Date:   Sat, 19 Jun 2021 17:56:22 +0800
Message-ID: <1624096589-13452-2-git-send-email-huangguangbin2@huawei.com>
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

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/can/at91_can.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 04d0bb3ffe89..a2da76796b57 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -935,7 +935,6 @@ static void at91_irq_err_state(struct net_device *dev,
 		break;
 	}
 
-
 	/* process state changes depending on the new state */
 	switch (new_state) {
 	case CAN_STATE_ERROR_ACTIVE:
@@ -1004,7 +1003,6 @@ static int at91_get_state_by_bec(const struct net_device *dev,
 	return 0;
 }
 
-
 static void at91_irq_err(struct net_device *dev)
 {
 	struct at91_priv *priv = netdev_priv(dev);
-- 
2.8.1

