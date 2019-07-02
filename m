Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A9A5C935
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfGBGUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:20:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44432 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfGBGUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 02:20:48 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D31A995C6CEF97FA6E31;
        Tue,  2 Jul 2019 14:20:45 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 2 Jul 2019
 14:20:38 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] iavf: remove unused debug function iavf_debug_d
Date:   Tue, 2 Jul 2019 14:20:21 +0800
Message-ID: <20190702062021.41524-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller of function iavf_debug_d() in tree since
commit 75051ce4c5d8 ("iavf: Fix up debug print macro"),
so it can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 881561b..327dda8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -143,28 +143,6 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 }
 
 /**
- * iavf_debug_d - OS dependent version of debug printing
- * @hw:  pointer to the HW structure
- * @mask: debug level mask
- * @fmt_str: printf-type format description
- **/
-void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
-{
-	char buf[512];
-	va_list argptr;
-
-	if (!(mask & ((struct iavf_hw *)hw)->debug_mask))
-		return;
-
-	va_start(argptr, fmt_str);
-	vsnprintf(buf, sizeof(buf), fmt_str, argptr);
-	va_end(argptr);
-
-	/* the debug string is already formatted with a newline */
-	pr_info("%s", buf);
-}
-
-/**
  * iavf_schedule_reset - Set the flags and schedule a reset event
  * @adapter: board private structure
  **/
-- 
2.7.4


