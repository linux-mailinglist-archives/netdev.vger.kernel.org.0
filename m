Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6453142E114
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhJNSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:23:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:62163 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhJNSXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 14:23:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="226531104"
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="226531104"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 11:21:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="717815809"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2021 11:21:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-10-14
Date:   Thu, 14 Oct 2021 11:19:49 -0700
Message-Id: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Brett ensures RDMA nodes are removed during release and rebuild. He also
corrects fw.mgmt.api to include the patch number for proper
identification.

Dave stops ida_free() being called when an IDA has not been allocated.

Michal corrects the order of parameters being provided and the number of
entries skipped for UDP tunnels.

The following are changes since commit 1fcd794518b7644169595c66b1bfe726d1f498ab:
  icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (2):
  ice: Fix failure to re-add LAN/RDMA Tx queues
  ice: Print the api_patch as part of the fw.mgmt.api

Dave Ertman (1):
  ice: Avoid crash from unnecessary IDA free

Michal Swiatkowski (1):
  ice: fix getting UDP tunnel entry

 Documentation/networking/devlink/ice.rst       |  9 +++++----
 drivers/net/ethernet/intel/ice/ice_devlink.c   |  3 ++-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c |  4 ++--
 drivers/net/ethernet/intel/ice/ice_lib.c       |  9 +++++++++
 drivers/net/ethernet/intel/ice/ice_main.c      |  6 +++++-
 drivers/net/ethernet/intel/ice/ice_sched.c     | 13 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_sched.h     |  1 +
 7 files changed, 37 insertions(+), 8 deletions(-)

-- 
2.31.1

