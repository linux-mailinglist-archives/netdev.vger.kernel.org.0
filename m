Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39A05452C0
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343784AbiFIRQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244311AbiFIRQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:16:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751CEC50BC
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654794959; x=1686330959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cHPBJ6V0IvAWwSGFppRmDZpqR+HYpQpRif0JvcVK+oc=;
  b=UVGg2IksGq7VVkDkeNswCYGA5WVXRya5Y7SbXoF6lfGRGDjtL97k4TBo
   LKaL3//FbrYrnR2zrt9AYkTjWbdfB+eswZmyfCMnjt9cLdIlkxbTlAi0f
   Je9Twmua96kJ4vhdp5g8sZv8+WjYVUQWrrNQ5wNUVehVmD5UnfqXSYwxD
   MPkdYGZB0yCup8hhxLO5SVe6fQE/T+Pdxt4bJa0+bzV6WJ4tRLUEGoQuD
   aPeu7HxsMumGeNGLrPh55DsT/cbkDNkbit+TIkE6zZhPOTXuCKSFlSqAL
   2ka71YqFThZvM2LDWLpCCcCiCCOHDodAuB9V7bCiYO5RiKhyS6xH3miEh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="276124440"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="276124440"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 10:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="566487537"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2022 10:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 2/6] igb: Remove duplicate defines
Date:   Thu,  9 Jun 2022 10:12:53 -0700
Message-Id: <20220609171257.2727150-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609171257.2727150-1-anthony.l.nguyen@intel.com>
References: <20220609171257.2727150-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

There's no need to define same thing twice.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_defines.h | 3 ---
 drivers/net/ethernet/intel/igb/e1000_regs.h    | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_defines.h b/drivers/net/ethernet/intel/igb/e1000_defines.h
index ca5429774994..fa028928482f 100644
--- a/drivers/net/ethernet/intel/igb/e1000_defines.h
+++ b/drivers/net/ethernet/intel/igb/e1000_defines.h
@@ -1033,9 +1033,6 @@
 #define E1000_VFTA_ENTRY_MASK                0x7F
 #define E1000_VFTA_ENTRY_BIT_SHIFT_MASK      0x1F
 
-/* DMA Coalescing register fields */
-#define E1000_PCIEMISC_LX_DECISION      0x00000080 /* Lx power on DMA coal */
-
 /* Tx Rate-Scheduler Config fields */
 #define E1000_RTTBCNRC_RS_ENA		0x80000000
 #define E1000_RTTBCNRC_RF_DEC_MASK	0x00003FFF
diff --git a/drivers/net/ethernet/intel/igb/e1000_regs.h b/drivers/net/ethernet/intel/igb/e1000_regs.h
index 9cb49980ec2d..eb9f6da9208a 100644
--- a/drivers/net/ethernet/intel/igb/e1000_regs.h
+++ b/drivers/net/ethernet/intel/igb/e1000_regs.h
@@ -116,7 +116,6 @@
 #define E1000_DMCRTRH	0x05DD0 /* Receive Packet Rate Threshold */
 #define E1000_DMCCNT	0x05DD4 /* Current Rx Count */
 #define E1000_FCRTC	0x02170 /* Flow Control Rx high watermark */
-#define E1000_PCIEMISC	0x05BB8 /* PCIE misc config register */
 
 /* TX Rate Limit Registers */
 #define E1000_RTTDQSEL	0x3604 /* Tx Desc Plane Queue Select - WO */
-- 
2.35.1

