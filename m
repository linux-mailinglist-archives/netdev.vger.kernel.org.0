Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABAD2F3A73
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437018AbhALT30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437011AbhALT3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:29:23 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC11C0617AB
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:28:43 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id z5so6443308iob.11
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t+ObhEAIT9fbovEwiN4T77G8335SbFAVW9ujGpSZ6KQ=;
        b=YiY4GITUfqV0Ju6NrKP6tTelKbu55g5WcVocCIkh9J97hvylvbHfXfxRbs9t7arvYu
         7TBzprW/7l8bGlNR2k93a6Ih63jJpYoW03nCeksVwmbf0NY/uHNR3SS11Y5Vh7pp+YZi
         ODcxXWbtO7a8H2GieGW2oZASSZyG+EGnWN2iCM72OEd4vpveMzmG4GZ7cinY8wr69Kp/
         /KR/CwAqcWKmSfpe7mkM5pAQ6fWYWA1sujYc6g1qNr6bJOn7Jz2PfJ8Ae8dXYqyl47fQ
         vIxpgmrfmtykQs5pY8858VxFdVtajirNFY4XPADwW/EXEgLRVBH3UbSWSdtCxPfqZ6oR
         payg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t+ObhEAIT9fbovEwiN4T77G8335SbFAVW9ujGpSZ6KQ=;
        b=fKQxQz4AqqRHhl90isM0MsDe5mNHM8N1IbCThiAombfMIa3k49fRsX23p2130VcsGQ
         iZYHq+AF2wEJXO0ypK35VRXXyGw9E63PX0/WO0pFtySP1Rq6kyZ8Dn1HP7Sa/qngq32o
         ELtpzQUFiNxvyOpLM4x9PAqYDI8M1FTAngDZ6kAm1dNcyemD4x7lxDh/UsBJWkTJEm1g
         DgNGnjD5Ymk0p6WPHpoLcwQFhJII9eAhUol83g2JI5IkNdq5rkmJiwhBONZHg/wRuhdW
         OzRBqDZdJLu51LD3lePE3k11xyNJtWv4dfr/tvfPKaISG8MVhCd0+dW+M9wV/oRUTaFb
         N2Lw==
X-Gm-Message-State: AOAM531U/WOXq5JU/QN/i7D0uvvrUQHnCj/oWf7SrD6QOa+F95We1rQ9
        GTzu/xTohWbmGAi2D3wSFp0j6A==
X-Google-Smtp-Source: ABdhPJxdpjK4MHK7eEwmiaY8MoJxnbpHnHBq4GeZDh2NLXnoJg4TdUYv0qq8BS5VhvrneSNyKFJQBg==
X-Received: by 2002:a92:8e0f:: with SMTP id c15mr590204ild.224.1610479722521;
        Tue, 12 Jan 2021 11:28:42 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id q5sm3191892ilg.62.2021.01.12.11.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 11:28:42 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        rdunlap@infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] arm64: dts: qcom: sdm845: kill IPA modem-remoteproc property
Date:   Tue, 12 Jan 2021 13:28:31 -0600
Message-Id: <20210112192831.686-5-elder@linaro.org>
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
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index bcf888381f144..04b2490eec9f4 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2366,8 +2366,6 @@
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
 						"ipa-clock-enabled";
 
-			modem-remoteproc = <&mss_pil>;
-
 			status = "disabled";
 		};
 
-- 
2.20.1

