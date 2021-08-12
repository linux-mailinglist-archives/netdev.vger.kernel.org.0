Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724543EA2C2
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhHLKHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:07:54 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:24237 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbhHLKHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 06:07:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628762848; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=pfs7bphLr84b60SKfpIAI0Zp8QrmUutMvnQtmN/Dwhs=; b=YrrGvqcge/GK5SoOp8MoTDYJkP503JafmH9EkUGfxa+2aanDaQTrtYWo/+ijVa5mFrq9WFDV
 8jf7mtzbmnhV3CF3XjImPREWmUASbEDFT+zz60qaEdsYIBEkBaJ8fMEvkiW+T3IZp5iF/PXx
 i4wbznf0eXzTBV51vyXjzm9fLn4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6114f2cc454b7a558f14c788 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 12 Aug 2021 10:07:08
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7FCD2C43460; Thu, 12 Aug 2021 10:07:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CF12CC433D3;
        Thu, 12 Aug 2021 10:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CF12CC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, agross@kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        robert.marko@sartura.hr
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 2/3] MDIO: Kconfig: Specify more IPQ chipset supported
Date:   Thu, 12 Aug 2021 18:06:41 +0800
Message-Id: <20210812100642.1800-3-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210812100642.1800-1-luoj@codeaurora.org>
References: <20210812100642.1800-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPQ MDIO driver currently supports the chipset IPQ40xx, IPQ807x,
IPQ60xx and IPQ50xx.

Add the compatible 'qcom,ipq5018-mdio' because of ethernet LDO dedicated
to the IPQ5018 platform.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/mdio/Kconfig        | 2 +-
 drivers/net/mdio/mdio-ipq4019.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index a94d34cc7dc1..6da1fcb25847 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -172,7 +172,7 @@ config MDIO_IPQ4019
 	depends on COMMON_CLK
 	help
 	  This driver supports the MDIO interface found in Qualcomm
-	  IPQ40xx series Soc-s.
+	  IPQ40xx, IPQ60xx, IPQ807x and IPQ50xx series Soc-s.
 
 config MDIO_IPQ8064
 	tristate "Qualcomm IPQ8064 MDIO interface support"
diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index e14d437e42a8..14e08b786334 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -258,6 +258,7 @@ static int ipq4019_mdio_remove(struct platform_device *pdev)
 
 static const struct of_device_id ipq4019_mdio_dt_ids[] = {
 	{ .compatible = "qcom,ipq4019-mdio" },
+	{ .compatible = "qcom,ipq5018-mdio" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ipq4019_mdio_dt_ids);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

