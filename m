Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63D0668EC4
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241077AbjAMHDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241075AbjAMHCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:02:42 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3483F72D38
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673592635; x=1705128635;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=azzSjfiS8JW8TRsrRsEric/+iTuGrHz6TiqdBGzypA0=;
  b=CxtdHTLdabILpIm89TiIjVYUTjeV3lnNS7h13igqL4xMMQ9R8ndpPd40
   +glkXt6qSuvj+MuPefrHeq6iH2kCMy4yYA7YSmm6vKkCE+ih5MMz4WImQ
   9g42B7vh2F4kczJAdpsPbIGa6a37pmv57mIPjD1wX/WxTu9nLYPxjA8UM
   N9zGPxP8ufoaT7xh2MiKuDvEmAoTV1bVPeXxDLsjc0Q6IN/hUwp3aK3iL
   ylljOULhQDkjna0vDnSMYGdXyniI4TiwdF3VH+fY1S1RBvt+djpAqJ37z
   Dy6CR5y81uJFgQMmcnnUx1DIqB+uq10IA7mrzyDmytHX3Cpcw/OpLKdHe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="304311171"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="304311171"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 22:50:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="746834388"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="746834388"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jan 2023 22:50:32 -0800
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH 1/1] ice: Add the CEE DCBX support in the comments
Date:   Fri, 13 Jan 2023 18:19:12 -0500
Message-Id: <20230113231912.22423-1-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

From the function ice_parse_org_tlv, CEE DCBX TLV is also supported.
The comments are changed.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 6be02f9b0b8c..7964405efa77 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -566,7 +566,7 @@ ice_parse_cee_tlv(struct ice_lldp_org_tlv *tlv, struct ice_dcbx_cfg *dcbcfg)
  * @tlv: Organization specific TLV
  * @dcbcfg: Local store to update ETS REC data
  *
- * Currently only IEEE 802.1Qaz TLV is supported, all others
+ * Currently IEEE 802.1Qaz and CEE DCBX TLV are supported, others
  * will be returned
  */
 static void
@@ -585,7 +585,7 @@ ice_parse_org_tlv(struct ice_lldp_org_tlv *tlv, struct ice_dcbx_cfg *dcbcfg)
 		ice_parse_cee_tlv(tlv, dcbcfg);
 		break;
 	default:
-		break;
+		break; /* Other OUIs not supported */
 	}
 }
 
-- 
2.27.0

