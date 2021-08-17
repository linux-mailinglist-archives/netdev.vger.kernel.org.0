Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0430F3EF41B
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhHQUdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:33:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:49427 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhHQUdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 16:33:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216186349"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="216186349"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 13:32:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="488169511"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 17 Aug 2021 13:32:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/2][pull request] 40GbE Intel Wired LAN Driver Updates 2021-08-17
Date:   Tue, 17 Aug 2021 13:35:47 -0700
Message-Id: <20210817203549.3529860-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf and i40e drivers.

Stefan Assmann converts use of flag based locking of critical sections
to mutexes for iavf.

Colin King fixes a spelling error for i40e.

The following are changes since commit 752be2976405b7499890c0b6bac6d30d34d08bd6:
  selftests: net: improved IOAM tests
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Colin Ian King (1):
  i40e: Fix spelling mistake "dissable" -> "disable"

Stefan Assmann (1):
  iavf: use mutexes for locking of critical sections

 drivers/net/ethernet/intel/i40e/i40e_main.c   |   2 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   9 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 100 +++++++++---------
 4 files changed, 57 insertions(+), 64 deletions(-)

-- 
2.26.2

