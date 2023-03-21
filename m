Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569926C2E14
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCUJjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCUJjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D433668D;
        Tue, 21 Mar 2023 02:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59BADB8133B;
        Tue, 21 Mar 2023 09:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B11C4339B;
        Tue, 21 Mar 2023 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679391548;
        bh=y4DQQgqTeIOp+QSV53CC0j5id0oCyBXkdp89zbwqiMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5Z9G5RhRob13EVQTljJZCAmCEYyyM9fYBf+rNjtCNqM+iL+MxJ1+MujMcRZjZTjr
         xhhPd4QD5t4ElLlkVFsDLYb7I341Y4aXnl3zQvTDyUxVTQn5l92Y9fk8AW2n4qMHDQ
         Ejjc8Y8rkqkOYZsNTJ3BN2Lt69j6rVDwMCO3gMNdcsdg5wzs54qUT/56B6ywxM3nLo
         TLHeUenQTUE6+PBT1FfrIBbc1OMamsmaFeq1zx24yEkc1KAKMs0xkOZyrmycKQIOZO
         xPSi/PbZuEset6GkJzTHqUw90m8nOr0CIcWhxYqZFU1Y7yDsPu3hFFto6M9ADEy2dg
         Ymd2iQIXqNicg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1peYTo-0002Y0-DN; Tue, 21 Mar 2023 10:40:32 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v2 2/2] arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
Date:   Tue, 21 Mar 2023 10:40:11 +0100
Message-Id: <20230321094011.9759-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321094011.9759-1-johan+linaro@kernel.org>
References: <20230321094011.9759-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the bus topology for PCIe domain 6 and add the ath11k
calibration variant so that the board file (calibration data) can be
loaded.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216246
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 150f51f1db37..0051025e0aa8 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -711,6 +711,23 @@ &pcie4 {
 	pinctrl-0 = <&pcie4_default>;
 
 	status = "okay";
+
+	pcie@0 {
+		device_type = "pci";
+		reg = <0x0 0x0 0x0 0x0 0x0>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		ranges;
+
+		bus-range = <0x01 0xff>;
+
+		wifi@0 {
+			compatible = "pci17cb,1103";
+			reg = <0x10000 0x0 0x0 0x0 0x0>;
+
+			qcom,ath11k-calibration-variant = "LE_X13S";
+		};
+	};
 };
 
 &pcie4_phy {
-- 
2.39.2

