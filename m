Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D473513AE9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350493AbiD1Raw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350501AbiD1Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D493F329
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166839; x=1682702839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B/Vg6ozBZaNPfG9hPDFXRX0ekmfbZ6xvkedt6hxKnOM=;
  b=oIlvxRnCCMX35H0HEttT298tLCUC53yO7/qNGHhVkRuO628B6s2keU3I
   XeRD4g4HoLI1h9FaBJHrDhNk2nZcfbm9rYebCk8hXs4+qHUCaGhe11BFe
   8Vqhn6hb63e5rmRRb6bU85AeHLSXOq3wStrciIVfjBjT3YCw3mbiSXSqm
   A7BgxMu8pQvbHfcSjE/Qw+rXMewMwSknAiK+W76ucO4ZbYSW5PJkzw9aK
   NmkrFeGccwDGGnYrztN6O2Mg19g402N7Jq2YQbMgK4q1UxJ5nrxtlODuT
   8S79xTedaUxNQEq8A1b+f1n8faw8dnS6KnKr6epIm0v/4dc7fawX84sP0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306371"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306371"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497063"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 11/11] ice: remove period on argument description in ice_for_each_vf
Date:   Thu, 28 Apr 2022 10:24:30 -0700
Message-Id: <20220428172430.1004528-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_for_each_vf macros have comments describing the implementation. One
of the arguments has a period on the end, which is not our typical style.
Remove the unnecessary period.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 831b667dc5b2..1b4380d6d949 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -176,7 +176,7 @@ static inline u16 ice_vf_get_port_vlan_tpid(struct ice_vf *vf)
  * ice_for_each_vf - Iterate over each VF entry
  * @pf: pointer to the PF private structure
  * @bkt: bucket index used for iteration
- * @vf: pointer to the VF entry currently being processed in the loop.
+ * @vf: pointer to the VF entry currently being processed in the loop
  *
  * The bkt variable is an unsigned integer iterator used to traverse the VF
  * entries. It is *not* guaranteed to be the VF's vf_id. Do not assume it is.
@@ -192,7 +192,7 @@ static inline u16 ice_vf_get_port_vlan_tpid(struct ice_vf *vf)
  * ice_for_each_vf_rcu - Iterate over each VF entry protected by RCU
  * @pf: pointer to the PF private structure
  * @bkt: bucket index used for iteration
- * @vf: pointer to the VF entry currently being processed in the loop.
+ * @vf: pointer to the VF entry currently being processed in the loop
  *
  * The bkt variable is an unsigned integer iterator used to traverse the VF
  * entries. It is *not* guaranteed to be the VF's vf_id. Do not assume it is.
-- 
2.31.1

