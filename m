Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0DB4A903D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355514AbiBCVvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:63985 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355189AbiBCVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925112; x=1675461112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vKIVO6Rxov4SzABHM51C7oWjITco7qBBhyCkPfaU97o=;
  b=jyRKTLdfGUHhyJx4ufH/im6yByrBb7mcU+ohHd/91aWS/ISXTo3uCQ/c
   6MYGrz3jJdhyq8FM2mygzqzx/KiedOGNAUdRYLEYfNVu6UgQ/QJhNcfE5
   Ww1cLS/nOO4QL7nQaY2N9Q+QbhvwYi7xvSmhb14nxaEZBx69gQVkTl9rV
   EXjApM/DXJBDtkk+2+egJzS/yPXY1BiPcu+049tjMf5yBzVweqnGkZY2F
   8U/g2J4TBiEZ3zGP3zt6E7AQzDSwtYNprh0oNvnkGIXuCI4ycaJT9WNSi
   SY1Waas5F1vhPPGGaI8uaZVZeOTToxHyszxJ8GUfKAiAIcQ5QXNCPNm3U
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272760132"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="272760132"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295199"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, shiraz.saleem@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/7] i40e: remove enum i40e_client_state
Date:   Thu,  3 Feb 2022 13:51:36 -0800
Message-Id: <20220203215140.969227-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
References: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

It's not used.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/net/intel/i40e_client.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
index 6b3267b49755..ed42bd5f639f 100644
--- a/include/linux/net/intel/i40e_client.h
+++ b/include/linux/net/intel/i40e_client.h
@@ -26,11 +26,6 @@ struct i40e_client_version {
 	u8 rsvd;
 };
 
-enum i40e_client_state {
-	__I40E_CLIENT_NULL,
-	__I40E_CLIENT_REGISTERED
-};
-
 enum i40e_client_instance_state {
 	__I40E_CLIENT_INSTANCE_NONE,
 	__I40E_CLIENT_INSTANCE_OPENED,
@@ -190,11 +185,6 @@ struct i40e_client {
 	const struct i40e_client_ops *ops; /* client ops provided by the client */
 };
 
-static inline bool i40e_client_is_registered(struct i40e_client *client)
-{
-	return test_bit(__I40E_CLIENT_REGISTERED, &client->state);
-}
-
 void i40e_client_device_register(struct i40e_info *ldev, struct i40e_client *client);
 void i40e_client_device_unregister(struct i40e_info *ldev);
 
-- 
2.31.1

