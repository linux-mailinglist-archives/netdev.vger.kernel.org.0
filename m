Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0418A474B59
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhLNS71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:59:27 -0500
Received: from mga05.intel.com ([192.55.52.43]:65190 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237253AbhLNS70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 13:59:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639508366; x=1671044366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iq8Jz43RgmONRh+i1pVwEybpn/d+7PKcK2yoCePU+0w=;
  b=k8m37YAFQ+kBlC8WFARDCl6wFiiPOG23fD2f4rwMobsnluVG6VjhRNny
   Y1eftyOQt7empWdmSSLmCXV81PKj0375SA6Koa2FisD658rde38ny1J7M
   UyWMueh6R9vKWTZcEzJ5n2JrYZ7T8GpNDjulDEKFPn3jvoxc2SfLU2gKX
   uW1pbYou+0Klv5OLN98xXRnC74uLcni7E9UGf1lPJNOlnxyky0YX1YRyF
   by3aN8aWBBRZWJnihPPS3vjf43NxFMLtuatVb6r2HU8MIRAyzrj/7TMm8
   d8C8lP7Q3qUsiWztYIwvU1ekzoKRpkcQXMDWu4QoCbjA8buUgWGoEoNag
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="325335076"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="325335076"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 10:30:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="583712813"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2021 10:30:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 12/12] ice: Remove unused ICE_FLOW_SEG_HDRS_L2_MASK
Date:   Tue, 14 Dec 2021 10:29:08 -0800
Message-Id: <20211214182908.1513343-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
References: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unused define ICE_FLOW_SEG_HDRS_L2_MASK.

Reported-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index b17b984196a2..2c5332953679 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -609,8 +609,6 @@ struct ice_flow_prof_params {
 	ICE_FLOW_SEG_HDR_ESP | ICE_FLOW_SEG_HDR_AH | \
 	ICE_FLOW_SEG_HDR_NAT_T_ESP)
 
-#define ICE_FLOW_SEG_HDRS_L2_MASK	\
-	(ICE_FLOW_SEG_HDR_ETH | ICE_FLOW_SEG_HDR_VLAN)
 #define ICE_FLOW_SEG_HDRS_L3_MASK	\
 	(ICE_FLOW_SEG_HDR_IPV4 | ICE_FLOW_SEG_HDR_IPV6 | ICE_FLOW_SEG_HDR_ARP)
 #define ICE_FLOW_SEG_HDRS_L4_MASK	\
-- 
2.31.1

