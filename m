Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209F4263E2C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgIJHLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbgIJHAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 03:00:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE59C061365
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:22 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l9so4616798wme.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sh6GJ0mJWJb3ICmo91l9UDo6bvtBy9zVj1QpKnJ7Ig=;
        b=C4soKIQr+HtIx13rx9qA/15FRHFKVdvspCRsPnq/goUVkiQ4KZNEepatmbLTp2tc3C
         ctqDXC+sft2sLmaCxPWFVqy1wjtwIvIBpREamtN4rJ/LVvlDdEi2MJu1cNiQSxnQD4VE
         GgMMRYv2oCxVohRyT3aSUb5j0mD7xM2sZKmpxpCyBm8JAZaFPCCxQQ+bV8NjJKJKx9RI
         kxwK/4ZD646Lcol5oAd8xIPIhFj1TridIQ0n8S8PuxUHc+2LskD63txFM8mBTn+CzvgY
         j3bSz3NJOG4J2WrBJaWnu/qLYBGNnrA3NqcKKZsebBbl9Q9V9U/a9z+aLQBwA59U/hBs
         56wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sh6GJ0mJWJb3ICmo91l9UDo6bvtBy9zVj1QpKnJ7Ig=;
        b=SAfNPpsjhQCkzzQa1Pzl9yIwLUiqosAy6CFf/OLyFEnwyiwwz64hkGxoRZPnNsEBgo
         2MwxwsMVchbXPouUSezNk8ARQ3Q9ZeB9oxkdfVpggYxeqd9gPvXybDnf9Zqyc1d9c40A
         5deXTahyALYmfJKizhAdNMc57G0dx8/qhjJvipRF1MAb40X94VC1a9KZ122whLiFqGNS
         eIBlEpBfl+Hyqy4rr8HEzCCwny0REfFVFwUm+T20TT4PL6dedk9XYAU6Ap7xAJMd7iUX
         Q6sZOtu1kSxdE9q4aqylldFWcSTw3HZcEPLEgn7/2GNsDi+eq4S8pJrjUhKFPIv3SeBy
         rk2w==
X-Gm-Message-State: AOAM532KUSJuAsYULUyM6uNe1NAdQovQaKUU7LIqN0TKuzx19yQG2X00
        U1Nr+N0r73590O1Z2PpH2u2P6w==
X-Google-Smtp-Source: ABdhPJxK5TLost41t/MKr8GdTX/Kl9grFZdTUozpgRhsaRFzGojXjDqHZfOOKR5KBakgrCfLrwscfg==
X-Received: by 2002:a7b:c5c1:: with SMTP id n1mr6617738wmk.125.1599720921171;
        Wed, 09 Sep 2020 23:55:21 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH 24/29] ath9k: ar9002_initvals: Remove unused array 'ar9280PciePhy_clkreq_off_L1_9280'
Date:   Thu, 10 Sep 2020 07:54:26 +0100
Message-Id: <20200910065431.657636-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
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

