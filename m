Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837A436F441
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 05:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhD3DLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 23:11:46 -0400
Received: from mail-m176218.qiye.163.com ([59.111.176.218]:46718 "EHLO
        mail-m176218.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3DLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 23:11:45 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m176218.qiye.163.com (Hmail) with ESMTPA id 980723200A7;
        Fri, 30 Apr 2021 11:10:55 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: stmmac: Remove duplicate declaration of stmmac_priv
Date:   Fri, 30 Apr 2021 11:10:47 +0800
Message-Id: <20210430031047.34888-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQkJIQ1ZOH0pDQk0eGh9DH0hVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hOSFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N0k6ISo6CT8IPEhIQzJWTwoj
        KFFPCglVSlVKTUpCTE5JSU5NSExDVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFJSUNPNwY+
X-HM-Tid: 0a7920c201ead978kuws980723200a7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit f4da56529da60 ("net: stmmac: Add support for external
trigger timestamping"), struct stmmac_priv was declared at line 507
which caused duplicate struct declarations.
Remove later duplicate declaration here.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 2cc91759b91f..6d5e0f2b03ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -564,7 +564,6 @@ struct stmmac_mode_ops {
 #define stmmac_clean_desc3(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mode, clean_desc3, __args)
 
-struct stmmac_priv;
 struct tc_cls_u32_offload;
 struct tc_cbs_qopt_offload;
 struct flow_cls_offload;
-- 
2.25.1

