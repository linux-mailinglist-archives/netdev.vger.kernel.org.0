Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB852A294A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgKBLYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbgKBLYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:49 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE53C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:49 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id a9so14113520wrg.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcBd80NlVbn3uGSdfGXvocYKOP7aRNETXFKMl2YiPGc=;
        b=TuQtao6p6GFiEVg6JEmLlKgf0D49U9VNmQ4ReLha2879SpnKSDPyH9euAO02gE1yKf
         f5uN+SxO3aZQiyAcxMKHEH5mLrEPIvx36/Va40Vnm/yBPXj+5ZYIj//8tAzCOGV5bS/z
         LZ/KBRyN5OWHznYhKUj3qnkXMRd4/Q8LQ17xM1xjKXYBWJNId5acNlg6BkGTChNR5sxD
         XX0QcYhXsd6NIl00/mG1dTsdx1XfUVbzV/8mHesihcvklchsFOLlAk8otYKJqscyS+pv
         jnWUOgs+P7yK7RPfAA2PiPaSjFd/5JzTgfi4es+zl3tYcu3KgsxRsbC3LcJErsVNFYRC
         Q9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcBd80NlVbn3uGSdfGXvocYKOP7aRNETXFKMl2YiPGc=;
        b=kpYRzkkbH+D4KZxgxKKI8wCy0IApngIdaJVp8c4ejM0CZjWGYHGTcsiIs2uKleyWZ/
         rcg+Kj7ogHUEC4eI5pkjB+ofJtrNXy6Hq1jxMJhNlO0huTksra0jm8Yo7JRsf1Um59PH
         fq2z1pkyj1ujWriUSThEOSIRgA4ZbS0dj8r7PK3Q3bAxxe0CXrTnX/Uh8BIGxjet1P+L
         IR1nWJsSDJmA79uhWG8PdiHuggc7Z3X1AE3z+KoH1h91YhHQhxilgEvD02veV2d/1O1V
         gaRJ6CxfI9NtU8klc7IJp5E8CkVQbzDNNIsc6B+hjvejOkPbdUco0Mx5bEZTiMy+Adqi
         LPTw==
X-Gm-Message-State: AOAM5321dmKSqSrRMY8ACRTO8ZYlj/4UqXx77Yz1KfPVqExULVoME1xV
        1K6Ox3GMVyWO230EgqeLb5mWLQ==
X-Google-Smtp-Source: ABdhPJxg1nc4dmX5MjDufhqqTExnyiFLhhTFkmUc8dGkb00hCvUBR2eKgcQZt8OUc7WUWUfi6p97lg==
X-Received: by 2002:a5d:62cf:: with SMTP id o15mr19138513wrv.49.1604316287835;
        Mon, 02 Nov 2020 03:24:47 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:47 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 21/41] ath: dfs_pattern_detector: Fix some function kernel-doc headers
Date:   Mon,  2 Nov 2020 11:23:50 +0000
Message-Id: <20201102112410.1049272-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/dfs_pattern_detector.c:34: warning: Function parameter or member 'region' not described in 'radar_types'
 drivers/net/wireless/ath/dfs_pattern_detector.c:141: warning: Function parameter or member 'region' not described in 'get_dfs_domain_radar_types'
 drivers/net/wireless/ath/dfs_pattern_detector.c:239: warning: Function parameter or member 'dpd' not described in 'channel_detector_get'
 drivers/net/wireless/ath/dfs_pattern_detector.c:239: warning: Function parameter or member 'freq' not described in 'channel_detector_get'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 0813473793df1..80390495ea250 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -23,7 +23,7 @@
 
 /**
  * struct radar_types - contains array of patterns defined for one DFS domain
- * @domain: DFS regulatory domain
+ * @region: regulatory DFS region
  * @num_radar_types: number of radar types to follow
  * @radar_types: radar types array
  */
@@ -133,8 +133,9 @@ static const struct radar_types *dfs_domains[] = {
 
 /**
  * get_dfs_domain_radar_types() - get radar types for a given DFS domain
- * @param domain DFS domain
- * @return radar_types ptr on success, NULL if DFS domain is not supported
+ * @region: regulatory DFS region
+ *
+ * Return value: radar_types ptr on success, NULL if DFS domain is not supported
  */
 static const struct radar_types *
 get_dfs_domain_radar_types(enum nl80211_dfs_regions region)
@@ -227,9 +228,10 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 
 /**
  * channel_detector_get() - get channel detector for given frequency
- * @param dpd instance pointer
- * @param freq frequency in MHz
- * @return pointer to channel detector on success, NULL otherwise
+ * @dpd: DPD instance pointer
+ * @freq: freq frequency in MHz
+ *
+ * Return value: pointer to channel detector on success, NULL otherwise
  *
  * Return existing channel detector for the given frequency or return a
  * newly create one.
-- 
2.25.1

