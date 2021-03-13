Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5B339F3A
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 17:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhCMQwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 11:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhCMQvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 11:51:40 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3297C061574;
        Sat, 13 Mar 2021 08:51:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c16so13367543ply.0;
        Sat, 13 Mar 2021 08:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=S9+2IFN1dv7+M9NnZ3JAWoiEoZQsQf5Cgay5lNY5ss4=;
        b=BD6P9vK8aJUvG4QnoR3Puj8kvKseW+6o55j/P82M88x02I+JmcKr0kc3RGQsZ37JnF
         TpAsEmNKWLD8YcrY1wJOrOaJth1XufxoyCEXfxwFdsxgKUKYZZtWWBJmNpnispcNGt2p
         PqOZpRCAZAYCByrvhSWdqpYAjP8DW0Lo/GmzX+O/Ffo3uNXGi2hgeJmmx0j8E+bzFZXe
         Ul5IFFt6mJqynovKGjmk0NFGAz3Lrw6VZE0wb6YDCFxj7HgcbaIG3sEkPOeXEVOgBYTw
         KfU5povOAaC0mN3ZNhPy4cibPnvN0xRuGA2k4NL60Fv8NBSNN5PKWktHs3qf/X7CEPTr
         kDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=S9+2IFN1dv7+M9NnZ3JAWoiEoZQsQf5Cgay5lNY5ss4=;
        b=RAmEywcLsWhFMiMt+avBKNjnHQjIrht29xc2hjrpAcddYjGE+m2pCcc29sEnl2IEdv
         K+/kyRHaR4XLfPiVHDScwc7g6PB5EWaoQ0ctzqaJ48ixh3s1Hr2w3oJtkgiMoCTdrnjK
         /Km7oB11rb92B0BVoN5U4A1UxN/PcQB7d/jycFrhydH9D8UtvntqHNwDZ7h0eJ2g5vDt
         jW+X5PnTE67bqWbGiUAJ9SSjm23EDZd5hN/hjnz8uF6HWBNA6VPlO4F/LMjaRsgxBX90
         AHt3dbB1LXvZ6cDEOOXA5LTsl8ZKNqZwC0n3RWbZRv5ohQmOsRUDnjzRwjT7XUxRTIs2
         ZwMw==
X-Gm-Message-State: AOAM532kyAeKpAWXaGH0DD4GgqJWYJOD/aVll5Bb2GJ5qwxxtvZP1a2t
        xAgO19CW7fvtCRN6oFXbgkE=
X-Google-Smtp-Source: ABdhPJyhUajGkXVqVI+2w2kKBevWnt3jZ2LBA6OEJfupov4wAmkSuPaGY7mKMoi4jniZ4t/uSUzXRQ==
X-Received: by 2002:a17:90a:bb91:: with SMTP id v17mr4287638pjr.24.1615654300218;
        Sat, 13 Mar 2021 08:51:40 -0800 (PST)
Received: from client-VirtualBox ([223.186.9.86])
        by smtp.gmail.com with ESMTPSA id a70sm8572800pfa.202.2021.03.13.08.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 08:51:39 -0800 (PST)
Date:   Sat, 13 Mar 2021 22:21:28 +0530
From:   Chinmayi Shetty <chinmayishetty359@gmail.com>
To:     pablo@netfilter.org, laforge@gnumonks.org, davem@davemloft.net,
        kuba@kernel.org, osmocom-net-gprs@lists.osmocom.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     bkkarthik@pesu.pes.edu
Subject: [PATCH] Net: gtp: Fixed missing blank line after declaration
Message-ID: <20210313165128.jc2u2pnpm3enbx2h@client-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Chinmayi Shetty <chinmayishetty359@gmail.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index efe5247d8c42..79998f4394e5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -437,7 +437,7 @@ static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	gtp1->length	= htons(payload_len);
 	gtp1->tid	= htonl(pctx->u.v1.o_tei);
 
-	/* TODO: Suppport for extension header, sequence number and N-PDU.
+	/* TODO: Support for extension header, sequence number and N-PDU.
 	 *	 Update the length field if any of them is available.
 	 */
 }
-- 
2.25.1

