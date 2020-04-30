Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912891BF3C7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 11:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD3JHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 05:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726907AbgD3JHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 05:07:37 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A351C035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 02:07:37 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d17so5871581wrg.11
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 02:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LWNLbbug+kOK8gudRYkqI8/+G2DNYHCHmidemuCiQE=;
        b=iBd84ggDJFof8EZ9qo1Y9VkaE8gV3w9MJt68Q8FVbP1s/YM6DhBWT0hmczB4LiYEy3
         f1V3v2oIzHUBrQbwtstbpxFS9mdASa3Xg6lBd2LdZE69f5A6ELeckgB7G839Acuo79RJ
         93ZTkskH0/a+B3I+RLSEwUodVDJNpZ8AXUVuLbEtFrICcLOpZjmTB2F8i59o7UIwE4o2
         am7TT3Cc0nIz7yNbl4qQ2EN39ecAoiGYX+S6V+sKLWAzj6PFSXI+eODNb0fTqEiwZOqD
         djnaIf1vO5blvwnioGU6WPedeOlA/TUR/KhKct+hTNMepKHLBwm/16rPDrTvodw1Ojs+
         G6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LWNLbbug+kOK8gudRYkqI8/+G2DNYHCHmidemuCiQE=;
        b=f9TM7MolPz+57eNqu9UX/3eSjpQ8a7vAYpt33MrydTeppgvN8deg3JMMDLdVczFjEO
         rf+WKYFnJxzqOYfpoqNfpG0bzFwV13DKlcKtfq13y/qRiG3HFTo/G4pEfiWcyQA3YCGW
         jT7K/W13+yS/jE0ctONTOKZIe2hLSUTxbMyBDI5wNTWbRun32Y7TZnZhI0FmcCQQRwr4
         ykcyGuB2slTOj+6xXVCgIqQXO2iuozNv7PyQfCNBvCZ5w1t/rlB4IZms8hEByiRVbeqW
         cEAUilNmiEDa/FR/i5wDtvRmQesyuLG/MkJesK3g6MZcyel5lwC95rGlvQijpKPQjqUr
         CarA==
X-Gm-Message-State: AGi0PuZKKzQ4EEZDYkvB6TUuV2BK82ed51Pr+atfwzWloQaD/IuLxIrO
        s1HrsGNMKPrCuuKhySplmKFMgw==
X-Google-Smtp-Source: APiQypJAebwircJDFu+JA5JJ5LW0VuZ9H0Q8lJtahQqO+fkp//ZcxyC6MDxBPskPjtY7bZeajZKGHA==
X-Received: by 2002:adf:bb0d:: with SMTP id r13mr2861094wrg.251.1588237656263;
        Thu, 30 Apr 2020 02:07:36 -0700 (PDT)
Received: from localhost.localdomain ([2a0e:b107:830:0:47e5:c676:4796:5818])
        by smtp.googlemail.com with ESMTPSA id t20sm10962025wmi.2.2020.04.30.02.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 02:07:35 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH net-next v5 3/3] ARM: dts: qcom: ipq4019: add MDIO node
Date:   Thu, 30 Apr 2020 11:07:07 +0200
Message-Id: <20200430090707.24810-4-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430090707.24810-1-robert.marko@sartura.hr>
References: <20200430090707.24810-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the necessary MDIO interface node
to the Qualcomm IPQ4019 DTSI.

Built-in QCA8337N switch is managed using it,
and since we have a driver for it lets add it.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
Changes from v4 to v5:
* Rebase to apply on net-next

Changes from v3 to v4:
* Change compatible to IPQ4019

Changes from v2 to v3:
* Correct commit title

 arch/arm/boot/dts/qcom-ipq4019.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index bfa9ce4c6e69..b9839f86e703 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -576,5 +576,33 @@ wifi1: wifi@a800000 {
 					  "legacy";
 			status = "disabled";
 		};
+
+		mdio: mdio@90000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "qcom,ipq4019-mdio";
+			reg = <0x90000 0x64>;
+			status = "disabled";
+
+			ethphy0: ethernet-phy@0 {
+				reg = <0>;
+			};
+
+			ethphy1: ethernet-phy@1 {
+				reg = <1>;
+			};
+
+			ethphy2: ethernet-phy@2 {
+				reg = <2>;
+			};
+
+			ethphy3: ethernet-phy@3 {
+				reg = <3>;
+			};
+
+			ethphy4: ethernet-phy@4 {
+				reg = <4>;
+			};
+		};
 	};
 };
-- 
2.26.2

