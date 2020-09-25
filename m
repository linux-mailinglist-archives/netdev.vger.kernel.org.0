Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97230279302
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgIYVJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:09:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:48591 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727654AbgIYVJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 17:09:41 -0400
IronPort-SDR: xt+6FkXYqjOFWg3qRnWySA/G5+OvezrsIhlm3amsA3u0CP2ZiYHpXJ8LkwguFW24PloaS9NtSq
 X0BKWbmgWXlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="161724521"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="161724521"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:41 -0700
IronPort-SDR: CasuGQYCTcI3iuMDtC9/oZF315vjYOKqkvM5l+8KgfoxO4lgdGIwZdXJwITOkpYO5dtc+8dcKD
 aUi1OpNrUXkw==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="291979262"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net v2 0/4][pull request] Intel Wired LAN Driver Updates 2020-09-25
Date:   Fri, 25 Sep 2020 14:09:26 -0700
Message-Id: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
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

v2: Rebased; no other changes

The following are changes since commit ad2b9b0f8d0107602bdc1f3b1ab90719842ace11:
  tcp: skip DSACKs with dubious sequence ranges
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

