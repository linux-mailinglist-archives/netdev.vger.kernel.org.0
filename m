Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2184674512
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjASVmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjASVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506AC241C4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163687; x=1705699687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VGmFJIUC+q+cAB54ZsXIPVmUwskiGl/OPOafIka5PZY=;
  b=FqNQzvfwv97xRsdacwAn4uUgVsCoXDXDPTo47bb3RSZQRCo6BkXQkJvH
   wjZNH6+osrNiU97/uWwONnyjUf36UaZUwAwuo3Pid2xDLNMwLBEeW99il
   Z8VGjMU+7zAFmnfSxDFldrKjAb03ms7QBvN9ptm2w+VnD26rTPpyE/gc2
   lmmvmwya/vvrtkXbja2pOU4YhNEQPwk0SmKXEBaLAXRKk4uEw+S0HwBZP
   xId02nsKnzMEHYyNrziig6TMnwZBPHh43Hz5ARuUwcXvW0KLAjvXKl+UZ
   fPNJSsYUZdroFNV/3ibgR5RfA+DT4JotP++i0FWuTfpnIaNl5ouzVe2l8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120636"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120636"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589892"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589892"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 09/15] ice: Remove cppcheck suppressions
Date:   Thu, 19 Jan 2023 13:27:36 -0800
Message-Id: <20230119212742.2106833-10-anthony.l.nguyen@intel.com>
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

The use of suppressions for cppcheck in the kernel does not look to be
standard as the ice driver is the only one doing it. Remove the
comments/suppressions.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 3 ---
 drivers/net/ethernet/intel/ice/ice_nvm.c       | 1 -
 drivers/net/ethernet/intel/ice/ice_sched.c     | 1 -
 drivers/net/ethernet/intel/ice/ice_txrx.c      | 3 ---
 4 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 4b3bb19e1d06..487d56acec2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -415,7 +415,6 @@ ice_boost_tcam_handler(u32 sect_type, void *section, u32 index, u32 *offset)
 	if (sect_type != ICE_SID_RXPARSER_BOOST_TCAM)
 		return NULL;
 
-	/* cppcheck-suppress nullPointer */
 	if (index > ICE_MAX_BST_TCAMS_IN_BUF)
 		return NULL;
 
@@ -486,7 +485,6 @@ ice_label_enum_handler(u32 __always_unused sect_type, void *section, u32 index,
 	if (!section)
 		return NULL;
 
-	/* cppcheck-suppress nullPointer */
 	if (index > ICE_MAX_LABELS_IN_BUF)
 		return NULL;
 
@@ -2757,7 +2755,6 @@ ice_match_prop_lst(struct list_head *list1, struct list_head *list2)
 		count++;
 	list_for_each_entry(tmp2, list2, list)
 		chk_count++;
-	/* cppcheck-suppress knownConditionTrueFalse */
 	if (!count || count != chk_count)
 		return false;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index c262dc886e6a..f6f52a248066 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -662,7 +662,6 @@ ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
 
 		/* Verify that the simple checksum is zero */
 		for (i = 0; i < sizeof(*tmp); i++)
-			/* cppcheck-suppress objectIndex */
 			sum += ((u8 *)tmp)[i];
 
 		if (sum) {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 6d08b397df2a..70568f8af72a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1063,7 +1063,6 @@ ice_sched_add_nodes_to_layer(struct ice_port_info *pi,
 	*num_nodes_added = 0;
 	while (*num_nodes_added < num_nodes) {
 		u16 max_child_nodes, num_added = 0;
-		/* cppcheck-suppress unusedVariable */
 		u32 temp;
 
 		status = ice_sched_add_nodes_to_hw_layer(pi, tc_node, parent,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 086f0b3ab68d..ccf09c957a1c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1996,7 +1996,6 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 	if (err < 0)
 		return err;
 
-	/* cppcheck-suppress unreadVariable */
 	protocol = vlan_get_protocol(skb);
 
 	if (eth_p_mpls(protocol))
@@ -2033,8 +2032,6 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		}
 
 		/* reset pointers to inner headers */
-
-		/* cppcheck-suppress unreadVariable */
 		ip.hdr = skb_inner_network_header(skb);
 		l4.hdr = skb_inner_transport_header(skb);
 
-- 
2.38.1

