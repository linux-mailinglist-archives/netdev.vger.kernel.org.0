Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D058D6D580B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 07:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbjDDFgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 01:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjDDFgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 01:36:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C262C19A8
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680586599; x=1712122599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zINHbC/usNsuk082wrIK26y6e2wA1xg6pX6G62VaWkw=;
  b=LUiW4R6g37HRXF1hHLvS8Y3Eq6ByRl5aeeU13F5UlXOE2s0iWf80OEif
   Fo4kkcIClAI0QLimltZrK4+kRV4TnYEERQU3MDkf11I9F5WkxRK67dUlL
   1Pt47LZ1u1Z9ED8W3kCHbrmN/ul8d2AA9Di1nJI5klccX2OW5bKddELZz
   B7Fty3UO5TQD0OZsfEafLoTEtv0k+Y/qj9rVvCp+ZvOyJDCgZ0b+Lavjx
   LArTJo8wRWSZCuaqVat0E3WdRQgDie/+sab0J5e0w57t73pJT8KJayfOC
   M7fciqpPBntf1+oTY0Ov6opU3Hks7RFnLFu5Emxh2T18yjNgC9kPhQhjG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="340826304"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="340826304"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 22:36:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="688760550"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="688760550"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2023 22:36:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 1470E14B; Tue,  4 Apr 2023 08:36:37 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] net: thunderbolt: Fix typo in comment
Date:   Tue,  4 Apr 2023 08:36:36 +0300
Message-Id: <20230404053636.51597-3-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should be UDP not UPD. No functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 6a43ced74881..0ce501e34f3f 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -1030,7 +1030,7 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
 	/* Data points on the beginning of packet.
 	 * Check is the checksum absolute place in the packet.
 	 * ipcso will update IP checksum.
-	 * tucso will update TCP/UPD checksum.
+	 * tucso will update TCP/UDP checksum.
 	 */
 	if (protocol == htons(ETH_P_IP)) {
 		__sum16 *ipcso = dest + ((void *)&(ip_hdr(skb)->check) - data);
-- 
2.39.2

