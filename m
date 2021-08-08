Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D1B3E3961
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 09:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhHHHWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 03:22:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:21588 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhHHHWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 03:22:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628407306; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=fhmTdFlO7B+pDaZJEx7ZsxKpYgii7y1RdKtso6bZJVE=; b=qg9d3HUrN6XCppr1+OsXTO/PZ6OtMpt8r+IX5flgifAuhyWG5h+RqxM7J58zDZeoNeyRsYbn
 2zgWWS3qjor95BuKJf54p+1WjhNJDH+8lsk0QBl6gk90C0J/uuns5o/Lxffo3iEzXz0i30vB
 MYbM0iLv3ccKS1nn/7Pp2fwb8RA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 610f8606454b7a558f396546 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 08 Aug 2021 07:21:42
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 98517C43143; Sun,  8 Aug 2021 07:21:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 95E77C433F1;
        Sun,  8 Aug 2021 07:21:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 95E77C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v1 2/2] MDIO: Kconfig: Specify more IPQ chipset supported
Date:   Sun,  8 Aug 2021 15:21:11 +0800
Message-Id: <20210808072111.8365-3-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210808072111.8365-1-luoj@codeaurora.org>
References: <20210808072111.8365-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPQ MDIO driver currently supports IPQ40xx, IPQ807x, IPQ60xx and IPQ50xx.

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
index b365f13c92ca..bc26b1459b12 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -262,6 +262,7 @@ static int ipq4019_mdio_remove(struct platform_device *pdev)
 
 static const struct of_device_id ipq4019_mdio_dt_ids[] = {
 	{ .compatible = "qcom,ipq4019-mdio" },
+	{ .compatible = "qcom,ipq5018-mdio" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ipq4019_mdio_dt_ids);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

