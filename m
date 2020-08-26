Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9393A252A3C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgHZJgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbgHZJfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:13 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA21BC06135C
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:36 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b18so1092699wrs.7
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ce/xQKtB6h18AIsA1S/vHOwsBOtcRFWUAHoCEtAF9MI=;
        b=j7GRt0ZVvyJLC/IQxJbBRdWVh9IPb6r50Td8Ok6n3IwhwuwGb+5uH4Dg/H9O7DD+cB
         zz1mBimmNGNqXSDXvKC4udI1Es1Mn6+Fjzt4WOr5H0Jze6fbM9SJUrzpABJ8mEENeT4Y
         JUYPjZL0jpXlFXCdcylWj3wubP4D0eGp+0o8EAkbAmZitIm6Wnj+c27Qy1nKYK/arj0p
         5OE/OfrAJLP2SgHRW+q4gL6ow+XzGX3/hu75oQ5gxNDmvVHA4nNPEuOxsEr42gU8eKOa
         gIUqWt6LDrtHD6FaiDBcOH3Bx9pS8s4sW3BHnMSnvZtNyOZW4VUcNlPxb6/AEDD8XtC8
         YMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ce/xQKtB6h18AIsA1S/vHOwsBOtcRFWUAHoCEtAF9MI=;
        b=Nr18URkfTRYaa3WqTH6xw9qu01SQOqSQXEVSkWb4O31rwJE9+ncBhuMg6b3H7z+osN
         Qj89KA8QALsXdJQSWNvC4kep7zonaiMbIcK8uHX/c3z7vSspGBCqyQ6vyNPsUyP2Jyes
         pDN3ix6BYiyh9c/pMcW4S8YGHuxO+Pyqo6HizCKovwsoq/edVDy1RroaEwyRRKYhMSO8
         t4k2S+QaVWwou/AZj6HfArMjSWr1RtwF8/yAG874IJpjqINuzODDGuOqH0LQLkeCu+Us
         pP3gtVrGtAKLXLW6RoIqlo0QBehsZk4K7yasklFL+Dw3/mbAh2esxatqU4wB2p+Z13gc
         1hLA==
X-Gm-Message-State: AOAM532xpVNNO3txudVaB588lfNu6/OpVfEVB75aqsfuM1WGWKxotI04
        BE+VC4Ix5HuU/xt7GNS4yaDLB7HdNJQcxg==
X-Google-Smtp-Source: ABdhPJxkM0Sw9I4QKFI81msP+pRFoUMDQmuIvVoGyyoB71BeWbpMPWrwb/Ng/uqtofjhgaIxX5geWg==
X-Received: by 2002:a5d:6843:: with SMTP id o3mr661325wrw.421.1598434475499;
        Wed, 26 Aug 2020 02:34:35 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH 25/30] wireless: ath: ath9k: ar5008_initvals: Remove unused table entirely
Date:   Wed, 26 Aug 2020 10:33:56 +0100
Message-Id: <20200826093401.1458456-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath9k/ar5008_initvals.h:553:18: warning: ‘ar5416Bank6’ defined but not used [-Wunused-const-variable=]

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/ath/ath9k/ar5008_initvals.h  | 37 -------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
index 467ccfae2ceed..8d251600d8458 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
@@ -550,43 +550,6 @@ static const u32 ar5416Bank3[][3] = {
 	{0x000098f0, 0x01400018, 0x01c00018},
 };
 
-static const u32 ar5416Bank6[][3] = {
-	/* Addr      5G          2G        */
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00e00000, 0x00e00000},
-	{0x0000989c, 0x005e0000, 0x005e0000},
-	{0x0000989c, 0x00120000, 0x00120000},
-	{0x0000989c, 0x00620000, 0x00620000},
-	{0x0000989c, 0x00020000, 0x00020000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x40ff0000, 0x40ff0000},
-	{0x0000989c, 0x005f0000, 0x005f0000},
-	{0x0000989c, 0x00870000, 0x00870000},
-	{0x0000989c, 0x00f90000, 0x00f90000},
-	{0x0000989c, 0x007b0000, 0x007b0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00f50000, 0x00f50000},
-	{0x0000989c, 0x00dc0000, 0x00dc0000},
-	{0x0000989c, 0x00110000, 0x00110000},
-	{0x0000989c, 0x006100a8, 0x006100a8},
-	{0x0000989c, 0x004210a2, 0x004210a2},
-	{0x0000989c, 0x0014008f, 0x0014008f},
-	{0x0000989c, 0x00c40003, 0x00c40003},
-	{0x0000989c, 0x003000f2, 0x003000f2},
-	{0x0000989c, 0x00440016, 0x00440016},
-	{0x0000989c, 0x00410040, 0x00410040},
-	{0x0000989c, 0x0001805e, 0x0001805e},
-	{0x0000989c, 0x0000c0ab, 0x0000c0ab},
-	{0x0000989c, 0x000000f1, 0x000000f1},
-	{0x0000989c, 0x00002081, 0x00002081},
-	{0x0000989c, 0x000000d4, 0x000000d4},
-	{0x000098d0, 0x0000000f, 0x0010000f},
-};
-
 static const u32 ar5416Bank6TPC[][3] = {
 	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
-- 
2.25.1

