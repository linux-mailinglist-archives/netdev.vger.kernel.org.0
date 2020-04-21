Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187BC1B231F
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgDUJpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728162AbgDUJpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 05:45:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B268C061A0F;
        Tue, 21 Apr 2020 02:45:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e6so1135134pjt.4;
        Tue, 21 Apr 2020 02:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=63dlfBrKorbJ+FwMRBgb43Uw19Cb7qy/VHJKu/L+1jo=;
        b=uFlVqQtoMEXJofyar5xlWMsXKHPaJ5IfFs1bYkDAcMygct54MuFIdYvTaMEeMHT7V6
         qO9KUHelwHwrNa9DZB7zmgbDsdHklLam9Aa6vUM3xO6IAGV18W2ZPGJTuWPKobjHOAAI
         cMzmwoVoBB0jFKxKWco38VVC9A2DHYqMmwrtG8FlUtKWRqdQTj4Sc5P+DmuzV0CSsE3v
         wxQnjixIdgU3ohCMAx8rXVONsR6S6zBkGG88X7SgNHTMpdEY4ccuJRdZNAI+8jR69z1g
         sofJh1oVbnN6SsGRbUGva33uN3ZC0z95Q3aR22bjjl4LoQpsxoojRCvXqP2Z+NiSkmTs
         4VJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=63dlfBrKorbJ+FwMRBgb43Uw19Cb7qy/VHJKu/L+1jo=;
        b=lA5f4xHTKC+TWvkAIoBmM7aHzCyGPUn9N9SeCljAjWos9FLm9zl2Cx5ksLXrFCP5Qu
         hglzPYKqtvausF9q7AGRC1nDSr0cy/DhH9Yw2oSiwFBueAsHmNQ6HImHvgJPtFIq0w6a
         I838hDS3aDEobC0vrsUZHEUchowgq2S8H1kamabWNb3O3/6UivywrjWHvao5HzfTVlYD
         OPq+SMKTNXi15vzrXAJVVqRlfyNJlHNxYqntG9ksVvuTph+/gt6nnT1C+6xTHBqxwyQy
         Z4k3jJOQtGd3GRzAgLIaW0yTpocO51P28JfvGlSZZdWqRQczk1MDb9VJLXfXUEi4CR5S
         dotw==
X-Gm-Message-State: AGi0PubUfrKZwPEiFZloxhctb2SFLb7m6DMOX3h/B9EUiBboXgXTMGUS
        PC/VwmUBccCZGYfrAqn0Y3Q=
X-Google-Smtp-Source: APiQypL1xj4xNKUg43U4SUtQmw/Hr5BuApYChUbtuQ+3RFQkN1ofC5PbpmqT7rJtDVB10m+n0FOlBQ==
X-Received: by 2002:a17:90a:8994:: with SMTP id v20mr4669161pjn.76.1587462319819;
        Tue, 21 Apr 2020 02:45:19 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id h193sm1966886pfe.30.2020.04.21.02.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 02:45:19 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] libxt_IDLETIMER.c - fix target v1 help alignment and doc
Date:   Tue, 21 Apr 2020 02:45:10 -0700
Message-Id: <20200421094510.126375-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 extensions/libxt_IDLETIMER.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
index 68b223f4..216b6257 100644
--- a/extensions/libxt_IDLETIMER.c
+++ b/extensions/libxt_IDLETIMER.c
@@ -66,7 +66,7 @@ static void idletimer_tg_help_v1(void)
 "IDLETIMER target options:\n"
 " --timeout time	Timeout until the notification is sent (in seconds)\n"
 " --label string	Unique rule identifier\n"
-" --alarm none	    Use alarm instead of default timer\n"
+" --alarm	Use alarm instead of default timer\n"
 "\n");
 }
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

