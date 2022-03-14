Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44034D8B6E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243701AbiCNSLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbiCNSLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E746813F5D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281407; x=1678817407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eg2RzSN4nQuF2DO82hKqcI4Q9p/hY+74z8iZuybfz1A=;
  b=Uj8P8H5qe/eFOnXEm63YFqlHNGmP0Xb4NxzdIKvK4/fV0eva/dr/tBBX
   ITOwa6vsWoEfoUfDeLJCJ5KTIv9043J/t2ufHkW1hBWqfKBkrqB4chSQ5
   9XRSAUi1Kd7jhgydWstAJOTiU7Ye2bE+KrZXXr9Vo8gApY5PyKHOStoXI
   +ngbPCTDuj7UEpZZVsKupWkizQiH2k6DtlURxmFzXkz0aCoii47ogFzTG
   awAoB/rcP768qpwQ+h6DfEGFerfhWr8xlr1vzuDydVtigYDkD+4JRWVNl
   ef6pFKjLH+0nd3anxWq54/M4R9adCW6c86N6DAIog4hM58/P5Hpn0YUEe
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275409"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275409"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297727"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:03 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 23/25] ice: cleanup long lines in ice_sriov.c
Date:   Mon, 14 Mar 2022 11:10:14 -0700
Message-Id: <20220314181016.1690595-24-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

