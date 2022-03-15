Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3604DA545
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352215AbiCOWXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352202AbiCOWXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:23:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0975C673
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647382924; x=1678918924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eg2RzSN4nQuF2DO82hKqcI4Q9p/hY+74z8iZuybfz1A=;
  b=cHX0KPtAYEw8K70A1Dc4IcXl1eUSVW098lOBeHv2EVcfkG3a0p0ReFYx
   3ilkmwPl3AoCUD8ArA/hlbSKDs/96gH1zwyb4AM0clrSi4XucXm537zR3
   4FYAvNaG94LyGeL3/a8nrXwsRizBhEOEviXBlOi1vVHPQMBvXYyVdgPzB
   zFG9exrjcDSwaccNzAORT6JC7Uvc4aOHYmgRA+3O03GP93m8kkKmMoUJx
   6ApDNzCabxZ9isDoUBmHp1h6nOTljt1oxfhrlZSNXXQGds7CGDvoqa9WK
   BQg28jDy3Vgu3/czkMyTl0nL/ANPicG1oZuIVuhattxgXRVWFfRelXCt2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255264562"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="255264562"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690362239"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 15:22:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 12/14] ice: cleanup long lines in ice_sriov.c
Date:   Tue, 15 Mar 2022 15:22:18 -0700
Message-Id: <20220315222220.2925324-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
References: <20220315222220.2925324-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Before we move the virtchnl message handling from ice_sriov.c into
ice_virtchnl.c, cleanup some long line warnings to avoid checkpatch.pl
complaints.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 39 +++++++++++++++-------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index f74474f8af99..4f3d25ed68c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -2325,16 +2325,21 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
 			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
 				 vf->vf_id);
-		else if (!allmulti && test_and_clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+		else if (!allmulti &&
+			 test_and_clear_bit(ICE_VF_STATE_MC_PROMISC,
+					    vf->vf_states))
 			dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n",
 				 vf->vf_id);
 	}
 
 	if (!ucast_err) {
-		if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+		if (alluni &&
+		    !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
 			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
 				 vf->vf_id);
-		else if (!alluni && test_and_clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+		else if (!alluni &&
+			 test_and_clear_bit(ICE_VF_STATE_UC_PROMISC,
+					    vf->vf_states))
 			dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n",
 				 vf->vf_id);
 	}
@@ -2878,8 +2883,9 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			}
 
 			vsi->max_frame = qpi->rxq.max_pkt_size;
-			/* add space for the port VLAN since the VF driver is not
-			 * expected to account for it in the MTU calculation
+			/* add space for the port VLAN since the VF driver is
+			 * not expected to account for it in the MTU
+			 * calculation
 			 */
 			if (ice_vf_is_port_vlan_ena(vf))
 				vsi->max_frame += VLAN_HLEN;
@@ -3665,8 +3671,11 @@ static u16 ice_vc_get_max_vlan_fltrs(struct ice_vf *vf)
 }
 
 /**
- * ice_vf_outer_vlan_not_allowed - check outer VLAN can be used when the device is in DVM
+ * ice_vf_outer_vlan_not_allowed - check if outer VLAN can be used
  * @vf: VF that being checked for
+ *
+ * When the device is in double VLAN mode, check whether or not the outer VLAN
+ * is allowed.
  */
 static bool ice_vf_outer_vlan_not_allowed(struct ice_vf *vf)
 {
@@ -3944,9 +3953,11 @@ ice_vc_validate_vlan_filter_list(struct virtchnl_vlan_filtering_caps *vfc,
 			return false;
 
 		if ((ice_vc_is_valid_vlan(outer) &&
-		     !ice_vc_validate_vlan_tpid(filtering_support->outer, outer->tpid)) ||
+		     !ice_vc_validate_vlan_tpid(filtering_support->outer,
+						outer->tpid)) ||
 		    (ice_vc_is_valid_vlan(inner) &&
-		     !ice_vc_validate_vlan_tpid(filtering_support->inner, inner->tpid)))
+		     !ice_vc_validate_vlan_tpid(filtering_support->inner,
+						inner->tpid)))
 			return false;
 	}
 
@@ -4421,7 +4432,8 @@ static int ice_vc_ena_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2, v_ret, NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
+				     v_ret, NULL, 0);
 }
 
 /**
@@ -4490,7 +4502,8 @@ static int ice_vc_dis_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2, v_ret, NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
+				     v_ret, NULL, 0);
 }
 
 /**
@@ -4548,7 +4561,8 @@ static int ice_vc_ena_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2, v_ret, NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
+				     v_ret, NULL, 0);
 }
 
 /**
@@ -4602,7 +4616,8 @@ static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2, v_ret, NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
+				     v_ret, NULL, 0);
 }
 
 static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
-- 
2.31.1

