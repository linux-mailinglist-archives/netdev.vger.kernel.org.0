Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A9259909A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345617AbiHRWeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238901AbiHRWeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:34:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2459D64D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660862049; x=1692398049;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P8akgLCcrj5lbt0ZJWAFreSnl7SKQZVTN1hz0IGroT4=;
  b=ANuX+keLjGwp4NNbcemMgz9r/P7X6ocwJ6ASZCIyWx9x5GPPKPHfuTo4
   VWbWB/xeZ/C0WY+RBewmzaw3QSmzIpsel/Ki0tiX3o3X0hV7GVhjoV6Tg
   rOOUpsm+I9BCeT/vlJ3knmjLk4d9Cg8XtwslRsIWgY6iXXG4tdj8YUHej
   icC60aW5j7HfFQfZjgu9z+dwomyvUSSH9QRbP4vSdN8GZmct655WWcIBn
   tPu//7jIS15uE6Lu93IdbmUMsyAZBqkcCyC457heiun+vW6QIAZNLydQS
   dGx3WP1IIcdjalGFb+KvFKZ2NuKbtAivTuJT5QLq9ZaxENuqsGqNGCOz+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="379178800"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="379178800"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:34:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558718706"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2022 15:34:08 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2][pull request] Intel Wired LAN Driver Updates 2022-08-18 (ixgbe)
Date:   Thu, 18 Aug 2022 15:34:00 -0700
Message-Id: <20220818223402.1294091-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe driver only.

Fabio M. De Francesco replaces kmap() call to page_address() for
rx_buffer->page().

Jeff Daly adds a manual AN-37 restart to help resolve issues with some link
partners.

The following are changes since commit e34cfee65ec891a319ce79797dda18083af33a76:
  stmmac: intel: remove unused 'has_crossts' flag
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Fabio M. De Francesco (1):
  ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC

Jeff Daly (1):
  ixgbe: Manual AN-37 for troublesome link partners for X550 SFI

 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 56 ++++++++++++++++++-
 3 files changed, 57 insertions(+), 6 deletions(-)

-- 
2.35.1

