Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78EE2EC1CF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbhAFRKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbhAFRK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:10:29 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77A9C06134C;
        Wed,  6 Jan 2021 09:09:49 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id c132so2658822pga.3;
        Wed, 06 Jan 2021 09:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MYeP/uvWBFHe2FlwmtWLN2ABOHOAqDXitrzhMsjGg74=;
        b=is1k7bDKWYfD76GDU+G7NsA4ngQ+j6tJwTsqZB6gaZ67vcB2L7Wgid4wuPJO+Skz1Y
         pBfRdGwLOR/X0gwiKtaoGfORmyrjr4QlmpI9v4xxBYHX/6/9Wf9VLfzQVPxml5WioJTK
         xuorzQAM7VNF0kUNFHM+wnKbJ/7thEEFoNMnBIh6VJ4o5CNQp6rhvIwAJWTO4oQypdDd
         +lhTXX5k/YDUeYtbitJbFDUDemfSNNmILCnhaSl3MMtbMF2xVgsXUhrDVu5HIs1eJ4Rm
         sX2ifypo0JEoKDBj0ZHgHwCFSe60O7B4mrmLmPaYeAXRAY1zYgeJ2KBOxBXyQC0nK1qw
         rOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MYeP/uvWBFHe2FlwmtWLN2ABOHOAqDXitrzhMsjGg74=;
        b=Sb/3MId/+ZQ4CWTQNdgcJ/qXLbGzN9EaO0PGzNH3Tlt12AXZxjxyCp7wvrL5CQvzCD
         eCdbnejFqLJb2So1zRmI9YZC45UQzPt3gnHrj+l8luoWunCmBIBKzrIqf85xS0UVi1Ep
         7qo3jKmQ4xZpGn4U38mo/WdMQrMpPsW+vM2kMWasHdXdRCjEA/a0bcvMlhW5ZlnvZamn
         wqrIi7x2tbsJC0SU1ZUGDyO9tfvk4TFDuhEVTgG674D8f2w582F9iHwuQWgiHHmZq0yz
         CigfJ0ctPGJXDISiGj7eVAEUq3MqPCjIZA/2P0fCArmK0jGZA/SyP6a4qd91ETot+X+i
         cLAA==
X-Gm-Message-State: AOAM53362SvIbU0a0GjD/Kw0aLo0yDjotliW3kH+nZL6hmaEeWI2dmOy
        J53X25N6dUBY+W9kLwpkFv/dM2ACTEA=
X-Google-Smtp-Source: ABdhPJzuBeVyrOnHzHxNOmN/knrCTRXE6Mr8hOG2HniOtC6BhhtU4N1vbfUCdtpuH09jWxIugTc+sQ==
X-Received: by 2002:a62:ee03:0:b029:1a9:cc29:7d1f with SMTP id e3-20020a62ee030000b02901a9cc297d1fmr4939696pfi.24.1609952988851;
        Wed, 06 Jan 2021 09:09:48 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f9sm3198944pfa.41.2021.01.06.09.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 09:09:48 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: bcm7xxx: Add an entry for BCM72116
Date:   Wed,  6 Jan 2021 09:09:44 -0800
Message-Id: <20210106170944.1253046-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM72116 features a 28nm integrated EPHY, add an entry to match this PHY
OUI.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 2 ++
 include/linux/brcmphy.h   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 15812001b3ff..e79297a4bae8 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -612,6 +612,7 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 
 static struct phy_driver bcm7xxx_driver[] = {
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM72113, "Broadcom BCM72113"),
+	BCM7XXX_28NM_EPHY(PHY_ID_BCM72116, "Broadcom BCM72116"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7250, "Broadcom BCM7250"),
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM7255, "Broadcom BCM7255"),
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM7260, "Broadcom BCM7260"),
@@ -633,6 +634,7 @@ static struct phy_driver bcm7xxx_driver[] = {
 
 static struct mdio_device_id __maybe_unused bcm7xxx_tbl[] = {
 	{ PHY_ID_BCM72113, 0xfffffff0 },
+	{ PHY_ID_BCM72116, 0xfffffff0, },
 	{ PHY_ID_BCM7250, 0xfffffff0, },
 	{ PHY_ID_BCM7255, 0xfffffff0, },
 	{ PHY_ID_BCM7260, 0xfffffff0, },
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index d0bd226d6bd9..de9430d55c90 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -31,6 +31,7 @@
 #define PHY_ID_BCM89610			0x03625cd0
 
 #define PHY_ID_BCM72113			0x35905310
+#define PHY_ID_BCM72116			0x35905350
 #define PHY_ID_BCM7250			0xae025280
 #define PHY_ID_BCM7255			0xae025120
 #define PHY_ID_BCM7260			0xae025190
-- 
2.25.1

