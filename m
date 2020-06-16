Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DB91FC1E3
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgFPWyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:54:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:27234 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgFPWyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 18:54:04 -0400
IronPort-SDR: siqQHxaBbGD2X9EI5S4wseZYWjqCxBLNlqPLPUoiBnb6GHrqf8IFAhRfusqkbIXXgwG1cSEFSZ
 yTLGzQVr20Qg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 15:54:02 -0700
IronPort-SDR: sIMCboB6Vz41MgnMYXqOtZC0lEZiJ6NQXG8n/RFYM4ixjrOl1r4FwC/myFwqY1AB9BOJyBDlIl
 3tMPQ80CKmHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,520,1583222400"; 
   d="scan'208";a="317362141"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2020 15:53:55 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 0/3][pull request] Intel Wired LAN Driver Updates 2020-06-16
Date:   Tue, 16 Jun 2020 15:53:51 -0700
Message-Id: <20200616225354.2744572-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to e1000 and e1000e.

Chen fixes an e1000e issue where systems could be waken via WoL, even
though the user has disabled the wakeup bit via sysfs.

Vaibhav Gupta updates the e1000 driver to clean up the legacy Power
Management hooks.

Arnd Bergmann cleans up the inconsistent use CONFIG_PM_SLEEP
preprocessor tags, which also resolves the compiler warnings about the
possibility of unused structure.

The following are changes since commit b8ad540dd4e40566c520dff491fc06c71ae6b989:
  mptcp: fix memory leak in mptcp_subflow_create_socket()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 1GbE

Arnd Bergmann (1):
  e1000e: fix unused-function warning

Chen Yu (1):
  e1000e: Do not wake up the system via WOL if device wakeup is disabled

Vaibhav Gupta (1):
  e1000: use generic power management

 drivers/net/ethernet/intel/e1000/e1000_main.c | 49 +++++--------------
 drivers/net/ethernet/intel/e1000e/netdev.c    | 30 ++++++------
 2 files changed, 28 insertions(+), 51 deletions(-)

-- 
2.26.2

