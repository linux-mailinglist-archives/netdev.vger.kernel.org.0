Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EB115F81A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389587AbgBNUte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:49:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42439 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389029AbgBNUtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:49:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id k11so12452559wrd.9;
        Fri, 14 Feb 2020 12:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cFc8PKAJJ5VAeO0nmRlDEGv7dk9E8dGhNfk7CB3NGUU=;
        b=YX+mqKG9mNGRcsGMGcNEKbXt9zOda190gqOQKhJIjbyvdOyACGNGtDV9WTacdTyPy4
         zuLwZxHWpmw36B3ElZ4kskcj7MKflXisP5ilzgjv9UrR6Q3IUjeFE5PVEhrCiQCZNktx
         KGuYOUIntkaf3U90SaajiycN+cPvusAoWC1Shx/gI66VkWD38jnKShuOVGrnSE4zVQ08
         B4KCaS0/bF5SdAbMPDY7Xv9r5RWk+XMFUUv+eCil90LIO8DOBdZm3c1TBn6Y4RHUjc//
         8DRQgT+WzbDLxwAPvO4PmyZzaYmJigiO2ZS0287DSzLNlsTXhCpO7p8t4Ai+p/fHf38o
         VBfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFc8PKAJJ5VAeO0nmRlDEGv7dk9E8dGhNfk7CB3NGUU=;
        b=oBREP/4eJcPMTgYFHQMOvW2jb9gG9PiI+DExSA92swb1EDwGLLut8CgQhWEp88dkAk
         SH94HS7eqCTgybCdDSXApSDU7hxwON7J7yPGckY8sdXRb8KSmNEss28PeviBf/7sDXBw
         Q0VTnGn0YfvyuX+17U/uk7enU5rf0kQMQdMaAh5t7qaMEJo8+0JXtToqRuTgvosA1eEU
         WZ7mlMP7g3c8dPJto1gEZKNt1hLVPrACt/wAkFGYF4az7m6AnKPXpIMOh2oScqQui2A9
         AA+qsdZh3BTCYyhYkrztuuawZ76jpRn3ecWF8+QmrLma1zxEBWJde8LByMVRuFoUEsuL
         /gHw==
X-Gm-Message-State: APjAAAVfOArlP5W73QzPKzvyEhLXccO9q0Lsw1n99mktiYpF4sGgs/ue
        T9wbziuCkjMuHssfN2bX304TrCjtALh2
X-Google-Smtp-Source: APXvYqyflOfL35udfu0aBxg+ZTDGNV/apfz6OWt8OI/GcHH2YHG9fa1pWrwPmJ3cf2kVXef4FuTQug==
X-Received: by 2002:adf:df0f:: with SMTP id y15mr5738077wrl.26.1581713344463;
        Fri, 14 Feb 2020 12:49:04 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:49:04 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TIPC NETWORK LAYER),
        tipc-discussion@lists.sourceforge.net (open list:TIPC NETWORK LAYER)
Subject: [PATCH 28/30] tipc: Add missing annotation for tipc_node_write_unlock()
Date:   Fri, 14 Feb 2020 20:47:39 +0000
Message-Id: <20200214204741.94112-29-jbi.octave@gmail.com>
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

Sparse reports a warning at tipc_node_write_unlock()

warning: context imbalance in tipc_node_write_unlock
	 - unexpected unlock

The root cause is the missing annotation at tipc_node_write_unlock()
Add the missing __releases(&n->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index cc656b2205db..c3b810427d24 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -372,7 +372,7 @@ static void tipc_node_write_unlock_fast(struct tipc_node *n)
 	write_unlock_bh(&n->lock);
 }
 
-static void tipc_node_write_unlock(struct tipc_node *n)
+static void tipc_node_write_unlock(struct tipc_node *n) __releases(&n->lock)
 {
 	struct net *net = n->net;
 	u32 addr = 0;
-- 
2.24.1

