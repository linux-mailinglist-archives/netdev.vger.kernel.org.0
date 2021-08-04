Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB433E0599
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhHDQNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:13:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:7118 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229820AbhHDQNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 12:13:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="193547320"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="193547320"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 09:11:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="569083321"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2021 09:11:14 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 3/4] net: wwan: iosm: correct data protocol mask bit
Date:   Wed,  4 Aug 2021 21:39:51 +0530
Message-Id: <20210804160952.70254-4-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct ul/dl data protocol mask bit to know which protocol capability
does device implement.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.h b/drivers/net/wwan/iosm/iosm_ipc_mmio.h
index 45e6923da78f..f861994a6d90 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.h
@@ -10,10 +10,10 @@
 #define IOSM_CP_VERSION 0x0100UL
 
 /* DL dir Aggregation support mask */
-#define DL_AGGR BIT(23)
+#define DL_AGGR BIT(9)
 
 /* UL dir Aggregation support mask */
-#define UL_AGGR BIT(22)
+#define UL_AGGR BIT(8)
 
 /* UL flow credit support mask */
 #define UL_FLOW_CREDIT BIT(21)
-- 
2.25.1

