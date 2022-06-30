Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F133B56255A
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbiF3Vfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237609AbiF3Vfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C61523BA
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624929; x=1688160929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9vvVi25YbEkHkq/158cQ66krc9ToTBrtPq1lFx61xoc=;
  b=W7DQ7CROVifm/1qi6IIL/rW/2oNINKhf9x2bVxcSvtNDjtwwP+ffjEN3
   yfxONCgrfsTjw219z2bgOIm2O6A+YAMysETnSa7WkL+XYNzbH1fxNA6Lh
   /2YlxPThZ5yPSwEqWdrFYasgxKOetvfZR5fSfIC+7FyxDNunsG6Tsp30B
   WDhOvRpwFOIjdP+q6+PTsEzDfvQ6U7VkxgLex+5c2kpR/7JPmKKT17AZ2
   Fd0RiP+Bk41q1G+sHGII+/YZr7VZQcv+zguyzyUls7oJnbC9CvYxnBBVE
   q8U69dvL2OkLaoodBAolYcOhRXVS63tKQGM1gJmexz/PRfMMpi5TrR84W
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507755"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507755"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771837"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jilin Yuan <yuanjilin@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 10/15] intel/iavf:fix repeated words in comments
Date:   Thu, 30 Jun 2022 14:32:03 -0700
Message-Id: <20220630213208.3034968-11-anthony.l.nguyen@intel.com>
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
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 541103909ef4..69ade653f5d4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4250,7 +4250,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	}
 
 	/* No need to validate L4LEN as TCP is the only protocol with a
-	 * a flexible value and we support all possible values supported
+	 * flexible value and we support all possible values supported
 	 * by TCP, which is at most 15 dwords
 	 */
 
-- 
2.35.1

