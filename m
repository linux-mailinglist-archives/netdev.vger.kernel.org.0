Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C779B3B93B1
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhGAPKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:10:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:1118 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233059AbhGAPKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 11:10:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="195839759"
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="195839759"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 08:07:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,314,1616482800"; 
   d="scan'208";a="642103649"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by fmsmga006.fm.intel.com with ESMTP; 01 Jul 2021 08:07:23 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH V2 0/5] net: wwan: iosm: fixes
Date:   Thu,  1 Jul 2021 20:36:23 +0530
Message-Id: <20210701150623.1004950-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains IOSM Driver fixes and details are
are mentioned below.

Patch1: Corrects uevent reporting format key=value pair.
Patch2: Removes redundant IP session checks.
Patch3: Correct link-Id number to be in sycn with MBIM session Id.
Patch4: Update netdev tx stats.
Patch5: Set netdev default mtu size.

Changes since V1:
* Patch4: Backup skb->len to local var & use same for updating tx_bytes.

---
M Chetan Kumar (5):
  net: wwan: iosm: fix uevent reporting
  net: wwan: iosm: remove reduandant check
  net: wwan: iosm: correct link-id handling
  net: wwan: iosm: fix netdev tx stats
  net: wwan: iosm: set default mtu

 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c  | 21 ++++-----------------
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h  |  6 +++---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_uevent.c    |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c      | 11 ++++++++---
 5 files changed, 17 insertions(+), 25 deletions(-)

-- 
2.25.1

