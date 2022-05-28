Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8388536CE7
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 14:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355873AbiE1MdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 08:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355011AbiE1MdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 08:33:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9029167C4
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 05:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653741191; x=1685277191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OSPAZxxv37pqTzJAcaSeIjrOLXfsZ/RNRjVK/H4Q9KI=;
  b=l7VH/dzHD92l9mpz5NTbbpwAqD+n4xRMxnrbNlt3N8Dplb41I0Clfcp/
   l9GqEzeVUWMFarAraI0KGhBpfTzpKO4DY1duz6azKv2nONITdYLhMw9k2
   1c0Bliuwdlg5x9zUbtqSNBrlxpFEAymWQ3TE/n/jF7fLQJu3ViBi6r0+e
   gvfwGpI7onI0E4/Xg2c74k8tuDWyPpJRDq9UgeDQIqMFqfeH3w3NXirF7
   ncFoZ3DGix40p8LI8EEeHb1mfTlOit4GBcFbv/OCrc7bVD2+YILCf3BG8
   KedsGOHUN9qKfo8lTAo9HBHR13Wm6BrOmAWQEHoEkgrgEFG2vFsM8Owzf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10360"; a="335321208"
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="335321208"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:11 -0700
X-IronPort-AV: E=Sophos;i="5.91,258,1647327600"; 
   d="scan'208";a="604391834"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 05:33:10 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 1/3] e1000: Fix typos in comments
Date:   Sat, 28 May 2022 20:31:21 +0800
Message-Id: <20220528123123.1851519-2-jiaqing.zhao@linux.intel.com>
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
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 1042e79a1397..f8860f24ede0 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -4376,7 +4376,7 @@ void e1000_rar_set(struct e1000_hw *hw, u8 *addr, u32 index)
 /**
  * e1000_write_vfta - Writes a value to the specified offset in the VLAN filter table.
  * @hw: Struct containing variables accessed by shared code
- * @offset: Offset in VLAN filer table to write
+ * @offset: Offset in VLAN filter table to write
  * @value: Value to write into VLAN filter table
  */
 void e1000_write_vfta(struct e1000_hw *hw, u32 offset, u32 value)
@@ -4396,7 +4396,7 @@ void e1000_write_vfta(struct e1000_hw *hw, u32 offset, u32 value)
 }
 
 /**
- * e1000_clear_vfta - Clears the VLAN filer table
+ * e1000_clear_vfta - Clears the VLAN filter table
  * @hw: Struct containing variables accessed by shared code
  */
 static void e1000_clear_vfta(struct e1000_hw *hw)
-- 
2.34.1

