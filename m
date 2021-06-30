Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4163B8869
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhF3S3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:29:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:17945 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233336AbhF3S3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 14:29:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="188092525"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="188092525"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 11:26:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="641802675"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2021 11:26:27 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 0/5] net: wwan: iosm: fixes
Date:   Wed, 30 Jun 2021 23:54:16 +0530
Message-Id: <20210630182415.3270-1-m.chetan.kumar@linux.intel.com>
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
 drivers/net/wwan/iosm/iosm_ipc_wwan.c      | 10 +++++++---
 5 files changed, 16 insertions(+), 25 deletions(-)

-- 
2.25.1

