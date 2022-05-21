Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2A052FB42
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354886AbiEULNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354793AbiEULMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:39 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACD036E23;
        Sat, 21 May 2022 04:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h9/JLNwcfi/UY5XpGVBvv5kFeV8RXwx4GEz/iaYQX+U=;
  b=cKB/R5Gfg8TWn1SfPypRD8jrZI/29M4NQMYtmp85N2SNBeg6kCETahRa
   qlxV7ugiJEmc6zNaX3bslOXg710vAiTVVTX1zJ7kkqXFV1PALXp6GcTs/
   lQkckbvWFuJ7qlGgv0/IUrRuXDKGIBMV082QG41d/fO5pZIj6lHT7hQI9
   4=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727951"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:12:01 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     kernel-janitors@vger.kernel.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/ethernet/intel: fix typos in comments
Date:   Sat, 21 May 2022 13:11:00 +0200
Message-Id: <20220521111145.81697-50-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling mistakes (triple letters) in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c   |    2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c       |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index 30ca9ee1900b..f2fba6e1d0f7 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -1825,7 +1825,7 @@ static void fm10k_sm_mbx_process_error(struct fm10k_mbx_info *mbx)
 		fm10k_sm_mbx_connect_reset(mbx);
 		break;
 	case FM10K_STATE_CONNECT:
-		/* try connnecting at lower version */
+		/* try connecting at lower version */
 		if (mbx->remote) {
 			while (mbx->local > 1)
 				mbx->local--;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 454e01ae09b9..70961c0343e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2403,7 +2403,7 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
 				agg_id);
 			return;
 		}
-		/* aggregator node is created, store the neeeded info */
+		/* aggregator node is created, store the needed info */
 		agg_node->valid = true;
 		agg_node->agg_id = agg_id;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 3e74ab82868b..3f5ef5269bb2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -77,7 +77,7 @@ static int __ixgbe_enable_sriov(struct ixgbe_adapter *adapter,
 	IXGBE_WRITE_REG(hw, IXGBE_PFDTXGSWC, IXGBE_PFDTXGSWC_VT_LBEN);
 	adapter->bridge_mode = BRIDGE_MODE_VEB;
 
-	/* limit trafffic classes based on VFs enabled */
+	/* limit traffic classes based on VFs enabled */
 	if ((adapter->hw.mac.type == ixgbe_mac_82599EB) && (num_vfs < 16)) {
 		adapter->dcb_cfg.num_tcs.pg_tcs = MAX_TRAFFIC_CLASS;
 		adapter->dcb_cfg.num_tcs.pfc_tcs = MAX_TRAFFIC_CLASS;

