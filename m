Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5F832DA3F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 20:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhCDTUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 14:20:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:12794 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhCDTUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 14:20:19 -0500
IronPort-SDR: bee/YL2ldzSjSR2lWBut8LaRYEGbvsN2006+lIOBz8mBO/k35yAChjmjj4N9BY1Pk8zuIRPhzr
 /ltDkcYmf90w==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="184113692"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="184113692"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 11:19:17 -0800
IronPort-SDR: ETkrqdrUF5Biazb/09JJ8qK7ruIkZbUCPwibi450k+nQT2Sd70hcOuQXrRTPFfELySV48hzuPx
 6HGTNauUTVtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="400816195"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2021 11:19:17 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates 2021-03-04
Date:   Thu,  4 Mar 2021 11:20:15 -0800
Message-Id: <20210304192017.1911095-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and ixgbevf drivers.

Antony Antony adds a check to fail for non transport mode SA with
offload as this is not supported for ixgbe and ixgbevf.

Dinghao Liu fixes a memory leak on failure to program a perfect filter
for ixgbe.

v2:
- Dropped patch 1

The following are changes since commit a9ecb0cbf03746b17a7c13bd8e3464e6789f73e8:
  rtnetlink: using dev_base_seq from target net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Antony Antony (1):
  ixgbe: fail to create xfrm offload of IPsec tunnel mode SA

Dinghao Liu (1):
  ixgbe: Fix memleak in ixgbe_configure_clsu32

 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 5 +++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 6 ++++--
 drivers/net/ethernet/intel/ixgbevf/ipsec.c     | 5 +++++
 3 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.26.2

