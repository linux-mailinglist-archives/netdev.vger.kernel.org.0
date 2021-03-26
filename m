Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F20F34B2D3
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCZXUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhCZXSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:13 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EDBC0613B5;
        Fri, 26 Mar 2021 16:18:11 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id g15so6978392qkl.4;
        Fri, 26 Mar 2021 16:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WYy011GyX62Pm/ehNkchCKTDPlINF1PIVbzE0/YBtc8=;
        b=LfZ3uV6OrWHVrFTYH3EtrXug9dmWNtKFyssuy2ZvJbkF1MdCATuC+M1WWNxq1CC58K
         XCtJMFQO10WF9qExcW4AcHZhSHG8Hhgl1UJMtoFNVI1RlNeopoBtdsEs/CZriDZ/1tEH
         F3HJxf/0b8BALvUH/Ridq4K94PlScAMKWzUbA9vhi+JUh2AdKXzXOTGwjuHnp6cdFTwk
         chRGqMxfdZlI8MllwkG9GYvF+mIlIGg1UyqPcCFzA///3j3OPQckE99gba+izzypbnlI
         SuPoXAFmeG8jiAWVnyyZzTw8haGw4l8lap4ApyFEl0ql5Sgb59qpoQmGJVKIL3pjE0eU
         dWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WYy011GyX62Pm/ehNkchCKTDPlINF1PIVbzE0/YBtc8=;
        b=K/nEae5Br1onfWhZ+wpUph7bls35f/dLhrSayi6QLIv390TtU3pl+LYAo9HkD8F/te
         yeu8krFbt0J2v264Qmd5nc/hFeloraEqTNVIecl0phkHSWKH312Rg1UG9rfxTmtIathB
         kDDvG+9Vz+XPum0anfWvJXlt4ok36oTyTXGsHyuE8Rsk4wGjjvoa/wSdjThBDk316YNP
         S0uVTQmJYdj+9lskqbe89b4WbjwTz3qsWWHV2nTLnUBvIfltLYCQ6xTIWVbTNtcEgCUa
         0jW/xEo5rSUyc3J3QTquGxEXITipp0qQasEoWEkvhepUbXATajbOfkwf3NwKH3GF57cA
         +JTQ==
X-Gm-Message-State: AOAM531CzABKgl0ZjIWWnDGH7m8ez41wbonLXG+OgJpoFQXq3E5Tpg6o
        X7OQLLO63fY+AHBYILmDNWo=
X-Google-Smtp-Source: ABdhPJxf4MpfKap2Cict2kUMaccT2msbphnMMBzS5ZQrEBUKQXR0xJkFmWk/aGU1HE34GLOUiivP+Q==
X-Received: by 2002:a37:a5c2:: with SMTP id o185mr16206174qke.428.1616800690656;
        Fri, 26 Mar 2021 16:18:10 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:10 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 14/19] iucv: af_iucv.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:43:07 +0530
Message-Id: <6972443965d2707a669dd567d26bc411202403ad.1616797633.git.unixbhaskar@gmail.com>
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

