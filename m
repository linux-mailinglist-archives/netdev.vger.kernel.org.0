Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C5966A53B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjAMVmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjAMVmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:42:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531D210FEC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 13:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673646139; x=1705182139;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7LJztHIkI1y506qgcudT6YAHfwWH30H9nMf1j5PRUQc=;
  b=dJ+mfXfbdZJ7jycxMmgF68EXrrComOO8G80UlFFk4Wx7v9n7i1dcHz2d
   5clCVACkksr8D3+4tKR+bd02IhIshZuf4bdTr8a28v37rhnM0tYXre3TA
   80EpZgVfsCjXkoWyeu4yXs8vtnil/ygjNfJeAN0wVHyxs9VUoktNSyAYR
   0g2jvDyNKYG0oLftgG/TOAD+hdfm2QpJQX/sLJIpVf93NDNDh8fc/AkrU
   xo09wwJPC/6HDs35qu9QnN1Rzzz1EU5XVJ5q0yTTUsswjNrvOVLPXvdpe
   qLFAQqOqRVvjnqrfnPfWmr0r8EKtGuk//wyJ8Yl5Y/qoRxL0tsalW844p
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="351341452"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="351341452"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 13:42:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="690629636"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="690629636"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 13 Jan 2023 13:42:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2][pull request] Intel Wired LAN Driver Updates 2023-01-13 (ixgbe)
Date:   Fri, 13 Jan 2023 13:42:46 -0800
Message-Id: <20230113214248.970670-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe driver only.

Jesse resolves warning for RCU pointer by no longer restoring old
pointer.

Sebastian adds waiting for updating of link info on devices utilizing
crosstalk fix to avoid false link state.

The following are changes since commit 6e6eda44b939c0931533d6681d9f2ed41b44cde9:
  sock: add tracepoint for send recv length
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Jesse Brandeburg (1):
  ixgbe: XDP: fix checker warning from rcu pointer

Sebastian Czapla (1):
  ixgbe: Filter out spurious link up indication

 .../net/ethernet/intel/ixgbe/ixgbe_common.c   | 21 ++++++++++++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 13 ++++++------
 2 files changed, 24 insertions(+), 10 deletions(-)

-- 
2.38.1

