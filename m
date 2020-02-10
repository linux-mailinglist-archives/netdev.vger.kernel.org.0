Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C8F157CE9
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgBJN6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:58:34 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:36086 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbgBJN6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 08:58:34 -0500
Received: from [109.168.11.45] (port=56010 helo=pc-ceresoli.dev.aim)
        by hostingweb31.netsons.net with esmtpa (Exim 4.92)
        (envelope-from <luca@lucaceresoli.net>)
        id 1j19a1-005QhN-Qh; Mon, 10 Feb 2020 14:58:29 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     linux-wireless@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] iwlwifi: fix config variable name in comment
Date:   Mon, 10 Feb 2020 14:58:17 +0100
Message-Id: <20200210135817.31994-1-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.25.0
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

The correct variable name was replaced here by mistake by commit
ab27926d9e4a ("iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF
modules").

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>

---

Changes in v3:
 - remove "Fixes:" tag from commit message (suggested by Kalle Valo)

Changes in v2:
 - rebased on current master fixing conflicts
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index be6a2bf9ce74..df2d3257cce2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -600,6 +600,6 @@ extern const struct iwl_cfg iwlax211_2ax_cfg_so_gf_a0;
 extern const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0;
 extern const struct iwl_cfg iwlax411_2ax_cfg_so_gf4_a0;
 extern const struct iwl_cfg iwlax411_2ax_cfg_sosnj_gf4_a0;
-#endif /* CPTCFG_IWLMVM || CPTCFG_IWLFMAC */
+#endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
-- 
2.25.0

