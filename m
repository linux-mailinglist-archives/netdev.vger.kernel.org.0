Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A482D7BD2
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733306AbgLKRAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:00:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:8161 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732259AbgLKRAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 12:00:05 -0500
IronPort-SDR: Mb76smmAcD7/E4918a0HIQxR3AUekTHYfLL/PSv3EqXsl2PducFMuBB9/eREeuTmsxUHP3071u
 B+D3xD4jtOvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="236055065"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="236055065"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 08:59:24 -0800
IronPort-SDR: wNA6O4mTlDWoiViRkY0PmDumrX/67R3hrEp9rl08fNXjikevz9zcA0l1V9RuRgWahyZY2hCc4U
 n5Pw7KWlp9GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="365497494"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2020 08:59:22 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next 0/8] i40e/ice cleanups
Date:   Fri, 11 Dec 2020 17:49:48 +0100
Message-Id: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
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
 drivers/net/ethernet/intel/ice/ice_txrx.c   | 43 +++++++---------
 drivers/net/ethernet/intel/ice/ice_txrx.h   |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c    |  7 ++-
 7 files changed, 34 insertions(+), 90 deletions(-)

-- 
2.20.1

