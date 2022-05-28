Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D3C536CE8
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 14:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355881AbiE1MdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 08:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355889AbiE1MdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 08:33:15 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8A320BE2
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 05:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653741194; x=1685277194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XBvauSL9Vi28ZrrgQphGN9OE84f0OiZZNwJpSV2vbak=;
  b=VSfwDAAeBEdzaALuz+AvW5A88iixylScF5ffWK5EzM/4jMl9WTzE5giz
   7YehGSbWrz0UnV15ORcijTs/+6k4MC4+XmAj3yCLWJQzJqaQLcLO0PlZr
   zOk9LsCrxvDF/QdtUsqV3NMTogXTC2XF5V5Zjlg2oJd6R1V5r2GaaFxKw
   6o1wDTiv2Vl728Z/CIzWoQ75kk5rAJzDWhyT+jHuVp+KdFxlAi+g+IuDI
   3jbqsRYOizaQMsjiPBu+s9eE4TnBCbyafprlQly++l84Swjl/TemZgR6P
   9FdHhVUbokKQoukOgTgzSQSI5amiwSfmt7c8ivmLDs++oKawGkk1uWomX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10360"; a="335321211"
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="335321211"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:14 -0700
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="604391851"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:13 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 3/3] ixgbe: Fix typos in comments
Date:   Sat, 28 May 2022 20:31:23 +0800
Message-Id: <20220528123123.1851519-4-jiaqing.zhao@linux.intel.com>
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
2.34.1

