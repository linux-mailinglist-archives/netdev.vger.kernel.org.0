Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7D1536CE6
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 14:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355894AbiE1MdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 08:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355881AbiE1MdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 08:33:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AB420BDB
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 05:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653741193; x=1685277193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kTqxEHapl+wX9DZddm1wFNmrkuqZW8jiLDyrJBUDs74=;
  b=RrJudHXpYlX4xBUl3uPyPH0396OpvcPCLNRllobLoFN/D083kR2+zIBz
   SLIlV7Yf+h4Z06bYWzicvZqRfEPysFT50c87KhpK3obbnOqQl3EH3Sg7V
   6DEhMcmAX5Fwshnhrlm6hF6XxqsAma4eBpiPZb/snGroxcOCfsjU3Dtaj
   hUGfN9Vsx63itFYWRmcID6lvWt/DCFtylTrzmVykV1JU0sievBiVEESyo
   NVpnfPiBgepMxm3qbTIgLyVvFsI0KApXFb9g+6UMEQfRD4Gp0TqpueuNm
   4mMvMcJ3ad5Q4VXJKVwHtcCOZeaazPA7Q1E86EUO6v6q8HjnYe0L/vNAD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10360"; a="335321210"
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="335321210"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="604391840"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:11 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 2/3] ixgb: Fix typos in comments
Date:   Sat, 28 May 2022 20:31:22 +0800
Message-Id: <20220528123123.1851519-3-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528123123.1851519-1-jiaqing.zhao@linux.intel.com>
References: <20220528123123.1851519-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"VLAN filter" was misspelled as "VLAN filer" in some comments.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
---
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
index c8d1e815ec6b..98bd3267b99b 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
@@ -576,7 +576,7 @@ ixgb_rar_set(struct ixgb_hw *hw,
  * Writes a value to the specified offset in the VLAN filter table.
  *
  * hw - Struct containing variables accessed by shared code
- * offset - Offset in VLAN filer table to write
+ * offset - Offset in VLAN filter table to write
  * value - Value to write into VLAN filter table
  *****************************************************************************/
 void
@@ -588,7 +588,7 @@ ixgb_write_vfta(struct ixgb_hw *hw,
 }
 
 /******************************************************************************
- * Clears the VLAN filer table
+ * Clears the VLAN filter table
  *
  * hw - Struct containing variables accessed by shared code
  *****************************************************************************/
-- 
2.34.1

