Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36EF5CC74
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 11:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfGBJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 05:12:16 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:50990 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725851AbfGBJMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 05:12:16 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7E0BFC0BD1;
        Tue,  2 Jul 2019 09:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562058736; bh=MXYUQxPCERQHdIJRtSDEXTJHNvOhl9taWreAQc8jCzQ=;
        h=From:To:Cc:Subject:Date:From;
        b=d9yIlswJ3fbMbeqgHoR93Jqqeccy0IGwyaGekW7caQU6SaDPG7vB+WIVXTMQoYWOV
         sZhneZCKqcrnqHYhZsiXPpO4JgsL5DTpWOTw8eBkeiV2+rIKuGgQMotZ0SAI7RWwpx
         0ShfZQ8eZ3HllCJcSFcjsW2INCUP/2v8ce2CY6gkX3QczNeUdyirOrQg6gfgqCsJq4
         YkC9oPHBRkqS0GjQmcMZglNeLx7JK39ZPlaWeMs4swjaHoP16joFQbwnllYtmiOGHc
         LeNSsHDde10lowBxMcZXQDy35hUWn9UNT0fkLcujUOyU7PFWxHwnZBPgcp7XPeVWWn
         x/5qqMciDPWKg==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id A0EBEA0057;
        Tue,  2 Jul 2019 09:12:13 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 2000D3FECB;
        Tue,  2 Jul 2019 11:12:13 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next] net: stmmac: Re-word Kconfig entry
Date:   Tue,  2 Jul 2019 11:12:10 +0200
Message-Id: <eac9ac857255993581bec265fb5ce7e3bdd20c78.1562058669.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We support many speeds and it doesn't make much sense to list them all
in the Kconfig. Let's just call it Multi-Gigabit.

Suggested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 2acb999b7f63..943189dcccb1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config STMMAC_ETH
-	tristate "STMicroelectronics 10/100/1000/EQOS/2500/5000/10000 Ethernet driver"
+	tristate "STMicroelectronics Multi-Gigabit Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
 	select PHYLINK
-- 
2.7.4

