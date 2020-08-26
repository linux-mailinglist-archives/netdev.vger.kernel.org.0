Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B563E252A26
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgHZJfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbgHZJe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:34:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62958C06179B
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:28 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t14so1076350wmi.3
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVfVHRbfLs77xvEowdNmRYJl1Eqf3t8uGBw9b5yOc7s=;
        b=JuY0r5yXntpWWzZXsdA88BXsBYv590V4Ep8F6jfWf6kGIWp1JSFtrAQadAVxFywmbN
         RtkCN5MVz8Kb5gEYOUJAvT5dlvGbvkWMLI/pGdjCNsDAXh6K9kvNfg/crGE7jeGkn9uH
         YqfwFTj4gh/eR0PkX25QY/QvgCmNAqJjUMxUmUuBD7hHDWFW5mfuZcIj04QlMlM6jNji
         KT1WWvFzTJ9kZXWxDpKk0Alp8YvzaEa1JeM4SwjWhQGblNi93mk/Xr4Q4s2zw+WJB36o
         Knnsb802yKk5B/vVGx1+qzXlMyRLPWnxnY32BR97sUmGXn7J8XMufW1T5tzJAEiN7aV0
         BN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVfVHRbfLs77xvEowdNmRYJl1Eqf3t8uGBw9b5yOc7s=;
        b=fooJ3fA3q5IuWSpoxDCl16UYZXTQIoMDRPOVlDaYbrAINggSkeIJL+ebW7VjRFaztZ
         ZA01sGuzAyk1aAJOXmfHLq2uIHZWJRhHHKXlnzHfYcGCx36jxq3IoTaQQsjhsBLJ07M1
         /ZSlvELD3JXjMRWcnpLW2KnypLz084/i2LptiZ7KHlQc1arLRZxFG1ESImEFy5RS2QLI
         VYiYxmMgyumIlSUjGATN4HrevDA1G5LhhvBMT0EuPFoAuPZLKyX0a9JfGiiNqJ7lx4UE
         cawphI6UWC5vrvF215zyus3GjJlT6I9Vjq3UZXq5pXfvG+yVnri70c0XUKrsi2CIxKhf
         AqMg==
X-Gm-Message-State: AOAM532zmzN0IGmRVUYbmwWWOquOMnrQ1Vl5RSd/uwOi2/0YASwaB1Jb
        47gVjdozcHZlqAxA1+4Jgkmykg==
X-Google-Smtp-Source: ABdhPJyU2nSGobc0dtKGFmaO2f5zOBwubTya6uY4DUiS+jy3Wni+yfPQlhnFiLfmGxtP5tH2dPQoLg==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr4307425wmc.122.1598434467042;
        Wed, 26 Aug 2020 02:34:27 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH 18/30] wireless: ath: ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
Date:   Wed, 26 Aug 2020 10:33:49 +0100
Message-Id: <20200826093401.1458456-19-lee.jones@linaro.org>
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

 drivers/net/wireless/ath/ath9k/ar9001_initvals.h:462:18: warning: ‘ar5416Bank6_9100’ defined but not used [-Wunused-const-variable=]

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/ath/ath9k/ar9001_initvals.h  | 37 -------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
index 59524e1d4678c..aa5f086fa3b0b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
@@ -459,43 +459,6 @@ static const u32 ar5416Common_9100[][2] = {
 	{0x0000a3e0, 0x000001ce},
 };
 
-static const u32 ar5416Bank6_9100[][3] = {
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
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
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
-	{0x0000989c, 0x0014000f, 0x0014000f},
-	{0x0000989c, 0x00c40002, 0x00c40002},
-	{0x0000989c, 0x003000f2, 0x003000f2},
-	{0x0000989c, 0x00440016, 0x00440016},
-	{0x0000989c, 0x00410040, 0x00410040},
-	{0x0000989c, 0x000180d6, 0x000180d6},
-	{0x0000989c, 0x0000c0aa, 0x0000c0aa},
-	{0x0000989c, 0x000000b1, 0x000000b1},
-	{0x0000989c, 0x00002000, 0x00002000},
-	{0x0000989c, 0x000000d4, 0x000000d4},
-	{0x000098d0, 0x0000000f, 0x0010000f},
-};
-
 static const u32 ar5416Bank6TPC_9100[][3] = {
 	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
-- 
2.25.1

