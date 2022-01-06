Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C505F486BF8
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244291AbiAFVdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:33:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:26402 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244292AbiAFVdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 16:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641504822; x=1673040822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f+uhi+evyPx+g2DGyxoZMC/xE13sD0sY84+aPu+4xd0=;
  b=JEfRHkLF4vu8flT/GSBCrKU0y15E0DLwpmuZQCHMl3ODiTdc8zPJnD7s
   xsTRqhw0P/CfKUVc9p3AGrB2HTe85yLBurTvR22gGxxzCzjQKoS6cdG8r
   VdzZ16lu698RvjwijJ7UPSFBU1d0syeOhrf0y6I6hEvmsewLi9b6NLDep
   5zKpyUQrpA7mqK0IzSYuVy2G8ygXcbtW6MqTpnkJ0DGPLzh+Pxst2CKcu
   oOJfXMwX86YAH6XhewYY+vrs99Anwb9uDSf4/bREBt8EGMUKBBnXcqGze
   1KTRSczQ9jSJh2gWseKbPLS3h4t4mfC7ZpILiOhosghk7dgqZ5tvb7hJk
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303490349"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="303490349"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:33:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="611972900"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2022 13:33:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/7] i40e: Update FW API version
Date:   Thu,  6 Jan 2022 13:32:58 -0800
Message-Id: <20220106213301.11392-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Update FW API versions to the newest supported NVM images.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 140b677f114d..60f9e0a6aaca 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -11,8 +11,8 @@
  */
 
 #define I40E_FW_API_VERSION_MAJOR	0x0001
-#define I40E_FW_API_VERSION_MINOR_X722	0x0009
-#define I40E_FW_API_VERSION_MINOR_X710	0x0009
+#define I40E_FW_API_VERSION_MINOR_X722	0x000C
+#define I40E_FW_API_VERSION_MINOR_X710	0x000F
 
 #define I40E_FW_MINOR_VERSION(_h) ((_h)->mac.type == I40E_MAC_XL710 ? \
 					I40E_FW_API_VERSION_MINOR_X710 : \
-- 
2.31.1

