Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92144243A3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbhJFRCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:02:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:5209 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239439AbhJFRCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:02:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="224820447"
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="224820447"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2021 09:59:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="439189019"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Oct 2021 09:58:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2021-10-06
Date:   Wed,  6 Oct 2021 09:56:56 -0700
Message-Id: <20211006165659.2298400-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Jiri Benc expands an error check to prevent infinite loop for i40e.

Sylwester prevents freeing of uninitialized IRQ vector to resolve a
kernel oops for i40e.

Stefan Assmann fixes a double mutex unlock for iavf.

The following are changes since commit a50a0595230d38be15183699f7bbc963bf3d127a:
  dt-bindings: net: dsa: marvell: fix compatible in example
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Jiri Benc (1):
  i40e: fix endless loop under rtnl

Stefan Assmann (1):
  iavf: fix double unlock of crit_lock

Sylwester Dziedziuch (1):
  i40e: Fix freeing of uninitialized misc IRQ vector

 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++--
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.31.1

