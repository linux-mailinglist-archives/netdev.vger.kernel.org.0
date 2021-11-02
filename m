Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BB64427ED
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 08:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhKBHPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 03:15:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:61548 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhKBHPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 03:15:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635837189; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=KZMn3JM90Lz0p3flftlVAHmLRP1ej20KZZkGlmNqfOI=; b=bGW/ep4GavAoWQkhxuFmp7u57/3mMqBAiNzAJd8zVSOsk8td7iZT/rT/+xdnkJ+JVMVkyTo0
 vXbJq8FYIUHwl+fhkf5Q69CICesr5dxWDrFxeGr1GlwYAtxAxyM6Lu6v2anHEqp8TkeFhmHZ
 T1dRrHXSFXRVTW9KKCbD9UnahQE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6180e4975c66efd3722a986e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 02 Nov 2021 07:11:19
 GMT
Sender: zijuhu=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3D268C43616; Tue,  2 Nov 2021 07:11:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from zijuhu-gv.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zijuhu)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5BDEFC4338F;
        Tue,  2 Nov 2021 07:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5BDEFC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Zijun Hu <zijuhu@codeaurora.org>
To:     davem@davemloft.net, rjliao@codeaurora.org, kuba@kernel.org,
        robh+dt@kernel.org, bgodavar@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, devicetree@vger.kernel.org,
        zijuhu@codeaurora.org, Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add device tree bindings for QTI bluetooth MAPLE
Date:   Tue,  2 Nov 2021 15:11:09 +0800
Message-Id: <1635837069-1293-1-git-send-email-zijuhu@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zijun Hu <quic_zijuhu@quicinc.com>

Add device tree bindings for QTI bluetooth MAPLE.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
index f93c6e7a1b59..9f0508c4dd16 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
@@ -23,6 +23,7 @@ properties:
       - qcom,wcn3998-bt
       - qcom,qca6390-bt
       - qcom,wcn6750-bt
+      - qcom,maple-bt
 
   enable-gpios:
     maxItems: 1
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

