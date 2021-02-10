Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B7316743
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBJM6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhBJM4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:56:14 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205F5C06178B
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:55:33 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id sa23so4034879ejb.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QP3xask6OD7k8KSQ5tVVcC2So9/tpald+pKQ9QG/+P8=;
        b=HjJ6Lp/AhwITcJlB6qLHzWAJY/BrcnEYgKc4a+8TzLCZ5CCXAWI50E7ZohLrJGmbNh
         vJrTk3rv9gio+BQgS8wQLCxK71fcPm4j7kUztMMCdcVx/oTZX9NlArdOQaVP7cWrf4O9
         GwQ0TONto3hfchlvQ64hAmFR9JDfWwa/PSQobPThflThTbPoWGazrjdNbtRIidAB3yRg
         nxZgEs+dFWA85wunPG6kzc023yG4EgtDXPtOazdvsunr0wY4BaDYGMfNUx4VVEuuRKhH
         uVE2hurMQquNBrpsxDYaWpM95IBONWC3y795H39kYzccBfOuawpXw9sIVli4PaGufh6n
         l54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QP3xask6OD7k8KSQ5tVVcC2So9/tpald+pKQ9QG/+P8=;
        b=IC2H16PZt/JwIYshImdR2ZnO8J6gjgMH8M8DV1dAc7tMUKEBs6wIvAtmikGY729d+Z
         oPOxQYC0kEd26lRBxajGdm0oTjAN+/OtueHIMv32MdgXwdpv/lOg5tzxPafFOn9dOAMJ
         z1jPiXNnwuu3WCv31LPb1lzBI7M9xWn9m3xhTGQfMS8nVIUTAQdoIxzNiWIPK7XTXV20
         u9DjOTvLuhn8dGFyt+QCd7Gi8rieC1pRD58zXpZPDtiOZHquvZUsYH16kaXqemyHKCqS
         +E/ZiwEGJuk24t+rsP//fslTfgi9NMS1+FK71mKIhkfx/lmVHNgNyQwQY954rXpnEPKC
         RWug==
X-Gm-Message-State: AOAM5326Md8YWJwCC+AbiKRV7y1vS/ZLkFJGabLKb91mK7XXQ8F78BJW
        uYtRKLFPjL9xdf5Tg7EliCnpGg==
X-Google-Smtp-Source: ABdhPJySVHbEy7cRf3FVEZU38MkaaqoQGA40nPFPDQevnBQvfDLbeE2YY+LPPPi8oagsbkMesjJCnQ==
X-Received: by 2002:a17:906:2b16:: with SMTP id a22mr2792396ejg.291.1612961731916;
        Wed, 10 Feb 2021 04:55:31 -0800 (PST)
Received: from localhost.localdomain (dh207-97-164.xnet.hr. [88.207.97.164])
        by smtp.googlemail.com with ESMTPSA id u5sm1084900edc.29.2021.02.10.04.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:55:31 -0800 (PST)
From:   Robert Marko <robert.marko@sartura.hr>
To:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH v2 net-next 1/4] dt-bindings: net: Add QCA807x PHY
Date:   Wed, 10 Feb 2021 13:55:20 +0100
Message-Id: <20210210125523.2146352-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210210125523.2146352-1-robert.marko@sartura.hr>
References: <20210210125523.2146352-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT bindings for Qualcomm QCA807x PHY series.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
Changes in v2:
* Drop PSGMII/QSGMII TX driver defines

 include/dt-bindings/net/qcom-qca807x.h | 30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 include/dt-bindings/net/qcom-qca807x.h

diff --git a/include/dt-bindings/net/qcom-qca807x.h b/include/dt-bindings/net/qcom-qca807x.h
new file mode 100644
index 000000000000..a5ac12777c2b
--- /dev/null
+++ b/include/dt-bindings/net/qcom-qca807x.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Device Tree constants for the Qualcomm QCA807X PHYs
+ */
+
+#ifndef _DT_BINDINGS_QCOM_QCA807X_H
+#define _DT_BINDINGS_QCOM_QCA807X_H
+
+/* Full amplitude, full bias current */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_BIAS		0
+/* Amplitude follow DSP (amplitude is adjusted based on cable length), half bias current */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_HALF_BIAS		1
+/* Full amplitude, bias current follow DSP (bias current is adjusted based on cable length) */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_DSP_BIAS		2
+/* Both amplitude and bias current follow DSP */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_BIAS		3
+/* Full amplitude, half bias current */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_HALF_BIAS		4
+/* Amplitude follow DSP setting; 1/4 bias current when cable<10m,
+ * otherwise half bias current
+ */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_QUARTER_BIAS	5
+/* Full amplitude; same bias current setting with “010” and “011”,
+ * but half more bias is reduced when cable <10m
+ */
+#define QCA807X_CONTROL_DAC_FULL_VOLT_HALF_BIAS_SHORT	6
+/* Amplitude follow DSP; same bias current setting with “110”, default value */
+#define QCA807X_CONTROL_DAC_DSP_VOLT_HALF_BIAS_SHORT	7
+
+#endif
-- 
2.29.2

