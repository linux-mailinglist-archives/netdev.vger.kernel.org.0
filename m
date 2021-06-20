Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DE63ADE55
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 14:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhFTMlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 08:41:19 -0400
Received: from out28-124.mail.aliyun.com ([115.124.28.124]:47295 "EHLO
        out28-124.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhFTMlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 08:41:14 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.409767|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0190236-0.000312141-0.980664;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047190;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.KVAnlIH_1624192730;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KVAnlIH_1624192730)
          by smtp.aliyun-inc.com(10.147.44.129);
          Sun, 20 Jun 2021 20:38:57 +0800
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
Subject: [PATCH 1/2] dt-bindings: dwmac: Remove unexpected item.
Date:   Sun, 20 Jun 2021 20:38:49 +0800
Message-Id: <1624192730-43276-2-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624192730-43276-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1624192730-43276-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unexpected "snps,dwmac" item in the example.

Fixes: 3b8401066e5a ("dt-bindings: dwmac: Add bindings for new Ingenic SoCs.")

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---
 Documentation/devicetree/bindings/net/ingenic,mac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
index 5e93d4f..d08a881 100644
--- a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
+++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
@@ -61,7 +61,7 @@ examples:
     #include <dt-bindings/clock/x1000-cgu.h>
 
     mac: ethernet@134b0000 {
-        compatible = "ingenic,x1000-mac", "snps,dwmac";
+        compatible = "ingenic,x1000-mac";
         reg = <0x134b0000 0x2000>;
 
         interrupt-parent = <&intc>;
-- 
2.7.4

