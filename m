Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D42457628
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhKSSRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:17:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:52700 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhKSSRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 13:17:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="221683610"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="221683610"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 10:14:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="508004002"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 19 Nov 2021 10:14:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-11-19
Date:   Fri, 19 Nov 2021 10:12:39 -0800
Message-Id: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Nitesh prevents user from changing interrupt settings when adaptive
interrupt moderation is on.

Jedrzej resolves a hang that occurred when interface was closed while a
reset was occurring and fixes statistics to be updated when requested to
prevent stale values.

Brett adjusts driver to accommodate changes in supported VLAN features
that could occur during reset and cause various errors to be reported.

The following are changes since commit 0f296e782f21dc1c55475a3c107ac68ab09cc1cf:
  stmmac_pci: Fix underflow size in stmmac_rx
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Brett Creeley (1):
  iavf: Fix VLAN feature flags after VFR

Jedrzej Jagielski (2):
  iavf: Fix deadlock occurrence during resetting VF interface
  iavf: Fix refreshing iavf adapter stats on ethtool request

Nitesh B Venkatesh (1):
  iavf: Prevent changing static ITR values if adaptive moderation is on

 drivers/net/ethernet/intel/iavf/iavf.h        |  3 +
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 33 +++++++++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 58 ++++++++++++-------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 47 ++++++++++++++-
 4 files changed, 112 insertions(+), 29 deletions(-)

-- 
2.31.1

