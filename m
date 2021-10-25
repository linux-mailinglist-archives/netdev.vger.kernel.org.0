Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF8343A554
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbhJYVAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:00:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:2993 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232036AbhJYVAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 17:00:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="209846549"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="209846549"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 13:58:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="446799551"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Oct 2021 13:58:03 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-10-25
Date:   Mon, 25 Oct 2021 13:56:20 -0700
Message-Id: <20211025205622.1967785-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Dave adds event handler for LAG NETDEV_UNREGISTER to unlink device from
link aggregate.

Yongxin Liu adds a check for PTP support during release which would
cause a call trace on non-PTP supported devices.

The following are changes since commit f7a1e76d0f608961cc2fc681f867a834f2746bce:
  net-sysfs: initialize uid and gid before calling net_ns_get_ownership
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Dave Ertman (1):
  ice: Respond to a NETDEV_UNREGISTER event for LAG

Yongxin Liu (1):
  ice: check whether PTP is initialized in ice_ptp_release()

 drivers/net/ethernet/intel/ice/ice_lag.c | 18 ++++--------------
 drivers/net/ethernet/intel/ice/ice_ptp.c |  3 +++
 2 files changed, 7 insertions(+), 14 deletions(-)

-- 
2.31.1

