Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9305452C3
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiFIRQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245360AbiFIRQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:16:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659062C369A
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654794960; x=1686330960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dJ6fX6qEgIRqmojQz/Z7q2AHXD/ls+TuzE/aRNid0fg=;
  b=dKpr+Cp/Zmt42wLOR4I4b+GHCpdrhNCqOye+qlz8zhlpcjtmvyj1Aqi4
   xWu59d/XU/W+oQ+6fWNVhQlBFG5Gq0fDg5flc3d/cHSb+z3Munu5QLoRH
   OQHbJi5hGiA5a6kSRRxpAmMxy9yUbJLrU0cTqOC/I9/4MBiHF8hRcpmeA
   lic/whiLwozVuIjTvopwFJWLLlQe0ZlARD3MAcbkjcVQLOYpUYo5SbmoA
   GTC76HYp9Wqy+XNh3z/vMquOc28PiXNASTKd62l4pxTTFosNNJv6j7BlI
   29CyjmwltMx8IKoKFxIk+qCOC2z6gx6K88NJHZoTSYQatUtEhVzohj5HT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="276124447"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="276124447"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 10:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="566487546"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2022 10:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 5/6] ixgbe: Fix typos in comments
Date:   Thu,  9 Jun 2022 10:12:56 -0700
Message-Id: <20220609171257.2727150-6-anthony.l.nguyen@intel.com>
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

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

"VLAN filter" was misspelled as "VLAN filer" in some comments.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c  | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
index 95c92fe890a1..100388968e4d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
@@ -879,7 +879,7 @@ static s32 ixgbe_set_vfta_82598(struct ixgbe_hw *hw, u32 vlan, u32 vind,
  *  ixgbe_clear_vfta_82598 - Clear VLAN filter table
  *  @hw: pointer to hardware structure
  *
- *  Clears the VLAN filer table, and the VMDq index associated with the filter
+ *  Clears the VLAN filter table, and the VMDq index associated with the filter
  **/
 static s32 ixgbe_clear_vfta_82598(struct ixgbe_hw *hw)
 {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 4c26c4b92f07..38c4609bd429 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3237,7 +3237,7 @@ s32 ixgbe_set_vfta_generic(struct ixgbe_hw *hw, u32 vlan, u32 vind,
  *  ixgbe_clear_vfta_generic - Clear VLAN filter table
  *  @hw: pointer to hardware structure
  *
- *  Clears the VLAN filer table, and the VMDq index associated with the filter
+ *  Clears the VLAN filter table, and the VMDq index associated with the filter
  **/
 s32 ixgbe_clear_vfta_generic(struct ixgbe_hw *hw)
 {
-- 
2.35.1

