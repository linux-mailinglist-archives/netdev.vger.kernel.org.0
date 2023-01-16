Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4358366B58E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 03:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjAPCXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 21:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjAPCXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 21:23:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058EA6A70
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 18:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673835784; x=1705371784;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zSspbzPOerkJVpTB4SrCceZZpws3n9Kul9ZMusgzDi0=;
  b=HD9VMB3dI+4rfJ7iXz9ZW+3qNQREtnJEUvNFMFEAkbTkEqDpdDcnVBEZ
   8uDRCJY8YixehQW/KP6qZZr46UDX5kCJ/fvh5cUT21ygPvTE/ZQwu/4xA
   2hhqUfhNzd07GyNxuUi1KmGjzjoBH/qXaRVYiloWQu3DxvHseBAeH0uFE
   FE7sdABFKwVJU7gH1xd03asFde/xO8EbqYqGnOGXRCpxOH4Wwpp6Rtgxe
   wqmKTdhFTgumPcojdUXhV0UUl2mA7/LqgE2h3sIONPx8b7p6PqYPhztX6
   m/LKbcyEWluNLNBljkN4jNhmi6HoKemShSMeNUIN/Mo4FzDQPhlsT6mJ8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="322063128"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="322063128"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2023 18:23:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="658858854"
X-IronPort-AV: E=Sophos;i="5.97,219,1669104000"; 
   d="scan'208";a="658858854"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga002.jf.intel.com with ESMTP; 15 Jan 2023 18:23:00 -0800
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH 1/1] ice: Mention CEE DCBX in code comment
Date:   Mon, 16 Jan 2023 13:51:31 -0500
Message-Id: <20230116185131.63315-1-yanjun.zhu@intel.com>
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
So update the comment. Or else, it is confusing.

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

