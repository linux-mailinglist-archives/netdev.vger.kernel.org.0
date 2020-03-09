Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C9C17DB1C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgCIIhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:37:09 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42500 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbgCIIgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:36:45 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F1330C04C1;
        Mon,  9 Mar 2020 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583743004; bh=G3io2HtqWrz75qyPw31i1mMVlC9mUpQx2JEEWDPYGq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=UE4HnfD9Y4yrPQJP78MfJT9lw1jU3QpfncTPiPFXyfjvW7PEh9FIzKpneVk0wQ7XT
         fIYqs5Nk07lIV0u40Ht7NP0nomYopwWWuXXeRd7bs91XqdtgwyLbd0qJ39GfWd1I6R
         1iLsFtBssXKINU1hgu4KKDrCByE2iMRKsmn/ElRXyN404iRRwljyGIkyhHDlCceORR
         aF4vADoFRFNHLy1NpRRTKgQ5jMDQuI/+4v5ht3kZ4AQT9/W25CnPexj0KFL3uLOoR9
         e8yTWEI5ksEhHApIgDVcYqTRLP2KCZMvKrlQXBpABLjFv3TuGsZ8wPm4BKodLQIMSA
         uXdmQR6FL9qDg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5E9FAA0071;
        Mon,  9 Mar 2020 08:36:41 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] net: phylink: Add missing Backplane speeds
Date:   Mon,  9 Mar 2020 09:36:24 +0100
Message-Id: <72f937085fd6167f9dd6e8c72e0f7f0a161d8001.1583742616.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USXGMII also supports these missing backplane speeds.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phylink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b4367fab7899..47f4ce02d7bc 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -312,11 +312,13 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 1000baseT_Half);
 			phylink_set(pl->supported, 1000baseT_Full);
 			phylink_set(pl->supported, 1000baseX_Full);
+			phylink_set(pl->supported, 1000baseKX_Full);
 			phylink_set(pl->supported, 2500baseT_Full);
 			phylink_set(pl->supported, 2500baseX_Full);
 			phylink_set(pl->supported, 5000baseT_Full);
 			phylink_set(pl->supported, 10000baseT_Full);
 			phylink_set(pl->supported, 10000baseKR_Full);
+			phylink_set(pl->supported, 10000baseKX4_Full);
 			phylink_set(pl->supported, 10000baseCR_Full);
 			phylink_set(pl->supported, 10000baseSR_Full);
 			phylink_set(pl->supported, 10000baseLR_Full);
-- 
2.7.4

