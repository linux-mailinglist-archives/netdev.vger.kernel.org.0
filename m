Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103AB34B29E
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhCZXRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhCZXQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:37 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF12C0613AA;
        Fri, 26 Mar 2021 16:16:37 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q3so6936712qkq.12;
        Fri, 26 Mar 2021 16:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5erpXU3Aq3hneBUldIzDMOS6BrUCvWqA6H+cu2bXQ5c=;
        b=CH30D8ON/1LI1U+uYv8riNgZmyrXAq7JKZ40U64ba8dwYxp4Vi7Pls44NYcCwEwVOL
         MgJDByTVS0oZmRRQUxwn+WthIBe7lo1x8Lxn9ZChof6BNefrA9mSAnPbJP25KOOYyuoe
         hTB/c02eBGzSPPqf1zOHg/tyqg/hXykGDpceyvDodccpL8MuIBHjem+O0oeHc/nM3rpB
         2nvTpSOuGSUXyqkdX3C65DKvd0BqYE4RyX62QCpMYY9QO0KHGwijsoOBNmaeaENw3znm
         d1MbB705eMU1wrdvIfkndinTnN8Hve2CG2T96bzcmrqot5tQq6KVfg/OBxrZ1iIFhKvR
         pPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5erpXU3Aq3hneBUldIzDMOS6BrUCvWqA6H+cu2bXQ5c=;
        b=SqQQJMvLPEf0XJCCYQ/IrZz2nbjzPvK8oSuFjNh5Jc4Qg6f/2DkAnf6An7SN4LuQlF
         cj7HDvKxVZrYDICrtGGRYV1nyLMBeOV9+TvXR4j/rHSsn1PJ53cJ8BbhZdltEEtiuyXr
         SGvgmo/0Dnoirr75jv7NPalFc07cWkAeVfi9yRoG9YfPpTUtawukoblyIGrlmatDFknP
         +oXSoPENE46vSNal0kwdXEVifxUptQeYFzLrWDFx/9OAzx3h1rp6jSzXyx6tyap81iYJ
         D5M7dkZMEL5G9FL8ZXgP5Y9PPsdfogWf1gJ0hP1PKzbNUBlYH89SIt/Ra/0E7rbv6fmR
         /zfA==
X-Gm-Message-State: AOAM5317wa49YJOG/TB1iVhw5zvNPrmo9s2n27oLriHubtWvD0pchhzo
        iw6aZuNNeZcvhYMJj+lsRaCBCCGqxnH9dcH1
X-Google-Smtp-Source: ABdhPJwK3aDywgHiHIjsYjovV6/HGstEHm5oubPEW9jiWiwz/rUPrn5QybJj9qXQhi+nb99Ja47UsQ==
X-Received: by 2002:a05:620a:714:: with SMTP id 20mr15531143qkc.192.1616800596650;
        Fri, 26 Mar 2021 16:16:36 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:36 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] iucv: af_iucv.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:42:42 +0530
Message-Id: <20210326231608.24407-7-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/unitialized/uninitialized/
s/notifcations/notifications/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/iucv/af_iucv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 6092d5cb7168..0fdb389c3390 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -621,7 +621,7 @@ static int iucv_sock_bind(struct socket *sock, struct sockaddr *addr,
 	for_each_netdev_rcu(&init_net, dev) {
 		if (!memcmp(dev->perm_addr, uid, 8)) {
 			memcpy(iucv->src_user_id, sa->siucv_user_id, 8);
-			/* Check for unitialized siucv_name */
+			/* Check for uninitialized siucv_name */
 			if (strncmp(sa->siucv_name, "        ", 8) == 0)
 				__iucv_auto_name(iucv);
 			else
@@ -2134,7 +2134,7 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 }

 /**
- * afiucv_hs_callback_txnotify() - handle send notifcations from HiperSockets
+ * afiucv_hs_callback_txnotify() - handle send notifications from HiperSockets
  *                                 transport
  **/
 static void afiucv_hs_callback_txnotify(struct sock *sk, enum iucv_tx_notify n)
--
2.26.2

