Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A86233765
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgG3RJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:09:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:53573 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbgG3RJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 13:09:44 -0400
IronPort-SDR: 7H26Q+21jT4sJgB42ljmzG69q7CapvW8h6Im1N8G5GUHMmnzZ60UiRk0jhp4mDmaPgfNvZ3NiX
 YN8cHEtZT3+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149111762"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="149111762"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 10:09:43 -0700
IronPort-SDR: 5fCkZ6mIUDgibLYONj7QF5fwCeek7B7MGwhInpQ02+Q6alV6seisRgX/OXUP6VI5jXjZq7PXM9
 71Dql/o0pIGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="272979235"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2020 10:09:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net 0/2][pull request] Intel Wired LAN Driver Updates 2020-07-30
Date:   Thu, 30 Jul 2020 10:09:36 -0700
Message-Id: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the e1000e and igb drivers.

Aaron Ma allows PHY initialization to continue if ULP disable failed for
e1000e.

Francesco Ruggeri fixes race conditions in igb reset that could cause panics. 

The following are changes since commit 27a2145d6f826d1fad9de06ac541b1016ced3427:
  ibmvnic: Fix IRQ mapping disposal in error path
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 1GbE

Aaron Ma (1):
  e1000e: continue to init PHY even when failed to disable ULP

Francesco Ruggeri (1):
  igb: reinit_locked() should be called with rtnl_lock

 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 +---
 drivers/net/ethernet/intel/igb/igb_main.c   | 9 +++++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.26.2

