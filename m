Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4068E576930
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiGOVuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiGOVt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:49:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F664F1A5
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 14:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657921798; x=1689457798;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=viw7/2yI6kkHs5hJvUlTUlZQg0KpQibAlzk4I6UOdnw=;
  b=FXIg/2QV7oGd4atMFladv+TF+XooNgqwV9e9BsHA+B5Ft41k7MqXQdhv
   Zfb7te1OTO9m+ak987IqFo2KNE7AIN8Da9bVRYUEDucHlOw7CUx0eC1QE
   n6zJSwrlz2iZGinQitqCui+GHvr9iDXh4q7DDPcXS1So1GZtpDjihBtqQ
   t2w/rcoonkerlBPOKLnggsSDLU6NVvJYe9vpz1437PGeTIwg1AVqoQ51X
   KF9PRwxdRbp2zl328Nvhjjlj0jlaNIu0nxOAx3WlJ82I4mm9KrSxyo+Ho
   kCF/fWDhHqwmHCZopPShWxpWC/7Lyw+oIPEpR4HTu8B7MpuJ0teahO8Tz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="283467130"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="283467130"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="571693440"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Jul 2022 14:49:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/2][pull request] 100GbE Intel Wired LAN Driver Updates 2022-07-15
Date:   Fri, 15 Jul 2022 14:46:40 -0700
Message-Id: <20220715214642.2968799-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Ani updates feature restriction for devices that don't support external
time stamping.

Zhuo Chen removes unnecessary call to pci_aer_clear_nonfatal_status().
---
v2:  Drop FEC patch for rework

The following are changes since commit 459f326e995ce6f02f3dc79ca5bc4e2abe33d156:
  octeontx2-af: Set NIX link credits based on max LMAC
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Add EXTTS feature to the feature bitmap

Zhuo Chen (1):
  ice: Remove pci_aer_clear_nonfatal_status() call

 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_lib.c  |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c |  6 ------
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 18 +++++++++++++-----
 4 files changed, 15 insertions(+), 11 deletions(-)

-- 
2.35.1

