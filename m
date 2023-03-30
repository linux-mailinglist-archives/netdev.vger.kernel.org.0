Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD96D0C19
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjC3RCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjC3RCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:02:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F4CDDF
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680195725; x=1711731725;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oowOzC0AUDrG79yzlv63K5H7lL8HxuQez4d1PBI2R8k=;
  b=Oh3j022K0ID96NCwnNQwwPlMaZ+cwOdb8tkYx47nBHZf15PvL9yS9utb
   nlsICGbsQcPDaQoFSS66/r8+NR0M1B8320OKnagimCR7E2ip2Vb04GbKx
   azRyFGBy4vMI4zxZ/8XNT2yxpHNC8Q7FJHAy+E17zgeM2nwHuERy633oT
   KSR0AgqdUjO2u1tkK9Wn+3nZ2vLWoxb7MjAzt69DGJmXyHNHR9A0b2ycr
   9Mtlw4bASfJEcUdWyeOgLuTqQldW7VTbPueavrDpiFJvJg2koRP2c3PmW
   Rfizfjhsz/lPdzNl0Cdf73vLzcZUhBMdItIJwell6I09nMboBCMB0rIKf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329747470"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="329747470"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="687317623"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="687317623"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 30 Mar 2023 10:01:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2023-03-30 (documentation, ice)
Date:   Thu, 30 Mar 2023 09:59:32 -0700
Message-Id: <20230330165935.2503604-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to driver documentation and the ice driver.

Tony removes links and addresses related to the out-of-tree driver from the
Intel ethernet driver documentation.

Jake removes a comment that is no longer valid to the ice driver.

The following are changes since commit da617cd8d90608582eb8d0b58026f31f1a9bfb1d:
  smsc911x: remove superfluous variable init
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (1):
  ice: remove comment about not supporting driver reinit

Tony Nguyen (2):
  Documentation/eth/intel: Update address for driver support
  Documentation/eth/intel: Remove references to SourceForge

 .../networking/device_drivers/ethernet/intel/e100.rst    | 4 +---
 .../networking/device_drivers/ethernet/intel/e1000.rst   | 9 ++-------
 .../networking/device_drivers/ethernet/intel/e1000e.rst  | 7 +------
 .../networking/device_drivers/ethernet/intel/fm10k.rst   | 7 +------
 .../networking/device_drivers/ethernet/intel/i40e.rst    | 7 +------
 .../networking/device_drivers/ethernet/intel/iavf.rst    | 7 +------
 .../networking/device_drivers/ethernet/intel/ice.rst     | 5 +----
 .../networking/device_drivers/ethernet/intel/igb.rst     | 7 +------
 .../networking/device_drivers/ethernet/intel/igbvf.rst   | 7 +------
 .../networking/device_drivers/ethernet/intel/ixgbe.rst   | 7 +------
 .../networking/device_drivers/ethernet/intel/ixgbevf.rst | 7 +------
 drivers/net/ethernet/intel/ice/ice_devlink.c             | 1 -
 12 files changed, 12 insertions(+), 63 deletions(-)

-- 
2.38.1

