Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2222639F8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgIJCPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:15:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:25575 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbgIJCM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:12:59 -0400
IronPort-SDR: w4MtCGolgWO3d84kB1Wv2ysGzYH2jm/+DDcCzZE42197p7IfgDwlIdXMCBMdeiN/gwiQMLJ3ey
 wE14Awp3z/Tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="157721712"
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="157721712"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:22 -0700
IronPort-SDR: vkkj5VtYjJUSzcLiLMEepd1DNDR7dZzY7tdoGTAeSP/K2sv/epy4RCY9YcovpTxYJausEI3sP3
 OHKvGyNYfBKg==
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="341733826"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-09-09
Date:   Wed,  9 Sep 2020 17:04:07 -0700
Message-Id: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and igc drivers.

Stefan Assmann changes num_vlans to u16 to fix may be used uninitialized
error and propagates error in i40_set_vsi_promisc() for i40e.

Vinicius corrects timestamping latency values for i225 devices and
accounts for TX timestamping delay for igc.

The following are changes since commit b87f9fe1ac9441b75656dfd95eba70ef9f0375e0:
  hsr: avoid newline  end of message in NL_SET_ERR_MSG_MOD
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Stefan Assmann (2):
  i40e: fix return of uninitialized aq_ret in i40e_set_vsi_promisc
  i40e: always propagate error value in i40e_set_vsi_promisc()

Vinicius Costa Gomes (2):
  igc: Fix wrong timestamp latency numbers
  igc: Fix not considering the TX delay for timestamps

 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 22 ++++++++++++++-----
 drivers/net/ethernet/intel/igc/igc.h          | 20 +++++++----------
 drivers/net/ethernet/intel/igc/igc_ptp.c      | 19 ++++++++++++++++
 3 files changed, 43 insertions(+), 18 deletions(-)

-- 
2.26.2

