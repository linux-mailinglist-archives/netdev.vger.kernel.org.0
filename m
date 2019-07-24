Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8331072720
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 07:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfGXFDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 01:03:14 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:26661 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfGXFDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 01:03:14 -0400
Received: from ironmsg02-tai.qualcomm.com ([10.249.140.7])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 24 Jul 2019 13:03:12 +0800
X-IronPort-AV: E=McAfee;i="6000,8403,9326"; a="35255352"
Received: from akronite-sh-dev01.ap.qualcomm.com ([10.231.215.213])
  by ironmsg02-tai.qualcomm.com with ESMTP; 24 Jul 2019 13:03:00 +0800
Received: by akronite-sh-dev01.ap.qualcomm.com (Postfix, from userid 206661)
        id 3E23C1F617; Wed, 24 Jul 2019 13:02:59 +0800 (CST)
From:   xiaofeis <xiaofeis@codeaurora.org>
To:     davem@davemloft.net
Cc:     vkoul@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org,
        xiaofeis <xiaofeis@codeaurora.org>
Subject: [PATCH v2] net: dsa: qca8k: enable port flow control
Date:   Wed, 24 Jul 2019 13:02:56 +0800
Message-Id: <1563944576-62844-1-git-send-email-xiaofeis@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set phy device advertising to enable MAC flow control.

Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
---
 drivers/net/dsa/qca8k.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 232e8cc..c5ac426 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2009 Felix Fietkau <nbd@nbd.name>
  * Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
- * Copyright (c) 2015, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2015, 2019, The Linux Foundation. All rights reserved.
  * Copyright (c) 2016 John Crispin <john@phrozen.org>
  */
 
@@ -935,6 +935,8 @@
 	qca8k_port_set_status(priv, port, 1);
 	priv->port_sts[port].enabled = 1;
 
+	phy->advertising |= ADVERTISED_Pause | ADVERTISED_Asym_Pause;
+
 	return 0;
 }
 
-- 
1.9.1

