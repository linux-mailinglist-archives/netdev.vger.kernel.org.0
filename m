Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E64513ADE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350508AbiD1Ras (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350505AbiD1Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643FF3F327
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166839; x=1682702839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S5xMmbl4cOwL81GZsDc1OhN+m3q5BKp1Gsoi9JirqcA=;
  b=QD4mTtz3/Mn4Ka6fz7Zxwvx96v5R1d7QE3B/d/HP4qyV5gwRsYzovuTH
   +xWMMa/ktg17PVLegdXbXyn3E7F2vWQAoJUQ839iSaVAwzMSFL9jZXH8E
   62ILs3xnQGcPD3MakR6llRnDTepfhyJ/K9KZCbU2EbyYkl/PllZSSVrsF
   pA2n8JiDLCfce1SRbK8E4ZVxsqEzJyP125Ze0aXwvRCYrew9HKV2PJ5LY
   Ytrss/HLbJwdUscXt9bxg8K16LihFkV1boice55ScfSFYapW1yXULfwAj
   dobIyOeTqwk+At8ZQ9/wjH/PA9mOmIhZA9Oqx7E9qCmlB2xKOXWSHt9hi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306369"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306369"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497056"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 09/11] ice: fix wording in comment for ice_reset_vf
Date:   Thu, 28 Apr 2022 10:24:28 -0700
Message-Id: <20220428172430.1004528-10-anthony.l.nguyen@intel.com>
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

The comment explaining ice_reset_vf has an extraneous "the" with the "if
the resets are disabled". Remove it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 24cf6a5b49fe..8f875a17755f 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -477,8 +477,8 @@ static void ice_notify_vf_reset(struct ice_vf *vf)
  *   ICE_VF_RESET_NOTIFY - Send VF a notification prior to reset
  *   ICE_VF_RESET_LOCK - Acquire VF cfg_lock before resetting
  *
- * Returns 0 if the VF is currently in reset, if the resets are disabled, or
- * if the VF resets successfully. Returns an error code if the VF fails to
+ * Returns 0 if the VF is currently in reset, if resets are disabled, or if
+ * the VF resets successfully. Returns an error code if the VF fails to
  * rebuild.
  */
 int ice_reset_vf(struct ice_vf *vf, u32 flags)
-- 
2.31.1

