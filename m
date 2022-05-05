Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B9751C9FA
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385612AbiEEUK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385591AbiEEUKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:10:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA1A5E777
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651781222; x=1683317222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DhqSEDo+JUqCr4KeL1OGcY8Df7wWfcFQFzTd/ae9+XY=;
  b=WPwPPXhCtHpFqGfEf5dqiKZWJsNWHv8965fhmVt8J8ZRmwh2v1pmPCA5
   fshh58NOJgGaOIdUoaQ3hm7NcCpeBTbooy0Wgg6Iv7smvPHZ0s1V4CIk6
   OmE0fOUS+tE/TnFnlHm7OeZJkCXIBToTakmQPXDq6LKKJeBei13bTe18/
   NF/5zwYQcT1LxAa0/TJZ+UK7zIC7JT3J1/MCgYPG3YKFeNYnzF8YJkDJO
   9Zg2oNv8knXy2W2A3ATVdsna0A6rDojemX3u1e2EFmd2D027m85xaWak4
   2OELqwxROOHHvYwpBT1ULlTZR+Ls6PhcR6gIEr/cqpMa0wTV9hPWOClsM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248772042"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248772042"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:07:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="735111725"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 13:06:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next v2 08/10] ice: fix wording in comment for ice_reset_vf
Date:   Thu,  5 May 2022 13:03:57 -0700
Message-Id: <20220505200359.3080110-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
References: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
2.35.1

