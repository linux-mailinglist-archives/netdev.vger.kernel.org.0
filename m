Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78A63E4A88
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhHIRLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:11:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:27772 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229877AbhHIRLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 13:11:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="236736368"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="236736368"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 10:10:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="570519339"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 09 Aug 2021 10:10:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-08-09
Date:   Mon,  9 Aug 2021 10:13:58 -0700
Message-Id: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Ani prevents the ice driver from accidentally being probed to a virtual
function and stops processing of VF messages when VFs are being torn
down.

Brett prevents the ice driver from deleting is own MAC address.

Fahad ensures the RSS LUT and key are always set following reset for
iavf.

The following are changes since commit d09c548dbf3b31cb07bba562e0f452edfa01efe3:
  net: sched: act_mirred: Reset ct info when mirror/redirect skb
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anirudh Venkataramanan (2):
  ice: Prevent probing virtual functions
  ice: Stop processing VF messages during teardown

Brett Creeley (1):
  ice: don't remove netdev->dev_addr from uc sync list

Md Fahad Iqbal Polash (1):
  iavf: Set RSS LUT and key in reset handle path

 drivers/net/ethernet/intel/iavf/iavf_main.c   | 13 +++++----
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 28 +++++++++++++------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  7 +++++
 4 files changed, 36 insertions(+), 13 deletions(-)

-- 
2.26.2

