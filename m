Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8EA5452BE
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbiFIRQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244850AbiFIRQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:16:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6D61021DD
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 10:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654794959; x=1686330959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jYdAMLXMABR5XZFgJokDnmlV26lqlCZdhh0ngOvn2lE=;
  b=I51uvqftDmIo0DMrWED1sQwzTohL0Ni4CjyY2w2bmoACKlXhZ6tjU/0e
   HgRseYCppoOqATHVsCZouDt8VM9ReOSZT+cDQ3Y7NKdaogec9wj23QGiy
   ZXeeXBrAOjo6zbUXa+qzEQtNiS2Rn+18u881ioMy3k0oJbFkLYQkVuDGA
   i4feFLWoqwgG+rqB5BhrQ+1pzi5hXVdoJGkTgwX6KNYvcPiJWVBxxraLn
   2KiIdpEK1ShkFjLX3thTS/s3EDyWEhVZrJqCimrJttUqMkzcuTK6iVsXO
   NZM3jwvU+J/OEJCM7fNOcwNwDNHjmYIAOIvunbp3QZawZ18DCm3n6qKyY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="276124442"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="276124442"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 10:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="566487540"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2022 10:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 3/6] e1000: Fix typos in comments
Date:   Thu,  9 Jun 2022 10:12:54 -0700
Message-Id: <20220609171257.2727150-4-anthony.l.nguyen@intel.com>
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
2.35.1

