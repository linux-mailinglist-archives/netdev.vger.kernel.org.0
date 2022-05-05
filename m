Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1751C472
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381569AbiEEQDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381587AbiEEQDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:03:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264FB5C361
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 08:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651766391; x=1683302391;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7ewVM21jJfY3w+ee2iD8OpWPGXKWvT/T9sz8IaMHHWg=;
  b=d+dS7J+nkN5HLlc6Uh4+lbjYI4wka+IKF1oF3bJanXARjyJJHuIYPmOk
   iVzoxz2eg7QuLCy6NcID2zbfN1t5qSfVrsPpm2n3cXu1vBOotHd37i2E9
   1fALwGXE7hKPw8702w7KgoYJAVWMxGJjvjl2+6gxJ2Lsn6WSESn9ZCNvD
   QcuM22YI2FonHPAalLIYTia6p7YptLs/Za1jb4i8Q9ep1tq3b33dLnivM
   FVavLGBqFGdCQ2VfWQdBym9DUSzq41fl0om0MMWVtA5Neks/T/ShZSSlN
   RQqAWgw8oeugQoFCSv5/SPPhjpEjAL7i00inf/06zTzqait9LtN4KvMNs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248696915"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="248696915"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 08:59:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="811682467"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 05 May 2022 08:59:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver Updates 2022-05-05
Date:   Thu,  5 May 2022 08:56:49 -0700
Message-Id: <20220505155651.2606195-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and igb drivers.

Jeff Daly adjusts type for 'allow_unsupported_sfp' to match the
associated struct value for ixgbe.

Alaa Mohamed converts, deprecated, kmap() call to kmap_local_page() for
igb.

The following are changes since commit 1c1ed5a48411e1686997157c21633653fbe045c6:
  net: sparx5: Add handling of host MDB entries
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Alaa Mohamed (1):
  igb: Convert kmap() to kmap_local_page()

Jeff Daly (1):
  ixgbe: Fix module_param allow_unsupported_sfp type

 drivers/net/ethernet/intel/igb/igb_ethtool.c  | 4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.35.1

