Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C37E30E8C2
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhBDAnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:43:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:40021 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234277AbhBDAm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:42:56 -0500
IronPort-SDR: oJMlxZXmp0lGMxMfjagw0vv1hGVAPZg3rAH4wvfNMwJ2euFwq0XB3VMxpl66HTEVR6pVoHKtQ/
 P+nvGV6r6uGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638223"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638223"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:12 -0800
IronPort-SDR: wjKLhrvLbd07WoDeao8qdH5DzdjsPaRS/6pZSYNQ2CpvXhiCcFQcYFxEH8N4fnxNZnnbOnfcvO
 AQcZA9PNjXlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687479"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 02/15] igc: Remove igc_set_fw_version comment
Date:   Wed,  3 Feb 2021 16:42:46 -0800
Message-Id: <20210204004259.3662059-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

i225 device not supported and do not plan to support
configuration of fw version string for ethtool

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index ec8cd69d4992..29da2710b500 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -544,7 +544,6 @@ static int igc_ethtool_set_eeprom(struct net_device *netdev,
 	if (ret_val == 0)
 		hw->nvm.ops.update(hw);
 
-	/* check if need: igc_set_fw_version(adapter); */
 	kfree(eeprom_buff);
 	return ret_val;
 }
-- 
2.26.2

