Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE7535F8DF
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352685AbhDNQTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:19:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:61890 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352671AbhDNQTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:19:11 -0400
IronPort-SDR: eNnIDkcjxemQjxezKxnejj5hbyEv8QN1Yj6SiU18isyxH4iYZuTcv1mC7j8FclRQUojxZsgd9s
 FHtOAL2QGYtw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="182179980"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="182179980"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 09:18:47 -0700
IronPort-SDR: XjlFZ4hqzP+9dYRnvy92dYfk7TTZfnXWP7VrtcD2nvfzna2AMmbEARc7ivCRtHHz2latLGWLfz
 NRWRqkDiNZhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="452520776"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2021 09:18:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2021-04-14
Date:   Wed, 14 Apr 2021 09:20:29 -0700
Message-Id: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and ice drivers.

Alex Duyck fixes a NULL pointer dereference for ixgbe.

Yongxin Liu fixes an unbalanced enable/disable which was causing a call
trace with suspend for ixgbe.

Colin King fixes a potential infinite loop for ice.

The following are changes since commit 2afeec08ab5c86ae21952151f726bfe184f6b23d:
  xen-netback: Check for hotplug-status existence before watching
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Alexander Duyck (1):
  ixgbe: Fix NULL pointer dereference in ethtool loopback test

Colin Ian King (1):
  ice: Fix potential infinite loop when using u8 loop counter

Yongxin Liu (1):
  ixgbe: fix unbalanced device enable/disable in suspend/resume

 drivers/net/ethernet/intel/ice/ice_dcb.c      |  4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.26.2

