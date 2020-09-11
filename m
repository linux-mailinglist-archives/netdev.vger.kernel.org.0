Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB55C26767D
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgIKXWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:22:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:17589 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbgIKXWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:22:14 -0400
IronPort-SDR: NqTVIzf4NOjH9tB0V25Cqu6XR6LQOcD+EQYardtg4jVkh5VS1i/GOhEJjAykUx7wFuu3pouCiK
 lvmg4nlJzfKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="220426159"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="220426159"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:13 -0700
IronPort-SDR: 6h/Gs1nF9Dwc5MTzVFsuWCcukcp5R7wn22Db+5hY1UE9ux+Tnqom3m8sJl6tTDCKboDOr9Abhw
 nYCmELtgxCiQ==
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="505656577"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [RESEND net 0/4][pull request] Intel Wired LAN Driver Updates 2020-09-09
Date:   Fri, 11 Sep 2020 16:22:03 -0700
Message-Id: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
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

