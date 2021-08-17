Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F393EEBFB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 13:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbhHQLzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 07:55:43 -0400
Received: from smtpbg126.qq.com ([106.55.201.22]:32794 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239829AbhHQLzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 07:55:41 -0400
X-QQ-mid: bizesmtp40t1629201286t3laxpke
Received: from localhost.localdomain (unknown [125.69.42.50])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 17 Aug 2021 19:54:45 +0800 (CST)
X-QQ-SSF: 01000000004000B0C000B00A0000000
X-QQ-FEAT: +fe027EjEe5RZpPMlp4GprPwn6YSKJr5uthjgoWzpBs8nbxTaGok0VJd5XDBP
        17HtfNorSXskbLhJFrXSavGnZBbpUgePGuJzA6V5ooyBKoSnawrMC9XoviOG3el86G3/BnG
        ErUz4QuSjV2bar3TxiYWZBeD6dlruwnTQo+gmzwZiboXzzfnOqs7Al7JZB/fVWZGf2YIIxJ
        pbXyp9DCt2ytVWbh7u9UI871aLX3EQPbfZX6tZzMEyE7Cjb5isud2w8HZhBE1n2VpK3XaUA
        5Uny8aPT/FiSNlA/LGPp4R3kj0S8q4nmJNla4UmdLDJolUoNTSEZ3B3HYWcA1qRSxv3UAAO
        kx4SN2sap3HVC/AIMVGXZmthXVeVw==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kvalo@codeaurora.org
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] ipw2x00: no need to initilise statics to 0
Date:   Tue, 17 Aug 2021 19:54:38 +0800
Message-Id: <20210817115438.33449-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Global static variables dont need to be initialised to 0. Because
the compiler will initilise them.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 47eb89b773cf..6bfe55d79ce1 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -173,11 +173,11 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
-static int debug = 0;
-static int network_mode = 0;
-static int channel = 0;
-static int associate = 0;
-static int disable = 0;
+static int debug;
+static int network_mode;
+static int channel;
+static int associate;
+static int disable;
 #ifdef CONFIG_PM
 static struct ipw2100_fw ipw2100_firmware;
 #endif
@@ -7197,7 +7197,7 @@ static int ipw2100_wx_set_txpow(struct net_device *dev,
 {
 	struct ipw2100_priv *priv = libipw_priv(dev);
 	int err = 0, value;
-	
+
 	if (ipw_radio_kill_sw(priv, wrqu->txpower.disabled))
 		return -EINPROGRESS;
 
-- 
2.32.0

