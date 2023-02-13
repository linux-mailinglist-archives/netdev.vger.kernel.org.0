Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D71F69501C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjBMS7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjBMS7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:59:31 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4244211CC
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676314747; x=1707850747;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jKv00w3+kTWL2gtwtvL/hoypXy4ocug618eHGgyV2yw=;
  b=XKy6RCcpfOBmC6rjgDTZEFYUPMWatJCvqjM6Cn4OdahhxRtl96Lj7ZzW
   MznwdvDNOwQ3hKbuxnOB2MSOXjvFTmxsQaDffR8gpgfHJI02mJCVJ0N3r
   nm8YDYNaotJYvWd0hV9Y5VQuwQdL9xtEgFZJ26MjtVAp0Wj4lNXwRGX1K
   N75hJmOfgCuUdu2GcVYE8Yp4q9OrpKNCAyzlbxblHc8MMUdEgIa3Z9rVW
   zZr8KR1A6p5WfRyzWXeY0tYodDbNc2N1+6DuyjVAudZH3gRY4C4B/my0B
   d/lLqJx+lfiL5EvwshTU7Az9yu6A5A/F0JSszDEGUN0QeXnokEVeswKID
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328677760"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="328677760"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 10:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="737619902"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="737619902"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 13 Feb 2023 10:53:32 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2023-02-13 (ice)
Date:   Mon, 13 Feb 2023 10:52:57 -0800
Message-Id: <20230213185259.3959224-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Michal fixes check of scheduling node weight and priority to be done
against desired value, not current value.

Jesse adds setting of all multicast when adding promiscuous mode to
resolve traffic being lost due to filter settings.

The following are changes since commit 2038cc592811209de20c4e094ca08bfb1e6fbc6c:
  bnxt_en: Fix mqprio and XDP ring checking logic
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Jesse Brandeburg (1):
  ice: fix lost multicast packets in promisc mode

Michal Wilczynski (1):
  ice: Fix check for weight and priority of a scheduling node

 drivers/net/ethernet/intel/ice/ice_devlink.c |  4 +--
 drivers/net/ethernet/intel/ice/ice_main.c    | 26 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

-- 
2.38.1

