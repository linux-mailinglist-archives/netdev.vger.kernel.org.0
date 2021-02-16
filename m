Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE2231D0B5
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhBPTJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhBPTJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:09:22 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2388C061574;
        Tue, 16 Feb 2021 11:08:41 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 189so6755128pfy.6;
        Tue, 16 Feb 2021 11:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DDbSq81kjRkOQSUTzOFIYpBc78afn8u5F423xQVG7+o=;
        b=Ltg5ikKcb0pCOGL0abodIN4jACPbtcMJVs6Avt3uZq6GD2/35DkE9CzT6LlLd4TilK
         zaNxK+Jo6CfHnUwIAChIYTdt2O2sbskRWZo893re/h0V1myauWJ6RwNZq1BryVNHuPAW
         +c6laF7erLx2FX24qTWEeI4DjLwXgM6pfvlG/thOTlhKL+N0U9pla6MVZlHXdIJe25fS
         bPJpsKiMxHuznTlsRi5eq/71HNt3GJtKukKaDPXyt+LG/1D3VNfL/s5W2oVT2kYuA1Mq
         OU6O+Bwgc5rmCiaHP2GYFWIws5cPWZBbPnfuTC233cVGWzuW4/Go/laoTfGryZvww+MQ
         x4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DDbSq81kjRkOQSUTzOFIYpBc78afn8u5F423xQVG7+o=;
        b=PtORNNKkpyWYj8BP18g3Rg9KJR12ruoaDL/E42Ny0jUybzvSZsorRGfv3inrjMN+bl
         BgKG7t7cdXd/0ALo+R+lHxXDcjif0o5ixPg5C6sTmQ9w6togszx90OAUDR2ARzJtVjkO
         5kkU1nvR/y0O5h6QvdQ3NUJ7FLtlA9rwrLp1gs1DSfqOsU3WkWtQjoBUupwGYD7qXNPe
         94HgI/4E1+M2eRdIQ/pXftvyaUF1UQeFFzz3qPc0MnjRAOwxPdl8xDTMM6MOQcjTkYZP
         TykcEUXfVQyUas0ENkUO6DpvG7hPYr+0wGiwMxmCKaSQVPwApdXYt0Lxu5CiZzefG7Iq
         KmCw==
X-Gm-Message-State: AOAM531aM8VnXVb9kP+OCxls1wNpdAg7lJwJFNUGzLPJ5XsSbGb4pvLM
        XzRRt70/DnTYbQxXZAqNLWYL3+fxyK8=
X-Google-Smtp-Source: ABdhPJwsHwl1Xz3y4SIE7CHwzzUelTZlM0h7OwnCX6edk/4HEYyALH7z0PZRu5DQrAzPokoj5dBIDw==
X-Received: by 2002:a62:3503:0:b029:1aa:6f15:b9fe with SMTP id c3-20020a6235030000b02901aa6f15b9femr20747796pfa.65.1613502520918;
        Tue, 16 Feb 2021 11:08:40 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id lr7sm3420137pjb.56.2021.02.16.11.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 11:08:40 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS)
Subject: [PATCH] tg3: Remove unused PHY_BRCM flags
Date:   Tue, 16 Feb 2021 11:08:37 -0800
Message-Id: <20210216190837.2555691-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tg3 driver tried to communicate towards the PHY driver whether it
wanted RGMII in-band signaling enabled or disabled however there is
nothing that looks at those flags in drivers/net/phy/broadcom.c so this
does do not anything.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 6 ------
 include/linux/brcmphy.h             | 9 +++------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 8936c2bc6286..d2381929931b 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1580,12 +1580,6 @@ static int tg3_mdio_init(struct tg3 *tp)
 				     PHY_BRCM_RX_REFCLK_UNUSED |
 				     PHY_BRCM_DIS_TXCRXC_NOENRGY |
 				     PHY_BRCM_AUTO_PWRDWN_ENABLE;
-		if (tg3_flag(tp, RGMII_INBAND_DISABLE))
-			phydev->dev_flags |= PHY_BRCM_STD_IBND_DISABLE;
-		if (tg3_flag(tp, RGMII_EXT_IBND_RX_EN))
-			phydev->dev_flags |= PHY_BRCM_EXT_IBND_RX_ENABLE;
-		if (tg3_flag(tp, RGMII_EXT_IBND_TX_EN))
-			phydev->dev_flags |= PHY_BRCM_EXT_IBND_TX_ENABLE;
 		fallthrough;
 	case PHY_ID_RTL8211C:
 		phydev->interface = PHY_INTERFACE_MODE_RGMII;
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 16597d3fa011..8fe1d55371ac 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -63,12 +63,9 @@
 
 #define PHY_BRCM_AUTO_PWRDWN_ENABLE	0x00000001
 #define PHY_BRCM_RX_REFCLK_UNUSED	0x00000002
-#define PHY_BRCM_STD_IBND_DISABLE	0x00000004
-#define PHY_BRCM_EXT_IBND_RX_ENABLE	0x00000008
-#define PHY_BRCM_EXT_IBND_TX_ENABLE	0x00000010
-#define PHY_BRCM_CLEAR_RGMII_MODE	0x00000020
-#define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00000040
-#define PHY_BRCM_EN_MASTER_MODE		0x00000080
+#define PHY_BRCM_CLEAR_RGMII_MODE	0x00000004
+#define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00000008
+#define PHY_BRCM_EN_MASTER_MODE		0x00000010
 
 /* Broadcom BCM7xxx specific workarounds */
 #define PHY_BRCM_7XXX_REV(x)		(((x) >> 8) & 0xff)
-- 
2.25.1

