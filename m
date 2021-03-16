Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC3133CBD2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 04:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhCPDPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 23:15:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:18301 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234773AbhCPDPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 23:15:38 -0400
IronPort-SDR: kuGmZLKnKdzNSdfQaKBLF9nNKjIn5ZZU6CZkgbplxk+f34sPSTHypxL379QqnVWbwG3SOJOfal
 XHqJ2rVylFZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="274233660"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="274233660"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 20:15:37 -0700
IronPort-SDR: raNSzNKT+UyzoQRx7DQP8tdu6N1WiWeTvJ4zLa9UvYcchurpmwWPfQgfHpW0r1COdnYFbwiurK
 7n+9S5xbPFfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="601672899"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 15 Mar 2021 20:15:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, kai.heng.feng@canonical.com,
        rjw@rjwysocki.net, len.brown@intel.com, todd.e.brandt@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        yu.c.chen@intel.com
Subject: [PATCH net-next v2 0/2][pull request] 1GbE Intel Wired LAN Driver Updates 2021-03-15
Date:   Mon, 15 Mar 2021 20:16:57 -0700
Message-Id: <20210316031659.3695692-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e only.

Chen Yu says:

The NIC is put in runtime suspend status when there is no cable connected.
As a result, it is safe to keep non-wakeup NIC in runtime suspended during
s2ram because the system does not rely on the NIC plug event nor WoL to
wake up the system. Besides that, unlike the s2idle, s2ram does not need to
manipulate S0ix settings during suspend.

v2: remove __maybe_unused from e1000e_pm_prepare()

The following are changes since commit 2117fce81f6b862aac0673abe8df0c60dca64bfa:
  Merge branch 'psample-Add-additional-metadata-attributes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Chen Yu (2):
  e1000e: Leverage direct_complete to speed up s2ram
  e1000e: Remove the runtime suspend restriction on CNP+

 drivers/net/ethernet/intel/e1000e/netdev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.26.2

