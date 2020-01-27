Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF314A2BA
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgA0LPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:15:55 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:44516 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726771AbgA0LPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:15:52 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1C2714067C;
        Mon, 27 Jan 2020 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580123371; bh=PJxQQe6LRMVQ+GUC/YIJKHseFjn16R2owaP2nQ3enlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Qdpr2Gi5s0uO+ZwqvE+R8q1qOVFfkM7ge2D/ymd6F+mCKwI7QpDDT5TRocLwkxVGJ
         L0Fs6xdCTz1mlZ/SMe1yEKgXhZ86HoYLYBTPcOo+HPn649Me1WD3g90R/tPNFVovvI
         8pq+OjywGFrUiX0oGdQ2xWw8Zsz2Xp71i/kQ3jl+mtON5NjeF8GrFkQUPhJgS9uM7S
         JIB5HTeRQRH5XUcqAZT6P8eWR1ZjTJxKWG+L+giI+MdTGIZLN2Yz5hCSwnmAVgcdkN
         51Qx4Ame0LIUbJ/bVRRYJzaf+FASIJY+dztnT571qQNfDtVfwFlxAXSirQT5CFWxDA
         qUlpWlYlxB4yQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 84564A005E;
        Mon, 27 Jan 2020 11:09:28 +0000 (UTC)
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
Subject: [RFC net-next 1/8] net: stmmac: selftests: Do not fail if PHY is not attached
Date:   Mon, 27 Jan 2020 12:09:06 +0100
Message-Id: <9634df6d4cfe28e3f4ca06791c3488e687bb249e.1580122909.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a PHY is not attached, we can still run the tests with MAC loopback
mode. Return -EOPNOTSUPP error code in PHY loopback test so that global
status is not a failure.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 2aba2673d6c3..586a657be984 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -380,7 +380,7 @@ static int stmmac_test_phy_loopback(struct stmmac_priv *priv)
 	int ret;
 
 	if (!priv->dev->phydev)
-		return -EBUSY;
+		return -EOPNOTSUPP;
 
 	ret = phy_loopback(priv->dev->phydev, true);
 	if (ret)
-- 
2.7.4

