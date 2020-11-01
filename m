Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0FF2A1F55
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 16:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgKAP6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 10:58:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726499AbgKAP6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 10:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604246309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=uGnDR6G7/vPpNC+qZpU8vljrteTG7L+Sb38lV82f6o8=;
        b=H7/1gSeSfJksKesnpUxIwoVWoWLHVqzllOxYHyGiD1042KDI/9C94N/bF1r9iGlJoTVIo4
        8Vv44I8Uia2Nw9exckqx+I/YCtYh8RnW71lLGStNNq9+i30fMf3YNbruqnyp5oa/kTiG+X
        hnu3rKJs3fQStyEL2JHkpUASYX5XH4A=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-XHYt9XDJP0CEFUUBR9vwKw-1; Sun, 01 Nov 2020 10:58:27 -0500
X-MC-Unique: XHYt9XDJP0CEFUUBR9vwKw-1
Received: by mail-ot1-f71.google.com with SMTP id x18so5221128otp.5
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 07:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uGnDR6G7/vPpNC+qZpU8vljrteTG7L+Sb38lV82f6o8=;
        b=BCCtyH8XxUfxXxoqH9Z8EOU8aP5N5JU680JYSzRe3wHUBXm7QYTP0rSK/8Ue4q2vXO
         IPaMcuhulCIh9+xnWgVBN1aFtB1f083pqmR+gHHQAqQtYani92+fqYYJsRkzt54Js/Ld
         CvfTENfK1BWvZPevCtizl28gboZDiUVANFoHDv9VEcZkkFEBQy6ZCA3SgUCtofTmHFdk
         2GsD5LQt/lm+n9zVNc31gKyoQeyFDiJRWRTYoqNo2XjrhSUpJk5E7A9cdJc8bQ0mRd+c
         BzM8n4YCjQs6/Kl7GA0SfNBO1fUGMwtqgKHg+I0+UJjL+qLDQPNFwfHaMgPZIqzC0GGG
         ji2w==
X-Gm-Message-State: AOAM5322vAw4ZUdRluZ7d+rgtEsz62PW+SlgSz+01/O2HyYjOQFJlFcf
        aMd87Az8W1xNTL6or17ofr8x8A9yKoJZclwCnM7UixKZloeo/YaeIW7I7GlrUlZEnmQxiW/79AF
        xCOzrVhNsq1i8g01n
X-Received: by 2002:aca:5285:: with SMTP id g127mr7816629oib.88.1604246307072;
        Sun, 01 Nov 2020 07:58:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0OCbtyASaS0yijWJrsajMPLt1AD4+e8hVYb2K8mGI3EvQYc9N7aiAjDy5zRjHAF0JoHA9vg==
X-Received: by 2002:aca:5285:: with SMTP id g127mr7816623oib.88.1604246306930;
        Sun, 01 Nov 2020 07:58:26 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id y8sm2821515oon.16.2020.11.01.07.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 07:58:26 -0800 (PST)
From:   trix@redhat.com
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] tipc: remove unneeded semicolon
Date:   Sun,  1 Nov 2020 07:58:22 -0800
Message-Id: <20201101155822.2294856-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/tipc/link.c | 2 +-
 net/tipc/node.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 06b880da2a8e..97b1c6bd45dc 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1260,7 +1260,7 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 		pr_warn("Dropping received illegal msg type\n");
 		kfree_skb(skb);
 		return true;
-	};
+	}
 }
 
 /* tipc_link_input - process packet that has passed link protocol check
diff --git a/net/tipc/node.c b/net/tipc/node.c
index d269ebe382e1..cd67b7d5169f 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1638,7 +1638,7 @@ static void tipc_lxc_xmit(struct net *peer_net, struct sk_buff_head *list)
 		return;
 	default:
 		return;
-	};
+	}
 }
 
 /**
-- 
2.18.1

