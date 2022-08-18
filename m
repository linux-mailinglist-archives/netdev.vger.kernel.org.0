Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D069598825
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344425AbiHRPzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344520AbiHRPyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:54:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC0F55A9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660838001; x=1692374001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dj7HjKAP0X249nF0M+jfXlwl/RHHIN2BG1edFDF/ZwA=;
  b=QWqlM/06iufmY1/xtNFlFCvgTsmZ65fTFGMnZoythzNhgeTjdsPSXnGN
   kAMer0Pw8FydMYm3j4J2YdXyefIGh0dPf/mUM9mVfAYrpOWEjRIAoFygg
   rz2XkjWJrEGSOLIHRroScrnnN+Mdr7RKuywBMrXI0plgyUFiZdk9YoHyk
   8HvkR6DwpfUhVlxOpWPYXRyZjlhpuMlAImuhTGd8qxsSlhhqYkASEDaL0
   FkxWVX/WnIgwWr99KZOZbbRUtdSCmM45ty2lBUjwStZQcS3dyQUh8SFeH
   OYoCq9HUfzQvxGaPSiwBTRXHPr0r1dZes/TCeMUKc6lFvxTTxIg3ikBIS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318817406"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="318817406"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 08:52:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="676104325"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 08:52:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Mikael Barsehyan <mikael.barsehyan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/5] ice: remove non-inclusive language
Date:   Thu, 18 Aug 2022 08:52:07 -0700
Message-Id: <20220818155207.996297-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
References: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mikael Barsehyan <mikael.barsehyan@intel.com>

Remove non-inclusive language from the driver where
possible; replace "master" with "primary"; replace
"slave" with "secondary".

Signed-off-by: Mikael Barsehyan <mikael.barsehyan@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 16 ++++++++--------
 drivers/net/ethernet/intel/ice/ice_lag.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index c9f7393b783d..ee5b36941ba3 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -61,13 +61,13 @@ static void ice_lag_set_backup(struct ice_lag *lag)
  */
 static void ice_display_lag_info(struct ice_lag *lag)
 {
-	const char *name, *peer, *upper, *role, *bonded, *master;
+	const char *name, *peer, *upper, *role, *bonded, *primary;
 	struct device *dev = &lag->pf->pdev->dev;
 
 	name = lag->netdev ? netdev_name(lag->netdev) : "unset";
 	peer = lag->peer_netdev ? netdev_name(lag->peer_netdev) : "unset";
 	upper = lag->upper_netdev ? netdev_name(lag->upper_netdev) : "unset";
-	master = lag->master ? "TRUE" : "FALSE";
+	primary = lag->primary ? "TRUE" : "FALSE";
 	bonded = lag->bonded ? "BONDED" : "UNBONDED";
 
 	switch (lag->role) {
@@ -87,8 +87,8 @@ static void ice_display_lag_info(struct ice_lag *lag)
 		role = "ERROR";
 	}
 
-	dev_dbg(dev, "%s %s, peer:%s, upper:%s, role:%s, master:%s\n", name,
-		bonded, peer, upper, role, master);
+	dev_dbg(dev, "%s %s, peer:%s, upper:%s, role:%s, primary:%s\n", name,
+		bonded, peer, upper, role, primary);
 }
 
 /**
@@ -119,7 +119,7 @@ static void ice_lag_info_event(struct ice_lag *lag, void *ptr)
 	}
 
 	if (strcmp(bonding_info->slave.slave_name, lag_netdev_name)) {
-		netdev_dbg(lag->netdev, "Bonding event recv, but slave info not for us\n");
+		netdev_dbg(lag->netdev, "Bonding event recv, but secondary info not for us\n");
 		goto lag_out;
 	}
 
@@ -164,8 +164,8 @@ ice_lag_link(struct ice_lag *lag, struct netdev_notifier_changeupper_info *info)
 	lag->bonded = true;
 	lag->role = ICE_LAG_UNSET;
 
-	/* if this is the first element in an LAG mark as master */
-	lag->master = !!(peers == 1);
+	/* if this is the first element in an LAG mark as primary */
+	lag->primary = !!(peers == 1);
 }
 
 /**
@@ -264,7 +264,7 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
 	netdev_dbg(netdev, "bonding %s\n", info->linking ? "LINK" : "UNLINK");
 
 	if (!netif_is_lag_master(info->upper_dev)) {
-		netdev_dbg(netdev, "changeupper rcvd, but not master. bail\n");
+		netdev_dbg(netdev, "changeupper rcvd, but not primary. bail\n");
 		return;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lag.h b/drivers/net/ethernet/intel/ice/ice_lag.h
index c2e3688dd8fd..51b5cf467ce2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.h
+++ b/drivers/net/ethernet/intel/ice/ice_lag.h
@@ -24,7 +24,7 @@ struct ice_lag {
 	struct net_device *upper_netdev; /* upper bonding netdev */
 	struct notifier_block notif_block;
 	u8 bonded:1; /* currently bonded */
-	u8 master:1; /* this is a master */
+	u8 primary:1; /* this is primary */
 	u8 handler:1; /* did we register a rx_netdev_handler */
 	/* each thing blocking bonding will increment this value by one.
 	 * If this value is zero, then bonding is allowed.
-- 
2.35.1

