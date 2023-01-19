Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1095767451B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjASVnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjASVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224219FDDD
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163689; x=1705699689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Efv13EAK9TT6VWdq1+Uq6vxNW7204wGkz6zFb772qtU=;
  b=a1aqbCZMcJucxu8LrT5rlHMYUMlpGFi7tdpk09r9+ELLvXoOdKeITvhI
   hrEkt2TXs+BKMMTv/CR9GNP8q6023LtVeHOsnTZkly1hwj/wsn9QX0wwI
   VuiSOP4l2xjfnJyhHhoD/WFeUIE/MsUJcEVhvEVUnbT/agr3/3Z2TWM0+
   waucKZazV81VptfwzCVOz85KN6LAyDNb0KHZw6VRqXP2K7zNq5KMG3F9a
   Gq3jwal2+kENjCD0vQJLlIesX5ZuBXGzWhx4riZTvnPV8KgAjUYyrLE7t
   /23dgcbKSNYW6KsTpDx1RguXCNtSU2N1u13+9y43FN7lX5DW+0enNsy6G
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120670"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120670"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589913"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589913"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 15/15] ice: Remove excess space
Date:   Thu, 19 Jan 2023 13:27:42 -0800
Message-Id: <20230119212742.2106833-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smatch reports inconsistent indenting due to an extra space; remove it to
resolve the issue.

smatch warnings:
drivers/net/ethernet/intel/ice/ice_lib.c:1673 ice_vsi_alloc_ring_stats() warn: inconsistent indenting

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 94aa834cd9a6..8316037b5548 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1670,7 +1670,7 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
 			if (!ring_stats)
 				goto err_out;
 
-			 WRITE_ONCE(rx_ring_stats[i], ring_stats);
+			WRITE_ONCE(rx_ring_stats[i], ring_stats);
 		}
 
 		ring->ring_stats = ring_stats;
-- 
2.38.1

