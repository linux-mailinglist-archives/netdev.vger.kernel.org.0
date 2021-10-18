Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D82F430E3A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhJRDge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:36:34 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:16022 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhJRDgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 23:36:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528055; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=p3H8RqPS9Cos4ekAUzPQhrOXNmu756X/LerUBEhGN1M=; b=HigSD4mdsij0oco9VcWJtWqIkacPrU59wwpsOg3XCLHxr/QWdFlOcCYSoHfyyjW/QqrA8P36
 LbdjvhbUPOaxLyoUGQRP+ZIwx6/RrQAl4/7G+3BWA/Blp5kZnYi8pZMAx9mrbZYUzKNasBHp
 tE4+j5IqY4l2qAnPN3vgBHFYajI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 616ceb3603355859c87c6f13 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:34:14
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B6F01C4360D; Mon, 18 Oct 2021 03:34:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02AE9C43616;
        Mon, 18 Oct 2021 03:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 02AE9C43616
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 09/13] net: phy: add constants for fast retrain related register
Date:   Mon, 18 Oct 2021 11:33:29 +0800
Message-Id: <20211018033333.17677-10-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add constants for 2.5G and 5G fast retrain capability
in 10G AN control register, fast retrain status and
control register and THP bypass register into mdio.h.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 include/uapi/linux/mdio.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index bdf77dffa5a4..7276e7c3dc0a 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -53,12 +53,14 @@
 #define MDIO_AN_EEE_LPABLE	61	/* EEE link partner ability */
 #define MDIO_AN_EEE_ADV2	62	/* EEE advertisement 2 */
 #define MDIO_AN_EEE_LPABLE2	63	/* EEE link partner ability 2 */
+#define MDIO_AN_CTRL2		64	/* AN THP bypass request control */
 
 /* Media-dependent registers. */
 #define MDIO_PMA_10GBT_SWAPPOL	130	/* 10GBASE-T pair swap & polarity */
 #define MDIO_PMA_10GBT_TXPWR	131	/* 10GBASE-T TX power control */
 #define MDIO_PMA_10GBT_SNR	133	/* 10GBASE-T SNR margin, lane A.
 					 * Lanes B-D are numbered 134-136. */
+#define MDIO_PMA_10GBR_FSRT_CSR	147	/* 10GBASE-R fast retrain status and control */
 #define MDIO_PMA_10GBR_FECABLE	170	/* 10GBASE-R FEC ability */
 #define MDIO_PCS_10GBX_STAT1	24	/* 10GBASE-X PCS status 1 */
 #define MDIO_PCS_10GBRT_STAT1	32	/* 10GBASE-R/-T PCS status 1 */
@@ -239,6 +241,9 @@
 #define MDIO_PMA_10GBR_FECABLE_ABLE	0x0001	/* FEC ability */
 #define MDIO_PMA_10GBR_FECABLE_ERRABLE	0x0002	/* FEC error indic. ability */
 
+/* PMA 10GBASE-R Fast Retrain status and control register. */
+#define MDIO_PMA_10GBR_FSRT_ENABLE	0x0001	/* Fast retrain enable */
+
 /* PCS 10GBASE-R/-T status register 1. */
 #define MDIO_PCS_10GBRT_STAT1_BLKLK	0x0001	/* Block lock attained */
 
@@ -247,6 +252,8 @@
 #define MDIO_PCS_10GBRT_STAT2_BER	0x3f00
 
 /* AN 10GBASE-T control register. */
+#define MDIO_AN_10GBT_CTRL_ADVLPTIMING	0x0001	/* Advertise loop timing */
+#define MDIO_AN_10GBT_CTRL_ADVFSRT2_5G	0x0020	/* Advertise 2.5GBASE-T fast retrain */
 #define MDIO_AN_10GBT_CTRL_ADV2_5G	0x0080	/* Advertise 2.5GBASE-T */
 #define MDIO_AN_10GBT_CTRL_ADV5G	0x0100	/* Advertise 5GBASE-T */
 #define MDIO_AN_10GBT_CTRL_ADV10G	0x1000	/* Advertise 10GBASE-T */
@@ -289,6 +296,9 @@
 #define MDIO_EEE_2_5GT		0x0001	/* 2.5GT EEE cap */
 #define MDIO_EEE_5GT		0x0002	/* 5GT EEE cap */
 
+/* AN MultiGBASE-T AN control 2 */
+#define MDIO_AN_THP_BP2_5GT	0x0008	/* 2.5GT THP bypass request */
+
 /* 2.5G/5G Extended abilities register. */
 #define MDIO_PMA_NG_EXTABLE_2_5GBT	0x0001	/* 2.5GBASET ability */
 #define MDIO_PMA_NG_EXTABLE_5GBT	0x0002	/* 5GBASET ability */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

