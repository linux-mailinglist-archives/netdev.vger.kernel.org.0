Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C44358B6B
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhDHReS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:34:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:25282 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231566AbhDHReJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 13:34:09 -0400
IronPort-SDR: Jdg/ESnBNeH4+SfWZHUpc9Eb6PGoq7Pfrb7MwdLyHQujh9gDC/4OzG7bj12XIko1tQwTUOOr+G
 msoswdQHNB1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="181132904"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="181132904"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 10:33:57 -0700
IronPort-SDR: PHSrWv5VhObpkKEF+IhtKCnc4hII0UzpF64fw4dOyBNtM51coO0IAv/0ZYYfNLx1fntoscPEsh
 PYiO53izCFoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="422343441"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Apr 2021 10:33:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates 2021-04-08
Date:   Thu,  8 Apr 2021 10:35:31 -0700
Message-Id: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and ice drivers.

Grzegorz fixes the ordering of parameters to i40e_aq_get_phy_register()
which is causing incorrect information to be reported.

Arkadiusz fixes various sparse issues reported on the i40e driver.

Yongxin Liu fixes a memory leak with aRFS following resume from suspend
for ice driver.

The following are changes since commit 8a12f8836145ffe37e9c8733dce18c22fb668b66:
  net: hso: fix null-ptr-deref during tty device unregistration
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Arkadiusz Kubalewski (4):
  i40e: Fix sparse errors in i40e_txrx.c
  i40e: Fix sparse error: uninitialized symbol 'ring'
  i40e: Fix sparse error: 'vsi->netdev' could be null
  i40e: Fix sparse warning: missing error code 'err'

Grzegorz Siwik (1):
  i40e: Fix parameters in aq_get_phy_register()

Yongxin Liu (1):
  ice: fix memory leak of aRFS after resuming from suspend

 drivers/net/ethernet/intel/i40e/i40e_debugfs.c |  3 +++
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 11 +++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 12 +++++-------
 drivers/net/ethernet/intel/ice/ice_main.c      |  1 +
 5 files changed, 17 insertions(+), 12 deletions(-)

-- 
2.26.2

