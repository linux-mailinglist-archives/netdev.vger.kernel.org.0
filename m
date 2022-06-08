Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7654387C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbiFHQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245001AbiFHQMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:12:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DAC36E01
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654704719; x=1686240719;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=66SMn2CgEzKBpL0E+C0zuRD/kkNjpizPQW3oF85wkW8=;
  b=cYRFZaWXnXgRapV/V191KcV96lHv8bnTuYov2/PioujSpNoFW/2UqF+3
   d4m9UDtoI8TUZ5dngsP+GAWJ9R2QWQ0yzkvT/LqwKLj1eNm7y9UAJl6GL
   QsVSUDyKDKdk5YmQrrlgGWVBHqsDTdGsU5vPYgUdy5PeSxkN33gzXgr4J
   1a48eKJJY7miSmUQuiLJ1eoKS3p1m1IJswhe6fD/5jdVqeOKwDaIDuumi
   EhKlahYGsK9cumGi1SaIfhgnkaRExZqOP+9GW0woemCtWVNTduj04cFvc
   5j0z1DnA173hRfHi4DESyFNciSYgNLmZZMl0OhAyTUQZ4XPu+isfQdDTH
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="260099529"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="260099529"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 09:11:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="827049662"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2022 09:10:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4][pull request] 100GbE Intel Wired LAN Driver Updates 2022-06-08
Date:   Wed,  8 Jun 2022 09:07:53 -0700
Message-Id: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Michal prevents setting of VF VLAN capabilities in switchdev mode and
removes, not needed, specific switchdev VLAN operations.

Karol converts u16 variables to unsigned int for GNSS calculations.

Christophe Jaillet corrects the parameter order for a couple of
devm_kcalloc() calls.

The following are changes since commit da6e113ff010815fdd21ee1e9af2e8d179a2680f:
  net: ethernet: mtk_eth_soc: enable rx cksum offload for MTK_NETSYS_V2
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Christophe JAILLET (1):
  ice: Use correct order for the parameters of devm_kcalloc()

Karol Kolacinski (1):
  ice: remove u16 arithmetic in ice_gnss

Michal Swiatkowski (2):
  ice: don't set VF VLAN caps in switchdev
  ice: remove VLAN representor specific ops

 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c     |  11 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 121 ++++++++----------
 4 files changed, 65 insertions(+), 74 deletions(-)

-- 
2.35.1

