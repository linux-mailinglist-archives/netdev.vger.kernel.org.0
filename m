Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D5F3461E6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhCWOw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbhCWOvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:51:41 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD20C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:40 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id t6so18395450ilp.11
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=flVhxrdHNm+ho7oVCfDF48oI3mzbP2vh1ljYYMgf2e4=;
        b=E8cU9WetZDv/IVdHdGkraGw43oroA3Y4oDiVfvDX1x4dwSEC6gy8Hii1wQvM5y7WlE
         GrXVVXBfMVAWmdaNK7tKyK4zEo2WKJyRYOm8nrEb6w8eg4WESREViWSKITOpiHFS5rIN
         0GL4kNMYjzc7RoWPmkupDfbWur4R08L4VDx6N0TRTtygZ92FoW3HZSIeNbFwxGK+tYU1
         dLADOZvOIHGyCvAX6J0Q5mpbksqIyqiNaAHgGMUNQTBvOBaAVNRCLocBmQNuPCWF6olu
         Emw1Ua7iQxTAo8z9s/Te5O4+MU/H9Ck1CqOv8EeIHaYWhnPWJxv+zyF/pOJ7/ufRz62F
         OysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=flVhxrdHNm+ho7oVCfDF48oI3mzbP2vh1ljYYMgf2e4=;
        b=a9m6WbgQSCl24ZOfDv6K19rM6qr9UNKCsVp21SZbO+PSfVvF5OAVY6s5/xAJ7O1M7T
         pjI3zsCkBUmrExq4Gp55JlcSGFrQQ+qavjadcubiRxoTh66AoRJaoUgPVpLAZ+Kf1osu
         tdUkHy3RwV0A9hHCHKk5Y15bbua0rG2rDqm8hojfXnm3Uy/nqqGGjkfHl6HGwHwiWoCD
         LPshWY5DznO/tbeFwoAN8cZu4Tx52njPizDR/Pu/9jSSq+Wl2e9/uw1jY5omh6fftc6B
         ITCbghfaQpAsv2y1mStlQhA/lNNddnSQo3OKYepc2tD3q9ep9Kf/d9AvlzCHQmhlmeb9
         fEfg==
X-Gm-Message-State: AOAM530qEiYfgLDHYAZihSjHuViZhQLKFYblW8TzoqU5t1nJ30dUryvr
        hjLSO9JJ9mPsPUOPEh4iHHhIow==
X-Google-Smtp-Source: ABdhPJxTDjufux1kIlVeyZjhhdk1XFsiDbHoa/s9BTi6V21f29NLNTX3NXtMvtnZJGgO8s1JzogJsw==
X-Received: by 2002:a92:b00d:: with SMTP id x13mr5106532ilh.128.1616511100243;
        Tue, 23 Mar 2021 07:51:40 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o13sm8961147iob.17.2021.03.23.07.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:51:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: update version definitions
Date:   Tue, 23 Mar 2021 09:51:28 -0500
Message-Id: <20210323145132.2291316-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210323145132.2291316-1-elder@linaro.org>
References: <20210323145132.2291316-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IPA version definitions for all IPA v3.x and v4.x.  Fix the GSI
version associated with IPA version 4.1.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_version.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 2944e2a890231..ec87b0824c307 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -14,11 +14,17 @@
  * it where it's needed.
  */
 enum ipa_version {
-	IPA_VERSION_3_5_1,	/* GSI version 1.3.0 */
+	IPA_VERSION_3_0,	/* GSI version 1.0 */
+	IPA_VERSION_3_1,	/* GSI version 1.1 */
+	IPA_VERSION_3_5,	/* GSI version 1.2 */
+	IPA_VERSION_3_5_1,	/* GSI version 1.3 */
 	IPA_VERSION_4_0,	/* GSI version 2.0 */
-	IPA_VERSION_4_1,	/* GSI version 2.1 */
+	IPA_VERSION_4_1,	/* GSI version 2.0 */
 	IPA_VERSION_4_2,	/* GSI version 2.2 */
 	IPA_VERSION_4_5,	/* GSI version 2.5 */
+	IPA_VERSION_4_7,	/* GSI version 2.7 */
+	IPA_VERSION_4_9,	/* GSI version 2.9 */
+	IPA_VERSION_4_11,	/* GSI version 2.11 (2.1.1) */
 };
 
 #endif /* _IPA_VERSION_H_ */
-- 
2.27.0

