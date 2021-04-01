Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA1351B5B
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhDASHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:07:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:1737 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbhDASCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:02:46 -0400
IronPort-SDR: 2GNhjo8v/uWtvVXArLObcgf5JbHomOWzZhfhm+j9y/72lexYpoA5oPS6iNWkNX8rFdtClm6nbM
 K/wEhETlLOWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="256275595"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="256275595"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 10:19:29 -0700
IronPort-SDR: rhJ48G03twwUO1royRDfug38cwdv40sO9XXl8VH7W/iQzJvxf14/thFUQc0VFMZeCIgjaSLjm6
 HMVq6lXIYqUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="439290147"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 01 Apr 2021 10:19:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2021-04-01
Date:   Thu,  1 Apr 2021 10:21:04 -0700
Message-Id: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Arkadiusz fixes warnings for inconsistent indentation.

Magnus fixes an issue on xsk receive where single packets over time
are batched rather than received immediately.

Eryk corrects warnings and reporting of veb-stats.

The following are changes since commit 622d13694b5f048c01caa7ba548498d9880d4cb0:
  xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Fix inconsistent indenting

Eryk Rybak (1):
  i40e: Fix display statistics for veb_tc

Magnus Karlsson (1):
  i40e: fix receiving of single packets in xsk zero-copy mode

 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 52 ++++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  8 +--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  4 +-
 3 files changed, 52 insertions(+), 12 deletions(-)

-- 
2.26.2

