Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7AB463D8F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245436AbhK3SVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:21:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:22722 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245423AbhK3SVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:21:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="216976650"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="216976650"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 10:00:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="654258442"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 30 Nov 2021 10:00:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com, songliubraving@fb.com
Subject: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver Updates 2021-11-30
Date:   Tue, 30 Nov 2021 09:59:16 -0800
Message-Id: <20211130175918.3705966-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer says:

Changes to fix and enable XDP metadata to a specific Intel driver igc.
Tested with hardware i225 that uses driver igc, while testing AF_XDP
access to metadata area.

The following are changes since commit 196073f9c44be0b4758ead11e51bc2875f98df29:
  net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Jesper Dangaard Brouer (2):
  igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
  igc: enable XDP metadata in driver

 drivers/net/ethernet/intel/igc/igc_main.c | 37 +++++++++++++++--------
 1 file changed, 25 insertions(+), 12 deletions(-)

-- 
2.31.1

