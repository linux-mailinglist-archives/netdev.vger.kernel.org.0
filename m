Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B498434685B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhCWTBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:01:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:10824 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhCWTA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:26 -0400
IronPort-SDR: jqeGFjIrOTKWfHszVPRjViXKexwoNMPUXkjbW5P1ezt7qHrePyBbxFhovwN8XzqQ4axaH2GC5X
 H7ZFH7++DMPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545843"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545843"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:24 -0700
IronPort-SDR: CVe0/LVrJl1Dx57xkp0jBurouGWNcr55vcHjTZ/N7H6SppAoUGd5qvqAoH8v3CURl1bKCZlsc3
 yfldJpTYYYrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460637"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 01/10] ice: Fix prototype warnings
Date:   Tue, 23 Mar 2021 12:01:40 -0700
Message-Id: <20210323190149.3160859-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
References: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct reported warnings for "warning: expecting prototype for ...
Prototype was for ... instead"

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c      | 2 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c         | 2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c        | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c        | 4 ++--
 drivers/net/ethernet/intel/ice/ice_sched.c       | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3d9475e222cd..1898325e62b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4373,7 +4373,7 @@ ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 }
 
 /**
- * ice_fw_supports_lldp_fltr - check NVM version supports lldp_fltr_ctrl
+ * ice_fw_supports_lldp_fltr_ctrl - check NVM version supports lldp_fltr_ctrl
  * @hw: pointer to HW struct
  */
 bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw)
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index e42727941ef5..85c9eccfdae8 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -834,7 +834,7 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 }
 
 /**
- * ice_get_ieee_dcb_cfg
+ * ice_get_ieee_or_cee_dcb_cfg
  * @pi: port information structure
  * @dcbx_mode: mode of DCBX (IEEE or CEE)
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index e8155c7954a0..59ef68f072c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -1135,7 +1135,7 @@ bool ice_fdir_has_frag(enum ice_fltr_ptype flow)
 }
 
 /**
- * ice_fdir_find_by_idx - find filter with idx
+ * ice_fdir_find_fltr_by_idx - find filter with idx
  * @hw: pointer to hardware structure
  * @fltr_idx: index to find.
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index eb895e6db077..f318d7f607e4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1044,7 +1044,7 @@ struct ice_aq_task {
 };
 
 /**
- * ice_wait_for_aq_event - Wait for an AdminQ event from firmware
+ * ice_aq_wait_for_event - Wait for an AdminQ event from firmware
  * @pf: pointer to the PF private structure
  * @opcode: the opcode to wait for
  * @timeout: how long to wait, in jiffies
@@ -4321,7 +4321,7 @@ static void ice_set_wake(struct ice_pf *pf)
 }
 
 /**
- * ice_setup_magic_mc_wake - setup device to wake on multicast magic packet
+ * ice_setup_mc_magic_wake - setup device to wake on multicast magic packet
  * @pf: pointer to the PF struct
  *
  * Issue firmware command to enable multicast magic wake, making
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2403cb38b93c..f890337cc24a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1857,7 +1857,7 @@ ice_sched_cfg_vsi(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 maxqs,
 }
 
 /**
- * ice_sched_rm_agg_vsi_entry - remove aggregator related VSI info entry
+ * ice_sched_rm_agg_vsi_info - remove aggregator related VSI info entry
  * @pi: port information structure
  * @vsi_handle: software VSI handle
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 20343a0fe726..78679ece2e08 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1591,7 +1591,7 @@ static int ice_start_vfs(struct ice_pf *pf)
 }
 
 /**
- * ice_set_dflt_settings - set VF defaults during initialization/creation
+ * ice_set_dflt_settings_vfs - set VF defaults during initialization/creation
  * @pf: PF holding reference to all VFs for default configuration
  */
 static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
@@ -4182,7 +4182,7 @@ void ice_print_vf_rx_mdd_event(struct ice_vf *vf)
 }
 
 /**
- * ice_print_vfs_mdd_event - print VFs malicious driver detect event
+ * ice_print_vfs_mdd_events - print VFs malicious driver detect event
  * @pf: pointer to the PF structure
  *
  * Called from ice_handle_mdd_event to rate limit and print VFs MDD events.
-- 
2.26.2

