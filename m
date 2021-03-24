Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B59347956
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbhCXNQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbhCXNPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:15:34 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D14C0613E0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:33 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id n198so21430277iod.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jEdK7HODEXGaHkN0tnvNi4JdIE04/obrX1IK6/1t7T4=;
        b=yd5bAmiXbtr+I8BpZsrowONFEdcu9LIc0uxTJpFW/umz0BZFdG+gFe6M/fT5HPi4GD
         AZ3P4EzTCvhIUPgsIeB4TMyIud5TZTTylwcx1w8pg5+ZNLAtJoJgCTFzM3+7mzojfBJd
         XqBN5DYmqBRgkPMVNA2+MMXYYOkHMy300TCLOQzJ3swRBXSedCiLPUXrLStvNEHtqNzs
         BC8XZPNWu9+kDyHpDHr9jA5GdEe/eLKvIZ5jLxkIcgbGGEHmOLr+OkPLxzffqtNlvyXb
         y8tRdtTybASbk9Cot0Nbfui8pZWbmCBe3lGnYg+99qv4PUEs9bpiv3CYtzTUH00pBNjS
         ZQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jEdK7HODEXGaHkN0tnvNi4JdIE04/obrX1IK6/1t7T4=;
        b=i/JaKbbpRKMS/zPCwG3kiPoos4lRF8FXRIWhmO+8Ld20e3/s+xH87HIM9ZX6VaEiCO
         ed1ZJmuY8czz6bMKYhkvVh0PbhVk7ZVEt27GVpeLr2lLQ+p28905J27DNoxQXw5xX2y4
         bKi5XUt3r5Lpu7OffjxxnsXpcYk1IkoUj9RvxwkUuJaMMq6JrEAhWxwNhHmZgO4HCcsQ
         P23mkYOxwRHfPNg3jRrlSNue4yqqrMUFMA5zBq2JRom7IrmBwoFowcMNvwe97f79UWSr
         PA3J0SL9kvPuGZryihddZMqubpvWcNrrNgMrz1FLietfMTPI48pRZIW+aEeim9Rx47rG
         jFHg==
X-Gm-Message-State: AOAM532OmvVcLkGCfKlbGFwlS4oE0tcJeo0lwC0nPcba8WhClIwLPrWH
        WdPoe/ejp7DH8NQhHddbzT7/wA==
X-Google-Smtp-Source: ABdhPJxCQk2NaFFUj5DSTJ/Hin8w5JteNpb2QDiHIQ4dkUk3JoGciH49oGv6htzeYaPv6kskaHR7Bg==
X-Received: by 2002:a02:cb8f:: with SMTP id u15mr2735141jap.45.1616591732787;
        Wed, 24 Mar 2021 06:15:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n7sm1160486ile.12.2021.03.24.06.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:15:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/6] net: ipa: update version definitions
Date:   Wed, 24 Mar 2021 08:15:24 -0500
Message-Id: <20210324131528.2369348-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324131528.2369348-1-elder@linaro.org>
References: <20210324131528.2369348-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IPA version definitions for all IPA v3.x and v4.x.  Fix the GSI
version associated with IPA version 4.1.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: - Add kernel-doc descriptions for ipa_version members.

 drivers/net/ipa/ipa_version.h | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 2944e2a890231..ee2b3d02f3cd3 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -8,17 +8,32 @@
 
 /**
  * enum ipa_version
+ * @IPA_VERSION_3_0:	IPA version 3.0/GSI version 1.0
+ * @IPA_VERSION_3_1:	IPA version 3.1/GSI version 1.1
+ * @IPA_VERSION_3_5:	IPA version 3.5/GSI version 1.2
+ * @IPA_VERSION_3_5_1:	IPA version 3.5.1/GSI version 1.3
+ * @IPA_VERSION_4_0:	IPA version 4.0/GSI version 2.0
+ * @IPA_VERSION_4_1:	IPA version 4.1/GSI version 2.0
+ * @IPA_VERSION_4_2:	IPA version 4.2/GSI version 2.2
+ * @IPA_VERSION_4_5:	IPA version 4.5/GSI version 2.5
+ * @IPA_VERSION_4_7:	IPA version 4.7/GSI version 2.7
+ * @IPA_VERSION_4_9:	IPA version 4.9/GSI version 2.9
+ * @IPA_VERSION_4_11:	IPA version 4.11/GSI version 2.11 (2.1.1)
  *
  * Defines the version of IPA (and GSI) hardware present on the platform.
- * It seems this might be better defined elsewhere, but having it here gets
- * it where it's needed.
  */
 enum ipa_version {
-	IPA_VERSION_3_5_1,	/* GSI version 1.3.0 */
-	IPA_VERSION_4_0,	/* GSI version 2.0 */
-	IPA_VERSION_4_1,	/* GSI version 2.1 */
-	IPA_VERSION_4_2,	/* GSI version 2.2 */
-	IPA_VERSION_4_5,	/* GSI version 2.5 */
+	IPA_VERSION_3_0,
+	IPA_VERSION_3_1,
+	IPA_VERSION_3_5,
+	IPA_VERSION_3_5_1,
+	IPA_VERSION_4_0,
+	IPA_VERSION_4_1,
+	IPA_VERSION_4_2,
+	IPA_VERSION_4_5,
+	IPA_VERSION_4_7,
+	IPA_VERSION_4_9,
+	IPA_VERSION_4_11,
 };
 
 #endif /* _IPA_VERSION_H_ */
-- 
2.27.0

