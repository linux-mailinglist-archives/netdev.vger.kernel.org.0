Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC947286653
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgJGRzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:55:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:18440 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgJGRy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:54:59 -0400
IronPort-SDR: HzZx+cU5ZEiVpWGvfCDbTnFvjW1GkCRS1adW38QJF37gAzbBfPJVXPzgHU/8zKIq0+f1EeopDy
 31Oe9C6zSeqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="144957651"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="144957651"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
IronPort-SDR: zhtdCeaVTy5LWKW58Qxj1w9UmnPnkpd5bus6z/0W/1h0Lz6dlAK0CiO0ZGT1gra79rOSWBWqfU
 I+6qQvBaeU3A==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935777"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 2/8] ice: remove repeated words
Date:   Wed,  7 Oct 2020 10:54:41 -0700
Message-Id: <20201007175447.647867-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

A new test in checkpatch detects repeated words; cleanup all pre-existing
occurrences of those now.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_flow.c        | 4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c        | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index ac448d223e9a..9095b4d274ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -4876,7 +4876,7 @@ ice_rem_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
 
 			if (last_profile) {
 				/* If there are no profiles left for this VSIG,
-				 * then simply remove the the VSIG.
+				 * then simply remove the VSIG.
 				 */
 				status = ice_rem_vsig(hw, blk, vsig, &chg);
 				if (status)
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index fe677621dd51..45fa3d9e3af2 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -385,7 +385,7 @@ ice_flow_xtract_fld(struct ice_hw *hw, struct ice_flow_prof_params *params,
  * ice_flow_xtract_raws - Create extract sequence entries for raw bytes
  * @hw: pointer to the HW struct
  * @params: information about the flow to be processed
- * @seg: index of packet segment whose raw fields are to be be extracted
+ * @seg: index of packet segment whose raw fields are to be extracted
  */
 static enum ice_status
 ice_flow_xtract_raws(struct ice_hw *hw, struct ice_flow_prof_params *params,
@@ -999,7 +999,7 @@ enum ice_status ice_flow_rem_entry(struct ice_hw *hw, enum ice_block blk,
  *
  * This helper function stores information of a field being matched, including
  * the type of the field and the locations of the value to match, the mask, and
- * and the upper-bound value in the start of the input buffer for a flow entry.
+ * the upper-bound value in the start of the input buffer for a flow entry.
  * This function should only be used for fixed-size data structures.
  *
  * This function also opportunistically determines the protocol headers to be
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f34444cd90f8..a3e032f844a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2416,7 +2416,7 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 	int i, v_idx;
 
 	/* q_vectors are freed in reset path so there's no point in detaching
-	 * rings; in case of rebuild being triggered not from reset reset bits
+	 * rings; in case of rebuild being triggered not from reset bits
 	 * in pf->state won't be set, so additionally check first q_vector
 	 * against NULL
 	 */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 71497776ac62..ec7f6c64132e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -871,7 +871,7 @@ static int ice_get_max_valid_res_idx(struct ice_res_tracker *res)
  * If there are not enough resources available, return an error. This should
  * always be caught by ice_set_per_vf_res().
  *
- * Return 0 on success, and -EINVAL when there are not enough MSIX vectors in
+ * Return 0 on success, and -EINVAL when there are not enough MSIX vectors
  * in the PF's space available for SR-IOV.
  */
 static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
-- 
2.26.2

