Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8803634B2AE
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhCZXRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhCZXRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:07 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDF8C0613AA;
        Fri, 26 Mar 2021 16:17:07 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id q12so3778173qvc.8;
        Fri, 26 Mar 2021 16:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=952+y4uMf0/pVptF5Wduqg9Re4XUWCLAGYqO1h4oDAo=;
        b=TuijCrCgL9B76ZQeUVLXyr+2B8YS9S1aeUKO9Z1QJvGLDb65Nr4XCBP34Co26pyUCt
         4cHmtb4qBxh4bFfek9MYyjF1qlAw226PBnppgaaaKONwK4CvWHXGvXc/nGsFUWagZq2S
         IxeHYhRKunbe9COX6XFEUWAdyIMtF+De7W07itgqBVfhUT9suOL9/zSkwOHpndz+aIhQ
         +828+nnI4Us2hoD3IlBLmliLiy+5Pe55ZZ9mNQWfcfRjctubj5veaF+yXoYjWe6VxWuH
         ovqYtbqMlwhDKM428sBAT4fzR/uvjrM6bSuLw/cFRWpuaXDzHMIA6UdblNrTWLSG0mv2
         aTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=952+y4uMf0/pVptF5Wduqg9Re4XUWCLAGYqO1h4oDAo=;
        b=lSNmlg0mwO0cIFxgSv0gmXlGXsytU/JCpetoQS0fPDmfy0IlQU60artx++dqc7UeVF
         kZRp98SH9upnjcyeZlwV4Dyng1/jRE38vCaOhe6K3JlylR0bGIFmGmGxasx80c2GNTtY
         KL3PPQYek/z7FCa/PSc3MseFhTbS0DERlEzWwHc756AVpzrK3TC7yRulI9I4r4oMzew4
         dZoCxUlkzfvruyaQ7jTJhrNjWKsD9z+rMzqup6Qlw6G48SKeJ0vDAfvgp43LcoQwXssA
         Kw+gQPwFzscD7IJvB0/rTAUqf+ggQOyCpB7TP3S1sz6gxryWP2kSFC3ytP1o7YX0yiUt
         sNLw==
X-Gm-Message-State: AOAM530uDfwgJmf870q/CMCcWfOiopPhjkIlu0j27SNDgxo/BinqNWba
        y/Mgu9hgWLpHlZsJ1crLblI=
X-Google-Smtp-Source: ABdhPJxII6W/MdmVFTwImOXF5k69/aoRrsgzGJuNDpFQMEY/jSgED95jJjCd7LzStuPCAOE19IK6Ew==
X-Received: by 2002:a05:6214:1305:: with SMTP id a5mr15551537qvv.42.1616800626536;
        Fri, 26 Mar 2021 16:17:06 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:05 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] node.c: A typo fix
Date:   Sat, 27 Mar 2021 04:42:50 +0530
Message-Id: <20210326231608.24407-15-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/synching/syncing/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 008670d1f43e..713550c16eba 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2009,7 +2009,7 @@ static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
 		return true;
 	}

-	/* No synching needed if only one link */
+	/* No syncing needed if only one link */
 	if (!pl || !tipc_link_is_up(pl))
 		return true;

--
2.26.2

