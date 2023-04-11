Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9C26DD650
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjDKJLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjDKJK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:10:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB9F30F3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681204249; x=1712740249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTpoh+zVp5ia8SwYnUrFz50Ez8HcPW5Xj7Tq/YwzLvI=;
  b=Ng/ZipOZxh3DWkt3iB8fwSGbtVWXXhwgJX7f3JXxG7I/UwHWGY+jVkPK
   rD6nKLtRcbW2JcVC9IivLOy178bF15zWoPrFIsIHb7yaJXHcfFV87mhUC
   mkYQIamPstgIjCzKSK+B3HAOH5A6z29zFNQiU8zRkMHNUcR1rjvlW3ob/
   jEXaTowv8OC/JR+fNxxX9Y0zfiKSJ4NGK0Ifz6X+iW+WXqiEgsOoBKyaQ
   F70deulT1pIksQa7bHMzz+KLzz5IZ16yFyNQ4TJWFiXLeNWTeRW5U4tSq
   xatjt3LEFr0vP9hrOkxQuB/DJVxsMgZyDxiuJcpoacK4sXr4Pzt8ZuYwg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="327665002"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="327665002"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 02:10:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="682005210"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="682005210"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 11 Apr 2023 02:10:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 5580F6FC; Tue, 11 Apr 2023 12:10:49 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 3/3] net: thunderbolt: Fix typos in comments
Date:   Tue, 11 Apr 2023 12:10:49 +0300
Message-Id: <20230411091049.12998-4-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two typos in comments:

  blongs -> belongs
  UPD -> UDP

No functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/thunderbolt/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 6a43ced74881..0c1e8970ee58 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -148,7 +148,7 @@ struct tbnet_ring {
 /**
  * struct tbnet - ThunderboltIP network driver private data
  * @svc: XDomain service the driver is bound to
- * @xd: XDomain the service blongs to
+ * @xd: XDomain the service belongs to
  * @handler: ThunderboltIP configuration protocol handler
  * @dev: Networking device
  * @napi: NAPI structure for Rx polling
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

