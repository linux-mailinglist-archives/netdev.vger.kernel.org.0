Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A61D139209
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgAMNT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:19:56 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:52904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbgAMNT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 08:19:56 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7B511A564A5BD302656B;
        Mon, 13 Jan 2020 21:19:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 13 Jan 2020 21:19:43 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH] amd-xgbe: remove unnecessary conversion to bool
Date:   Mon, 13 Jan 2020 21:15:16 +0800
Message-ID: <20200113131516.142221-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion to bool is not needed, remove it.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 128cd64..46c3c1c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1227,7 +1227,7 @@ static bool xgbe_phy_sfp_verify_eeprom(u8 cc_in, u8 *buf, unsigned int len)
 	for (cc = 0; len; buf++, len--)
 		cc += *buf;
 
-	return (cc == cc_in) ? true : false;
+	return cc == cc_in;
 }
 
 static int xgbe_phy_sfp_read_eeprom(struct xgbe_prv_data *pdata)
-- 
2.7.4

