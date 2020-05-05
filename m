Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDE61C4F81
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgEEHqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:46:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgEEHqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:46:45 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AD96F2C046E99675C9A3;
        Tue,  5 May 2020 15:46:42 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:46:33 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <mark.einon@gmail.com>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: agere: use true,false for bool variable
Date:   Tue, 5 May 2020 15:45:56 +0800
Message-ID: <20200505074556.22331-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/agere/et131x.c:717:3-22: WARNING: Assignment of
0/1 to bool variable
drivers/net/ethernet/agere/et131x.c:721:1-20: WARNING: Assignment of
0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/agere/et131x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 1b19385ad8a9..865892c1f23f 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -714,11 +714,11 @@ static int et131x_init_eeprom(struct et131x_adapter *adapter)
 			 * gather additional information that normally would
 			 * come from the eeprom, like MAC Address
 			 */
-			adapter->has_eeprom = 0;
+			adapter->has_eeprom = false;
 			return -EIO;
 		}
 	}
-	adapter->has_eeprom = 1;
+	adapter->has_eeprom = true;
 
 	/* Read the EEPROM for information regarding LED behavior. Refer to
 	 * et131x_xcvr_init() for its use.
-- 
2.21.1

