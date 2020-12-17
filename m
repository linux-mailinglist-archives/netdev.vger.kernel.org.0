Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6F12DDB89
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732154AbgLQWfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:35:20 -0500
Received: from mga03.intel.com ([134.134.136.65]:25112 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732210AbgLQWfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 17:35:17 -0500
IronPort-SDR: hPyjbZSuDEtQ5BZ7sr0xuorJ4QhXyuOF8/i+YLaMDy/syA+iLVHXX2mvLLFSgXLr43LY94RxHh
 ekZbmfVD/izw==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="175444099"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="175444099"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 14:34:21 -0800
IronPort-SDR: sibp63mROQjv2xToGv3RjKabBiJeKnQbd+2rjEfbH4OMS/j6tb97rKJlXZR/nagX+r7VBcU8z4
 YQZC7INfI0QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="370133351"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2020 14:34:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net 0/2][pull request] Intel Wired LAN Driver Updates 2020-12-17
Date:   Thu, 17 Dec 2020 14:34:16 -0800
Message-Id: <20201217223418.3134992-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Sylwester fixes an issue where PF was not properly being rebuilt
following VF removal for i40e.

Jakub Kicinski fixes a double release of rtnl_lock on
iavf_lan_add_device() error for iavf.

The following are changes since commit 44d4775ca51805b376a8db5b34f650434a08e556:
  net/sched: sch_taprio: reset child qdiscs before freeing them
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Jakub Kicinski (1):
  iavf: fix double-release of rtnl_lock

Sylwester Dziedziuch (1):
  i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs

 drivers/net/ethernet/intel/i40e/i40e.h             |  3 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 10 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  4 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  4 +---
 4 files changed, 16 insertions(+), 5 deletions(-)

-- 
2.26.2

