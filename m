Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42AD616F65
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiKBVKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiKBVK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:10:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF05DEE2
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667423425; x=1698959425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3IUKsieukj2qJJJBUTrBfPGPrBEvhjQ6CQASDRvji1Y=;
  b=d88zy+dV8X2o5uMPIEevCLVvPA9ivQSgtPv5r7qp9PSGolyW4tuacWf0
   M3qZb4J4oZ/EmgayW4VCIURNy/GeqiiCSQ/M5DT96kwQasxnPqwKvko4B
   on7Z8mY/uFcAPVT/xVQLLZlksVYGpU964KNipgZYWenT8fYSdsgFUhc4T
   yUF96oe+I9/AItWqfjuLxHgyzMvzPHmf4BIyNydP05MA14f0P0IIM7Tf+
   6g5NgitnI5PxG6F47C8PDwXVO96i8ZXv6DM0Mi7CTDaZsLiBTP0r/wgzM
   +0851zHkMMJ9sdWjQjEy4y3Apiqx3m+vF5oAjTj1yeJuCdN6vPiSslQ42
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311245992"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="311245992"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 14:10:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629103007"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629103007"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 02 Nov 2022 14:10:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     ye xingchen <ye.xingchen@zte.com.cn>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 6/7] iavf: Replace __FUNCTION__ with __func__
Date:   Wed,  2 Nov 2022 14:10:10 -0700
Message-Id: <20221102211011.2944983-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
References: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
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

From: ye xingchen <ye.xingchen@zte.com.cn>

__FUNCTION__ exists only for backwards compatibility reasons with old
gcc versions. Replace it with __func__.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3fc572341781..efa2692af577 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4820,7 +4820,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
 		iavf_close(netdev);
 
 	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
+		dev_warn(&adapter->pdev->dev, "%s: failed to acquire crit_lock\n", __func__);
 	/* Prevent the watchdog from running. */
 	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
-- 
2.35.1

