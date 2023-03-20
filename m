Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E096C0FB2
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjCTKwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjCTKvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:51:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A52BCC0D;
        Mon, 20 Mar 2023 03:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13C8B80E14;
        Mon, 20 Mar 2023 10:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C708C4339C;
        Mon, 20 Mar 2023 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679309288;
        bh=TfrBhlCQseTHJXPXBcl5b1+T9R2FW/TX2/AG/Cm/hAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqE6oFvtG38Ej2exQfy3v9PMKXNQxEZwOkXCAJOdemspvQMF9HFIp256o9KXfF3P0
         abIoAZ0SKfffD1SBmE1YAO7QlhNQKXums8AWIb18qYG2VayVQ4zMDbBU+g2UFSJajY
         aQ/TVoRMv0kUhBc1GxenY2/d1gLzioMBAsqmfU0NJ9WWARtXKh8cCzFN0zkdW07CCq
         TvtIOHIk+Xirc6vRzhQP1m6a4e8jIHcyTyw6G244Bu4JchIVjcbuh6ewVUrldOBsQZ
         Xw9N24MDdQNJS0AMZTGV5Oq5OqVfqtCI+EBU5So14sCQp0ckMeKeDcMD2xL60jqJD9
         aauetD5xC9FRw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1peD4z-0005nZ-8T; Mon, 20 Mar 2023 11:49:29 +0100
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
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 3/3] arm64: dts: qcom: sc8280xp-crd: add wifi calibration variant
Date:   Mon, 20 Mar 2023 11:46:58 +0100
Message-Id: <20230320104658.22186-4-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320104658.22186-1-johan+linaro@kernel.org>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
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

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216036
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
index 90a5df9c7a24..5dfda12f669b 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -579,6 +579,23 @@ &pcie4 {
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

