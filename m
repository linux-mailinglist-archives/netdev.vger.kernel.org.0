Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA6533D9AF
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbhCPQmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:42:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:7038 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238797AbhCPQlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 12:41:37 -0400
IronPort-SDR: lNC7aodw9zEkW0cAYK6lAmq9BjvAYioviBNxSl+4dwqsBXSOjXnU7aTZFykOJQpgFZbg4IegsZ
 /t7invMtt0EA==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="176890020"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="176890020"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 09:41:33 -0700
IronPort-SDR: XnDiheDn4dLuDM/yLIWQhQ8V6KmZN2A/aITN2vzyep+SN/LUy2NTNlhScX5ZoQMqr66Nj+J3aF
 3VXoPsKknqLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="440138162"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2021 09:41:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver Updates 2021-03-16
Date:   Tue, 16 Mar 2021 09:42:51 -0700
Message-Id: <20210316164254.3744059-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e, ixgbe, and ice drivers.

Magnus Karlsson says:

Optimize run_xdp_zc() for the XDP program verdict being XDP_REDIRECT
in the xsk zero-copy path. This path is only used when having AF_XDP
zero-copy on and in that case most packets will be directed to user
space. This provides around 100k extra packets in throughput on my
server when running l2fwd in xdpsock.

The following are changes since commit 2117fce81f6b862aac0673abe8df0c60dca64bfa:
  Merge branch 'psample-Add-additional-metadata-attributes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Magnus Karlsson (3):
  i40e: optimize for XDP_REDIRECT in xsk path
  ixgbe: optimize for XDP_REDIRECT in xsk path
  ice: optimize for XDP_REDIRECT in xsk path

 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 11 +++++++----
 drivers/net/ethernet/intel/ice/ice_xsk.c     | 12 ++++++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
 3 files changed, 22 insertions(+), 12 deletions(-)

-- 
2.26.2

