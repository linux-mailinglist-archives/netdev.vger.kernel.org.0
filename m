Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5E0513AE2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350469AbiD1Rao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350490AbiD1Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570263E0E3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166837; x=1682702837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9jZppt5EAxLpDZjqNfsLcv/6B6HbDPijcpHT+xYeyiY=;
  b=Ksx29VnyEXYiriBcNClCSBa/Z34cxv+TooKc1obA+AorRd+tT3825uoz
   4VZ4w+008TpbQAydwFlJabjjF3jxE9AzcMPaWYuf5P3jqL4Xiy4SAb+zp
   7Ga3Dbglz3rzr7bFFf6kbXQdDNFkX6E182TnwAw557oDNnlHgsqYvlNHi
   C26H9NBFEr0H6nIQD1oiAHv0AQelBx/eLJG9VcqIicWbsS8A24sK01QnE
   1vy3y/O7d7GV9NsyUdhU4V8EUhELu0YLY1RRKlpr2GOjx4VNtGbsdXIfj
   uoD5FkH8vyG5FGS7AXEb5218abEqw02786jbbEfICEt09HbROkCZSqk8A
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306362"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306362"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497045"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH net-next 06/11] ice: add newline to dev_dbg in ice_vf_fdir_dump_info
Date:   Thu, 28 Apr 2022 10:24:25 -0700
Message-Id: <20220428172430.1004528-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The debug print in ice_vf_fdir_dump_info does not end in newlines. This can
look confusing when reading the kernel log, as the next print will
immediately continue on the same line.

Fix this by adding the forgotten newline.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 8e38ee2faf58..dbc1965c0609 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -1349,7 +1349,7 @@ static void ice_vf_fdir_dump_info(struct ice_vf *vf)
 
 	fd_size = rd32(hw, VSIQF_FD_SIZE(vsi_num));
 	fd_cnt = rd32(hw, VSIQF_FD_CNT(vsi_num));
-	dev_dbg(dev, "VF %d: space allocated: guar:0x%x, be:0x%x, space consumed: guar:0x%x, be:0x%x",
+	dev_dbg(dev, "VF %d: space allocated: guar:0x%x, be:0x%x, space consumed: guar:0x%x, be:0x%x\n",
 		vf->vf_id,
 		(fd_size & VSIQF_FD_CNT_FD_GCNT_M) >> VSIQF_FD_CNT_FD_GCNT_S,
 		(fd_size & VSIQF_FD_CNT_FD_BCNT_M) >> VSIQF_FD_CNT_FD_BCNT_S,
-- 
2.31.1

