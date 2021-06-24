Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93F63B3556
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhFXSOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:14:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:28682 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhFXSOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:14:09 -0400
IronPort-SDR: +BQKOt6YmDUZQwmO15e5i7SN9H62PJbNXv3PhBvvh4V7UXe0IYTXLGRnHkr5Kd0adgYf/kP+YU
 LXXOo1f0DlPQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="271382689"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="271382689"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 11:11:47 -0700
IronPort-SDR: rGkCQNVZap+ECb5h3li1nSvVX+tfbpvRhvrUpQ2IasVsk/pPtKXOolKRD9ev9LMxbzF5aIBnbW
 YqCiZoQilhcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="487866622"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 24 Jun 2021 11:11:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-06-24
Date:   Thu, 24 Jun 2021 11:14:30 -0700
Message-Id: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Dinghao Liu corrects error handling for failed i40e_vsi_request_irq()
call.

Mateusz allows for disabling of autonegotiation for all BaseT media.

Jesse corrects the multiplier being used on 5Gb speeds for PTP.

Jan adds locking in paths calling i40e_setup_pf_switch() that were
missing it.

The following are changes since commit c2f5c57d99debf471a1b263cdf227e55f1364e95:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Dinghao Liu (1):
  i40e: Fix error handling in i40e_vsi_open

Jan Sokolowski (1):
  i40e: Fix missing rtnl locking when setting up pf switch

Jesse Brandeburg (1):
  i40e: fix PTP on 5Gb links

Mateusz Palczewski (1):
  i40e: Fix autoneg disabling for non-10GBaseT links

 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  3 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 17 +++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_ptp.c     |  8 ++++++--
 3 files changed, 20 insertions(+), 8 deletions(-)

-- 
2.26.2

