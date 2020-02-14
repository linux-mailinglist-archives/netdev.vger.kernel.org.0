Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6676615F816
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388957AbgBNUtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:49:04 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50602 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388856AbgBNUtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:49:03 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so11326067wmb.0;
        Fri, 14 Feb 2020 12:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VHMVKXLHBNxjyTw9PodUAEyMC2IYxb6HL4YYaDfpFo=;
        b=TJd4McuiYr/ITRKbYOrr+cWzpWCbleppZ9QpDEG33Ynbcot2kvqD8xH3YkWMmoh8I5
         cOT/8hDhzuYpGxhQw9vcs8fNI9rtugg4rXH/9KCDomKViQcBJ33CFIFy0I557UryCXwo
         /rvqh3Thhb7tTbCpDVYPp32t6IAVSw6BXwL7ambONsi9SI0RSHyAXpT2yncaWHqYQEVi
         EVPrGJ20OYHN7cAyksjcYAruF76fTZQkziMwnHTGkanVYo48JpFejj3u4K85iP7RD3Yv
         8Cbb4WDM9BrPlVIbSdwjNKP4OibHHaaSMl8Ei2sm48eFXqhUWZQkk19Z2gdsvg7aDfkN
         D+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VHMVKXLHBNxjyTw9PodUAEyMC2IYxb6HL4YYaDfpFo=;
        b=pYDNsL2ovVZSYQOzyU2ZUBb2SL6z+9M5xzHrr9V4IyZPTMsUbIxFfUCL3BQmI1wYH9
         o6S8HC63YmXZrXAVw9UzI1kw9OElEK2TEXiPB9eRIbpahVcfM7eRWYZ1mgWkv5y6eKjO
         5Au0KEpqXuV68aIs76mv9+lx4bsr2U0boUlNqrX+e1uUlKM5fCShInGbQgF/g1jacGnb
         DnI1y7D33PZ/k0QMII9Qp9Tjy8RGZvcx2Z5ZQPre94Y2ay37DpUCP+hAKt4z6yRyCLZt
         f4UpiiUrvbXWMvvoNAbLFgz9SCEyvGVj0VaVyMlhIihpjh9PZltkbczLsxLmrQ+7cOfp
         N+7Q==
X-Gm-Message-State: APjAAAV66cP5+6yJqSQQF1+jT1c3jsVbu04hNqHO+lqeKxO+pCb7vOZh
        SMxXi/B+0J7nrHQm2fHX5TIKHHQUUiKa
X-Google-Smtp-Source: APXvYqwzVnMWjFKcCKtE6H0LQQPUyRuehJzk0vpQiz9ZNA6O2oNJs575AorCv6hLyHJqFNmNJQC5Vw==
X-Received: by 2002:a7b:c459:: with SMTP id l25mr6309989wmi.17.1581713341270;
        Fri, 14 Feb 2020 12:49:01 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:49:00 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TIPC NETWORK LAYER),
        tipc-discussion@lists.sourceforge.net (open list:TIPC NETWORK LAYER)
Subject: [PATCH 25/30] tipc: Add missing annotation for tipc_node_read_unlock()
Date:   Fri, 14 Feb 2020 20:47:36 +0000
Message-Id: <20200214204741.94112-26-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214204741.94112-1-jbi.octave@gmail.com>
References: <0/30>
 <20200214204741.94112-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at tipc_node_read_unlock()

warning: context imbalance in  tipc_node_read_unlock - unexpected unlock

The root cause is the missing annotation at tipc_node_read_unlock()
Add the missing __releases(&n->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 4e267ed94a2a..eafa38896e3a 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -356,7 +356,7 @@ static void tipc_node_read_lock(struct tipc_node *n) __acquires(&n->lock)
 	read_lock_bh(&n->lock);
 }
 
-static void tipc_node_read_unlock(struct tipc_node *n)
+static void tipc_node_read_unlock(struct tipc_node *n) __releases(&n->lock)
 {
 	read_unlock_bh(&n->lock);
 }
-- 
2.24.1

