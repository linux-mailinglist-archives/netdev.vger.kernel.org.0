Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870303E3A19
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhHHMB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:01:26 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:63409 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhHHMBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:01:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628424065; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=j7IQGffXK9kg88UgcrOPnQ5BKDVt8kfsqhGLmgRIpBM=; b=nbfTeh75Rh7jiWwssxPtMsC49zhKEKcq2X+eygN8DHl6gOZ3QhSYvPU8c9RzPWk7HlcCgl61
 kq5473bCt9CFRtDQABp3+3cOCnKShazEVOUOzI+yHfmFqjQ1r1Gx+H4Y4hVIRQd36VtjlISV
 vP0AGGvx+Ps93Pv0G8hiIMdi+GA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 610fc76bb4dfc4b0ef65921d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 08 Aug 2021 12:00:43
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 61289C433F1; Sun,  8 Aug 2021 12:00:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C0C2C43217;
        Sun,  8 Aug 2021 12:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5C0C2C43217
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [Resend v1 2/2] MDIO: Kconfig: Specify more IPQ chipset supported
Date:   Sun,  8 Aug 2021 20:00:18 +0800
Message-Id: <20210808120018.2480-3-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210808120018.2480-1-luoj@codeaurora.org>
References: <20210808120018.2480-1-luoj@codeaurora.org>
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
index 2b6a193f2d67..daaaf1c23f07 100644
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

