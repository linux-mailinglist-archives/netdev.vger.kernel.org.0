Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EC934B29B
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhCZXRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhCZXQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:33 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9720DC0613AA;
        Fri, 26 Mar 2021 16:16:33 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x9so5407489qto.8;
        Fri, 26 Mar 2021 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hq5rBNomcB5P7dul+poQPrfyCrFTOAzjYQ0izkenMTE=;
        b=hJdwp40RIoNOsaFhTdK1kyNjibxpLoK2UJbBQLmytGLeoYMUDHCIv67sKXkaMVuuWD
         /VoGFaWHtpMFIRXviWhrl9fITjJshqdqVbe4DKJHX49SuNfox628+mUhseenywhwFb+c
         nq+P90rrliBOP1Mz4qWt63EEJ/gag+EG6GL8rKNQ+Zkm+cgcWoJx4H5O8UWHZjCVeg3k
         42IEtCyjwqz2FCiEIcRl0RUGA47ur19H3f2nXZkPNwltrWikGIznXMFH8WsjBVFzgxU2
         NeQGKTpPl9fe7eg1+EnJlr4ezAxrxyK3sH1iO7/G4/EIxysk8syULVg5Y9N9zEYIyAiq
         yHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hq5rBNomcB5P7dul+poQPrfyCrFTOAzjYQ0izkenMTE=;
        b=rJsgkBQN0UBecV6H6ClyFMKCZJ2qF9uuj6z9LNm0spp7HZarj+/cjWEH0qn2SaaQgh
         5qrdoGMGuP2rYYIN7K40TB4tK48X8RdU5jYbDID99YbcjSWwZ2M2RrwUMiOwEFKqCaVH
         6s7B2SYL8IqdrPjGjrmFWbV0AjUZ4MoePDziU3z4rg4Pyo0uTbz6Ftdq1/1m6pfJmNac
         MU3RlCrt58Isx6j3oIzOgvZ2Xrx7Dx77HDSWq81JGHVrAblZDAT6QUIyB9RpBv7lw9Sa
         TooUS6kAbiVqlBHqfVsoZbInzlgSSAfDey6GHAXxY9SeRjTKtCZgl/5Qc3XVDBcaCASu
         8zjg==
X-Gm-Message-State: AOAM533NaPx3J6E7kpginrxs6u5UL+AljYqkVDPuC0mzRdBLv1t5zdrt
        SQBPfnKJy+u1V0Eir+q6B/XEurWe6mcRzUqD
X-Google-Smtp-Source: ABdhPJzNe6ALNFN7bKLGwtxl8NQfwtcdwezytdna2HJuchQWTL9w0U2UgBpWtnjodnHbXFEpLrYzKw==
X-Received: by 2002:ac8:4903:: with SMTP id e3mr8083321qtq.16.1616800592943;
        Fri, 26 Mar 2021 16:16:32 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:32 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] ipv6: route.c: A spello fix
Date:   Sat, 27 Mar 2021 04:42:41 +0530
Message-Id: <20210326231608.24407-6-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/notfication/notification/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1536f4948e86..dfe5fb260e4c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6093,7 +6093,7 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,

 	if (!rcu_access_pointer(f6i->fib6_node))
 		/* The route was removed from the tree, do not send
-		 * notfication.
+		 * notification.
 		 */
 		return;

--
2.26.2

