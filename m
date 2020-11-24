Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ED32C2D7B
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403803AbgKXQxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:53:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:45927 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731531AbgKXQxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:53:05 -0500
IronPort-SDR: JRyKoIumGemxJUG8KHmiMpQjN9Go2UUa4QS5rngEyINdziruhp0InpBp+sznNaDyqE4LhyTKgW
 7UginCe8eilA==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="172134512"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="172134512"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 08:53:05 -0800
IronPort-SDR: D7Xp4dA0a+4mdSMp3KHl9qds/GVXi86UQDMqREyY1MF1/+LmBjFmUqojU3FN27gxpb43ypxZs6
 VpQyXL1D+Crw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="365068652"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2020 08:53:04 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net-next v2 0/3][pull request] 40GbE Intel Wired LAN Driver Updates 2020-11-24
Date:   Tue, 24 Nov 2020 08:52:42 -0800
Message-Id: <20201124165245.2844118-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and igbvf drivers.

Marek removes a redundant assignment for i40e.

Stefan Assmann corrects reporting of VF link speed for i40e.

Karen revises a couple of error messages to warnings for igbvf as they
could be misinterpreted as issues when they are not.

v2: Dropped PTP patch as it's being updated.

The following are changes since commit 5112cf59d76d799b1c4d66af92417e2673fb1d5b:
  sctp: Fix some typo
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Karen Sornek (1):
  igbvf: Refactor traces

Marek Majtyka (1):
  i40e: remove redundant assignment

Stefan Assmann (1):
  i40e: report correct VF link speed when link state is set to enable

 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         | 1 -
 drivers/net/ethernet/intel/igbvf/netdev.c          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.26.2

