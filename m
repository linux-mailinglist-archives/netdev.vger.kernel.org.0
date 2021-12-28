Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D9B480C82
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 19:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbhL1SZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 13:25:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:29449 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhL1SZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 13:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640715905; x=1672251905;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9sH+wGcABgORGWi4PwMUgkxSBDftHsnC0PzfnHWynf8=;
  b=IX923tAfxPVYJARlwf00b7Rsjfwrk/j2bN0PdAie1bXtC72o1ImYUhUt
   QVuAfFKeX8BK7wP3tXvGX/4m0QeQHWkUuShIv98vOy15wjXufqO3bpjcD
   b/8637eyP+nY2IMYuomEMLX6ZxHG9uaKdaqNVAi5qDhwX/rxKx94q/c43
   cHOY3t7/dOuxgg2gS+Gj1lRVUaJF1DJYtfsZQgP9JRBsVODBLv8tVlENI
   RP7wq9dv+y3o+RX4Y+huFY9Z5+YE9h9dTrMjxbDUbX/aJrpn0QpeS9mmc
   WdTxc8JGyCjmftAu/wohLJIiTJFJvx7UqwiVe/MwvytwSu1bTY+jH0qDL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="241206669"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="241206669"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 10:25:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="666075951"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 28 Dec 2021 10:25:04 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-12-28
Date:   Tue, 28 Dec 2021 10:24:19 -0800
Message-Id: <20211228182421.340354-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Vinicius disables support for crosstimestamp on i225-V as lockups are being
observed.

James McLaughlin fixes Tx timestamping support on non-MSI-X platforms.

The following are changes since commit 16fa29aef7963293f8792789210002ec9f9607ac:
  Merge branch 'smc-fixes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

James McLaughlin (1):
  igc: Fix TX timestamp support for non-MSI-X platforms

Vinicius Costa Gomes (1):
  igc: Do not enable crosstimestamping for i225-V models

 drivers/net/ethernet/intel/igc/igc_main.c |  6 ++++++
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

-- 
2.31.1

