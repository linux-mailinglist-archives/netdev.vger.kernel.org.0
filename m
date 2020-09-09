Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F29263128
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgIIQB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:01:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11761 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730723AbgIIQBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:01:16 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9899E644A066854496B7;
        Wed,  9 Sep 2020 21:59:16 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:59:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] wlcore: Remove unused macro WL1271_SUSPEND_SLEEP
Date:   Wed, 9 Sep 2020 21:59:05 +0800
Message-ID: <20200909135905.35728-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 45aa7f071b06 ("wlcore: Use generic runtime pm calls for wowlan elp configuration")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d2bbd5108f7e..6863fd552d5e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -30,7 +30,6 @@
 #include "sysfs.h"
 
 #define WL1271_BOOT_RETRIES 3
-#define WL1271_SUSPEND_SLEEP 100
 #define WL1271_WAKEUP_TIMEOUT 500
 
 static char *fwlog_param;
-- 
2.17.1


