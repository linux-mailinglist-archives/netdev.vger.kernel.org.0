Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B043D3E2B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhGWQ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:26:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:18036 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhGWQ0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:26:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="210027942"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="210027942"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:07:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="502586205"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2021 10:07:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2021-07-23
Date:   Fri, 23 Jul 2021 10:10:18 -0700
Message-Id: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Arkadiusz corrects the order of calls for disabling queues to resolve
a false error message and adds a better message to the user when
transitioning FW LLDP back on while the firmware is still processing
the off request.

Lukasz adds additional information regarding possible incorrect cable
use when a PHY type error occurs.

Jedrzej adds ndo_select_queue support to resolve incorrect queue
selection when SW DCB is used and adds a warning when there are not
enough queues for desired TC configuration.

The following are changes since commit 9f42f674a89200d4f465a7db6070e079f3c6145f:
  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Arkadiusz Kubalewski (2):
  i40e: Fix logic of disabling queues
  i40e: Fix firmware LLDP agent related warning

Jedrzej Jagielski (2):
  i40e: Fix queue-to-TC mapping on Tx
  i40e: Fix log TC creation failure when max num of queues is exceeded

Lukasz Cieplicki (1):
  i40e: Add additional info to PHY type error

 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 61 +++++++++++--------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 50 +++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +
 4 files changed, 94 insertions(+), 25 deletions(-)

-- 
2.26.2

