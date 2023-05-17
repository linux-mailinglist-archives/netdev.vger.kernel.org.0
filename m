Return-Path: <netdev+bounces-3411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D97706EF0
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9622281245
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C151431EFC;
	Wed, 17 May 2023 16:59:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61C8442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:59:31 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC035FE4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684342767; x=1715878767;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F8D1M/WgxtW3S6c67AJPXszJ4quEWmp1jF1WCP+oHuE=;
  b=VBRjxva8+5t8nes10ponlyjf1wGxchV7iTfiV811HIvbADbP76CqNY5Y
   7sLtgBaJlNvdS/l8mNWVrKn9t8qeBrV10bjiFYHidSawn7mtKaZMr2uNz
   KYhVcU4JXCOQArDir6pn3CpyCZ2K1oMa9FIpAbIMZZpP98AVO00OngYf+
   5KXESGR+ZTR6teTH546utAaPSfET9QEWGM8R4bu415xv5bZ+ZzIfCbmYH
   hejZTraovRNPq71b8yCn6IPL5OIw5U/rGgOXPc/m+OlElIMoV6NHyBu6P
   BaVlztWUfwXCp9isX3wonCr0fEKwZwPhO25jiNpuGgzu+acObiyy+H/qf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380011540"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="380011540"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 09:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704876764"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="704876764"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 09:59:15 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates 2023-05-17 (ice, MAINTAINERS)
Date: Wed, 17 May 2023 09:55:25 -0700
Message-Id: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series contains updates to ice driver and MAINTAINERS file.

Paul refactors PHY to link mode reporting and updates some PHY types to
report more accurate link modes for ice.

Dave removes mutual exclusion policy between LAG and SR-IOV in ice
driver.

Jesse updates link for Intel Wired LAN in the MAINTAINERS file.

The following are changes since commit af2eab1a824349cfb0f6a720ad06eea48e9e6b74:
  dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Dave Ertman (1):
  ice: Remove LAG+SRIOV mutual exclusion

Jesse Brandeburg (1):
  MAINTAINERS: update Intel Ethernet links

Paul Greenwalt (3):
  ice: update ICE_PHY_TYPE_HIGH_MAX_INDEX
  ice: refactor PHY type to ethtool link mode
  ice: update PHY type to ethtool link mode mapping

 .../device_drivers/ethernet/intel/ice.rst     |  18 -
 MAINTAINERS                                   |   5 +-
 drivers/net/ethernet/intel/ice/ice.h          |  20 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 309 ++----------------
 drivers/net/ethernet/intel/ice/ice_ethtool.h  | 105 ++++++
 drivers/net/ethernet/intel/ice/ice_lag.c      |  12 -
 drivers/net/ethernet/intel/ice/ice_lag.h      |  54 ---
 drivers/net/ethernet/intel/ice/ice_lib.c      |   2 -
 drivers/net/ethernet/intel/ice/ice_sriov.c    |   4 -
 10 files changed, 144 insertions(+), 387 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ethtool.h

-- 
2.38.1


