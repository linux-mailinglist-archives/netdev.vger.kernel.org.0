Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635192A36F8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgKBXNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:13:21 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:42919 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbgKBXNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:13:21 -0500
Received: from localhost.localdomain (ip5f5af1d0.dynamic.kabel-deutschland.de [95.90.241.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7108420646217;
        Tue,  3 Nov 2020 00:13:18 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Upstream ONL patch for PHY BCM5461S
Date:   Tue,  3 Nov 2020 00:13:05 +0100
Message-Id: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux folks,


Looking a little bit at Open Network Linux, they carry some Linux
patches, but have not upstreamed them yet. This upstreams support for
the PHY BCM5461S. It’d be great, if you could help review it.


Kind regards,

Paul


Jeffrey Townsend (2):
  ethernet: igb: Support PHY BCM5461S
  ethernet: igb: e1000_phy: Check for ops.force_speed_duplex existence

 drivers/net/ethernet/intel/igb/e1000_82575.c  | 23 ++++-
 .../net/ethernet/intel/igb/e1000_defines.h    |  1 +
 drivers/net/ethernet/intel/igb/e1000_hw.h     |  1 +
 drivers/net/ethernet/intel/igb/e1000_phy.c    | 89 +++++++++++++++++--
 drivers/net/ethernet/intel/igb/e1000_phy.h    |  2 +
 drivers/net/ethernet/intel/igb/igb_main.c     |  8 ++
 6 files changed, 118 insertions(+), 6 deletions(-)

-- 
2.29.1

