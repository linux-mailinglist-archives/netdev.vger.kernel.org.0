Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7D6903A5
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 16:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfHPOHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 10:07:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50388 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727286AbfHPOHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 10:07:09 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 53D6156311E576FF5A5F;
        Fri, 16 Aug 2019 22:06:09 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 16 Aug 2019
 22:06:00 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtlwifi: remove unused variables 'RTL8712_SDIO_EFUSE_TABLE' and 'MAX_PGPKT_SIZE'
Date:   Fri, 16 Aug 2019 22:05:13 +0800
Message-ID: <20190816140513.72572-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/realtek/rtlwifi/efuse.c:16:31:
 warning: RTL8712_SDIO_EFUSE_TABLE defined but not used [-Wunused-const-variable=]
drivers/net/wireless/realtek/rtlwifi/efuse.c:9:17:
 warning: MAX_PGPKT_SIZE defined but not used [-Wunused-const-variable=]

They are never used, so can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index ea4fc53..2646672 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -6,29 +6,12 @@
 #include "pci.h"
 #include <linux/export.h>
 
-static const u8 MAX_PGPKT_SIZE = 9;
 static const u8 PGPKT_DATA_SIZE = 8;
 static const int EFUSE_MAX_SIZE = 512;
 
 #define START_ADDRESS		0x1000
 #define REG_MCUFWDL		0x0080
 
-static const struct efuse_map RTL8712_SDIO_EFUSE_TABLE[] = {
-	{0, 0, 0, 2},
-	{0, 1, 0, 2},
-	{0, 2, 0, 2},
-	{1, 0, 0, 1},
-	{1, 0, 1, 1},
-	{1, 1, 0, 1},
-	{1, 1, 1, 3},
-	{1, 3, 0, 17},
-	{3, 3, 1, 48},
-	{10, 0, 0, 6},
-	{10, 3, 0, 1},
-	{10, 3, 1, 1},
-	{11, 0, 0, 28}
-};
-
 static const struct rtl_efuse_ops efuse_ops = {
 	.efuse_onebyte_read = efuse_one_byte_read,
 	.efuse_logical_map_read = efuse_shadow_read,
-- 
2.7.4


