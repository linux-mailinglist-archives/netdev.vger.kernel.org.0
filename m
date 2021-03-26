Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80C834B2C5
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhCZXTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhCZXRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:50 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BA6C0613B4;
        Fri, 26 Mar 2021 16:17:48 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y5so6965394qkl.9;
        Fri, 26 Mar 2021 16:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=McAgNR//ZZOSE4RTlME+7zIMYVZ67kdO9uVaupZQzno=;
        b=lbepUcJmKwAY1jqAB61kOQMtNRI32tq0VF/SVxk8wGUSpmwZmguM/Y6W962rWefZah
         7GsHYxzH4kYgqLa9RzIkdz7KInx/hUtQIZyQ33OKJmXn2GOTxXW7Kd57edyyQFVUg0ul
         DHAScsSYxDUynoLed45mmChA2hOAADml6iS9Hz+7YJGhSsTdCPJon7dzsn3onUlekuiX
         5B5RGEDlmGm25Wtif1OiBPd+ydnskV20NT36VNz5QNKyzZ5LjHX59OHF1HZ8M9Eitl02
         bTajw4misDytjvgzadzpTRRyDCyD3HqLfY7ryKC5DukBileIDL3rBXACftRB3hYfXja0
         W9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=McAgNR//ZZOSE4RTlME+7zIMYVZ67kdO9uVaupZQzno=;
        b=bigCwlTfmkf1DS2Nw5gCozZ23nQIM+CgdRDhkDjOyDKZboarcz6PAXuoMo+KGYs0+M
         OyCaj7o9ChcO7A4J5jMolLkvG6rBGBmyNzeKRZ5wTaSSs0DCch0cKHrriDJmzA6U6Dci
         CN4YwaI21WcSYhdcafT5+Ow28uJzEUj5XB5IFITEGM99ZY9cpXrQ96lYrPN3lLuGokiy
         OhwxHecnR5UnL1z1gY4EZYL0xFkqqmcSTCzajQkX28hM7/PauaL8NB91HiQ2FJCrVIot
         EuxPNj/RBVQIwsNexJglSNz75rg97VdRB/pWg0xj/MVk6bHzUfxHnpjbBAjDZcuCxgx/
         dseA==
X-Gm-Message-State: AOAM5308i5xusJrlMksEk3Sg/FjwPh6O9Ojiqi1+dnJk97syhOUCUWOA
        7fC2UeKn+bn5aKkaRKy3FMc=
X-Google-Smtp-Source: ABdhPJy4j1Ie1Vds+z/TU8zXd0jRQXV8dC9bJJ0m3qSn6ejLzizRIFaX+bTgvrh+nl6j4hd8ia1TTw==
X-Received: by 2002:ae9:ebc3:: with SMTP id b186mr15034872qkg.335.1616800667669;
        Fri, 26 Mar 2021 16:17:47 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:47 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 08/19] netfilter: ipvs: A spello fix
Date:   Sat, 27 Mar 2021 04:43:01 +0530
Message-Id: <e332d89570c2dd95512a888c8372e69fab711952.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/registerd/registered/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 0c132ff9b446..128690c512df 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2398,7 +2398,7 @@ static int __net_init __ip_vs_init(struct net *net)
 	if (ipvs == NULL)
 		return -ENOMEM;

-	/* Hold the beast until a service is registerd */
+	/* Hold the beast until a service is registered */
 	ipvs->enable = 0;
 	ipvs->net = net;
 	/* Counters used for creating unique names */
--
2.26.2

