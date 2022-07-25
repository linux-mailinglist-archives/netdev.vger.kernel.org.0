Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3301058034C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbiGYRHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236172AbiGYRHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:07:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50ED1DA5B
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 10:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658768873; x=1690304873;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WF+FboEbqixSFooswMLJ/ZPy67YknPhOCbsPlvSuINc=;
  b=dDrLLu/jak1KollWtoUWc2A/aa1xLHU+Ma4HnL+lJi1XK4rW25zx6Msy
   Vl6m9Jw2qazGsgLXVrx9K8ip/am9ISESyzs5HWmncWMdUv01U2Z6zSh2P
   qcFdyj21ydw+VRDr4M6ThrjMKSVgf2bqy//CM8yhrKtPUUKECGmIcSuVh
   lBv/IR5fmAmNwke80YQEpAqLJogi6hFmZD4X8nuDNKJRvM5xcyRiALlGI
   vox7XMICqR6zOgz70rHSrofvIC3EpgpcsYmPGKEJTgvKVwn67ymrIbgKc
   CiOauAylpfJ2bj/Vguhw9iLJyZLfaiYa9/rgfD3OacpaZoT4wvwk2LsTH
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="270785654"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="270785654"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 10:07:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="845577972"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jul 2022 10:07:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-07-25
Date:   Mon, 25 Jul 2022 10:04:49 -0700
Message-Id: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
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
and reports updated queue counts when setting up TCs.

Sudheer prevents configuration of TC filters when TC offloads are not
enabled.

The following are changes since commit 9af0620de1e118666881376f6497d1785758b04c:
  Merge branch 'net-sysctl-races-part-6'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Przemyslaw Patynowski (2):
  iavf: Fix max_rate limiting
  iavf: Fix 'tc qdisc show' listing too many queues

Sudheer Mogilappagari (1):
  iavf: enable tc filter configuration only if hw-tc-offload is on

 drivers/net/ethernet/intel/iavf/iavf.h      |  6 +++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 52 ++++++++++++++++++++-
 2 files changed, 56 insertions(+), 2 deletions(-)

-- 
2.35.1

