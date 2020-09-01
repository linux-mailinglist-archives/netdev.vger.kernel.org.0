Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A92259E03
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgIASVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbgIASUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327CCC061249
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:20:38 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so1033502pjb.4
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IcN3C/Ls2OGYhSgdpQ1NfJ4oAC+4fYQIV9Br5dK/uxs=;
        b=fP0dBlgyOQv5JJrgWNYLsu8Rez7AsKifJoVYAUTWKm4pB2o7PU5jR1C0QC352kr6Qn
         /wDexuFd6UDPnn6kM86W7ZHvKq2PGYA3hfTa/qIZz+zoDUGfV8OrlE0stFgRLF0d54Wi
         ZZr7179HkqA5sVBlohwQGRyaV3gc/NSSnIB1Igse456Pt8o4cCA927glngPZh/DBjh3F
         Zys808y5SJxKRkM8RJEkySI1Og6BzSTS1i5Hh0VetJzsoAqjYQfrIl/CCbCA6C6sQ2Mk
         Rsx9ybrMAPS4T3LmFROoHdmcdNwOxS7XK+qprXdfZEV/prbQgmHQaY6685j10+xPW9ml
         m+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IcN3C/Ls2OGYhSgdpQ1NfJ4oAC+4fYQIV9Br5dK/uxs=;
        b=ONJGSUjldkdrg9wVi8q1l+ZoJPoqb3Z8mQ01ZC/GGS0nVi4KwgU4nEoD0RmeKnqjl3
         YJ+PSka4HO0RSTrSXttXOyvCd/6yHaJrUZ73XJb0d7dhCtRAlcFgoQNm9esUcBVyrSWs
         o2KrYPr6pDHqi3bUpvcSPQ3LvutfWNI6aa5n8dDhLdGmmNq+eJsRX4iVArCjiyFhuZsf
         wa0dHyQLRFbmMZiEUhJwrgufkqDAM0TI9QOF8ZDpDctUqlxhkH4eZOgGgBvoHt4nCwlb
         clpEPOvX0bMTGIdf34eEuoX4ZU5dAcO4TpEvxxauVbj0Ou1HBj7Pl8Wbp30XykLDyzoR
         qb+g==
X-Gm-Message-State: AOAM531XreqcmRWWq8X9iRZWy1y04mqvey3H+mgS0yBT+Kwm2/mcaJiP
        9O0VbCX4RgrLsz4A2CXRz1EcGlBclWFCtw==
X-Google-Smtp-Source: ABdhPJxNGYgRVhKKpdJJyW10Xgcish1p8xJElOGRLvLqZe831xUKVSuyo82ARv/y9k34+fdSI2+hkQ==
X-Received: by 2002:a17:902:6f01:: with SMTP id w1mr2576755plk.49.1598984437251;
        Tue, 01 Sep 2020 11:20:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j81sm2747086pfd.213.2020.09.01.11.20.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 11:20:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/6] ionic: remove unused variable
Date:   Tue,  1 Sep 2020 11:20:23 -0700
Message-Id: <20200901182024.64101-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901182024.64101-1-snelson@pensando.io>
References: <20200901182024.64101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a vestigial variable.

Pointed out in https://lore.kernel.org/lkml/20200806143735.GA9232@xsang-OptiPlex-9020/

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 060aaf00caed..b5f8d8250aff 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -670,7 +670,6 @@ void ionic_tx_flush(struct ionic_cq *cq)
 void ionic_tx_empty(struct ionic_queue *q)
 {
 	struct ionic_desc_info *desc_info;
-	int done = 0;
 
 	/* walk the not completed tx entries, if any */
 	while (q->head_idx != q->tail_idx) {
@@ -679,7 +678,6 @@ void ionic_tx_empty(struct ionic_queue *q)
 		ionic_tx_clean(q, desc_info, NULL, desc_info->cb_arg);
 		desc_info->cb = NULL;
 		desc_info->cb_arg = NULL;
-		done++;
 	}
 }
 
-- 
2.17.1

