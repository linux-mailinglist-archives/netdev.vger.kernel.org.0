Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F385B56255F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbiF3Vff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237555AbiF3Vf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985AD53D0F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624926; x=1688160926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kzuqHt/dnDEe0BIj7svzxm0M4rV00s01hsuj8TAbTqE=;
  b=hq3fVSd1MXux4ylS0I0aNsd3NhQniTjJpgcxGwYhpBKFhhE3WBG0wiE4
   Ommpd8htTtAJ9wUjVqPkuv/fxdKLsup79RJDzGsHG/+dMR7QHrHP8F4DY
   y6/5Ebcmeyh/kOzsi0/CirpY4LkNm+08lRr3daWz6A0HgNesb0KDZWfga
   YTMfj9WgozYh6jAN3Zwfa2uDyWZ5BOk18OTIR6+mh1SMJAAKl+o1RruXJ
   A5YVpCw/FSYmf7/MT3IIabtZpA1p164gCCKKxrRuVEe95pDiA7M6bfPz2
   Qk6f0QRMNLR27hPFgkmNWfRFgvwu16ALTj7AM0hbnZoku2EljWqiq9gXC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507746"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507746"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771816"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jilin Yuan <yuanjilin@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 06/15] intel/e1000:fix repeated words in comments
Date:   Thu, 30 Jun 2022 14:31:59 -0700
Message-Id: <20220630213208.3034968-7-anthony.l.nguyen@intel.com>
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

Delete the redundant word 'frames'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index f8860f24ede0..4542e2bc28e8 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -2000,7 +2000,7 @@ s32 e1000_force_mac_fc(struct e1000_hw *hw)
 	 *      1:  Rx flow control is enabled (we can receive pause
 	 *          frames but not send pause frames).
 	 *      2:  Tx flow control is enabled (we can send pause frames
-	 *          frames but we do not receive pause frames).
+	 *          but we do not receive pause frames).
 	 *      3:  Both Rx and TX flow control (symmetric) is enabled.
 	 *  other:  No other values should be possible at this point.
 	 */
-- 
2.35.1

