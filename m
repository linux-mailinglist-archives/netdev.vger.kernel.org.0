Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FD947C626
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbhLUSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:16:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:10327 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241108AbhLUSQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110583; x=1671646583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XIoaRQG5m9YCdBSHUYanWmd7ZLVXRRioFHa0HpyI0Ks=;
  b=Ba2eruSljtZhUQBktGKZOVuphgS/pEMfQmEJIr1ph2amaPRPyZzX/nlh
   RNdckZuCQNNYNR0cLZAsaM9Gu+OTPXcfwE7kVT1iOfJgMj2xPcwyM34GM
   zKILjIb4qrdWwLwiOljW58eJnXfeLCa7eJXX34C/lWL4Z92teu/JPa/Ou
   B34YHtm/BYeEJ/k/SZB4XGchgb2b1CaqiQx3zGryBgzkk25kriThZdLgF
   7NmJ5UDH+e2i3H/8J0q6e6IP1I1l3M7ZNtByOL/Hg9yNDSHuBBdztJV6Z
   +SM3cVZyYwuOjTxRKEsj1IqJVTtFTNJvZqht+O4trE/qrEUzunoMgnmvD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240684217"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240684217"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557844"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 4/8] igc: Remove obsolete mask
Date:   Tue, 21 Dec 2021 10:01:56 -0800
Message-Id: <20211221180200.3176851-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

'IGC_CTRL_EXT_LINK_MODE_MASK' not in use. This patch comes to tidy up
obsolete define.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 8b9b7ec20da7..bf2c31d1549c 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -85,9 +85,6 @@
 
 #define IGC_WUFC_EXT_FILTER_MASK GENMASK(31, 8)
 
-/* Physical Func Reset Done Indication */
-#define IGC_CTRL_EXT_LINK_MODE_MASK	0x00C00000
-
 /* Loop limit on how long we wait for auto-negotiation to complete */
 #define COPPER_LINK_UP_LIMIT		10
 #define PHY_AUTO_NEG_LIMIT		45
-- 
2.31.1

