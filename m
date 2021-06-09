Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB173A1BE7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhFIRhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:37:33 -0400
Received: from out28-49.mail.aliyun.com ([115.124.28.49]:57296 "EHLO
        out28-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhFIRha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:37:30 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.9020496|0.6613592;CH=green;DM=|SPAM|false|;DS=CONTINUE|ham_regular_dialog|0.0829513-0.00479038-0.912258;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047209;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=20;RT=20;SR=0;TI=SMTPD_---.KQ26pE3_1623260120;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KQ26pE3_1623260120)
          by smtp.aliyun-inc.com(10.147.41.138);
          Thu, 10 Jun 2021 01:35:31 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: [PATCH v2 1/2] dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
Date:   Thu, 10 Jun 2021 01:35:09 +0800
Message-Id: <1623260110-25842-2-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the dwmac bindings for the JZ4775 SoC, the X1000 SoC,
the X1600 SoC, the X1830 SoC and the X2000 SoC from Ingenic.

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---

Notes:
    v1->v2:
    No change.

 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2edd8be..9c0ce92 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -56,6 +56,11 @@ properties:
         - amlogic,meson8m2-dwmac
         - amlogic,meson-gxbb-dwmac
         - amlogic,meson-axg-dwmac
+        - ingenic,jz4775-mac
+        - ingenic,x1000-mac
+        - ingenic,x1600-mac
+        - ingenic,x1830-mac
+        - ingenic,x2000-mac
         - rockchip,px30-gmac
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac
@@ -310,6 +315,11 @@ allOf:
               - allwinner,sun8i-r40-emac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
+              - ingenic,jz4775-mac
+              - ingenic,x1000-mac
+              - ingenic,x1600-mac
+              - ingenic,x1830-mac
+              - ingenic,x2000-mac
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
@@ -353,6 +363,11 @@ allOf:
               - allwinner,sun8i-r40-emac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
+              - ingenic,jz4775-mac
+              - ingenic,x1000-mac
+              - ingenic,x1600-mac
+              - ingenic,x1830-mac
+              - ingenic,x2000-mac
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
-- 
2.7.4

