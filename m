Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7573B5854B0
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiG2RqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 13:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbiG2RqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 13:46:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F4D78221
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659116779; x=1690652779;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oP0MkLI/O21U1OIwG2nfPpP4zqk2/B5O+NSlIdWGsJQ=;
  b=O6D/sYR/puHwqptaHJBXXfeoIcmDnhAXpVDLFVZcaOVqnof1i5W/l0tu
   3eSGe3lqGou/3zw8ImpctgySt0LT1+Zr9k2xfUWGMXNdV3sZHbg1SzI4m
   ZHaXfgbAU3bixJ/uPMq5CSlXHCtE6SNCYTDY6xki3nUKm3k3an3t8Tjz1
   5VEdSgCdaJQ1Knj6+eSrAy+GsS59z6dnND+buhjWJAz+NIyxecE+1TWiI
   RhrMoBa/8xqV1nfBej4yIHVlLjpBMcDoVDsbH2Snz0tKJCAwUnpRIBb5d
   HwwlLBczVU9DesxxHY3obBCyrPJWaDO4QXBs+uhJ+t1kgK0c1H2AAmHte
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="271855810"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="271855810"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 10:46:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="743604949"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jul 2022 10:46:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates 2022-07-29
Date:   Fri, 29 Jul 2022 10:43:14 -0700
Message-Id: <20220729174316.398063-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Przemyslaw prevents setting of TC max rate below minimum supported values
and reports updated queue values when setting up TCs.
---
v2: Dropped patch 3 (hw-tc-offload check)

The following are changes since commit b65a1534cfd60929b671aecf8a20a3c8daf4c804:
  Merge branch 'netdevsim-fib-route-delete-leak'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Przemyslaw Patynowski (2):
  iavf: Fix max_rate limiting
  iavf: Fix 'tc qdisc show' listing too many queues

 drivers/net/ethernet/intel/iavf/iavf.h      |  6 +++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 46 ++++++++++++++++++++-
 2 files changed, 50 insertions(+), 2 deletions(-)

-- 
2.35.1

