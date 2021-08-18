Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE39B3F0A5A
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhHRRjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:39:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:31099 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhHRRjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 13:39:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="280123020"
X-IronPort-AV: E=Sophos;i="5.84,332,1620716400"; 
   d="scan'208";a="280123020"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 10:38:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,332,1620716400"; 
   d="scan'208";a="511317134"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2021 10:38:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-08-18
Date:   Wed, 18 Aug 2021 10:42:15 -0700
Message-Id: <20210818174217.4138922-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Arkadiusz fixes Flow Director not using the correct queue due to calling
the wrong pick Tx function for i40e.

Sylwester resolves traffic loss for iavf when it attempts to change its
MAC address when it does not have permissions to do so.

The following are changes since commit a786e3195d6af183033e86f0518ffd2c51c0e8ac:
  net: asix: fix uninit value bugs
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Fix ATR queue selection

Sylwester Dziedziuch (1):
  iavf: Fix ping is lost after untrusted VF had tried to change MAC

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  3 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  1 +
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 47 ++++++++++++++++++-
 4 files changed, 48 insertions(+), 4 deletions(-)

-- 
2.26.2

