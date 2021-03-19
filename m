Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB60B3421A2
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhCSQSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:18:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:48297 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230046AbhCSQSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 12:18:35 -0400
IronPort-SDR: 4cyDx1jmPZOwlQYsiYMPZzn2FOXBmLUx+pb5Wo9GH8zSopa4TVGzntDxWIrgzkdM++5hlQzoDj
 MV6BpvN9q+iw==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="190014463"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="190014463"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 09:18:34 -0700
IronPort-SDR: 2/sdxqt0Hmk+BCH+Wirs5BNP1FDG2z8NoxR/NFkwCUcKBBWPHiXrkIgAnKG1uDKTqfMmDX5bTZ
 8xDezSc0fJ5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="450915169"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 09:18:34 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2021-03-19
Date:   Fri, 19 Mar 2021 09:19:54 -0700
Message-Id: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igb drivers.

Tom Seewald fixes duplicate guard issues by including the driver name in
the guard for e1000e and igb.

Jesse adds checks that timestamping is on and valid to avoid possible
issues with a misinterpreted time stamp for igb.

The following are changes since commit c79a707072fe3fea0e3c92edee6ca85c1e53c29f:
  net: cdc-phonet: fix data-interface release on probe failure
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Jesse Brandeburg (1):
  igb: check timestamp validity

Tom Seewald (2):
  e1000e: Fix duplicate include guard
  igb: Fix duplicate include guard

 drivers/net/ethernet/intel/e1000e/hw.h    |  6 ++---
 drivers/net/ethernet/intel/igb/e1000_hw.h |  6 ++---
 drivers/net/ethernet/intel/igb/igb.h      |  4 +--
 drivers/net/ethernet/intel/igb/igb_main.c | 11 ++++----
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 31 ++++++++++++++++++-----
 5 files changed, 38 insertions(+), 20 deletions(-)

-- 
2.26.2

