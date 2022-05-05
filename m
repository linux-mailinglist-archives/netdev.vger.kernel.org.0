Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3424851C9F5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383847AbiEEUKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385586AbiEEUKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:10:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C475E755
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651781221; x=1683317221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hzd/bGALnr4Xvj/tgG5c6jOMJpOoSqiJolSxX+bUQ9Y=;
  b=OinmtDyarRGT3oIxkp4kYuGz9FiI2j0BviV/QzqM3nb2iqH34kIoBCdu
   K96Su6h9/B0EOdWCFHplFg6zx6d3PmJl+Lwmk1HA7zLZJ8A6m+8spcRI3
   +9nWHCTw2jlrIsK/m/eWP9KDwV+bo9ok2gayZUNZ2IfW7rcBctB22p6kk
   mlkTyc/2rtqxfbsNwiIydImO/iSsArY3otye/h3Il1XV8oZNsUjDfjpfJ
   W9TWVQQKUKkriiGl6yfVMSVWnLnQrCpZp5WogEvocuXfcYmqsNkreTCla
   TVJZlF2LhgfQxp6UkWBwPFs4ueBnsXiC0IIe/vyIh01zAqKcq+U/6xBF/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248772039"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248772039"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:07:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="735111720"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 13:06:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next v2 07/10] ice: remove return value comment for ice_reset_all_vfs
Date:   Thu,  5 May 2022 13:03:56 -0700
Message-Id: <20220505200359.3080110-8-anthony.l.nguyen@intel.com>
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

Since commit fe99d1c06c16 ("ice: make ice_reset_all_vfs void"), the
ice_reset_all_vfs function has not returned anything. The function comment
still indicated it did. Fix this.

While here, also add a line to clarify the function resets all VFs at once
in response to hardware resets such as a PF reset.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index aefd66a4db80..24cf6a5b49fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -359,12 +359,12 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
  * ice_reset_all_vfs - reset all allocated VFs in one go
  * @pf: pointer to the PF structure
  *
+ * Reset all VFs at once, in response to a PF or other device reset.
+ *
  * First, tell the hardware to reset each VF, then do all the waiting in one
  * chunk, and finally finish restoring each VF after the wait. This is useful
  * during PF routines which need to reset all VFs, as otherwise it must perform
  * these resets in a serialized fashion.
- *
- * Returns true if any VFs were reset, and false otherwise.
  */
 void ice_reset_all_vfs(struct ice_pf *pf)
 {
-- 
2.35.1

