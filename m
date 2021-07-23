Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4533D3E2E
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhGWQ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:27:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:12326 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhGWQ1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:27:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="297489715"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="297489715"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="502586220"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2021 10:07:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 3/5] i40e: Add additional info to PHY type error
Date:   Fri, 23 Jul 2021 10:10:21 -0700
Message-Id: <20210723171023.296927-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
References: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>

In case of PHY type error occurs, the message was too generic.
Add additional info to PHY type error indicating that it can be
wrong cable connected.

Fixes: 124ed15bf126 ("i40e: Add dual speed module support")
Signed-off-by: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index d9e26f9713a5..2c9e4eeb7270 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -980,7 +980,7 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 	default:
 		/* if we got here and link is up something bad is afoot */
 		netdev_info(netdev,
-			    "WARNING: Link is up but PHY type 0x%x is not recognized.\n",
+			    "WARNING: Link is up but PHY type 0x%x is not recognized, or incorrect cable is in use\n",
 			    hw_link_info->phy_type);
 	}
 
-- 
2.26.2

