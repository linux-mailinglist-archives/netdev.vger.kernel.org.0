Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537C75452C2
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344614AbiFIRQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245301AbiFIRQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:16:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302F42C3699
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654794960; x=1686330960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xkp3RKxGFUboQodHb9UUh95hbFMgvtiNN+tsOLWQLj0=;
  b=ncPGOALQPMGBhoo6uhC4Q0/UrMAW/aoU7Um8SA7QOji2WRA/MWt1FkdL
   OMaTSvBmYS1PI34oh4zATKiIFBnsgRigaq7Ku0zL0RZuiJpI3XCOt+gQf
   TGhiZ58AUPldfUOcwVLUPdQMTQgBd91GHnmnVM0Uax+kT/m0reYVv5zkj
   UVQ6d0lpyfND1Q4kuRUDHwEKH/S2e+bcwjW6CS7yExjGOu5FjFF8tUq0/
   8JEZhQ1KYmQTIZM9WH/NHvAPyIRbbal7onaRxMj2nM8sAQOGJw/tvjBS6
   iN4Cr2LEeL0IO0VbwGBadebGxPpxXmJpEwTYzBvg65VMtScuLwcWvLKPv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="276124445"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="276124445"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 10:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="566487543"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2022 10:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 4/6] ixgb: Fix typos in comments
Date:   Thu,  9 Jun 2022 10:12:55 -0700
Message-Id: <20220609171257.2727150-5-anthony.l.nguyen@intel.com>
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
2.35.1

