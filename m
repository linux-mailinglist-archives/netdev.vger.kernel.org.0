Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E74E18C40A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgCTABN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:01:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39977 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCTABM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:01:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id f3so5462040wrw.7
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F3ZI78ZMMyElK4iUNhZObxDnUIbJmnnq4fIHXEPoOqs=;
        b=k2vQLduHvlOcB1QTrdRwrsryrDCR9Gg+1My0bHUgECY69+jt+3tV98SIL1U9HM0b4w
         dVLtOPCcbCicaiOnKYqfVBOhugSpm0cw0SHK3jEvfE9zjC4gQwSN961oYAId0sXvzw0i
         dKowDgadOWiuUTwG/Oj2HiWQWuYdW3AWewJ4y7RZtBS7NbWUWFzcA8BYCmzQOIcf7NKQ
         Cjk1VpnaFv/nV0lJ7itE4213oSVFuWJf0OFrYnIBFymbRlIF5h1edUztiFt5SxLZLzQW
         pbaIuMOUIeGNdPMUVEoc5L3f3vCqXf2MkSlPUdXu7xICiFKC1uK/vuRhqeChO8iutYD/
         fpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F3ZI78ZMMyElK4iUNhZObxDnUIbJmnnq4fIHXEPoOqs=;
        b=nmjL/IvwQH4z8jNfHkbgeHhuQezNlalE7X13muVi8ai1Um+caQ14eNx0Uui77ylaTC
         ax0oZ3SNn1K1SbCzfkXVUEKY3Mxpq13D+fuU9JoIYmcq1XUCpRVKOLBGKvjcvfMiaia/
         vH6Qj1Ezp/GcmdCxXrrfJRJIEtdV0VLK9HkYFubM7UELiJ2A9uF0dimNnzGEdjNbOHIa
         htvzPeZJRdPkmn3JGbMC7i2Yn456+Y5BUWyLulT3aiuosKQi3X/4fGLc1fUCjK+UMrh+
         GFTIuWwfCpCTSdkGkM96tLNit56/mWlB5R2tMKldQYWEx8ANMi2SCa+rGQm4GdXNpB9O
         V1nA==
X-Gm-Message-State: ANhLgQ3dnVEQgP15ay/gRVTIad8LMazRKmaWYUr5EnXtBUcwV1CKmLN/
        o2h4Ej4EZ0YborCi0ZN/rJk=
X-Google-Smtp-Source: ADFU+vu6LE4d11hkfDbMYWwYf+2jHo+PrGHTVxuSW/COxgFu3+xCzkMQUq6N031QIP1EyTNavXJxYA==
X-Received: by 2002:a5d:4d51:: with SMTP id a17mr6698928wru.285.1584662469859;
        Thu, 19 Mar 2020 17:01:09 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t126sm5670418wmb.27.2020.03.19.17.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:01:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net 2/3] net: dsa: tag_8021q: remove obsolete comment
Date:   Fri, 20 Mar 2020 02:00:50 +0200
Message-Id: <20200320000051.28548-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320000051.28548-1-olteanv@gmail.com>
References: <20200320000051.28548-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the commit mentioned below, the dsa_8021q_netdev_ops structure has
been removed, so the comment is no longer true. Remove it.

Fixes: 129bd7ca8ac0 ("net: dsa: Prevent usage of NET_DSA_TAG_8021Q as tagging protocol")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index b97ad93d1c1a..0d51d4974826 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -2,9 +2,7 @@
 /* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  *
  * This module is not a complete tagger implementation. It only provides
- * primitives for taggers that rely on 802.1Q VLAN tags to use. The
- * dsa_8021q_netdev_ops is registered for API compliance and not used
- * directly by callers.
+ * primitives for taggers that rely on 802.1Q VLAN tags to use.
  */
 #include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
-- 
2.17.1

