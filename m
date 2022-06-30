Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3383956255D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiF3Vf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbiF3Vfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC7053EE8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624933; x=1688160933;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T9qzSs+wbAxW2jJWQPR1bj29amFj+4Ce1cAddNdJMxw=;
  b=WZsNjR+8V40DBD1Fw7rL09zMHVyFjrv2Z3NImBx+qMOL75a+co6M+yom
   W4DIsL++t0JBFJO3VnUBNtwE8cRLRN7kNHyyD/5XyvE3qk/JpEngrsW5V
   bnmEcKQf1wMzerzO7GVkvzojN2cHcckrnAThD8cedBl787z5+8jDkllvf
   Ro46CEzK+1/vi9qPNtAaa1xEU16ky4TKtIFtzVmkVGOkptjG2dr/DZ1Se
   +pLv9A/Oyhzot2zICURPPBYN+ooRBtNfWGB0KL7yBtrtTR0IMzY51jK+n
   yIWF1Xf1OboZ4CNKC/FWKxcBOBZI08ZnIupiknjcPGbC7jijcozsq73M6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507770"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507770"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771869"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jilin Yuan <yuanjilin@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 15/15] intel/ice:fix repeated words in comments
Date:   Thu, 30 Jun 2022 14:32:08 -0700
Message-Id: <20220630213208.3034968-16-anthony.l.nguyen@intel.com>
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

From: Jilin Yuan <yuanjilin@cdjrlc.com>

Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index c73cdab44f70..ada5198b5b16 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2639,7 +2639,7 @@ ice_ptg_remove_ptype(struct ice_hw *hw, enum ice_block blk, u16 ptype, u8 ptg)
  *
  * This function will either add or move a ptype to a particular PTG depending
  * on if the ptype is already part of another group. Note that using a
- * a destination PTG ID of ICE_DEFAULT_PTG (0) will move the ptype to the
+ * destination PTG ID of ICE_DEFAULT_PTG (0) will move the ptype to the
  * default PTG.
  */
 static int
-- 
2.35.1

