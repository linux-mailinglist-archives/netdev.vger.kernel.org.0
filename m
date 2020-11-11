Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E72AE4D4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgKKAU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:20:28 -0500
Received: from mga17.intel.com ([192.55.52.151]:17132 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbgKKAU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 19:20:27 -0500
IronPort-SDR: PYOtaY/bcfRenN0oMdtMAAGerJR/xRdjzpFdeuBg+njVE6cE8qLOP6WfwqmGxBABMmAreZs/pr
 deJgr1o055dQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149921006"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149921006"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 16:20:26 -0800
IronPort-SDR: a+04rLSzNZNcElq/G9wnzJMw7yjVd9NTGNPD6iN03NE5I+3+UHc4dqlApPm23ALeaYGS4vrilT
 FZcKkLuXdpvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="366049061"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2020 16:20:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-11-10
Date:   Tue, 10 Nov 2020 16:19:51 -0800
Message-Id: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and igc drivers and the MAINTAINERS
file.

Slawomir fixes updating VF MAC addresses to fix various issues related
to reporting and setting of these addresses for i40e.

Dan Carpenter fixes a possible used before being initialized issue for
i40e.

Vinicius fixes reporting of netdev stats for igc.

Tony updates repositories for Intel Ethernet Drivers.

The following are changes since commit 989ef49bdf100cc772b3a8737089df36b1ab1e30:
  mptcp: provide rmem[0] limit
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Dan Carpenter (1):
  i40e, xsk: uninitialized variable in i40e_clean_rx_irq_zc()

Slawomir Laba (1):
  i40e: Fix MAC address setting for a VF via Host/VM

Tony Nguyen (1):
  MAINTAINERS: Update repositories for Intel Ethernet Drivers

Vinicius Costa Gomes (1):
  igc: Fix returning wrong statistics

 MAINTAINERS                                   |  4 +--
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 26 +++++++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 14 +++++-----
 4 files changed, 35 insertions(+), 11 deletions(-)

-- 
2.26.2

