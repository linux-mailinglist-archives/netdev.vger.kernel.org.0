Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835012F78FB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbhAOMaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732014AbhAOMaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:30:21 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4320CC0617A1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:29:05 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d81so2588538iof.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t+ObhEAIT9fbovEwiN4T77G8335SbFAVW9ujGpSZ6KQ=;
        b=j6zz31UDqKS8+mz/uvFOZxGx09lqzxksGJlSucJEC306pIAr/tS++aEARxTyTaH+Hd
         XUuUs0eJMu9h+6nbhO3R3g7q8WXN6e9/LR/5RoOQc+IdiFEtT1tTAUlpnxrwo4z6kQ42
         M/j0WVGT//n0hPipDvnW9ADeABfPakasVTbrTtTroRkxku/HjEnk8cIBJ8BHicMgAYHF
         lW4soIHt3COX5JOAO+cKhe3KwPtpCdSbMF+06RITNiOGbHuseTyRc89ZYVaPTIfaCDjZ
         QzyhByhQrQB1NphzUS2MIUfJsy67NAAqja7dEBKS0NQRhiHWFgV8UOKKffnA5Fm0jZbD
         Nv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t+ObhEAIT9fbovEwiN4T77G8335SbFAVW9ujGpSZ6KQ=;
        b=Zeb2m1MjCb1e3I9DR5TwjaXQAWLU5O/yXPWUCvrLVLbb+LWwLPvaFd32DLfaZTpqrI
         e4dPk5jFnywtx8UFJUDjNKziTRvSOAq+fentkCeafRLlaXTKGvhEqaIWemcdgBYlX9PF
         tvOmc7BFCFpXRib7jbskbtjCgd/uz0PYT9RDH3T3pva9CTARAgARtc9EDiYO5YikBJe/
         i5dcQQZsorBJ6S6NpNXhmnSPKAy55F7xb6XulqT8wX4IpLbFvnDlT1xK32kuhmw3wpK1
         QNArTaVOmQw/nBvf9ZyJfpI3pqVFbT309EXYchUcpJ13d9IgmbRgziK0d1myUpamUD1V
         ++6A==
X-Gm-Message-State: AOAM533G27x0PnG8mEDGaInHam7BEGbFHyk0PZGLnY1JDC4pKdY/wZ8f
        1WQJJbGwy7SvbJ7m3Z/cvtgwSQ==
X-Google-Smtp-Source: ABdhPJz4k+H5EbE4BC6jKWyuKS4/qK9DyW17Y1VbtDQjIjztsxWWY3DD8dcCwWM8nxwAyr+batzR3w==
X-Received: by 2002:a6b:6f17:: with SMTP id k23mr8495949ioc.147.1610713744655;
        Fri, 15 Jan 2021 04:29:04 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a9sm3828509ion.53.2021.01.15.04.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:29:04 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        rdunlap@infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 4/4] arm64: dts: qcom: sdm845: kill IPA modem-remoteproc property
Date:   Fri, 15 Jan 2021 06:28:55 -0600
Message-Id: <20210115122855.19928-5-elder@linaro.org>
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

