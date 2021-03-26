Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E534B2A2
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhCZXRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhCZXQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:48 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58159C0613AA;
        Fri, 26 Mar 2021 16:16:48 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id h7so5446622qtx.3;
        Fri, 26 Mar 2021 16:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LllaaHpdvuCs0e3CEiSO6Aept4+/RFQNKUiAfBl1UJ0=;
        b=EwWAKWooVTzPwbG/7HKXQTrx8q0znZzMDHaO2mylQhAvJZ00oXtDTRXOIDa1do8YZT
         64L09xWscUBN+NHdc6YXc9rRqwgbiouSo9Onh4UD5UuxUjGlHQbWNdqRFUh7I0dpJPyI
         EJbl968iWR6adwKXwlYJQeI0Qn7QhBCpyyfdR+W5iRydf/Hqj58N25w7zG5ZXuB21K4m
         NTtrtEsHVA7fjNxvI+D5XR65JYzHMJIlvc9D3LDFtJCXd/AzsjwCRLkghrH9g+727KlH
         pTBvb3y4gwphqLUMM8rjd92VTimNRVohmPY0tIyu0i4Kx9EE6mgC6a1epv0dAmK4WNtj
         7gbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LllaaHpdvuCs0e3CEiSO6Aept4+/RFQNKUiAfBl1UJ0=;
        b=dg14r7EqCv35m38z2UYpATXLq7+lGTeJdY8iAPYU61NDm7WqftY3tiG4dviFAxVrdF
         s7Is3Ii0yk3UNMNCNsR6iWxvnnoe/SRvW2/eBxJOH5hGOC+QeXQDlE9yuiyHF6UtQU5x
         2AK2BXlQWVl3hT7nG278Uls/FIVZP80l00aaEEIBYjRD3j76k5jqz0I8dGHSJDIP6wJJ
         m+HA1NVLezdbHCZTaHLVCF8rjezlZh8087QlUIYfQG8m0EiFwjl9e3gdCXSZ7HDId4k+
         vhPRyPe+aAx+Xoi1smewjwOy7kutSmQyZa+iOQaNInuiSYhWvdN+R7Xw5jpReeFekpZP
         zlLQ==
X-Gm-Message-State: AOAM532gOXUBf63MBBnPNkVOadmC8vsw9jwosuQpuMBTrKycZ9MJARR2
        EF/VMl57sKfQyuxDP7BPOs0=
X-Google-Smtp-Source: ABdhPJwlBtZ9AWZCTZ6BSP73sWqasVi6tVKDq3K+983Oc6J0ZWbOnLpHhCfaoa0T49mg2Wdhj0wBuw==
X-Received: by 2002:ac8:46c9:: with SMTP id h9mr3350099qto.283.1616800607688;
        Fri, 26 Mar 2021 16:16:47 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:47 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] mac80211: cfg.c: A typo fix
Date:   Sat, 27 Mar 2021 04:42:45 +0530
Message-Id: <20210326231608.24407-10-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/assocaited/associated/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c4c70e30ad7f..62f2f356d401 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1486,7 +1486,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->sta.wme = set & BIT(NL80211_STA_FLAG_WME);

 	/* auth flags will be set later for TDLS,
-	 * and for unassociated stations that move to assocaited */
+	 * and for unassociated stations that move to associated */
 	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
 	    !((mask & BIT(NL80211_STA_FLAG_ASSOCIATED)) &&
 	      (set & BIT(NL80211_STA_FLAG_ASSOCIATED)))) {
--
2.26.2

