Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B4728688B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 21:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgJGTqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 15:46:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:13804 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGTqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 15:46:31 -0400
IronPort-SDR: Dnzj9DEVjoXxuIFsdPuPEHZGY3l7VJHUW0PVol4bAychLDUlp1V5bdW6uk7vxKxlRf5PTdC1eI
 yveNtZSlXXZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="165115348"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="165115348"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:58 -0700
IronPort-SDR: QXUyEDaIX8hQDvVQiSV/yDPoEn4lTuTHF80zjuQgpafFXfnURhFzxW/sdYLJGUTNZuJy/5FbA9
 tLub6Q4Ht66g==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935769"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver Updates 2020-10-07
Date:   Wed,  7 Oct 2020 10:54:39 -0700
Message-Id: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Andy Shevchenko changes usage to %*phD format to print small buffer as hex
string.

Bruce removes repeated words reported by checkpatch.

Ani changes ice_info_get_dsn() to return void as it always returns
success.

Jake adds devlink reporting of fw.app.bundle_id. Moves devlink_port
structure to ice_vsi to resolve issues with cleanup. Adds additional
debug info for firmware updates.

Bixuan Cui resolves -Wpointer-to-int-cast warnings.

Dan adds additional packet type masks and checks to prevent overwriting
existing Flow Director rules.

The following are changes since commit 9faebeb2d80065926dfbc09cb73b1bb7779a89cd:
  Merge branch 'ethtool-allow-dumping-policies-to-user-space'
and are available in the git repository at:
  https://github.com/anguy11/next-queue.git 100GbE

Andy Shevchenko (1):
  ice: devlink: use %*phD to print small buffer

Anirudh Venkataramanan (1):
  ice: Change ice_info_get_dsn to be void

Bixuan Cui (1):
  ice: Fix pointer cast warnings

Bruce Allan (1):
  ice: remove repeated words

Dan Nowlin (1):
  ice: fix adding IP4 IP6 Flow Director rules

Jacob Keller (3):
  ice: add the DDP Track ID to devlink info
  ice: refactor devlink_port to be per-VSI
  ice: add additional debug logging for firmware update

 Documentation/networking/devlink/ice.rst      |  5 ++
 drivers/net/ethernet/intel/ice/ice.h          |  7 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 78 +++++++++++--------
 drivers/net/ethernet/intel/ice/ice_devlink.h  |  4 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_flow.c     | 66 +++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |  4 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 28 +++++--
 drivers/net/ethernet/intel/ice/ice_lib.c      |  5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 19 +++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  2 +-
 11 files changed, 162 insertions(+), 58 deletions(-)

-- 
2.26.2

