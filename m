Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A56B244FCC
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 00:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgHNWR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 18:17:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:20045 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgHNWR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 18:17:59 -0400
IronPort-SDR: zPlXU5rWw7ezx/l1uwTSXCfIpIWgL3A97m3cOBb8bQewbPW9UzdWrsAqpi1STeFGbi1rQ3IdGV
 XXhcupxafCRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="172545041"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="172545041"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 15:17:58 -0700
IronPort-SDR: zMFaIQU0JNUIILfCo3Yd5RxopcttCyUCIOPvXJq+p4CR1HyNn11nV5u/XLWT6fSPtlm8iwrQFR
 tCsmeomo79dQ==
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="291857040"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 15:17:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net v2 0/3][pull request] Intel Wired LAN Driver Updates 2020-08-14
Date:   Fri, 14 Aug 2020 15:17:42 -0700
Message-Id: <20200814221745.666974-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and igc drivers.

Vinicius fixes an issue with PTP spinlock being accessed before
initialization.

Przemyslaw fixes an issue with trusted VFs seeing additional traffic.

Grzegorz adds a wait for pending resets on driver removal to prevent
null pointer dereference.

v2: Fix function parameter for hw/aq in patch 2. Fix fixes tag in patch
3.

The following are changes since commit a1d21081a60dfb7fddf4a38b66d9cef603b317a9:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Grzegorz Szczurek (1):
  i40e: Fix crash during removing i40e driver

Przemyslaw Patynowski (1):
  i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

Vinicius Costa Gomes (1):
  igc: Fix PTP initialization

 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 35 ++++++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  3 ++
 drivers/net/ethernet/intel/igc/igc_main.c     |  5 ++-
 drivers/net/ethernet/intel/igc/igc_ptp.c      |  2 --
 5 files changed, 33 insertions(+), 14 deletions(-)

-- 
2.26.2

