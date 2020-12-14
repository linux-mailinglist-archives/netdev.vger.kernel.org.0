Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65262D9AD6
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgLNPXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:23:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:28670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbgLNPXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 10:23:34 -0500
IronPort-SDR: j8oJ0LhvhRxsxD0Sh1oDGVsYiq0EzNDXi/1yUY9uQzV0jmw4Z9OYOOCcqDijcLWyReiWK/mfBX
 f/YTU+dVkv8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="154531324"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="154531324"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 07:22:54 -0800
IronPort-SDR: yVbryF9/CAvcv7DJmj1AZLTlKAQhEdobTU3q4WXmpE2WX3SNbuj7FdtU8kvK324ZI62neN8iaJ
 jkIRoslXcbwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="411285637"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2020 07:22:52 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 net-next 0/8] i40e/ice cleanups
Date:   Mon, 14 Dec 2020 16:13:00 +0100
Message-Id: <20201214151308.15275-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is mostly about the cleanups on Rx (ZC/normal) paths both in
ice and i40e drivers. Things that stand out are the simplifactions of
ice_change_mtu and i40e_xdp_setup.

Thanks!

v2: fix kdoc in patch 5 (Jakub)

Björn Töpel (1):
  i40e, xsk: Simplify the do-while allocation loop

Maciej Fijalkowski (7):
  i40e: drop redundant check when setting xdp prog
  i40e: drop misleading function comments
  i40e: adjust i40e_is_non_eop
  ice: simplify ice_run_xdp
  ice: move skb pointer from rx_buf to rx_ring
  ice: remove redundant checks in ice_change_mtu
  ice: skip NULL check against XDP prog in ZC path

 drivers/net/ethernet/intel/i40e/i40e_main.c |  3 --
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 56 +++++----------------
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c   |  9 ----
 drivers/net/ethernet/intel/ice/ice_txrx.c   | 44 +++++++---------
 drivers/net/ethernet/intel/ice/ice_txrx.h   |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c    |  7 ++-
 7 files changed, 34 insertions(+), 91 deletions(-)

-- 
2.20.1

