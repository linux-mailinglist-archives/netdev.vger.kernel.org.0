Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B496232C9CA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245368AbhCDBMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:45179 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388758AbhCDBGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:06:20 -0500
IronPort-SDR: VyNpwvgoH6OuzuABwWVmuWlu1EOjMVueehBx63lag3Mt6YIrTdINGshfrd7KSzaVX94HA+6WE4
 SIJ0mfPzDrWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="183934468"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="183934468"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 17:05:38 -0800
IronPort-SDR: JnVm466Q38yCGHZ041Jt1j5IHY7xlFHQpDQ3nhiea7FrRqX0lmSg+lDxlKMCvIDZJdiiD4FPse
 x+ClIBy+jPug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="367809979"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2021 17:05:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2021-03-03
Date:   Wed,  3 Mar 2021 17:06:46 -0800
Message-Id: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and ixgbevf drivers.

Bartosz Golaszewski does not error on -ENODEV from ixgbe_mii_bus_init()
as this is valid for some devices with a shared bus for ixgbe.

Antony Antony adds a check to fail for non transport mode SA with
offload as this is not supported for ixgbe and ixgbevf.

Dinghao Liu fixes a memory leak on failure to program a perfect filter
for ixgbe.

The following are changes since commit dbbe7c962c3a8163bf724dbc3c9fdfc9b16d3117:
  docs: networking: drop special stable handling
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Antony Antony (1):
  ixgbe: fail to create xfrm offload of IPsec tunnel mode SA

Bartosz Golaszewski (1):
  net: ethernet: ixgbe: don't propagate -ENODEV from
    ixgbe_mii_bus_init()

Dinghao Liu (1):
  ixgbe: Fix memleak in ixgbe_configure_clsu32

 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 5 +++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 8 +++++---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c     | 5 +++++
 3 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.26.2

