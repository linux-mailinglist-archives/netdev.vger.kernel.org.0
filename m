Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43FE2504
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 23:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406262AbfJWVQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 17:16:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:37691 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406230AbfJWVQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 17:16:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 14:16:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,222,1569308400"; 
   d="scan'208";a="228266382"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 23 Oct 2019 14:16:26 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iNNzW-0008C1-73; Thu, 24 Oct 2019 05:16:26 +0800
Date:   Thu, 24 Oct 2019 05:15:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     kbuild-all@lists.01.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: [RFC PATCH] net: aquantia: aq_ptp_poll_sync_work_cb() can be static
Message-ID: <20191023211528.pfpfg27exmgcssga@4978f4969bb8>
References: <a2a6ecfb5580858c2a690fa0ed1c98cffc61c4b9.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2a6ecfb5580858c2a690fa0ed1c98cffc61c4b9.1571737612.git.igor.russkikh@aquantia.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 66eb1087d188 ("net: aquantia: add support for PIN funcs")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 aq_ptp.c           |    2 +-
 hw_atl/hw_atl_b0.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 3ec08415e53eb..d92d11919649d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -1375,7 +1375,7 @@ static int aq_ptp_check_sync1588(struct aq_ptp_s *aq_ptp)
 	return 0;
 }
 
-void aq_ptp_poll_sync_work_cb(struct work_struct *w)
+static void aq_ptp_poll_sync_work_cb(struct work_struct *w)
 {
 	struct delayed_work *dw = to_delayed_work(w);
 	struct aq_ptp_s *aq_ptp = container_of(dw, struct aq_ptp_s, poll_sync);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 51ecf87e01987..8f866c7af4c04 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1152,7 +1152,7 @@ static int hw_atl_b0_set_sys_clock(struct aq_hw_s *self, u64 time, u64 ts)
 	return hw_atl_b0_adj_sys_clock(self, delta);
 }
 
-int hw_atl_b0_ts_to_sys_clock(struct aq_hw_s *self, u64 ts, u64 *time)
+static int hw_atl_b0_ts_to_sys_clock(struct aq_hw_s *self, u64 ts, u64 *time)
 {
 	*time = self->ptp_clk_offset + ts;
 	return 0;
