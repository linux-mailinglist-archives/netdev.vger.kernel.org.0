Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DAF6E5381
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjDQU7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjDQU7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:59:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA02C172
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 13:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681765036; x=1713301036;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fChB/H0FOP/LC7AyzsHi2M6L+z1XCYz81GFxgezknOc=;
  b=E2lyRY+FK+MnzNnW/1VzvLWFl9PG7SKINW4bZbF5Nu6VK5pAEgRmcOYq
   8EwrmhOMnlWIv0ljmdoULL/+XvNAiwEVjg+m9txqSG5dJe/BpaaLqwGpk
   q46Dkb1hk0DZwesJW+eYS1McLPqIbUf9bfh9qgyZ92v1/BJyGojao2nMJ
   M35zAcASC7Aptp4+vvwNwfD7aH0H3hqkHuHXGWZT8Px07HF/3gxkzb5Nz
   MVkyTvbY4oZMaY7KCYDVwh09TpxJWyt/gTNR9Hjw46QAPeHQL5+TAX9Ze
   Rhi+5361aW3AeW5qdr2jaxJQlveQkWU519zUgX15N1AWXJaUY3e/XZetZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="410222165"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="410222165"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 13:55:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="690818632"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="690818632"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 17 Apr 2023 13:55:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        aleksandr.loktionov@intel.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2023-04-17 (i40e)
Date:   Mon, 17 Apr 2023 13:52:43 -0700
Message-Id: <20230417205245.1030733-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e only.

Alex moves setting of active filters to occur under lock and checks/takes
error path in rebuild if re-initializing the misc interrupt vector
failed.

The following are changes since commit 338469d677e5d426f5ada88761f16f6d2c7c1981:
  net/sched: clear actions pointer in miss cookie init fail
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Aleksandr Loktionov (2):
  i40e: fix accessing vsi->active_filters without holding lock
  i40e: fix i40e_setup_misc_vector() error handling

 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.38.1

