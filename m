Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FAB4382EC
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhJWJ6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:58:37 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:18172 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhJWJ6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 05:58:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634982942; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=7zahY8FGLfXbTxBHrZgxPC3+TNZQHFPBnh8b/yiXqO4=; b=SfllSeiRYseTkjuNDky9DTNULPPRfDlQdTnV1GSrJjSHXwQ4/JsAqs8llQ7UpUJegHBedt//
 4XJBftt+CK8QxGpuziyCSL+WqXXcGFAJV9Nw2QPPPpFjYzXxtn5WCQ9YErr67TBFfaX/2n1P
 W9tlCdZmsiG/WaPCrxbtb4fmPPE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6173dc18e29a872c212e6883 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 09:55:36
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AFA7EC072DE; Sat, 23 Oct 2021 09:55:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48CA6C447B7;
        Sat, 23 Oct 2021 09:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 48CA6C447B7
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v6 09/14] net: phy: add constants for fast retrain related register
Date:   Sat, 23 Oct 2021 17:54:48 +0800
Message-Id: <20211023095453.22615-10-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023095453.22615-1-luoj@codeaurora.org>
References: <20211023095453.22615-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the constants for 2.5G fast retrain capability
in 10G AN control register, fast retrain status and
control register and THP bypass register into mdio.h.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 include/uapi/linux/mdio.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index bdf77dffa5a4..c54e6eae5366 100644
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
 
@@ -247,6 +252,7 @@
 #define MDIO_PCS_10GBRT_STAT2_BER	0x3f00
 
 /* AN 10GBASE-T control register. */
+#define MDIO_AN_10GBT_CTRL_ADVFSRT2_5G	0x0020	/* Advertise 2.5GBASE-T fast retrain */
 #define MDIO_AN_10GBT_CTRL_ADV2_5G	0x0080	/* Advertise 2.5GBASE-T */
 #define MDIO_AN_10GBT_CTRL_ADV5G	0x0100	/* Advertise 5GBASE-T */
 #define MDIO_AN_10GBT_CTRL_ADV10G	0x1000	/* Advertise 10GBASE-T */
@@ -289,6 +295,9 @@
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

