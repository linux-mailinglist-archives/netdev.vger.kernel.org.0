Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0757E5452C1
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344635AbiFIRQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245466AbiFIRQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:16:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B8FC50BC
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654794961; x=1686330961;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MnRpKOHLVwmJQ8YGnVz/s6jljKnGiCM+Umm5fBWZxiw=;
  b=WJTa5A311HICiuGJaHxEpHrrKwCLn8z5DbPI9wYndMnBQi43SwzTRqjV
   9wQUKmoZ2PIaC+kiicIGP7m8YyoUAJ5nuybCqBJWPJ/kmZY6PVs6nRy1+
   uMcAv8LKISLOjmQB/FS+bZ6dZpD7sTMlE8qT9ewnXw8iS7AkGX+gwuBMw
   KLOtZ+RKqsuv4/Z1ryWZpLAGQkFeXXqIHS6qFNmHgB+VvtC3Pp1hhoFZV
   rTDlHJi1rhtvSApPuLFaRXoU/UUdps/1ux6fPobdQrMAuHiK9BtOTm6PR
   RIKdt5FIrwR67D8twhMjt9GoAnoDdGSdGF+SLvOfq37A6Xv7GVYZzpWbq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="276124450"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="276124450"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 10:15:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="566487551"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2022 10:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Julia Lawall <Julia.Lawall@inria.fr>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH net-next 6/6] drivers/net/ethernet/intel: fix typos in comments
Date:   Thu,  9 Jun 2022 10:12:57 -0700
Message-Id: <20220609171257.2727150-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609171257.2727150-1-anthony.l.nguyen@intel.com>
References: <20220609171257.2727150-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>

Spelling mistakes (triple letters) in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c       | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index 30ca9ee1900b..f2fba6e1d0f7 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -1825,7 +1825,7 @@ static void fm10k_sm_mbx_process_error(struct fm10k_mbx_info *mbx)
 		fm10k_sm_mbx_connect_reset(mbx);
 		break;
 	case FM10K_STATE_CONNECT:
-		/* try connnecting at lower version */
+		/* try connecting at lower version */
 		if (mbx->remote) {
 			while (mbx->local > 1)
 				mbx->local--;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 454e01ae09b9..70961c0343e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2403,7 +2403,7 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
 				agg_id);
 			return;
 		}
-		/* aggregator node is created, store the neeeded info */
+		/* aggregator node is created, store the needed info */
 		agg_node->valid = true;
 		agg_node->agg_id = agg_id;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 7f11c0a8e7a9..07b982e473b2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -77,7 +77,7 @@ static int __ixgbe_enable_sriov(struct ixgbe_adapter *adapter,
 	IXGBE_WRITE_REG(hw, IXGBE_PFDTXGSWC, IXGBE_PFDTXGSWC_VT_LBEN);
 	adapter->bridge_mode = BRIDGE_MODE_VEB;
 
-	/* limit trafffic classes based on VFs enabled */
+	/* limit traffic classes based on VFs enabled */
 	if ((adapter->hw.mac.type == ixgbe_mac_82599EB) && (num_vfs < 16)) {
 		adapter->dcb_cfg.num_tcs.pg_tcs = MAX_TRAFFIC_CLASS;
 		adapter->dcb_cfg.num_tcs.pfc_tcs = MAX_TRAFFIC_CLASS;
-- 
2.35.1

