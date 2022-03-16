Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977914DB99C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344761AbiCPUlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiCPUlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:41:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AD953E3A
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647463200; x=1678999200;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9C1SQPxyOOlWxIV9rinEX1eBJD0Ip0C2royJ916KelQ=;
  b=CY8/HkHBMDQSeo96gK8i4sj0mxlPy7m85oyZ857Pc/6kSwvoIc1dzy48
   I6Ez8OUfCw2NMI8cp2VFnUllc0U3/90q5vdAUAaeeg1Ah17cRJ4PtWUVq
   qu7rSUrS8hRaK/VrzYcJIoPU8AewXouBMnmuhiUYeYm/VwwRrhDvQfnBV
   F2Xt+U9kxL1+O49qmdN5x4P+4AeOd3WVdBLD7S1PtWY4/1Oh8/yEwhLK9
   YwMMCbx2CGofWfhCbVocvFRvZ8GjzPl5hIrgRteKbKYLIKduIWq31oiRS
   2n6tksT/IJy9goCJyBR9faEPydtw5gETHzGiyBO8ovNmEmd8v5yZRT7/1
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="236653294"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="236653294"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 13:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="646799203"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 16 Mar 2022 13:39:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [PATCH net-next 0/4][pull request] 100GbE Intel Wired LAN Driver Updates 2022-03-16
Date:   Wed, 16 Mar 2022 13:40:20 -0700
Message-Id: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to gtp and ice driver.

Wojciech fixes smatch reported inconsistent indenting for gtp and ice.

Yang Yingliang fixes a couple of return value checks for GNSS to IS_PTR
instead of null.

Jacob adds support for trace events on tx timestamps.

The following are changes since commit 49045b9c810cd9b4ac5f8f235ad8ef17553a00fa:
  Merge branch 'mediatek-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (1):
  ice: add trace events for tx timestamps

Wojciech Drewek (2):
  gtp: Fix inconsistent indenting
  ice: Fix inconsistent indenting in ice_switch

Yang Yingliang (1):
  ice: fix return value check in ice_gnss.c

 drivers/net/ethernet/intel/ice/ice_gnss.c   |  4 ++--
 drivers/net/ethernet/intel/ice/ice_ptp.c    |  8 +++++++
 drivers/net/ethernet/intel/ice/ice_switch.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_trace.h  | 24 +++++++++++++++++++++
 drivers/net/gtp.c                           |  2 +-
 5 files changed, 36 insertions(+), 4 deletions(-)

-- 
2.31.1

