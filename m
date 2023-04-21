Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A348E6EAC75
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjDUOLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjDUOLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:11:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FFF125BD
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:11:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-504eb1155d3so12550490a12.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1682086305; x=1684678305;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5PDdlh4u/xfgKewafucHFDvnZU5PveoA4hr4MMyV4jk=;
        b=VKgUTyESHEzEfyEpyia7JO5LA5ceaG6BIWK/+IcQyWsjEzQK2Z00VNu7eATdp1i1p8
         hE12aSAUGs1tSXIPEvUOsBQ/40WfNJhTw24BlcGWAAJsctNYN/GxAmXCejz40UJsRaqV
         WSOGYmhpdgyrHd9dBN78Cu336z+XJHJZlP/Cnw7yk3vozClDHUMDEgUT+dJ0TERGJqUK
         OtPDfFtQv/5jhi1LakBn2lfrB9OChaoSzsKrosp+qo/f8eu1dE9Ay8fp545y+5OttAP9
         xT+MR41xOhjOSoz5O1k13DNUM0eNAY1LFYkxdY4I1Z10xq+/l1f6304MbBx4kuL5gcrR
         z/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682086305; x=1684678305;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5PDdlh4u/xfgKewafucHFDvnZU5PveoA4hr4MMyV4jk=;
        b=Dgt++xqYBd1XV5vEFdvDBbRNZaDXQtFmDvJYNOVC7mPHGXnlE0tB8sXVLckruF6RPL
         9amrUM+MHk7NS0LZxBwSggzF1FYzVu3VBuC12Tw1DtmnTKGC2IG5IruCDINuNxrv/3jH
         nCH8GViTVQ+WSPqJSyKho+vSBsgJfa33q/CfxU9EKKRAMeAg/s6rRcxjG+o0wq0XDUnr
         HickCf2O5EfxfqWPa0W3V6L8Y+dMBAdfC9Y7vYhk7AMhEm+bIyUzywon7xkp9KG54ATM
         /vX6332Qm2V38jJdOuF4dElohFzn9h8SsYMCGILUBtFkOGFZyYLitwDlKOmPruIM+KcG
         d2Aw==
X-Gm-Message-State: AAQBX9e6jbqSt42lCrRWaZS5XPmcQ8Q1tr7h057VzyD8qiokokwyZiUs
        Y/BK5coOMqIqrWDISlf9RNbDyw==
X-Google-Smtp-Source: AKy350a6WSSMU8x/JexPNPLK6hMUDOgynyh3AXwaCi2WmvSTFJLri5mu4oCGicSJQakg73ri0S9OZg==
X-Received: by 2002:a17:906:d14f:b0:94e:83d3:1b51 with SMTP id br15-20020a170906d14f00b0094e83d31b51mr2542062ejb.23.1682086305561;
        Fri, 21 Apr 2023 07:11:45 -0700 (PDT)
Received: from [172.16.220.31] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id mb20-20020a170906eb1400b0094f432f2429sm2104299ejb.109.2023.04.21.07.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:11:44 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Fri, 21 Apr 2023 16:11:41 +0200
Subject: [PATCH RFC 4/4] arm64: dts: qcom: sm7225-fairphone-fp4: Add
 Bluetooth
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230421-fp4-bluetooth-v1-4-0430e3a7e0a2@fairphone.com>
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
In-Reply-To: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device has a WCN3988 chip for WiFi and Bluetooth. Configure the
Bluetooth node and enable the UART it is connected to.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 7ae6aba5d2ec..35e2889c5439 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -31,6 +31,7 @@ / {
 
 	aliases {
 		serial0 = &uart9;
+		serial1 = &uart1;
 	};
 
 	chosen {
@@ -563,6 +564,22 @@ &tlmm {
 	gpio-reserved-ranges = <13 4>, <56 2>;
 };
 
+&uart1 {
+	status = "okay";
+
+	bluetooth {
+		compatible = "qcom,wcn3988-bt";
+
+		vddio-supply = <&vreg_l11a>;
+		vddxo-supply = <&vreg_l7a>;
+		vddrf-supply = <&vreg_l2e>;
+		vddch0-supply = <&vreg_l10e>;
+		swctrl-gpios = <&tlmm 69 GPIO_ACTIVE_HIGH>;
+
+		max-speed = <3200000>;
+	};
+};
+
 &uart9 {
 	status = "okay";
 };

-- 
2.40.0

