Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A286D93F
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 05:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfGSDAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 23:00:21 -0400
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:42783 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726015AbfGSDAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 23:00:21 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jul 2019 23:00:20 EDT
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 19 Jul 2019 10:54:13 +0800
X-IronPort-AV: E=McAfee;i="6000,8403,9322"; a="34578808"
Received: from akronite-sh-dev01.ap.qualcomm.com ([10.231.215.213])
  by ironmsg03-tai.qualcomm.com with ESMTP; 19 Jul 2019 10:54:01 +0800
Received: by akronite-sh-dev01.ap.qualcomm.com (Postfix, from userid 206661)
        id 9FB7E1F42B; Fri, 19 Jul 2019 10:54:00 +0800 (CST)
From:   xiaofeis <xiaofeis@codeaurora.org>
To:     davem@davemloft.net
Cc:     vkoul@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org,
        xiaofeis <xiaofeis@codeaurora.org>
Subject: [PATCH] qca8k: enable port flow control
Date:   Fri, 19 Jul 2019 10:53:11 +0800
Message-Id: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set phy device advertising to enable MAC flow control.

Change-Id: Ibf0f554b072fc73136ec9f7ffb90c20b25a4faae
Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
---
 drivers/net/dsa/qca8k.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d93be14..95ac081 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2009 Felix Fietkau <nbd@nbd.name>
  * Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
- * Copyright (c) 2015, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2015, 2019, The Linux Foundation. All rights reserved.
  * Copyright (c) 2016 John Crispin <john@phrozen.org>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -800,6 +800,8 @@
 	qca8k_port_set_status(priv, port, 1);
 	priv->port_sts[port].enabled = 1;
 
+	phy->advertising |= (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
+
 	return 0;
 }
 
-- 
1.9.1

