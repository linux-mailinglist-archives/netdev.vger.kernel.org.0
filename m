Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D142F3A70
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437010AbhALT3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406842AbhALT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:29:21 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E156C0617A9
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:28:41 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n4so6441425iow.12
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZgcJCeO5IRSICza2r6GEj0/QJ8rNtZfDDcOXMnAT21Y=;
        b=x+zr29usZZQIbS2asOmKyiSxbO7mFhmTFZ2dthGh2JMlxCYoFiM3ePy1GTpJmWrAZB
         PBB+vrKfko/Icku/ULr4vAt5wPH83XNS6kXIFnz5pWlBBeI1DeiXqMw6idzdWTXfAApU
         dHbAhFV0RGikv9uADhBu7C2CCBaXm3ysriC3MQ/gfxjrJ42C0VWrUJEm5JJWs7YUI0Au
         AdqH8wMtIQyTqh8O2poHpSO4eiBr2184s5SzvMTs7rx4m8Z9aPPKWpPkYE5+yBwHrkEQ
         HIXe/nh6E7yjCEMOMtFfcedK7Tfqw1lW2sjh4q0yV5eFH2Y9g7NfTOwFjIWgDe744YNX
         cjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgcJCeO5IRSICza2r6GEj0/QJ8rNtZfDDcOXMnAT21Y=;
        b=qo1MrSJsJqML1FqJpJfnDY/rFKGBHByBO65LtZdsjWuOEBQqDMjC542MsIoHO7bl+u
         JxDPTxaF9YFVfrEnpgOqabXgLo4CxElyq6vMfTTZ3u9uBQuta5bGBMclHPHxE3p9R8XG
         oBoakPRI96xIeRq1tvk0mF92IFAsG/fup3Bt/fctYnrVmzrj4V8MGuiJKcwY2mhh5tu7
         3hrmFW8ZUdsuaUKJ47f0u4tp332BZ2BftrrWTr3BbbLgP81ewohWu8QmLxA3+bvgCpQw
         X6/pSMBd5kqRGmSakza4tXLmyX3juV1aE+um5TUYP7CMlwnUFLXsowErzb++SuAz4fUo
         A0Zw==
X-Gm-Message-State: AOAM532koR/jSBOpY5LC0kaE1aqjpCM1F+9QffOr3xoKNR/9Plarz1Yv
        ySzmTetFHgtlxi/nLlBgOzKR8A==
X-Google-Smtp-Source: ABdhPJyyBSq3daVP41fcs1eGhpefB7YcnOnG8hbumFF8S2m1UNbJk49d27EQXxWb+Foa+W6C0FbctA==
X-Received: by 2002:a92:dc4a:: with SMTP id x10mr574601ilq.153.1610479720967;
        Tue, 12 Jan 2021 11:28:40 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id q5sm3191892ilg.62.2021.01.12.11.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 11:28:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        rdunlap@infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] arm64: dts: qcom: sc7180: kill IPA modem-remoteproc property
Date:   Tue, 12 Jan 2021 13:28:30 -0600
Message-Id: <20210112192831.686-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210112192831.686-1-elder@linaro.org>
References: <20210112192831.686-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "modem-remoteproc" property is no longer required for the IPA
driver, so get rid of it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 22b832fc62e3d..003309f0d3e18 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1434,8 +1434,6 @@
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
 						"ipa-clock-enabled";
 
-			modem-remoteproc = <&remoteproc_mpss>;
-
 			status = "disabled";
 		};
 
-- 
2.20.1

