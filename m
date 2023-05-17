Return-Path: <netdev+bounces-3407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9685D706EEA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 220EF1C20FAC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C992C747;
	Wed, 17 May 2023 16:59:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77D3442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:59:26 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C1B8A69
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684342762; x=1715878762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ICSyv53HwIS7yo9AW+hpVTuXanncxW48c84fxWphxQ=;
  b=bho/9yMZ/YzbcoCVHfjUvR2xF8fIujpeE6bCQ7bfdkqHwnM7Y1tW/hAd
   5309LavnJe/dNRZWTsxxxI9HMXuAIS0Wy3l80ezbsh3Zln3FOtoG3hu1D
   2+Y5BAoWS0Czq6fUD3hcOhcMoZDoqzvhLZhJ4/iFu1RcYnakrtgTRFhCS
   HbxitqLqvmGW+IsEvLv/1kXgJzowbZzJse3aL6qZ4qvzUrT+m8RaK5Pza
   3zNLSKaCLFZG5Z417v4XrCwdZ4cX3JzgMazTG4gQp5xPinEMs9P/afyCG
   y+5+JK66O5k1JjfqCStIHus3VG8EnYqYH8m2LbAZeF7pj7vp+98da9PwP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380011542"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="380011542"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 09:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704876767"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="704876767"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 09:59:16 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Paul Greenwalt <paul.greenwalt@intel.com>,
	anthony.l.nguyen@intel.com,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next 1/5] ice: update ICE_PHY_TYPE_HIGH_MAX_INDEX
Date: Wed, 17 May 2023 09:55:26 -0700
Message-Id: <20230517165530.3179965-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
References: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Paul Greenwalt <paul.greenwalt@intel.com>

ICE_PHY_TYPE_HIGH_MAX_INDEX should be the maximum index value and not the
length/number of ICE_PHY_TYPE_HIGH. This is not an issue because this
define is only used when calling ice_get_link_speed_based_on_phy_type(),
which will return ICE_AQ_LINK_SPEED_UNKNOWN for any invalid index. The
caller of ice_get_link_speed_based_on_phy_type(), ice_update_phy_type()
checks that the return value is a valid link speed before using it and
ICE_AQ_LINK_SPEED_UNKNOWN is not. However, update the define to reflect
the correct value.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 838d9b274d68..63d3e1dcbba5 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1087,7 +1087,7 @@ struct ice_aqc_get_phy_caps {
 #define ICE_PHY_TYPE_HIGH_100G_CAUI2		BIT_ULL(2)
 #define ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC	BIT_ULL(3)
 #define ICE_PHY_TYPE_HIGH_100G_AUI2		BIT_ULL(4)
-#define ICE_PHY_TYPE_HIGH_MAX_INDEX		5
+#define ICE_PHY_TYPE_HIGH_MAX_INDEX		4
 
 struct ice_aqc_get_phy_caps_data {
 	__le64 phy_type_low; /* Use values from ICE_PHY_TYPE_LOW_* */
-- 
2.38.1


