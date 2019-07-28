Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0772577C99
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 02:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbfG1A6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 20:58:06 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:57903 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbfG1A6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 20:58:06 -0400
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 28 Jul 2019 08:58:04 +0800
Received: from akronite-sh-dev01.ap.qualcomm.com ([10.231.215.213])
  by ironmsg03-tai.qualcomm.com with ESMTP; 28 Jul 2019 08:57:52 +0800
Received: by akronite-sh-dev01.ap.qualcomm.com (Postfix, from userid 206661)
        id E5F7D1F2F4; Sun, 28 Jul 2019 08:57:51 +0800 (CST)
From:   xiaofeis <xiaofeis@codeaurora.org>
To:     davem@davemloft.net
Cc:     vkoul@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org,
        xiaofeis <xiaofeis@codeaurora.org>
Subject: [PATCH v3] net: dsa: qca8k: enable port flow control
Date:   Sun, 28 Jul 2019 08:57:50 +0800
Message-Id: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set phy device advertising to enable MAC flow control.

Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
---
Changes since V2:
 drivers/net/dsa/qca8k.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 232e8cc..e429e92 100644
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
 
+	phy_support_asym_pause(phy);
+
 	return 0;
 }
 
-- 
1.9.1

