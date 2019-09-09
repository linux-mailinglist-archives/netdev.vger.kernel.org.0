Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE118AE137
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbfIIWsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:48:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:40891 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbfIIWsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 18:48:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 15:48:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,487,1559545200"; 
   d="scan'208";a="175121712"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 09 Sep 2019 15:48:07 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Hulk Robot <hulkci@huawei.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 01/15] iavf: remove unused debug function iavf_debug_d
Date:   Mon,  9 Sep 2019 15:47:48 -0700
Message-Id: <20190909224802.29595-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
References: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

There is no caller of function iavf_debug_d() in tree since
commit 75051ce4c5d8 ("iavf: Fix up debug print macro"),
so it can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 22 ---------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9d2b50964a08..554aa619ff02 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -142,28 +142,6 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 	return 0;
 }
 
-/**
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
 /**
  * iavf_schedule_reset - Set the flags and schedule a reset event
  * @adapter: board private structure
-- 
2.21.0

