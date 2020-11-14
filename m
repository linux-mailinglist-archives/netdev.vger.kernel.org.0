Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC6D2B2C6B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 10:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgKNJ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 04:26:53 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7539 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgKNJ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 04:26:52 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CY92P0hcCzhh4p;
        Sat, 14 Nov 2020 17:26:37 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sat, 14 Nov 2020 17:26:37 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] cxgb4: Remove unused variable ret
Date:   Sat, 14 Nov 2020 17:38:26 +0800
Message-ID: <1605346706-23782-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes below warning reported by coccicheck:

./drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3284:5-8: Unneeded variable: "ret". Return "0" on line 3301

Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 98d01a7..426d15e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3281,8 +3281,6 @@ int t4_get_scfg_version(struct adapter *adapter, u32 *vers)
  */
 int t4_get_version_info(struct adapter *adapter)
 {
-	int ret = 0;
-
 	#define FIRST_RET(__getvinfo) \
 	do { \
 		int __ret = __getvinfo; \
@@ -3298,7 +3296,7 @@ int t4_get_version_info(struct adapter *adapter)
 	FIRST_RET(t4_get_vpd_version(adapter, &adapter->params.vpd_vers));
 
 	#undef FIRST_RET
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.6.2

