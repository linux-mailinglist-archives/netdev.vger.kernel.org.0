Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C00553ED7
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354992AbiFUXCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354991AbiFUXCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:02:32 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC49B2FFEB
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655852551; x=1687388551;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pd0Xd5IMzgrI/Rc2xDAfejXHDWZe4iN6hGYgmfqXusQ=;
  b=QalrecFMxtgTmO67oEb8Wj7jIlCV+5n7/l47QR4KQ4i2rZQwNTVA4lXv
   xFBMdYYgyceBdfBqPobWZRjKfMojm++UobFKD27tdpmD0qlvkH8LNd0LD
   7ynnzB6weYSB0lwl/FJWCEsxEFtMnP+vWK/dTh6HPLVNBTc+Lwyv41wMb
   Z39JQJTjOh1qP/7i+UekOBboPTYEKRytnXrhWlZjnnPbQs3O/kGlpusNv
   9n7VHbszxnH1+gan15DBnKUccRZs+26U7uPrvdwQTdbWy/Ns/QMVmU1In
   XBKQa1Gl/HTSOqKbWVSKKE81vnU/6UbEQ6SKa71qCXX/sEqsygeAnQg1j
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="341943790"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="341943790"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 16:02:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="677234976"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jun 2022 16:02:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver Updates 2022-06-21
Date:   Tue, 21 Jun 2022 15:59:27 -0700
Message-Id: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
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

This series contains updates to i40e driver only.

Mateusz adds support for using the speed option in ethtool.

Minghao Chi removes unneeded synchronize_irq() calls.

Bernard Zhao removes unneeded NULL check.

The following are changes since commit 8720bd951b8e8515ffd995c7631790fdabaa9265:
  Merge branch 'net-dsa-microchip-common-spi-probe-for-the-ksz-series-switches-part-1'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Bernard Zhao (1):
  intel/i40e: delete if NULL check before dev_kfree_skb

Mateusz Palczewski (1):
  i40e: Add support for ethtool -s <interface> speed <speed in Mb>

Minghao Chi (1):
  i40e: Remove unnecessary synchronize_irq() before free_irq()

 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 90 +++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  6 +-
 3 files changed, 92 insertions(+), 6 deletions(-)

-- 
2.35.1

