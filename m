Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11F252A5B
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgHZJiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgHZJez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:34:55 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44075C061344
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:27 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o21so1081105wmc.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sh6GJ0mJWJb3ICmo91l9UDo6bvtBy9zVj1QpKnJ7Ig=;
        b=E7S6Pkng7Y0zFItSSiJ6u4PAD6CRFndCXBLJmIKAADhgYzB7tAwnaOstq39x7K8YiA
         aYOiEa6IQ9pL2hp7r4/h6gkkN38ntfPXaVOzMazdJu+zmREhsaSzSyEHFJRalsGXtdGq
         RH0GewQfte2wlRM98ENsZ362ARQtgwlM1+Sverg5BwZw6BS9GhUr+h+OwQTC+WD+R5LD
         xP6mO7vA/v8yQcC0oB3mckaIE4cr9uwDkWUMvsQSMjSzBT8BmE3dJhUPo5k9PsJ3dL4n
         7i40Rog29DFzVrx7zYzM4LzRshP1DRoEa6cMkG1OOmgevWJPDDV//yehqKjWH3ay8Sb8
         WoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sh6GJ0mJWJb3ICmo91l9UDo6bvtBy9zVj1QpKnJ7Ig=;
        b=GsPmSsscJYQQnV5zpE83mJCDyqw3IB10ZadH9DC1WTWVaiN6x59B3uy4lzlZ/kqTMf
         yvDmMgwe82Yu9N/XlbyCYUWsOX7vDTeMKppnajRwF97HznvMTsd20HpiKmv7XgF6zsAu
         aBGsfWjKcyEWNaS7vQNfc1kft6P2Q3+PB4nBsIdFjjEsnV+km6pjidqtXZOHmXI5gabq
         lrXdLau6S6Y/8dvugUhFsgauB7puXloLvXgszEYCh+od6mtYi10pPgH18IFqIHfi2JLN
         ls+T9cnPUfAElYDUdLedCiLAisnzCL0sgrScJn4ygEH3dFOAICIJRvZCWvSf0p9xZ6xn
         v0TA==
X-Gm-Message-State: AOAM5337VHD2N00s8OWEp1lLthtbMr8umJxjzXhrgAatMClbS1XCnouX
        kf8dbUXn+duDDDF6nJIWPhYcUwP0ncLGqA==
X-Google-Smtp-Source: ABdhPJzKS5OctiAZPFx3Qk+kjCmzI82WamC6hYGDP51dNtvT2E3Ogaz8sYsUpYWCXWko3lNaCQH5Og==
X-Received: by 2002:a1c:ed15:: with SMTP id l21mr6221723wmh.56.1598434465884;
        Wed, 26 Aug 2020 02:34:25 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH 17/30] wireless: ath: ath9k: ar9002_initvals: Remove unused array 'ar9280PciePhy_clkreq_off_L1_9280'
Date:   Wed, 26 Aug 2020 10:33:48 +0100
Message-Id: <20200826093401.1458456-18-lee.jones@linaro.org>
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

 drivers/net/wireless/ath/ath9k/ar9002_initvals.h:900:18: warning: ‘ar9280PciePhy_clkreq_off_L1_9280’ defined but not used [-Wunused-const-variable=]

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index 4d18c66a67903..e01b5c3728b86 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -897,20 +897,6 @@ static const u32 ar9280Modes_original_tx_gain_9280_2[][5] = {
 	{0x00007844, 0x92592480, 0x92592480, 0x92592480, 0x92592480},
 };
 
-static const u32 ar9280PciePhy_clkreq_off_L1_9280[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffc},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
 	/* Addr      allmodes  */
 	{0x00004040, 0x9248fd00},
-- 
2.25.1

