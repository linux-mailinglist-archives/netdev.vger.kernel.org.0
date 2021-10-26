Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E843B002
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhJZKc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:32:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:32726 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhJZKcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:32:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635244229; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=cfYktSnF61tp4+qWETQB8sWA7Wbx9jrqWirPe1RCJvQ=; b=iN8v22PTMumwJLZKOkg+WCF8oJ29vJvWJvccwfyIgGLgbRD+oF1ywKC+6vrjQvhPFEH67plu
 LChO+9MKqFGeaQYeIg5frSjLEMiKB0OSQKiGcwQIBKVl/R8xLclncZn5RgWURzPQmHbZHCkY
 H3c9XBtLiHG93LDdwYUlpQ7Pthw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6177d8b259612e0100e6a8b7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Oct 2021 10:30:10
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4870AC43617; Tue, 26 Oct 2021 10:30:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3B8FC4338F;
        Tue, 26 Oct 2021 10:30:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B3B8FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luo Jie <luoj@codeaurora.org>
Subject: [PATCH] net: phy: fixed warning: Function parameter not described
Date:   Tue, 26 Oct 2021 18:29:57 +0800
Message-Id: <20211026102957.17100-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed warning: Function parameter or member 'enable' not
described in 'genphy_c45_fast_retrain'

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/phy-c45.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index b01180e1f578..db709d30bf84 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -614,6 +614,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_loopback);
 /**
  * genphy_c45_fast_retrain - configure fast retrain registers
  * @phydev: target phy_device struct
+ * @enable: enable fast retrain or not
  *
  * Description: If fast-retrain is enabled, we configure PHY as
  *   advertising fast retrain capable and THP Bypass Request, then
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

