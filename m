Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931D44C1B29
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbiBWSyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244024AbiBWSyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:54:45 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC6B3ED34
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 10:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645642457; x=1677178457;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tVAU65wPDg40Wrg+csEw0/9/IGBkEOCwzFGOhUlzgUc=;
  b=SgHL0GJ5Z6Y5+OhGUi7df1Rl8GxFnjoLSlE0+G1go0ArB28RnSMH6gsy
   C110GfWOhMXrMvhAcqoJW0+5vD0tD7Zh1cdZF9ARqYZfktLsHUbkGoAn7
   QSFGmcOx+/FtJuMdyNBuomwZB8SrtAzRgy4PJko7qu3fibXBqR/T61HjL
   tv10pd39vgNr5ebI0dS5Xt7hA4SMTZeBk6qFb8L3K4r5xNq3KfQLlN0op
   D89osmniDqDhY6HnN7X8xv9djG+2TMNbnepgdSE/Xc/PMSbkzkS88/pWb
   jPUK7ovSev9C+SuWPbpb7kD0Y538Sf3FqjJNkYciFjTOv+cflz/sQEnfa
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="338492243"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="338492243"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 10:54:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="508557517"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 23 Feb 2022 10:54:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next 1/2] ixgbevf: clean up some inconsistent indenting
Date:   Wed, 23 Feb 2022 10:54:23 -0800
Message-Id: <20220223185424.2129067-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223185424.2129067-1-anthony.l.nguyen@intel.com>
References: <20220223185424.2129067-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

Eliminate the follow smatch warning:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:2756
ixgbevf_alloc_q_vector() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 17fbc450da61..84222ec2393c 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2753,7 +2753,7 @@ static int ixgbevf_alloc_q_vector(struct ixgbevf_adapter *adapter, int v_idx,
 		ring->reg_idx = reg_idx;
 
 		/* assign ring to adapter */
-		 adapter->tx_ring[txr_idx] = ring;
+		adapter->tx_ring[txr_idx] = ring;
 
 		/* update count and index */
 		txr_count--;
-- 
2.31.1

