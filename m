Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D982C9015
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388647AbgK3Vab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:30:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:5349 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388554AbgK3Vaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 16:30:30 -0500
IronPort-SDR: vTzTGnMqO7jl0FmhuTYzdy0J/78/5JWY8KAa2lFsWKg3D+7/XeHVTcrqnt/NwnfvtGJWc8SjeC
 FMDcdLbjJD3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="172815005"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="172815005"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 13:29:19 -0800
IronPort-SDR: 7JE0St8ISkgrAmoDakZgQJJDLQym2PUWkNxYYG6gueiOWtkkuxXjy+9Z6H+oOyWW1+hY/ORfAl
 qaNn5p/CQRtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="329719685"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2020 13:29:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, mario.limonciello@dell.com,
        sasha.neftin@intel.com
Subject: [net-next 0/4][pull request] 1GbE Intel Wired LAN Driver Updates 2020-11-30
Date:   Mon, 30 Nov 2020 13:29:03 -0800
Message-Id: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e driver only.

Mario Limonciello allows s0ix on supported ME systems and adds
additional supported systems.

Vitaly changes configuration to allow for S0i3.2 substate.

The following are changes since commit e71d2b957ee49fe3ed35a384a4e31774de1316c1:
  Merge branch 'net-ipa-start-adding-ipa-v4-5-support'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Mario Limonciello (3):
  e1000e: allow turning s0ix flows on for systems with ME
  e1000e: Add Dell's Comet Lake systems into s0ix heuristics
  e1000e: Add more Dell CML systems into s0ix heuristics

Vitaly Lifshits (1):
  e1000e: fix S0ix flow to allow S0i3.2 subset entry

 .../device_drivers/ethernet/intel/e1000e.rst  |  23 ++
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/e1000e/e1000.h     |   7 +
 drivers/net/ethernet/intel/e1000e/netdev.c    |  72 +++---
 drivers/net/ethernet/intel/e1000e/param.c     | 209 ++++++++++++++++++
 5 files changed, 270 insertions(+), 42 deletions(-)

-- 
2.26.2

