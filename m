Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0322B2986
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKNALb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:11:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:46584 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgKNAL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:11:29 -0500
IronPort-SDR: skuCuONSRdQlUTmVcAOcL540zYR4SGOwprCHXckCfFJbQiP9OmiVLQ7UNXJpTHxML3fmwMjdM0
 8nYxVPb621Hg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="150397830"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="150397830"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 16:11:27 -0800
IronPort-SDR: nm4iFR/wH9GCuCTcDNxa0E6B76wp4rEHMg0vKktX94A3FYo3PX0MaPXTwpQBr5XvA5zYFfcnUR
 sDML9SrZ5AQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="361505852"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 13 Nov 2020 16:11:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net-next 0/4][pull request] 40GbE Intel Wired LAN Driver Updates 2020-11-13
Date:   Fri, 13 Nov 2020 16:10:53 -0800
Message-Id: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and igbvf drivers.

Piotr adds support for PTP external clock synchronization to i40e via
GPIO pins.

Marek removes a redundant assignment for i40e.

Stefan Assmann corrects reporting of VF link speed for i40e.

Karen revises a couple of error messages to warnings for igbvf as they
could be misinterpreted as issues when they are not.

The following are changes since commit e1d9d7b91302593d1951fcb12feddda6fb58a3c0:
  Merge https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Karen Sornek (1):
  igbvf: Refactor traces

Marek Majtyka (1):
  i40e: remove redundant assignment

Piotr Kwapulinski (1):
  i40e: add support for PTP external synchronization clock

Stefan Assmann (1):
  i40e: report correct VF link speed when link state is set to enable

 drivers/net/ethernet/intel/i40e/i40e.h        |  76 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  18 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    | 747 +++++++++++++++++-
 .../net/ethernet/intel/i40e/i40e_register.h   |  31 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |   1 -
 drivers/net/ethernet/intel/igbvf/netdev.c     |   4 +-
 7 files changed, 851 insertions(+), 31 deletions(-)

-- 
2.26.2

