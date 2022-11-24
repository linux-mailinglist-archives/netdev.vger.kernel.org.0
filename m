Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF7D637695
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKXKhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKXKhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:37:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83937FAD7
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669286258; x=1700822258;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wveOYDgMubn+p0zGHMK3slbASm0Nz8gWgAOFLdCcn14=;
  b=SOKof719BRI60JolCSyDZxUAr5VRCJ4xvafKJ8JdKiUOjpcFicgExQNq
   UPT1tSwXYiLLNXJwSH1Dqa+6g1yBQ37PpQrGyiPAuKzGFQgkAAdeQPBky
   +f/AnG2UlhyBjv7Qvk1s6AFBz9V4rHBGkHY1tOGik21cedue2Zcw8AsBb
   HnBFRqrdzFQtFLwzChDJyO+yLmkTmphZWHJToRAhkpTIeoLmQ55/IL3Ql
   aQYrzl1gWbMOMXiGIfjJzQtXOnrj6wSGvO9hu9XYouxq3aJ7M1njyNICB
   FwciM2N7gPKPOXpUrQ11VvamMYHunUbzUTylZJuafxPVPecfuQScW1R4E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="316096157"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="316096157"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 02:37:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887327803"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="887327803"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2022 02:37:33 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, edumazet@google.com,
        pabeni@redhat.com, M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH v2 net 0/4] net: wwan: iosm: fix build errors & bugs
Date:   Thu, 24 Nov 2022 16:07:25 +0530
Message-Id: <20221124103725.1445974-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

This patch series fixes iosm driver bugs & build errors.

PATCH1: Fix kernel build robot reported error.
PATCH2: Fix build error reported on armhf while preparing
        6.1-rc5 for Debian.
PATCH3: Fix UL throughput crash.
PATCH4: Fix incorrect skb length.

Refer to commit message for details.

Changes since v1:
* PATCH4: Fix sparse warning.

M Chetan Kumar (4):
  net: wwan: iosm: fix kernel test robot reported error
  net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
  net: wwan: iosm: fix crash in peek throughput test
  net: wwan: iosm: fix incorrect skb length

 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 26 ++++++++++++----------
 drivers/net/wwan/iosm/iosm_ipc_protocol.h  |  2 +-
 2 files changed, 15 insertions(+), 13 deletions(-)

--
2.34.1

