Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CCE286B5B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgJGXLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:11:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:53903 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgJGXLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 19:11:05 -0400
IronPort-SDR: EFbMVyVEuuS+FzjIutjIi5hUTgjyL2yGikUe6MzuYb7QvOy99oPki0FfrJEC5A0V3fNPWwhh+g
 F5imvllHGuJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="249880361"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="249880361"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
IronPort-SDR: cMk2vy+jkLSXwLGIxTxGe7EyAl2xEvBOM/830pD1r5B8a38Rl6BRj0oMT+eqwk2XZRNOfQkvcD
 4+5CESy+3kkQ==
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="461557630"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/3][pull request] 40GbE Intel Wired LAN Driver Updates 2020-10-07
Date:   Wed,  7 Oct 2020 16:10:47 -0700
Message-Id: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and e1000 drivers.

Jaroslaw adds support for changing FEC on i40e if the firmware supports it.

Aleksandr fixes setting and reporting of VF MAC address under various
circumstances for i40e.

Jesse fixes a kbuild-bot warning regarding ternary operator on e1000. 

The following are changes since commit 9faebeb2d80065926dfbc09cb73b1bb7779a89cd:
  Merge branch 'ethtool-allow-dumping-policies-to-user-space'
and are available in the git repository at:
  https://github.com/anguy11/next-queue.git 40GbE

Aleksandr Loktionov (1):
  i40e: Fix MAC address setting for a VF via Host/VM

Jaroslaw Gawin (1):
  i40e: Allow changing FEC settings on X722 if supported by FW

Jesse Brandeburg (1):
  e1000: remove unused and incorrect code

 drivers/net/ethernet/intel/e1000/e1000_hw.c   | 10 +------
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  6 +++++
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 ++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 22 +++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 19 ++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 26 +++++++++++++++++--
 7 files changed, 72 insertions(+), 14 deletions(-)

-- 
2.26.2

