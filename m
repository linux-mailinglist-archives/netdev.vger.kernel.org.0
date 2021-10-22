Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D235E437664
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhJVMJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:09:04 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:20293 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhJVMJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 08:09:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634904404; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=gQd5lf95NWDRdVZli/PyLh37xveJUHlcO8QW95Vfjxc=; b=WjfUrfm2F86h/n/k0O/1Ph7fVeyxfWqEFwy0vzgnvZT4yxXt82A1R6fA55+Oj9NowiEg9tcS
 jR5ir/+nAv/bE9eReCYZ27O2DaioKAUmNueS28MWwOK2Rv9c1f76GHbeiMvbh058E08q711w
 Sp+tH5l4h3y+QrU9bWXygea7Cnk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6172a950321f240051baa0ca (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 Oct 2021 12:06:40
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 70C56C43619; Fri, 22 Oct 2021 12:06:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9E5C7C43616;
        Fri, 22 Oct 2021 12:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 9E5C7C43616
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v4 01/14] net: phy: at803x: replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS
Date:   Fri, 22 Oct 2021 20:06:11 +0800
Message-Id: <20211022120624.18069-2-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211022120624.18069-1-luoj@codeaurora.org>
References: <20211022120624.18069-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3feee4d59030..b04fb251bacb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -70,7 +70,6 @@
 #define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
 #define AT803X_LED_CONTROL			0x18
 
-#define AT803X_DEVICE_ADDR			0x03
 #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
 #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
 #define AT803X_LOC_MAC_ADDR_32_47_OFFSET	0x804A
@@ -330,7 +329,8 @@ static int at803x_set_wol(struct phy_device *phydev,
 	const u8 *mac;
 	int ret;
 	u32 value;
-	unsigned int i, offsets[] = {
+	unsigned int i;
+	const unsigned int offsets[] = {
 		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
 		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
 		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
@@ -346,7 +346,7 @@ static int at803x_set_wol(struct phy_device *phydev,
 			return -EINVAL;
 
 		for (i = 0; i < 3; i++)
-			phy_write_mmd(phydev, AT803X_DEVICE_ADDR, offsets[i],
+			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
 				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
 
 		value = phy_read(phydev, AT803X_INTR_ENABLE);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

