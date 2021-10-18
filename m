Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AA3432908
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhJRVa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:30:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:15066 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRVa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:30:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="291835771"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="291835771"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 14:28:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="493775455"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 18 Oct 2021 14:28:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, jakub.pawlak@intel.com,
        jan.sokolowski@intel.com, mateusz.palczewski@intel.com
Subject: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver Updates 2021-10-18
Date:   Mon, 18 Oct 2021 14:26:22 -0700
Message-Id: <20211018212625.2059527-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mateusz Palczewski says:

Use single state machine for driver initialization
and for service initialized driver. The init state
machine implemented in init_task() is merged
into the watchdog_task(). The init_task() function
is removed.

The following are changes since commit 041c61488236a5a84789083e3d9f0a51139b6edf:
  sfc: Fix reading non-legacy supported link modes
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Mateusz Palczewski (3):
  iavf: Refactor iavf state machine tracking
  iavf: Add __IAVF_INIT_FAILED state
  iavf: Combine init and watchdog state machines

 drivers/net/ethernet/intel/iavf/iavf.h        |  12 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 192 ++++++++----------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   2 +-
 3 files changed, 101 insertions(+), 105 deletions(-)

-- 
2.31.1

