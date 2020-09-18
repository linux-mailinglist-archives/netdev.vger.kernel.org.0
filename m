Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BE7270856
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIRVeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:34:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:65030 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgIRVeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 17:34:03 -0400
IronPort-SDR: 8v1UzLtuEK0cWKLEzZgyjNuHpxDqHgkkzr28P4PXRdk+WC4r9VntvV1S04IqPA32cAd1Nk4jzX
 k9xHeFEV8O1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="178128528"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="178128528"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 14:27:15 -0700
IronPort-SDR: K+xwbNPGE/S3PQM3/6DVpnrV3qgHYSErGoTFj2URfXTnqHgPKZpPTI73IHbzZ4IXTojKtDbkmn
 i/L4CquZyD2Q==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="508299900"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 14:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-09-18
Date:   Fri, 18 Sep 2020 14:26:59 -0700
Message-Id: <20200918212703.3398038-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the iavf and ice driver.

Sylwester fixes a crash with iavf resume due to getting the wrong pointers.

Ani fixes a call trace in ice resume by calling pci_save_state().

Jakes fixes memory leaks in case of register_netdev() failure or
ice_cfg_vsi_lan() failure for the ice driver.

The following are changes since commit 5f6857e808a8bd078296575b417c4b9d160b9779:
  nfp: use correct define to return NONE fec
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Fix call trace on suspend

Jacob Keller (2):
  ice: fix memory leak if register_netdev_fails
  ice: fix memory leak in ice_vsi_setup

Sylwester Dziedziuch (1):
  iavf: Fix incorrect adapter get in iavf_resume

 drivers/net/ethernet/intel/iavf/iavf_main.c |  4 ++--
 drivers/net/ethernet/intel/ice/ice_lib.c    | 20 ++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_lib.h    |  6 ------
 drivers/net/ethernet/intel/ice/ice_main.c   | 14 ++++----------
 4 files changed, 22 insertions(+), 22 deletions(-)

-- 
2.26.2

