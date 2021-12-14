Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1833A474C49
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhLNTvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:51:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:56344 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhLNTvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639511478; x=1671047478;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mGEJOLBtMaKeGV0j1wyqxU85wBtmGohZmVKvED/o4Cg=;
  b=lptoord1Rt4KU+FsZ9TfRAnngFfeSiiaz6gw8mjSAjaZQiXi1vt2tTPA
   0Fp6IANgE3kX8G4plZJp6EyBJTJp7vWVMj+nR5COJ4cXhEWv9DX/I0gGC
   oOdSeNLxJn+zwQIvsCp6A4gCgHA7hSIRKW+2+dqnkNQnkHkPIpgwPrYqL
   TC24Q2gxYLiK/e3rVhJcEWyIx3R3/86VoFh7fLR0h9weyGhOyaTPEG9oA
   saqO7ZN/x87q3gt6SdudJlyvrgVFRZfFRImQejb2t4xaspcw8wDbd4Wpn
   pR9hHfh4QxmvAHeWPbPu0qlbaRMmZ3o2e8D8j3iz+gDMJnYwOY8f0tYK3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263216670"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263216670"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 11:51:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="753098706"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 14 Dec 2021 11:51:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com, karol.kolacinski@intel.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2021-12-14
Date:   Tue, 14 Dec 2021 11:50:18 -0800
Message-Id: <20211214195020.1928635-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Karol corrects division that was causing incorrect calculations and
adds a check to ensure stale timestamps are not being used.

The following are changes since commit 3dd7d40b43663f58d11ee7a3d3798813b26a48f1:
  Merge branch 'mlxsw-fixes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Karol Kolacinski (2):
  ice: Use div64_u64 instead of div_u64 in adjfine
  ice: Don't put stale timestamps in the skb

 drivers/net/ethernet/intel/ice/ice_ptp.c | 13 +++++--------
 drivers/net/ethernet/intel/ice/ice_ptp.h |  6 ++++++
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
2.31.1

