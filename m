Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6E064E47A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiLOXIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLOXIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:08:48 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E97D2253B
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 15:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671145727; x=1702681727;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EzQjB7zSLbvMCySCdrNliuCve1WIytA4wKOqtgfSfrg=;
  b=BuRxVtTAjHDQELn4swMZLIVtgsO0ZTu3ujr7bHmgugazy4AVxc4/Lt5m
   meblWuHzVmUCgd7JK8VM5OrqUdWCeFQcYdrfGJLVmaXI3rPMPLk1m99Oz
   WB0o8+Ywf9hqnpjJ8epiuR6ZHC5xcnl8Sw/8MQ6wvxlbsr9FnyWFQfw6g
   OTvh965Zs3rIIG01xaKvQkEVS8N3uesJ6r4xd1AjmzYL/ubk9PlGNKrjM
   oI936aYbrWDBpzOcHV0aD8osgmiUANyYzreMUdczZH3B9bGVryK6gx5Xt
   MGfp/+iDVIhjpqvU0YoJfYuMjE5E8/8mpzc6VcANSrexyRjSITJLxcA9s
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316469420"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="316469420"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 15:08:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="718172554"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="718172554"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2022 15:08:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        muhammad.husaini.zulkifli@intel.com, sasha.neftin@intel.com
Subject: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates 2022-12-15 (igc)
Date:   Thu, 15 Dec 2022 15:07:52 -0800
Message-Id: <20221215230758.3595578-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Muhammad Husaini Zulkifli says:

This patch series fixes bugs for the Time-Sensitive Networking(TSN)
Qbv Scheduling features.

An overview of each patch series is given below:

Patch 1: Using a first flag bit to schedule a packet to the next cycle if
packet cannot fit in current Qbv cycle.
Patch 2: Enable strict cycle for Qbv scheduling.
Patch 3: Prevent user to set basetime less than zero during tc config.
Patch 4: Allow the basetime enrollment with zero value.
Patch 5: Calculate the new end time value to exclude the time interval that
exceed the cycle time as user can specify the cycle time in tc config.
Patch 6: Resolve the HW bugs where the gate is not fully closed.
---
This contains the net patches from this original pull request:
https://lore.kernel.org/netdev/20221205212414.3197525-1-anthony.l.nguyen@intel.com/

The following are changes since commit a7d82367daa6baa5e8399e6327e7f2f463534505:
  net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Muhammad Husaini Zulkifli (1):
  igc: Add checking for basetime less than zero

Tan Tee Min (3):
  igc: allow BaseTime 0 enrollment for Qbv
  igc: recalculate Qbv end_time by considering cycle time
  igc: Set Qbv start_time and end_time to end_time if not being
    configured in GCL

Vinicius Costa Gomes (2):
  igc: Enhance Qbv scheduling by using first flag bit
  igc: Use strict cycles for Qbv scheduling

 drivers/net/ethernet/intel/igc/igc.h         |   3 +
 drivers/net/ethernet/intel/igc/igc_defines.h |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 210 ++++++++++++++++---
 drivers/net/ethernet/intel/igc/igc_tsn.c     |  13 +-
 4 files changed, 188 insertions(+), 40 deletions(-)

-- 
2.35.1

