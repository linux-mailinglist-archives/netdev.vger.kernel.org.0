Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042F0562558
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiF3Vfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiF3Vf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F6C53D04
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624925; x=1688160925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kW2x/TNE4RSmgY18NyjUeu8qGvHt5hay9voeXG+NEC0=;
  b=HXTInf7W1GLaRQ7Rs0VTnAeswH9UC4g91Kkf7f+AsF+zu3JtBrJ8iuS8
   +R22uvZfVLPkYCJtpahHMWfjMi208i6Tu0E9nYxGh74z5zidwH4Iz9IGg
   voLVNV6aRCYYyAQHrzN+xkjjR3EDPI/H4RgiAVYTO2dLrjBi3IU4XDv/3
   BWy7m812dgLJth6Unn1u4/TB3ukoHFGX8hXUG0TkVZpBQCHskc8wu23X1
   bWD2pFBLybmLfDbfFVlwgibQ3iLjODPcS7vVjx1fl6tPRXNv2Iz0eTbbU
   aufsf54keCayJm7wsafcVPV0X7/VGu7SkwBtdl+6OqvfHWJf9dZ+ydxPf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507745"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507745"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771810"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jiang Jian <jiangjian@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 05/15] ixgbe: drop unexpected word 'for' in comments
Date:   Thu, 30 Jun 2022 14:31:58 -0700
Message-Id: <20220630213208.3034968-6-anthony.l.nguyen@intel.com>
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

there is an unexpected word 'for' in the comments that need to be dropped

file - drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
line - 5164

 * ixgbe_lpbthresh - calculate low water mark for for flow control

changed to:

 * ixgbe_lpbthresh - calculate low water mark for flow control

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 5c62e9963650..0493326a0d6b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5161,7 +5161,7 @@ static int ixgbe_hpbthresh(struct ixgbe_adapter *adapter, int pb)
 }
 
 /**
- * ixgbe_lpbthresh - calculate low water mark for for flow control
+ * ixgbe_lpbthresh - calculate low water mark for flow control
  *
  * @adapter: board private structure to calculate for
  * @pb: packet buffer to calculate
-- 
2.35.1

