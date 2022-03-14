Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3084D8B5F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbiCNSLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241784AbiCNSLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:07 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218781277B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281397; x=1678817397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ydaLrv9hbLlfNyz+3v3PIUFUr+wOJd2jKRjVqCA1aKE=;
  b=Oo5AnnoE19A4jd1lJ3ARyPzNnjVe34u+EEMri6lp7fXZNlvgmTRXAtds
   VrjzwhpQ57KO0cw4EjsgOJCqs8iyn2EsaYqx/TTQKZm4Mn1h0Q9hBJZ4L
   RPU5b6g1MJz6f2Kxmi0Gk+E7Zan5jiQ92UCsUuy0lILXeivjlUUZx0I8c
   Ape4xfMSoQHbZ9rwXAbLPsHpiOcM+0RVhFG8GQbhVrkvlQiGi8NF/dJfS
   XgwdUQMKCKdDBB9sBgSWIhm7GAQT+iz4r2SPZUxF5sv/gnRh7sdXWsUnv
   aUL6ICf/KYW0gAONfDNXo9VzacZWWHTAUrY1qbVOenorANSYoJGxYc85T
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275351"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275351"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:09:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297518"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:09:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 05/25] ice: remove unused definitions from ice_sriov.h
Date:   Mon, 14 Mar 2022 11:09:56 -0700
Message-Id: <20220314181016.1690595-6-anthony.l.nguyen@intel.com>
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

A few more macros exist in ice_sriov.h which are not used anywhere.
These can be safely removed. Note that ICE_VIRTCHNL_VF_CAP_L2 capability
is set but never checked anywhere in the driver. Thus it is also safe to
remove.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 1 -
 drivers/net/ethernet/intel/ice/ice_sriov.h | 7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 8578317ceb8a..205d7e5003d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -2012,7 +2012,6 @@ static int ice_create_vf_entries(struct ice_pf *pf, u16 num_vfs)
 
 		vf->vf_sw_id = pf->first_sw;
 		/* assign default capabilities */
-		set_bit(ICE_VIRTCHNL_VF_CAP_L2, &vf->vf_caps);
 		vf->spoofchk = true;
 		vf->num_vf_qs = pf->vfs.num_qps_per;
 		ice_vc_set_default_allowlist(vf);
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index b6951d718592..699690c1f6a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -13,9 +13,6 @@
  */
 #define ICE_MAX_MACADDR_PER_VF		18
 
-/* Malicious Driver Detection */
-#define ICE_MDD_EVENTS_THRESHOLD		30
-
 /* Static VF transaction/status register def */
 #define VF_DEVICE_STATUS		0xAA
 #define VF_TRANS_PENDING_M		0x20
@@ -28,7 +25,6 @@
 #define ICE_MAX_VF_COUNT		256
 #define ICE_MIN_QS_PER_VF		1
 #define ICE_NONQ_VECS_VF		1
-#define ICE_MAX_SCATTER_QS_PER_VF	16
 #define ICE_MAX_RSS_QS_PER_VF		16
 #define ICE_NUM_VF_MSIX_MED		17
 #define ICE_NUM_VF_MSIX_SMALL		5
@@ -95,8 +91,7 @@ enum ice_vf_states {
 
 /* VF capabilities */
 enum ice_virtchnl_cap {
-	ICE_VIRTCHNL_VF_CAP_L2 = 0,
-	ICE_VIRTCHNL_VF_CAP_PRIVILEGE,
+	ICE_VIRTCHNL_VF_CAP_PRIVILEGE = 0,
 };
 
 struct ice_time_mac {
-- 
2.31.1

