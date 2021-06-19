Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84853AD93A
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 11:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhFSKCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 06:02:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5049 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhFSKB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 06:01:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G6WNb4SRTzXh8y;
        Sat, 19 Jun 2021 17:54:39 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [PATCH net-next 6/8] net: at91_can: add braces {} to all arms of the statement
Date:   Sat, 19 Jun 2021 17:56:27 +0800
Message-ID: <1624096589-13452-7-git-send-email-huangguangbin2@huawei.com>
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

Braces {} should be used on all arms of this statement.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/can/at91_can.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 394fc72d39ac..5d984a448de4 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -585,9 +585,9 @@ static void at91_read_mb(struct net_device *dev, unsigned int mb,
 	reg_msr = at91_read(priv, AT91_MSR(mb));
 	cf->len = can_cc_dlc2len((reg_msr >> 16) & 0xf);
 
-	if (reg_msr & AT91_MSR_MRTR)
+	if (reg_msr & AT91_MSR_MRTR) {
 		cf->can_id |= CAN_RTR_FLAG;
-	else {
+	} else {
 		*(u32 *)(cf->data + 0) = at91_read(priv, AT91_MDL(mb));
 		*(u32 *)(cf->data + 4) = at91_read(priv, AT91_MDH(mb));
 	}
@@ -1020,15 +1020,15 @@ static void at91_irq_err(struct net_device *dev)
 		reg_sr = at91_read(priv, AT91_SR);
 
 		/* we need to look at the unmasked reg_sr */
-		if (unlikely(reg_sr & AT91_IRQ_BOFF))
+		if (unlikely(reg_sr & AT91_IRQ_BOFF)) {
 			new_state = CAN_STATE_BUS_OFF;
-		else if (unlikely(reg_sr & AT91_IRQ_ERRP))
+		} else if (unlikely(reg_sr & AT91_IRQ_ERRP)) {
 			new_state = CAN_STATE_ERROR_PASSIVE;
-		else if (unlikely(reg_sr & AT91_IRQ_WARN))
+		} else if (unlikely(reg_sr & AT91_IRQ_WARN)) {
 			new_state = CAN_STATE_ERROR_WARNING;
-		else if (likely(reg_sr & AT91_IRQ_ERRA))
+		} else if (likely(reg_sr & AT91_IRQ_ERRA)) {
 			new_state = CAN_STATE_ERROR_ACTIVE;
-		else {
+		} else {
 			netdev_err(dev, "BUG! hardware in undefined state\n");
 			return;
 		}
-- 
2.8.1

