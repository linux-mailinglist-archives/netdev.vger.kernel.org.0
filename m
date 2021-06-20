Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919AF3ADE56
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 14:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhFTMlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 08:41:21 -0400
Received: from out28-4.mail.aliyun.com ([115.124.28.4]:53201 "EHLO
        out28-4.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhFTMlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 08:41:15 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09709191|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0132484-0.00553607-0.981215;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047213;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.KVAnlIH_1624192730;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KVAnlIH_1624192730)
          by smtp.aliyun-inc.com(10.147.44.129);
          Sun, 20 Jun 2021 20:38:58 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
Subject: [PATCH 2/2] net: stmmac: Ingenic: Remove unused variables.
Date:   Sun, 20 Jun 2021 20:38:50 +0800
Message-Id: <1624192730-43276-3-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624192730-43276-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1624192730-43276-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused variables in ingenic_mac_suspend() and
ingenic_mac_resume().

Fixes: 2bb4b98b60d7 ("net: stmmac: Add Ingenic SoCs MAC support.")

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
index 667ed46..9a6d819 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -311,9 +311,6 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int ingenic_mac_suspend(struct device *dev)
 {
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct stmmac_priv *priv = netdev_priv(ndev);
-	struct ingenic_mac *mac = priv->plat->bsp_priv;
 	int ret;
 
 	ret = stmmac_suspend(dev);
@@ -325,7 +322,6 @@ static int ingenic_mac_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	struct ingenic_mac *mac = priv->plat->bsp_priv;
 	int ret;
 
 	ret = ingenic_mac_init(priv->plat);
-- 
2.7.4

