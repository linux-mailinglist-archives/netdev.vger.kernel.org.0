Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE49910E955
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLBLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 06:10:25 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:43264 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfLBLKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 06:10:24 -0500
X-Greylist: delayed 3393 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2019 06:10:23 EST
Received: from [109.168.11.45] (port=52414 helo=pc-ceresoli.dev.aim)
        by hostingweb31.netsons.net with esmtpa (Exim 4.92)
        (envelope-from <luca@lucaceresoli.net>)
        id 1ibiiB-0026XW-Su; Mon, 02 Dec 2019 11:13:47 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix config variable name in comment
Date:   Mon,  2 Dec 2019 11:13:39 +0100
Message-Id: <20191202101339.24265-1-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The correct variable name was replaced here by mistake.

Fixes: ab27926d9e4a ("iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules")
Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 317eac066082..fb6838527e28 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -636,6 +636,6 @@ extern const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0;
 extern const struct iwl_cfg iwlax211_2ax_cfg_so_gf_a0;
 extern const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0;
 extern const struct iwl_cfg iwlax411_2ax_cfg_so_gf4_a0;
-#endif /* CPTCFG_IWLMVM || CPTCFG_IWLFMAC */
+#endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
-- 
2.24.0

