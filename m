Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B89C33DA37
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbhCPRFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238972AbhCPRE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 13:04:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357D5C061756;
        Tue, 16 Mar 2021 10:04:58 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 16so9250976pfn.5;
        Tue, 16 Mar 2021 10:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lBoqDQGbVDAXmG7Obz/KwLjC/e8VHnkycjoidmWyVI=;
        b=NIyb7nSw5CTvnOicx0DR0Pqd3PKo/YN8dx4HYS0YShQ7gOabF1wT7cdloVz38e0t0E
         zmyX82Pz+Z1qkWjnee3uAa5CfIqnXfBLKzJMbLOsWa71O/CbEl2yXatDIVNSHus7XkVB
         8EOky+SMXsrEvtJq2JQF2NyQRckTMCnYQ9Wd7AinBl+2mACxBM1YwZD4vxsoCIWQSMuH
         xdi6OYgI4gzmD1eIOlgBKB43YII+LML2pZ8DbzlYUO/+KlnAsPlYZb2pDPGCqg/o3C6R
         0epjLzKx4GklZ4hFHAntyqd3FSgXHmyptn48dSyoijCDP/28G8haRt6ntS6fMwXCgMvu
         uCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lBoqDQGbVDAXmG7Obz/KwLjC/e8VHnkycjoidmWyVI=;
        b=Mr3nGOKfJk0FtnbZJKdsoCUj/lnijP3SrU0/zRK0h7wGd6kWLsa+y7dyvkWzn7xxZH
         krfTy6sc3U17j0w/wYIh+JwygSd23AZaFGT9rwlmDEIfQ7U7o2OX1IZrrgm6hUr+6WZC
         QPN793Z8j0RzzAWukkwYP8VvZRbW8NOVAu9T20Mx61IBrwBrzOkUDORcsq7mNVVc64Z5
         xOzQZ1O5PtLFt8BVDoAUHkt/4I9dQTRBK9c9m1/GcROjZL8O81IighHAuV/UImmN2fYu
         LkHr7e9jtTr1/eWB1Qg9f5OsvEd6eJlIpFQ4CAens7eYKDvT67a5MtLyZUDUR4FcPJhp
         rqAw==
X-Gm-Message-State: AOAM532lmzxhT5OlbNL2wgUdrO9fzdB9i/TzbsTp09u67by53DfXGNWz
        uIezwUqc8bo7buYlOiITprQ=
X-Google-Smtp-Source: ABdhPJyMN0dn2p8WDL4zzof28yTpopJAfm6Ga+kz8Oc4Ill/NGZWAau9MXh1N0BYHhY5AMtKq2IMPg==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr621283pgi.60.1615914297538;
        Tue, 16 Mar 2021 10:04:57 -0700 (PDT)
Received: from ubuntu.localdomain ([182.156.244.6])
        by smtp.gmail.com with ESMTPSA id t19sm16832031pgj.8.2021.03.16.10.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:04:57 -0700 (PDT)
From:   namratajanawade <namrata.janawade@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu,
        namrata.janawade@gmail.com
Subject: [PATCH] unix_diag: addtion of empty line
Date:   Tue, 16 Mar 2021 10:04:47 -0700
Message-Id: <20210316170447.3394-1-namrata.janawade@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Warning found by checkpatch.pl.
New empty line added  before return statement to improve readability

Signed-off-by: namratajanawade <namrata.janawade@gmail.com>
---
 net/unix/diag.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 9ff64f9df1f3..feb79a43944e 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -78,11 +78,11 @@ static int sk_diag_dump_icons(struct sock *sk, struct sk_buff *nlskb)
 			struct sock *req, *peer;
 
 			req = skb->sk;
-			/*
-			 * The state lock is outer for the same sk's
-			 * queue lock. With the other's queue locked it's
-			 * OK to lock the state.
-			 */
+			 /*
+			  * The state lock is outer for the same sk's
+			  * queue lock. With the other's queue locked it's
+			  * OK to lock the state.
+			  */
 			unix_state_lock_nested(req);
 			peer = unix_sk(req)->peer;
 			buf[i++] = (peer ? sock_i_ino(peer) : 0);
@@ -116,6 +116,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
 {
 	uid_t uid = from_kuid_munged(sk_user_ns(nlskb->sk), sock_i_uid(sk));
+
 	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);
 }
 
-- 
2.25.1

