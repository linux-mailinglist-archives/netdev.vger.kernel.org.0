Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA91262EA2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgIIMiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 08:38:03 -0400
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:22026 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730205AbgIIMhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 08:37:22 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.228])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id DFF464E0EF5;
        Wed,  9 Sep 2020 20:19:29 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] drivers/net/ethernet: fix a typo for stmmac_pltfr_suspend
Date:   Wed,  9 Sep 2020 20:19:21 +0800
Message-Id: <1599653964-29741-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTx9NGUgdSR8aGB0eVkpOQkJNTkhCTEtPS0xVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OVE6Ogw6Sz8vGh08F0M3DEoy
        KwsKCTRVSlVKTkJCTU5IQkxLQ0lCVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlJQ1lXWQgBWUFJSkJJNwY+
X-HM-Tid: 0a7472ce816f9376kuwsdff464e0ef5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the comment typo: "direcly" -> "directly".

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index f32317f..b666bb9
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -711,7 +711,7 @@ EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
 /**
  * stmmac_pltfr_suspend
  * @dev: device pointer
- * Description: this function is invoked when suspend the driver and it direcly
+ * Description: this function is invoked when suspend the driver and it directly
  * call the main suspend function and then, if required, on some platform, it
  * can call an exit helper.
  */
-- 
2.7.4

