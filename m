Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE463E5BAF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbhHJNcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:32:21 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28945 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbhHJNcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:32:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628602318; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=KiE+rVQY46cVQ5OE7ZvIdEvKX6VtwKSVL05iVQtQQGg=; b=Jfi0Z8mboUlVqrEmbp8hZINspTJjl+P6c69qYK1ldUa+rSG1vhMkmOsESz3JIkTcvCrf5X3x
 ZSsFXqAP+NPkPSiu6QJQ30+kJMByu2nMUxCw1KEukIDrFjJ3QMH5enhONxG2dPmJYas3ah+o
 J2CSgR6fSElMhh5O97Ex9wFCJKI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 61127fc1f746c298d9ee6c36 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Aug 2021 13:31:45
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E219BC4323A; Tue, 10 Aug 2021 13:31:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E26B5C433D3;
        Tue, 10 Aug 2021 13:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E26B5C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, agross@kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        robert.marko@sartura.hr
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v2 3/3] dt-bindings: net: Add the properties for ipq4019 MDIO
Date:   Tue, 10 Aug 2021 21:31:16 +0800
Message-Id: <20210810133116.29463-4-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210810133116.29463-1-luoj@codeaurora.org>
References: <20210810133116.29463-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new added properties resource "reg" is for configuring
ethernet LDO in the IPQ5018 chipset, the property "clocks"
is for configuring the MDIO clock source frequency.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 .../bindings/net/qcom,ipq4019-mdio.yaml           | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 0c973310ada0..2af304341772 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -14,7 +14,9 @@ allOf:
 
 properties:
   compatible:
-    const: qcom,ipq4019-mdio
+    enum:
+      - qcom,ipq4019-mdio
+      - qcom,ipq5018-mdio
 
   "#address-cells":
     const: 1
@@ -23,7 +25,18 @@ properties:
     const: 0
 
   reg:
+    minItems: 1
+    maxItems: 2
+    description:
+      the first Address and length of the register set for the MDIO controller.
+      the second Address and length of the register for ethernet LDO, this second
+      address range is only required by the platform IPQ50xx.
+
+  clocks:
     maxItems: 1
+    description: |
+      MDIO clock source frequency fixed to 100MHZ, this clock should be specified
+      by the platform IPQ807x, IPQ60xx and IPQ50xx.
 
 required:
   - compatible
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

