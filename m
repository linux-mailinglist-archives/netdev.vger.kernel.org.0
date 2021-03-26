Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9234B291
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhCZXQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCZXQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:15 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1DFC0613AA;
        Fri, 26 Mar 2021 16:16:15 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id x9so5407162qto.8;
        Fri, 26 Mar 2021 16:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lWmpm99AjPMwsAA+HeeQATviVqadwwf7PdEQKJXK2kQ=;
        b=BLXb7gDUO5enUcAxfflgvdHId605cDZItpb0L3NYVzxRL5MHmEXMRT1Od/y1svh0pm
         4h0k6rVphwzCIPKbEtf7ehzZqv7DQn2kWhea+fvS8tYV6158W68X137gSoWylqSX+bTw
         7r4BMfriu98bvT5QPMGLckfzaU2AYU20omca0Oq+Z1449ZW5heb1HPx+2vIQFr0xXooo
         KsiHUOnao3h+LdLdtYc7zxAXFpGI6dxQs9dL1Mqjek3krHmk5gol1IFasSuFWmzdnjBY
         WJNnjDN/oTryArR4e55dj50gKhUM7aznZSy5IdH4Y2tcqJNDyX+skWGZQ8ax3gEiJgxk
         +2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWmpm99AjPMwsAA+HeeQATviVqadwwf7PdEQKJXK2kQ=;
        b=cWj7KTETjMRctTkqHIIX5dlJsnD0fJE4ciaPBY6ra7qGgBPR+ysm6JQNCIYPVEfQuv
         3w92y49eKeKJCq/nZ4aYZyoiMhxMCe/ngpC3vs61uXF5TqHUBRFYCU5S40FItBD+XALm
         n+vP0uV9g5O/UjTaP41zqMqUM6CXCeJOJLsh0WfdRE8XeR8qJMuLSqjz9gCsPJz36okB
         b1eZrtBHfr+Z4HO7y8ETQF9FrNtV0coeEe01JqURYZOY37VLXTdueV8qYhMGe/DjlJUH
         zPdr65og7bUXd4Tet5U0DmzbxTyR6Supn+G/llBaTAoNEUVTFOn6ywII2nHLGfy3zoAM
         8SVw==
X-Gm-Message-State: AOAM530IxKouChawHfdN7ZVCF4VpgCTaOFdhkeoznQzFuA1sK1XyDIf0
        E/QFX7anYiLvjuXQNY6UV3A=
X-Google-Smtp-Source: ABdhPJywQ9kNiskHD1FT9gZHKmIGc0ChOnffk1zNnfcOkPRvCfQW3qyu799DpbdR7lzN8fzTW9zzkw==
X-Received: by 2002:ac8:688c:: with SMTP id m12mr14431693qtq.74.1616800574420;
        Fri, 26 Mar 2021 16:16:14 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:13 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] af_x25.c: Fix a spello
Date:   Sat, 27 Mar 2021 04:42:36 +0530
Message-Id: <20210326231608.24407-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/facilties/facilities/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index ff687b97b2d9..44d6566dd23e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1018,7 +1018,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,

 	/*
 	 * current neighbour/link might impose additional limits
-	 * on certain facilties
+	 * on certain facilities
 	 */

 	x25_limit_facilities(&facilities, nb);
--
2.26.2

