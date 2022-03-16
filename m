Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8594DB99B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345451AbiCPUlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350837AbiCPUlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:41:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53975FF0E
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647463201; x=1678999201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ICHO+fWkBDhcURAakNs4ToUsSuhHlLbq17ag72OMWaY=;
  b=Wa0rbltNdEy2K6YexJZdykm/bcR6bYU2JuMCuHB87ZfgO5Tgex0q5Axz
   8kW1Rn9a/xP5lZoQEdN+iORtQt9uGnOWzMVn8cKvK3OIeqSZoYEygNfg2
   b2A+h40qzoeAsWbWT1xmAQYu/CiRS7ewPlg21HmeMzqzZ5tuMiPUj77zZ
   Y5Dx16jiwcMC8rODnhZC6tqEuKL7yOCh3DOEqD53W7atTW4tHpPp5F8Kp
   quJNCkn0yg3z4GaTbXuIU3UVHFezzxalkm6UUMf46fIBkA/G7Ef68e3R+
   X3YY95IAYYNLA1evDOzSh1E4WvBmxSTpF0bnGulEQpp7MD/e1ePiQIbpm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="236653296"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="236653296"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 13:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="646799207"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 16 Mar 2022 13:39:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 1/4] gtp: Fix inconsistent indenting
Date:   Wed, 16 Mar 2022 13:40:21 -0700
Message-Id: <20220316204024.3201500-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
References: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Fix the following warning as reported by smatch:

New smatch warnings:
drivers/net/gtp.c:1796 gtp_genl_send_echo_req() warn: inconsistent indenting

Fixes: d33bd757d362 ("gtp: Implement GTP echo request")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 756714d4ad92..a208e2b1a9af 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1793,7 +1793,7 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 	if (IS_ERR(rt)) {
 		netdev_dbg(gtp->dev, "no route for echo request to %pI4\n",
 			   &dst_ip);
-			   kfree_skb(skb_to_send);
+		kfree_skb(skb_to_send);
 		return -ENODEV;
 	}
 
-- 
2.31.1

