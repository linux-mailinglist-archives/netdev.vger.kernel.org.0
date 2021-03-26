Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BE534B2CD
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhCZXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhCZXSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:04 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE1FC0613BB;
        Fri, 26 Mar 2021 16:18:03 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x9so5409404qto.8;
        Fri, 26 Mar 2021 16:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LllaaHpdvuCs0e3CEiSO6Aept4+/RFQNKUiAfBl1UJ0=;
        b=aMAfa00iJnCjuk/rPOYoBkZNnhJmUadLLBMsHVj5IPHSbp/1Ml9iqPf/pQTLA0ORWD
         mbNZJpuFEc9zlA6rgNt/xdsg1tJiJjosTVpeQuhiS7gDp5mvXDBSMtNZY8pJXi/AhqUl
         qw7pjo8itDtLi6EFzh1cHlv5/NmIjPUy2dgzG5UjY3BDZKTI0PFgDIEzCSxoGP3W26+a
         BEeq3yJ/ZQpcRsNSLk2ktsByT+SmL2/nHbIucnbGt2l9b5zF6KvLzmfHpBF6UJc3fsxm
         zfA/rarz+1GzZvxf1Sth1USKa1TVw95o6LpexsIWhYr1753w8WdtjIsqU3AD0BINBdZp
         usjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LllaaHpdvuCs0e3CEiSO6Aept4+/RFQNKUiAfBl1UJ0=;
        b=W6QYiPcWmxojL3WoDnzfRfXGhLyYP2ZdcrglS6h9IhcAT4a1TWEl6jb4Ix2qSPILre
         8GZReSafaZdYgHp1/nFEqc2QBThhoGHy6Ca/x7r7b3RRY2eJqxexpJ7tzIf3VDLHiwQb
         o3ut1SnQ06LNCfMtE43J7K1i95d9rd11p9BbQtAVA6CMt2NM6yB018y0HUjVSpjj4uZM
         am/cUYlhn5cwMsiUpq2xB0MVIYWBQRvp6kylGywKtVOfDhtk7N67qOcfz3l1raIDSxZa
         DoKkMAh1uXFB9VfuOX4MxddR5no0h2TldJqBK0CitzrgFw1MbV/RYAWtQvei9n+hGAWc
         H9/g==
X-Gm-Message-State: AOAM532vYRzcxZTzmPvgDsr2zNGHpavN2I7uSL1EBnJhkwbILGdJamb1
        N14i4fQEV8OUL8qTaF6mpL4=
X-Google-Smtp-Source: ABdhPJxgjXGzLmL2u/ZR8HMX2WHeAtfgxK2EmsL5sswlNy1khp17PfmfKHjGVoWlhK5fwo2r74Lr2g==
X-Received: by 2002:a05:622a:1746:: with SMTP id l6mr14036728qtk.110.1616800682996;
        Fri, 26 Mar 2021 16:18:02 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:02 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 12/19] mac80211: cfg.c: A typo fix
Date:   Sat, 27 Mar 2021 04:43:05 +0530
Message-Id: <94441e0bc79f1fa4f2788155b5977c284d6e6900.1616797633.git.unixbhaskar@gmail.com>
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

