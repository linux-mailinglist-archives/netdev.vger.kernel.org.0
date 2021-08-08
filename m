Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4878A3E3962
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 09:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhHHHWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 03:22:07 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11063 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhHHHWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 03:22:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628407307; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=U+e8PUX7vWPWwhyHYeFwTSGI6gjNe38VUz/tfvLZHvM=; b=gDIplNDj8iYA+zQLbeqBlXXID4WokKWIZVutZ2KOavjOOYzhVmYCy6m+LUFEm7E1fE1kXujw
 JP5Jw0Kw2Y2IyNPbu70cWM65mvGU3JfVrcb3HZvaUoElKsFum8frVxKwYzzBB9Z11pXsoAJt
 y2rLwYip5PB6QisHQak1dODxtEg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 610f8602fedc92032876f951 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 08 Aug 2021 07:21:38
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62A17C433F1; Sun,  8 Aug 2021 07:21:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8869C433F1;
        Sun,  8 Aug 2021 07:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8869C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v1 0/2] net: mdio: Add IPQ MDIO reset related function
Date:   Sun,  8 Aug 2021 15:21:09 +0800
Message-Id: <20210808072111.8365-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the MDIO reset features, which includes
configuring MDIO clock source frequency and indicating CMN_PLL that
ethernet LDO has been ready, this ethernet LDO is dedicated in the
IPQ5018 platform.

Specify more chipset IPQ40xx, IPQ807x, IPQ60xx and IPQ50xx supported by
this MDIO driver.

The PHY reset with GPIO and PHY reset with reset controller are covered
by the phylib code, so remove the PHY reset related code from the
initial patch series. 

Luo Jie (2):
  net: mdio: Add the reset function for IPQ MDIO driver
  MDIO: Kconfig: Specify more IPQ chipset supported

 drivers/net/mdio/Kconfig        |  3 ++-
 drivers/net/mdio/mdio-ipq4019.c | 48 +++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 1 deletion(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

