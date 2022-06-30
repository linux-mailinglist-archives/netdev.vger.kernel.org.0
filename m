Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1F656255C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbiF3Vfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237617AbiF3Vff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A942753D3F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624930; x=1688160930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bdFxM252hKGFixtBwHYTtROqs51haKT32trLGtPRCHU=;
  b=mt1sLfnOKf+i0PNILDixFdQsd2/tvu3Rsi/P9OWVfSaGoEcs/gfWPvhQ
   K5wkXYXAzD1HTKUIatBzznA8I1sSzo5cKRn+AWPNEX5J5df4itWXGoh5V
   cK6KDzbEl8zEhlUOYrEUq1qTjecuHpRVWEriIzQPvXFFgNyVvYD5J3zK+
   k99aV1sa3/h4w7ibI9+tpyWTUgg2bt38Mmfj6P2YSksMb39mkSNlbKrNS
   QuneRLsec7U3nXE7OL1rKCxXB2+thPXUdvo6PFsDFPKlDxkPg6Hsi3Qsk
   13AcEBLKtOCXYQuv9BpHrZFZTqWR2jyakP61o6CvSSNr1FPuzaBm8rJ3U
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507759"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507759"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771849"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jilin Yuan <yuanjilin@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 12/15] intel/igbvf:fix repeated words in comments
Date:   Thu, 30 Jun 2022 14:32:05 -0700
Message-Id: <20220630213208.3034968-13-anthony.l.nguyen@intel.com>
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

Delete the redundant word 'on'.
Delete the redundant word 'slot'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igbvf/igbvf.h  | 2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/igbvf.h b/drivers/net/ethernet/intel/igbvf/igbvf.h
index 975eb47ee04d..57d39ee00b58 100644
--- a/drivers/net/ethernet/intel/igbvf/igbvf.h
+++ b/drivers/net/ethernet/intel/igbvf/igbvf.h
@@ -227,7 +227,7 @@ struct igbvf_adapter {
 
 	/* The VF counters don't clear on read so we have to get a base
 	 * count on driver start up and always subtract that base on
-	 * on the first update, thus the flag..
+	 * the first update, thus the flag..
 	 */
 	struct e1000_vf_stats stats;
 	u64 zero_base;
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 43ced78c3a2e..f4e91db89fe5 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2537,7 +2537,7 @@ static pci_ers_result_t igbvf_io_error_detected(struct pci_dev *pdev,
 		igbvf_down(adapter);
 	pci_disable_device(pdev);
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-- 
2.35.1

