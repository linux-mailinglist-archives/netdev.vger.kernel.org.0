Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE46E4594EF
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 19:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbhKVStr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 13:49:47 -0500
Received: from mga12.intel.com ([192.55.52.136]:30770 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235967AbhKVStr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 13:49:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="214878593"
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="214878593"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 10:46:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="739350086"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 22 Nov 2021 10:46:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-11-22
Date:   Mon, 22 Nov 2021 10:45:20 -0800
Message-Id: <20211122184522.147331-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski says:

Here are the two fixes for issues around ethtool's set_channels()
callback for ice driver. Both are related to XDP resources. First one
corrects the size of vsi->txq_map that is used to track the usage of Tx
resources and the second one prevents the wrong refcounting of bpf_prog.

The following are changes since commit a68229ca634066975fff6d4780155bd2eb14a82a:
  nixge: fix mac address error handling again
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Maciej Fijalkowski (1):
  ice: fix vsi->txq_map sizing

Marta Plantykow (1):
  ice: avoid bpf_prog refcount underflow

 drivers/net/ethernet/intel/ice/ice_lib.c  |  9 +++++++--
 drivers/net/ethernet/intel/ice/ice_main.c | 18 +++++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.31.1

