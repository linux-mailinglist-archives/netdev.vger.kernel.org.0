Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA6415F81D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389654AbgBNUtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:49:49 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34073 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388892AbgBNUtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:49:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id s144so2845081wme.1;
        Fri, 14 Feb 2020 12:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GCRH+QSVscHEtOqyJbkVwS2XTrXy464tV8myRNcAShs=;
        b=Ay8hOWvCaf/jjwOzQL4nq3SxxQqmuZYQX8aqs71KDQfmrlnHqCU4FTeYtgzsW3T5D3
         QJ+59vMkLvAC487GmN798HbJ3thFXm0t9Wc6pAAgd/CZ9F/J+ownXtBvdR+fEJFgcW40
         bJr91ikng2vo7ZAmr43HAbSNb5GOTZ6yuJ0Su2g8ukACKa5nWCuA9ap0YWm5BijuqqWY
         XgR91YELX1wXHX71irhswQcsP1EyzId/VMwURtVpNFgcieo/BY4hxV9Lnlh0SQRrq56/
         sIa5uqSrooQ6DY7RTFwd3DL6JC8x+Sb2SRYr8U9o/+BrbJPAtR8O4mpjfhHazWL8pjam
         2ReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GCRH+QSVscHEtOqyJbkVwS2XTrXy464tV8myRNcAShs=;
        b=cBAkuhYHBNwQleLUfve/XniysjH/b7Hh1yEW35SwTVA2C/9PFUiEIYgjpZC1qfWSyd
         Ds0w4CaGpBJbWQZfnlUxMY/lEJkagEciTxT2HpS1kXpyP8ylcptByD/cwiXwQX+epqAm
         s/iR6mm/f2/Vjc9F9WUk+GKbcMFAVsCORBsPM4g84rCEeaMoz6eDFLkHHcNyPhO3Txpa
         ibJYbsPmXsq48fqnSuPW0i8HIqV8oc96ax3uEIdcTlSvdxOWkDio12jyJ5PrgeWWvEIX
         CKrvaZiHjghFTzJV+iwkL/oBGCCwR6D1Nxpiknpn63S168w6TTRHzabm0CkRA2P6b/sK
         qBuw==
X-Gm-Message-State: APjAAAVy3ggdapEl8EV+RASxOddAyG6eRRQlsrlhJErsFPGTwRuMLGcB
        tf2/3n6IymfVYQOYpUv5d+bv9reKmDeI
X-Google-Smtp-Source: APXvYqwTxeuGXC7F27jC1xbbu0tmh8GGXdsK27UP9jCeJm5RiluBDSW2gTi2k1Vk8Z86EPg58UDpbA==
X-Received: by 2002:a7b:c088:: with SMTP id r8mr6522805wmh.18.1581713342352;
        Fri, 14 Feb 2020 12:49:02 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:49:01 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TIPC NETWORK LAYER),
        tipc-discussion@lists.sourceforge.net (open list:TIPC NETWORK LAYER)
Subject: [PATCH 26/30] tipc: Add missing annotation for tipc_node_write_lock()
Date:   Fri, 14 Feb 2020 20:47:37 +0000
Message-Id: <20200214204741.94112-27-jbi.octave@gmail.com>
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

Sparse reports a warning at tipc_node_write_lock()

warning: context imbalance in  tipc_node_write_lock - wrong count at exit

The root cause is the missing annotation at tipc_node_write_lock()
Add the missing __acquires(&n->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index eafa38896e3a..d8401789fa23 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -361,7 +361,7 @@ static void tipc_node_read_unlock(struct tipc_node *n) __releases(&n->lock)
 	read_unlock_bh(&n->lock);
 }
 
-static void tipc_node_write_lock(struct tipc_node *n)
+static void tipc_node_write_lock(struct tipc_node *n) __acquires(&n->lock)
 {
 	write_lock_bh(&n->lock);
 }
-- 
2.24.1

