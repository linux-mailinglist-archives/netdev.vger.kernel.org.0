Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD7746F911
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhLJCXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbhLJCXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:23:50 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0254C061746;
        Thu,  9 Dec 2021 18:20:15 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id m24so6774340pgn.7;
        Thu, 09 Dec 2021 18:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6JqmrYn5MnXo3sIg5m8rICeAl70tcXHDD8ylnTsluak=;
        b=QkXO+13aySo56ouVWvJH4g7w1Zs6DkYNolh0GeYknQDWg4s/YeO5+FbPKtvyLm9GfV
         XvlVM6xnEsL9aOWQ8lVjCIz7Z4UtyWx5ttqtGhX0Y82jf+Hv2Q8MU9034A5pcc4UuyHK
         mPWGcAMZd4jdFXglSHuEYj/r+XyRZW16WEGhbtjljY9oCzd92eHnZDOlhhQRVEC33DRH
         6oNwAe1jmjJ3uD5uqe9ZFL5B19TzdBex6cGk2N1GlTOQq3VtRXJahBrr3XfG42N4OJ++
         TZrjV2XBUFY04/MgN/gQQSiko0cW1AHuvVoiWJU7WIF/G2TPLT9VNx2nwC7vCExU0234
         pCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6JqmrYn5MnXo3sIg5m8rICeAl70tcXHDD8ylnTsluak=;
        b=NcCy3MRZrHgjnWrEAPtDGLULAnDbogApDFaPFGrTCKkiBWrpOw1MZXyD0HV6mA/+AL
         rojcEkcp8dkiZzZWm75O73OggW2wzSJGDFu3347BzHncnD4Bp73S5Eu7h4RyLAVL6q50
         M4r6V6g9tGVVYH2s2jcpGNjIAfy5HNfwd+L0GtgD7vk7Dp22qZYJ3vpwafEMiMq5CSC+
         7tKTSHLJ5wgAMExxiP2AfcGDUvRyH6CriH8ztq61Avo50Pbj6lx/GABT4keczkP56xoS
         ZykpBEA8/YFFnpsGVT9pYYLNsDWEKTVtmrLsfdggvQeHhrMwsKOSzckAogzOGkWiETg9
         PQWQ==
X-Gm-Message-State: AOAM531tko1SrbFv19f70FFDBtxF3ME9kjoJPB+EuPPqjXjt3E96JSfQ
        wupNiNk4YJaVKlxSmohYPA0=
X-Google-Smtp-Source: ABdhPJxG2pkZvA/BC1OdbKRVPESROngPQJaOmv7QSUzF4jaLORYByPKVP3mC7CUM9dj4+MZFeYcg/A==
X-Received: by 2002:a63:90c8:: with SMTP id a191mr36435135pge.482.1639102815580;
        Thu, 09 Dec 2021 18:20:15 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f10sm10805298pjm.52.2021.12.09.18.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 18:20:15 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pablo@netfilter.org, contact@proelbtn.com,
        justin.iurman@uliege.be, chi.minghao@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH core-next] net/core: remove unneeded variable
Date:   Fri, 10 Dec 2021 02:20:12 +0000
Message-Id: <20211210022012.423994-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return status directly from function called.

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 net/core/lwtunnel.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 2820aca2173a..c34248e358ac 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -63,11 +63,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
 
 struct lwtunnel_state *lwtunnel_state_alloc(int encap_len)
 {
-	struct lwtunnel_state *lws;
-
-	lws = kzalloc(sizeof(*lws) + encap_len, GFP_ATOMIC);
-
-	return lws;
+	return kzalloc(sizeof(*lws) + encap_len, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(lwtunnel_state_alloc);
 
-- 
2.25.1

