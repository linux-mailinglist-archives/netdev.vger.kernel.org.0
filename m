Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8821222A164
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgGVVcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:32:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:4536 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgGVVcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:32:00 -0400
IronPort-SDR: vgGOnR0ZaFzjm+0nO7rhxU1GU8FrsGTtKYS9cQSqYEUz2MtO43I2pYolrOaqZOjMI62ZS5rS9b
 DOskIQlAYZjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137926753"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137926753"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:32:00 -0700
IronPort-SDR: gfLxMEDc5XnTFYsdBo6YDIe7snQY8ovNiv88Feadq+uU4vcv6vfr2p9n2ZCX60eRUnWlgnUWFg
 +Ke6sxvkC73Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284361343"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 14:31:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next 0/8][pull request] 1GbE Intel Wired LAN Driver Updates 2020-07-22
Date:   Wed, 22 Jul 2020 14:31:42 -0700
Message-Id: <20200722213150.383393-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Sasha cleans up double definitions, unneeded and non applicable
registers, and removes unused fields in structs. Ensures the Receive
Descriptor Minimum Threshold Count is cleared and fixes a static checker
error.

The following are changes since commit fa56a987449bcf4c1cb68369a187af3515b85c78:
  Merge branch 'ionic-updates'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Sasha Neftin (8):
  igc: Fix double definition
  igc: Add Receive Descriptor Minimum Threshold Count
  igc: Remove unneeded ICTXQMTC register
  igc: Fix registers definition
  igc: Remove ledctl_ fields from the mac_info structure
  igc: Clean up the mac_info structure
  igc: Clean up the hw_stats structure
  igc: Fix static checker warning

 drivers/net/ethernet/intel/igc/igc_hw.h   | 20 --------------------
 drivers/net/ethernet/intel/igc/igc_mac.c  | 12 ++----------
 drivers/net/ethernet/intel/igc/igc_main.c |  8 --------
 drivers/net/ethernet/intel/igc/igc_regs.h | 14 --------------
 4 files changed, 2 insertions(+), 52 deletions(-)

-- 
2.26.2

