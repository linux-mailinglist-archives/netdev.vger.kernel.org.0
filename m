Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1633420EAE4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgF3B17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:27:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:7472 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgF3B1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:53 -0400
IronPort-SDR: 2hswe04bleqyKqiUcjyRTGgWzGMSXWh/sFFHgkNe80TP0k61AdGtPbTPrrwViAx6o2/XjKyrEQ
 +2I6Lc9oj8xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134413754"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="134413754"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:51 -0700
IronPort-SDR: E+S8syGYQ/HTNnqD/T32MGGAqVF9xUl9Tu8OWMeW5ebHzfK/FQOov5G65NrqZ0xABCBhBXpjH8
 y0kT5XpQvwkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017725"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 12/13] igc: Remove unneeded check for copper media type
Date:   Mon, 29 Jun 2020 18:27:47 -0700
Message-Id: <20200630012748.518705-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

PHY of the i225 device support only copper mode.
There is no point to check media type in the
igc_power_up_link() method.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 555c6633f1c3..e544f0599dcf 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -115,8 +115,7 @@ static void igc_power_up_link(struct igc_adapter *adapter)
 {
 	igc_reset_phy(&adapter->hw);
 
-	if (adapter->hw.phy.media_type == igc_media_type_copper)
-		igc_power_up_phy_copper(&adapter->hw);
+	igc_power_up_phy_copper(&adapter->hw);
 
 	igc_setup_link(&adapter->hw);
 }
-- 
2.26.2

