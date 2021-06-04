Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917FE39BCF3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhFDQXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:23:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:53967 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhFDQXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:23:39 -0400
IronPort-SDR: r36nQZQ8ZD05CJ+vEHe3T+Xig/JH57V0zsJvPRwJdZeY6iB01Uhs4z/DTXla0ovldtWmPNCI5E
 jjXG5yKRdTAA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="184003814"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="184003814"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:21:52 -0700
IronPort-SDR: 1g7Na7vsc2h7OZnACgyfFAV+V2VK/HsdGjiVzjyXAwZ02Q3zF8cPJfBuCdylOL4I7U/NmBEjDT
 IK1zBvnhS7HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448309151"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 09:21:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com
Subject: [PATCH net-next 0/5][pull request] 1GbE Intel Wired LAN Driver Updates 2021-06-04
Date:   Fri,  4 Jun 2021 09:24:16 -0700
Message-Id: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Sasha utilizes the newly introduced ethtool_sprintf() function, removes
unused defines, and fixes indentation.

Muhammad adds support for hardware VLAN insertion and stripping.

The following are changes since commit ebbf5fcb94a7f3499747b282420a1c5f7e8d1c6f:
  netdevsim: Fix unsigned being compared to less than zero
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Muhammad Husaini Zulkifli (1):
  igc: Enable HW VLAN Insertion and HW VLAN Stripping

Sasha Neftin (4):
  igc: Update driver to use ethtool_sprintf
  igc: Remove unused asymmetric pause bit from igc defines
  igc: Remove unused MDICNFG register
  igc: Indentation fixes

 drivers/net/ethernet/intel/igc/igc.h         |  1 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  9 ++-
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 39 ++++-------
 drivers/net/ethernet/intel/igc/igc_main.c    | 74 +++++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_regs.h    |  2 +-
 5 files changed, 93 insertions(+), 32 deletions(-)

-- 
2.26.2

