Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9562F78FE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbhAOMaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732003AbhAOMaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:30:21 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08418C06179C
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:29:04 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id w18so17772525iot.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZgcJCeO5IRSICza2r6GEj0/QJ8rNtZfDDcOXMnAT21Y=;
        b=KlBHmLnqBTnK5J4DO27zadgPE02VDPajn5Xg/cG0Avp0kSMoBuas/f4gBKy6oYikjv
         eHMZ+mouCClKU0+QunG7Zrjbi/sGQ1MjvHhG2GHCJWNkRVYW/GTjc3FRXlCXRKAl5AlD
         MrGSX9n0S4lZFaCeasXFtcC/Vr+efZCJqGH9hSQKtv7gB2MwsF9ZsfeUF7k6tYce9ttE
         sROYyXbJf8wI7YD628/UzChvd6ivXvTPFcDM5BiPpBMg2FFg/vVqGsxfhsgYBBXicnw5
         aJnjob7RO7vZLcSrSO9IPRkzuyAP5GVEIrcPPDLQKEBr1BTzE3w/1Ei51hzx0eoGlT6s
         5F0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgcJCeO5IRSICza2r6GEj0/QJ8rNtZfDDcOXMnAT21Y=;
        b=fUVlwf+ze6vPnRB3xAEVB+CW7bIgG4JrPTRb7WiYgTkaLp+kzovopDP/zL1vjXhKnX
         ShTAN77Bi+MopCkVwabeiCBqw4BjC2T9sqpWNDmLwHmaXSCS2SUzMknB2h6gjh3IXb32
         ua4FGvV90JD96zLwIFArbTHVXvQ46TS+6SLdY57ZJ7pdp1J5sdYzOFkuaYx3yHYkBPQE
         hO5jNU40gC849Jt6zYh6gw7NGWlhP7Df7XGaHfEJSvVbNAtiRfJs9Z0JEpca5AgA3yJR
         rA1Z/ywg8AQ6tcNrdp6+MZ/vmV5jsIM5/FFi4U4hQ4ZfAxjW1QwDdU3dboyQitnmufmL
         z+7A==
X-Gm-Message-State: AOAM532hBUHOSDpdAw6PG9roA/Qj9KfS7rHYuhlKtXBeMNyM7Xvtevpe
        jbzCJRUxxov5QSx/v6IYTXkjpw==
X-Google-Smtp-Source: ABdhPJz1xDn2LWVaVJ8b+MHU6nw6XSrUBGZCU+K1D+osCjh8vAx4TY14eoXtbjzSaYSWT3Y4tk8i3A==
X-Received: by 2002:a5d:9418:: with SMTP id v24mr8176550ion.61.1610713743450;
        Fri, 15 Jan 2021 04:29:03 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a9sm3828509ion.53.2021.01.15.04.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:29:02 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        rdunlap@infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/4] arm64: dts: qcom: sc7180: kill IPA modem-remoteproc property
Date:   Fri, 15 Jan 2021 06:28:54 -0600
Message-Id: <20210115122855.19928-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115122855.19928-1-elder@linaro.org>
References: <20210115122855.19928-1-elder@linaro.org>
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

