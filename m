Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09FC61A2BF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiKDUyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiKDUy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:54:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A0CD109
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667595267; x=1699131267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AY+r0jZFS5S59FpZkNrvBQCsrzmG8iIRyzOdUtaJ5A8=;
  b=hekaBTntsSurmubL8F3t8pCWrsutEwo6r5e/zjv2r0cfIePtforeGXqb
   73LL4l156cqM9iczlY1erawT/YdFNm163Y7tfsk64kOubcAfuCx9ymiiz
   XJA8ZciJi3yKpk8/9kkAp30gz+WzJ0//m93KjsfHfQQdbCz112vS8brHO
   BY1fMiiaULZYdEc7ksvOr/snG1Lw5NvlX0ymQMtN9vZrBAoZgV6RMiwIO
   iKMSLE3sJ55nbaO0Nl/RQesTxCgOahjESuYxjkbUnaTmBKA1Jmi5dCwbQ
   y5gmUYheOqStFdIm4vIG+WnU+A19OU4dpXVnIF9QrSEhqVV2Gl0DDKVYu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372177364"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="372177364"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 13:54:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="637716210"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="637716210"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2022 13:54:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Yang Li <yang.lee@linux.alibaba.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next 3/6] ixgbe: Remove unneeded semicolon
Date:   Fri,  4 Nov 2022 13:54:11 -0700
Message-Id: <20221104205414.2354973-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

./drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c:1305:2-3: Unneeded semicolon

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2688
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index fd3f77a9e28d..0310af851086 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -1302,7 +1302,7 @@ static void ixgbe_ptp_init_systime(struct ixgbe_adapter *adapter)
 	default:
 		/* Other devices aren't supported */
 		return;
-	};
+	}
 
 	IXGBE_WRITE_FLUSH(hw);
 }
-- 
2.35.1

