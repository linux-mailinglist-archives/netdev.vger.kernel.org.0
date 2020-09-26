Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F11279B89
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgIZRqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgIZRqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 13:46:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF16C0613CE;
        Sat, 26 Sep 2020 10:46:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s12so7304414wrw.11;
        Sat, 26 Sep 2020 10:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9nv/gU1YFk3IEzxVXp+ajt3nGB2j/MGxPydW57eKpfM=;
        b=NLkmcx5c4XyG/S8wZ2CLwlcTTMyzHSrYy8MNlwbhY19F0eLA+32tVA+WhEpA+4pUIZ
         xMPomFGEZ+L91ubW3I5riVmEtWSO2BkF6RrRMFq7TPrR2nCTonBuzczX+A7HD6AxfsuE
         /CfzHeCtBFokXnKPISTkzFe0vyyY2iT2CGKSRX2AxAm4CgBViMpzkf73n+6bEqPVGb7l
         uiF68D4+aw2StsIhh2JH8sTIzMy7nw55Wy+o65cc13Zt/cJ5HSUCteMpsRzz4q5arQ1C
         +zcDtXT4csKgPd4f3FH5ZqL26RqYqR/VkcgflosraPio1EOUBpwY7CoKiwchAu1ovSEk
         tX6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9nv/gU1YFk3IEzxVXp+ajt3nGB2j/MGxPydW57eKpfM=;
        b=tP8gOfwRRMfo/T4ZkF29xSHgcO5yZZBqpsiWk+7Xwb88kyIwOMnQiJhrjf/sfosFVG
         vlWI7YycgMmQn/rJGDW/oyK7x0RlkqRVpHMwtr/TKCP6zcC6geLEFCTnRTIKBMHBBhYi
         NX6w3PZCu9pzZHvvwZ3vBflSmKXArc79GKrr1Zv7FwkCVbCY5/8sJX6AnSwgsNAXXlga
         37NchOIEyhxhTS4TGQ9MMVM6HQtSaAIzP5LiS4ro5+2pVIHqqmsokWBeANPC7Se6/Epg
         mO1DTlZ2ER8VmCDRiWJ8AuuzsNPepbYuYRIR/5afLueLHURJFqwDsktsMy7j9QZt3hoY
         yMnA==
X-Gm-Message-State: AOAM5334mQzqsr4Uh0uFOlkddXRKKGxAJ3B/8eCFQl0Hyctx8CaH2sVB
        zZegbJzHemTO4BadvnQ3f6s=
X-Google-Smtp-Source: ABdhPJzGjYA4k797mLZ6hLfD7hQA/MmrvjqyzeuLKlsKpl+/J4fcQz0GQmPAJbPcEfOKH1z6OTEpmw==
X-Received: by 2002:adf:d845:: with SMTP id k5mr9652147wrl.285.1601142368485;
        Sat, 26 Sep 2020 10:46:08 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id a5sm7366001wrp.37.2020.09.26.10.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 10:46:07 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wl3501_cs: Remove unnecessary NULL check
Date:   Sat, 26 Sep 2020 18:45:58 +0100
Message-Id: <20200926174558.9436-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In wl3501_detach(), link->priv is checked for a NULL value before being
passed to free_netdev(). However, it cannot be NULL at this point as it
has already been passed to other functions, so just remove the check.

Addresses-Coverity: CID 710499: Null pointer dereferences (REVERSE_INULL)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/wireless/wl3501_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 4e7a2140649b..026e88b80bfc 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1433,9 +1433,7 @@ static void wl3501_detach(struct pcmcia_device *link)
 	wl3501_release(link);
 
 	unregister_netdev(dev);
-
-	if (link->priv)
-		free_netdev(link->priv);
+	free_netdev(dev);
 }
 
 static int wl3501_get_name(struct net_device *dev, struct iw_request_info *info,
-- 
2.28.0

