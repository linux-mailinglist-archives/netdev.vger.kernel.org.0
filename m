Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3549D350A8C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhCaXHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:62995 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhCaXH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:28 -0400
IronPort-SDR: dvfG8+fHVk9Ib7cgXBjtdto9piAN/vFZD8L0v1SnjXGUudq9oykY3ma97EHWsYSCiKo+hUaK4V
 p/I8Wk3YISTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587987"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587987"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:25 -0700
IronPort-SDR: bOky83Rar87BKzwst958UVrQNRncuv80pHVTQWfak97m120aLfE2s8As5ORtNBn2Lrj22RNtNj
 GEQimf/U5wig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680149"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 14/15] ice: cleanup style issues
Date:   Wed, 31 Mar 2021 16:08:57 -0700
Message-Id: <20210331230858.782492-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

A few style issues reported by checkpatch have snuck into the code; resolve
the style issues.

COMPLEX_MACRO: Macros with complex values should be enclosed in parentheses

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.h  | 4 ++--
 drivers/net/ethernet/intel/ice/ice_flex_type.h | 4 ++--
 drivers/net/ethernet/intel/ice/ice_flow.c      | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index faaa08e8171b..7d0905f25ddc 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -14,8 +14,8 @@
 	(&(((struct ice_aq_desc *)((R).desc_buf.va))[i]))
 
 #define ICE_CTL_Q_DESC_UNUSED(R) \
-	(u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->count) + \
-	      (R)->next_to_clean - (R)->next_to_use - 1)
+	((u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->count) + \
+	       (R)->next_to_clean - (R)->next_to_use - 1))
 
 /* Defines that help manage the driver vs FW API checks.
  * Take a look at ice_aq_ver_check in ice_controlq.c for actual usage.
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 9806183920de..7d8b517a63c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -497,8 +497,8 @@ struct ice_xlt1 {
 #define ICE_PF_NUM_S	13
 #define ICE_PF_NUM_M	(0x07 << ICE_PF_NUM_S)
 #define ICE_VSIG_VALUE(vsig, pf_id) \
-	(u16)((((u16)(vsig)) & ICE_VSIG_IDX_M) | \
-	      (((u16)(pf_id) << ICE_PF_NUM_S) & ICE_PF_NUM_M))
+	((u16)((((u16)(vsig)) & ICE_VSIG_IDX_M) | \
+	       (((u16)(pf_id) << ICE_PF_NUM_S) & ICE_PF_NUM_M)))
 #define ICE_DEFAULT_VSIG	0
 
 /* XLT2 Table */
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 571245799646..4d59eb96383b 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -2008,9 +2008,9 @@ ice_add_rss_list(struct ice_hw *hw, u16 vsi_handle, struct ice_flow_prof *prof)
  * [63] - Encapsulation flag, 0 if non-tunneled, 1 if tunneled
  */
 #define ICE_FLOW_GEN_PROFID(hash, hdr, segs_cnt) \
-	(u64)(((u64)(hash) & ICE_FLOW_PROF_HASH_M) | \
-	      (((u64)(hdr) << ICE_FLOW_PROF_HDR_S) & ICE_FLOW_PROF_HDR_M) | \
-	      ((u8)((segs_cnt) - 1) ? ICE_FLOW_PROF_ENCAP_M : 0))
+	((u64)(((u64)(hash) & ICE_FLOW_PROF_HASH_M) | \
+	       (((u64)(hdr) << ICE_FLOW_PROF_HDR_S) & ICE_FLOW_PROF_HDR_M) | \
+	       ((u8)((segs_cnt) - 1) ? ICE_FLOW_PROF_ENCAP_M : 0)))
 
 /**
  * ice_add_rss_cfg_sync - add an RSS configuration
-- 
2.26.2

