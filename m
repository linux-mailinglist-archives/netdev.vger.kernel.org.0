Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3BD27EDC7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgI3Ptd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:49:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:2799 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgI3Ptd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:49:33 -0400
IronPort-SDR: 6U8JdS2ZT1+3B6Gyx942ejHkx8RxpCfhnSy4+FAqKwIodbb61oGAK3SValEywdwO+MyXqwtjAp
 Dj5fOIoND1SQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="162532290"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="162532290"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:49:31 -0700
IronPort-SDR: l/Czoz607HUUGveEKfnhSNsFxXf/CFCyFe7M9NE5qZx+zLslQbd3FMrVdOmlvGJLWofJyXMRbg
 2dSocs83LTZw==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="515123582"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:49:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net v2 0/2][pull request] Intel Wired LAN Driver Updates 2020-09-30
Date:   Wed, 30 Sep 2020 08:49:21 -0700
Message-Id: <20200930154923.2069200-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jake increases the wait time for firmware response as it can take longer
than the current wait time. Preserves the NVM capabilities of the device in
safe mode so the device reports its NVM update capabilities properly
when in this state.

v2: Added cover letter

The following are changes since commit 2b3e981a94d876ae4f05db28b9ac6a85a80c7633:
  Merge branch 'mptcp-Fix-for-32-bit-DATA_FIN'
and are available in the git repository at:
  https://github.com/anguy11/net-queue.git 100GbE

Jacob Keller (2):
  ice: increase maximum wait time for flash write commands
  ice: preserve NVM capabilities in safe mode

 drivers/net/ethernet/intel/ice/ice_common.c   | 49 ++++++++++---------
 .../net/ethernet/intel/ice/ice_fw_update.c    | 10 +++-
 2 files changed, 35 insertions(+), 24 deletions(-)

-- 
2.26.2

