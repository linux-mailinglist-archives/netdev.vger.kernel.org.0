Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C3C3A2094
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFIXN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:13:29 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:37498 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFIXN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:13:28 -0400
Received: by mail-wm1-f43.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso5333833wmg.2;
        Wed, 09 Jun 2021 16:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+v7noDDRjraZ3GHj7whVM5w/zJdcTfcXwuJlEu0MOc4=;
        b=O5hsZofqb6rEFyCevIV0McfFwrQRiPmWBIF1w3zJhgShliHklTJfDFxoT0qBzQV3ta
         Ap+Lo/7kS8FBBCXIZlBtHj1SmZHR2f3D9OQd/PUPllG4tW5xyLjgkeFTOXJr4pXY2f0Z
         /Mv+Ztt2pEzk7AJl9mRhzlFHoNHSBqNEOSxKyxhLkeP6bZIJt0msYhrbURU+c9EmewOg
         lqXuhko5OdEBlf+OCzTDv9UwRWmZ8HrftTtpH1u3OYNhNlR1KYVc/cPLKqc012WZhhBk
         lRhMqI4Rsdn++skyGHKVyJcNAqU/vuRhC31XtSA4kNBqMJO4VGf0JCTyP+NbTnplf2jV
         bbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+v7noDDRjraZ3GHj7whVM5w/zJdcTfcXwuJlEu0MOc4=;
        b=cmiAXYte1W3cdaZV336eQVZOsMICkVv6S669oknpX4OVNCEXvy+qJhnDB1UobnxLho
         y2cuCACpkP1u7iI3im8v8r6dOsPtnfAVhgmUnm28WTg5vgNFL5NI1YvfeVsnFq6J1GCp
         9TXa7bua0uC6wJL1vC+wHB3bHZovk0zg1BzKIOJhQ8x23+19ByulO3mqbR+hZF4TtRJI
         la+5t5bfYKtYTbQph0EdtQKDeK0VwWEKY7nDe4o79nIXj5+MFIkbEOOLjqTQOazPLujc
         ve38VK0dlDZFNR0sCJRxakDBt6ymu0L+99J9rZSUaoJaNA8WCwk5CYNoflkMWXJt8dFd
         SeXg==
X-Gm-Message-State: AOAM5331NlM5WRmnOKglLSHw4zzNZNlBD9xqBhEs/j16p/iC09otpQpk
        o+yQwFg+BIBpcTdJ0goAO1rj5jb/FK4=
X-Google-Smtp-Source: ABdhPJzFPxXx/VEdil7rGJL2h229tnpHYjaM+Z+Ps0NmnemF7QhFx7pbDIILRvCriYw4IqB+vpRi9g==
X-Received: by 2002:a05:600c:5112:: with SMTP id o18mr1987316wms.15.1623280215866;
        Wed, 09 Jun 2021 16:10:15 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id o5sm1300684wrw.65.2021.06.09.16.10.15
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 09 Jun 2021 16:10:15 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Matthew Hagan <mnhagan88@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH RESEND 1/2] ARM: dts: qcom: add ahb reset to ipq806x-gmac
Date:   Thu, 10 Jun 2021 00:09:44 +0100
Message-Id: <20210609230946.1294326-2-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210609230946.1294326-1-mnhagan88@gmail.com>
References: <20210609230946.1294326-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add GMAC_AHB_RESET to the resets property of each GMAC node.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 arch/arm/boot/dts/qcom-ipq8064.dtsi | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index 98995ead4413..1dbceaf3454b 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -643,8 +643,9 @@ gmac0: ethernet@37000000 {
 			clocks = <&gcc GMAC_CORE1_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE1_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE1_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
@@ -666,8 +667,9 @@ gmac1: ethernet@37200000 {
 			clocks = <&gcc GMAC_CORE2_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE2_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE2_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
@@ -689,8 +691,9 @@ gmac2: ethernet@37400000 {
 			clocks = <&gcc GMAC_CORE3_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE3_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE3_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
@@ -712,8 +715,9 @@ gmac3: ethernet@37600000 {
 			clocks = <&gcc GMAC_CORE4_CLK>;
 			clock-names = "stmmaceth";
 
-			resets = <&gcc GMAC_CORE4_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&gcc GMAC_CORE4_RESET>,
+				 <&gcc GMAC_AHB_RESET>;
+			reset-names = "stmmaceth", "ahb";
 
 			status = "disabled";
 		};
-- 
2.26.3

