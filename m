Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABF656255E
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbiF3Vfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbiF3Vfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A92553D3C
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624929; x=1688160929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mU06wmPzMvd7pf1CX7sfYUIrejdyJhsDJ2Y7GyVg6H8=;
  b=fqepFLmHKcYjNiwu6so5DoNCsbq3raiJkxT3aT5a872eD6P2mAi3Lli7
   JtPrhBMqVidM/5oNuIi5+s+BDxs72SaId2iBjscmRxPZXQ5zAC1lhEttW
   ofrNkvd9UugYC17VWkH1ctA1h55DcqunkxRyyF+9ZtrvZyh3/X8cbfSSE
   0ry2gixzldCHoXfVafHAvuelw038BqRoL5aOnVM0j2kQdat27TdOCBkmy
   pUMhLxrGz9Eo9Mf5uXTpnIR8VrihvyLv4grtQbObqmRLG2ssfsQEAT0Zu
   OeFc5x+Fkk2fhnCEjfaMAZEfyB5bjwUfUvaKlhGkft4i6T0K1vvxt2eRV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507756"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507756"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771844"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jilin Yuan <yuanjilin@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 11/15] intel/igb:fix repeated words in comments
Date:   Thu, 30 Jun 2022 14:32:04 -0700
Message-Id: <20220630213208.3034968-12-anthony.l.nguyen@intel.com>
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
Delete the redundant word 'set'.
Delete the redundant word 'slot'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_mac.c | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index 1277c5c7d099..205d577bdbba 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -854,7 +854,7 @@ s32 igb_force_mac_fc(struct e1000_hw *hw)
 	 *      1:  Rx flow control is enabled (we can receive pause
 	 *          frames but not send pause frames).
 	 *      2:  Tx flow control is enabled (we can send pause frames
-	 *          frames but we do not receive pause frames).
+	 *          but we do not receive pause frames).
 	 *      3:  Both Rx and TX flow control (symmetric) is enabled.
 	 *  other:  No other values should be possible at this point.
 	 */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index c5f04c40284b..4f91a85fe0cc 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1945,7 +1945,7 @@ static void igb_setup_tx_mode(struct igb_adapter *adapter)
 		 * However, when we do so, no frame from queue 2 and 3 are
 		 * transmitted.  It seems the MAX_TPKT_SIZE should not be great
 		 * or _equal_ to the buffer size programmed in TXPBS. For this
-		 * reason, we set set MAX_ TPKT_SIZE to (4kB - 1) / 64.
+		 * reason, we set MAX_ TPKT_SIZE to (4kB - 1) / 64.
 		 */
 		val = (4096 - 1) / 64;
 		wr32(E1000_I210_DTXMXPKTSZ, val);
@@ -9522,7 +9522,7 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
 		igb_down(adapter);
 	pci_disable_device(pdev);
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-- 
2.35.1

