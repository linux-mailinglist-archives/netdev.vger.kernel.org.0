Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B538274784
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 08:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfGYGzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 02:55:37 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54416 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfGYGzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 02:55:37 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4EA1DBBFDCE9F2066BED;
        Thu, 25 Jul 2019 14:55:33 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 25 Jul 2019 14:55:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] can: ti_hecc: remove set but not used variable 'mbx_mask'
Date:   Thu, 25 Jul 2019 07:00:44 +0000
Message-ID: <20190725070044.2692-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/can/ti_hecc.c: In function 'ti_hecc_mailbox_read':
drivers/net/can/ti_hecc.c:533:12: warning:
 variable 'mbx_mask' set but not used [-Wunused-but-set-variable]

It is never used so can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/can/ti_hecc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index b62f75fa03f0..e63e2f86c289 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -530,9 +530,8 @@ static unsigned int ti_hecc_mailbox_read(struct can_rx_offload *offload,
 					 u32 *timestamp, unsigned int mbxno)
 {
 	struct ti_hecc_priv *priv = rx_offload_to_priv(offload);
-	u32 data, mbx_mask;
+	u32 data;
 
-	mbx_mask = BIT(mbxno);
 	data = hecc_read_mbx(priv, mbxno, HECC_CANMID);
 	if (data & HECC_CANMID_IDE)
 		cf->can_id = (data & CAN_EFF_MASK) | CAN_EFF_FLAG;



