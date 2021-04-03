Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8950E3532BB
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 07:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhDCF1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 01:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhDCF1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 01:27:33 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743A2C0613E6;
        Fri,  2 Apr 2021 22:27:31 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c3so6981562qkc.5;
        Fri, 02 Apr 2021 22:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABtMI8ksFSdWzNo+QyX4TO78LN4nqKlOQbP/dp/j8yA=;
        b=ZF6hI2cjwuyUsdYmcWCMvhfhVFtrHBp2hsJdQMyfoH+/EJ1hYOUPXzbzANyEFwDBB9
         fUCETIEKtRsH581Gafpcu7iYCW6Y8ZFKJojwKTP4Y1N5eOr1Ljj0xTeOp4A+mGLxh5CH
         G9Jfk6y9tI5Phg1sF2H5n8V3QQKrljT49vA6269keoy9/6XxpwUMk+EDhG8W6u2V7bkT
         0/q/SpuerHhM34PVLBnq8GiLg4IyQme1ye3HmU4G5UJmAL3fYbldjzOZsoJ+mmAklAJj
         AqaU6T9MB7lYopmlx2LMul6x8uTuHVuKfrJV16pTF5I7cNra6fUuQrNnHbDbEvoMJ00x
         a5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABtMI8ksFSdWzNo+QyX4TO78LN4nqKlOQbP/dp/j8yA=;
        b=JgTveuaC1sQwUzIOwm+xeOaDWS6M0sW/Hc/mZUhQdPtCWZbl5eiHiIghqzyIR+yqNM
         I0L8HgpbTXIKt5VQhwf/k5y8kCFw5NTaZxOhe2Lat7HyA9rK3apj82VdUqMtL+iQIwGg
         poKb21sfrtO5K+hgMQvpyDp0NhOq8mJ6aimBGLL0h07Kluh6hMh3qrlhDiZL0xZIMMYv
         XqgJmFYcFaVlL37Z6/n9nLaO6MVffW4yVByFnCcuYsZ7uivoTi2+P64OtWCiwkTjh7dR
         luiaCQOIN42w5ZcfE6301EIZPmTYVn5zbIcIgD4OdOagb47e78PQaFxURdDT0CBdIAk3
         imeg==
X-Gm-Message-State: AOAM530BXjdNR5chPiZMefbEIgsxWSaTFT8tCq8Xm7RzlH1sRsJ+5vIZ
        Px6WRzlcRel35CS1Fs1iHrw/Y17JeB5NIA==
X-Google-Smtp-Source: ABdhPJwf+ODeyrc94hUge2+X1fh2EhD8g9HcWgBg0FoXBUQzwXFi+rW2B9FoBGem3nGUR+AdeWx3Eg==
X-Received: by 2002:a37:78b:: with SMTP id 133mr16001499qkh.109.1617427650588;
        Fri, 02 Apr 2021 22:27:30 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:d1:9277:b313:2e46])
        by smtp.gmail.com with ESMTPSA id v35sm8076007qtd.56.2021.04.02.22.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 22:27:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next] udp_bpf: remove some pointless comments
Date:   Fri,  2 Apr 2021 22:27:15 -0700
Message-Id: <20210403052715.13854-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

These comments in udp_bpf_update_proto() are copied from the
original TCP code and apparently do not apply to UDP. Just
remove them.

Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp_bpf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 7d5c4ebf42fe..4a7e38c5d842 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -110,7 +110,6 @@ int udp_bpf_update_proto(struct sock *sk, bool restore)
 
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-		/* Pairs with lockless read in sk_clone_lock() */
 		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
 		return 0;
 	}
@@ -118,7 +117,6 @@ int udp_bpf_update_proto(struct sock *sk, bool restore)
 	if (sk->sk_family == AF_INET6)
 		udp_bpf_check_v6_needs_rebuild(psock->sk_proto);
 
-	/* Pairs with lockless read in sk_clone_lock() */
 	WRITE_ONCE(sk->sk_prot, &udp_bpf_prots[family]);
 	return 0;
 }
-- 
2.25.1

