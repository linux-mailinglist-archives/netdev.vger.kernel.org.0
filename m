Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8270C562557
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiF3Vf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiF3VfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F4A53D02
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624925; x=1688160925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bv+oIfebpIfJMbyJ/l0Y5u/sDj8o5o0oPaviMCs44X0=;
  b=leAPDQ19WiTZPaK4TG8bl8I4qPz6NNiXtLCAfURlSgyPdrJtdcgTcN8z
   k9mHlhkuNXez1x+Ro16CrZyPy9g+QMMiCHy7vP1exRxz+owDkClGqe/3Z
   zqjm/xOhO58afb0d9U36aQpnSMtHEUkqi2eXbJlu4Emuyo4dIQBUtj348
   TjJwEMh/bOPNRAy38Wv9gaX2w/d6WeZ/2r0eE5PNpZqlOpQZKLj8jIsn4
   biuFbSDWRW6QO/2Qql+kBrYSsPKx4Wwj5/mixQHtcU9UVpeQ1XYBbMqHO
   juqFF5saYQ1YwT9OHaB+ZqHtEGwGAX+khTybWq1oOBSv+hyy/oAWFoJDi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507743"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507743"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771801"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jiang Jian <jiangjian@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 03/15] fm10k: remove unexpected word "the"
Date:   Thu, 30 Jun 2022 14:31:56 -0700
Message-Id: <20220630213208.3034968-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
References: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiang Jian <jiangjian@cdjrlc.com>

there is an unexpected word "the" in the comments that need to be removed

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index f2fba6e1d0f7..87fa5874f16e 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -809,7 +809,7 @@ static s32 fm10k_mbx_read(struct fm10k_hw *hw, struct fm10k_mbx_info *mbx)
  *  @hw: pointer to hardware structure
  *  @mbx: pointer to mailbox
  *
- *  This function copies the message from the the message array to mbmem
+ *  This function copies the message from the message array to mbmem
  **/
 static void fm10k_mbx_write(struct fm10k_hw *hw, struct fm10k_mbx_info *mbx)
 {
-- 
2.35.1

