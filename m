Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DD134B2D5
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhCZXUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhCZXSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:22 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DBDC06121F;
        Fri, 26 Mar 2021 16:18:19 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id x14so6950782qki.10;
        Fri, 26 Mar 2021 16:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hq5rBNomcB5P7dul+poQPrfyCrFTOAzjYQ0izkenMTE=;
        b=i8yjfy4cKx/eAxUSjJOayFqkspqkNttbr02cz9Ch+zEhk1YDx+W69Flr/DfJHCNXoH
         ceSZ/0Vt+oT4DR0JkWXN7t5Z0dgtxWpTS1H+286T+X6erkPyRSKILOgVs27QEZZzHq+y
         ExFcCNJN36e2+H4NAd8A5iN2BsPHbue8pDRTJkAkGGmrNgnbYZbfEId+IBM2zBzNogCz
         Mg/EI8ocMLCSTOcw1rl87o3xertETEGLKsRJuSzed5Lztp8Q5G+sptUkX3rbTWudNOTO
         T6lEcnYtl304+ejR0NEguc7Mhi+wFSQvGh5ykkwCB+FaUzTzgBCsZNQeKoXpQ6mZypjA
         yQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hq5rBNomcB5P7dul+poQPrfyCrFTOAzjYQ0izkenMTE=;
        b=HWSAbdYU3KbN9Rxxx5/bO9ZlUttn/XHnCKce9CFPTgrugJqtAb38cEOe00xVbB0tvV
         nTB+VHmVjXiNOaetzDgUC+5q3wMHE2U88eOiaSuxX3sHFINyiD0gUITy8Kusyyhv85dH
         VPqVkhFpxmsytjaf1hwk96+IrcjL4+uxbKYt0xnWO+lmAgvgEwZgSgArNTUlmtAuWgsi
         SdtTzhqxWWzhTz51GLhYPDpoacC3GFAR9nc7Uxw/U5cbz+xonF5Evd8blEtrm9FUmHjk
         R/f0YbgQOxSjCnswsLp3AS/B0JIXffixn7DZqAzM9I5uFwFa9R2GlYBwhGHBPLVy0Dw9
         8OMg==
X-Gm-Message-State: AOAM533nKMcI5kTUHeEicHBMhDpdeEeC6qdihhzECmnvqOwHD7YusOkM
        7L8TSk9hBcM3iqA2sKw2G00=
X-Google-Smtp-Source: ABdhPJzmIS2iGt+mff+0WobXyes5SoTLC0Fdpl41hiBMOOSaW3h8MydVH2GIou3miM7LqgI4rSw0FA==
X-Received: by 2002:ae9:ebc3:: with SMTP id b186mr15036817qkg.335.1616800698360;
        Fri, 26 Mar 2021 16:18:18 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:17 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 16/19] ipv6: route.c: A spello fix
Date:   Sat, 27 Mar 2021 04:43:09 +0530
Message-Id: <def62040c9b7ccae36c81d5805b1413e23d68c21.1616797633.git.unixbhaskar@gmail.com>
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

