Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356C72C6A48
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgK0Q5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:57:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41276 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730324AbgK0Q5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 11:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606496261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=h1nOL9wj/tWhRU30VsP8qRNUyfiW/X3b6h6qswQWTtc=;
        b=LcV4UafGe15OUiS3aSyylZqA6OFW45iNE/J6Jm4JP8eksrYjpjhmbv7aYBVF/JVs28jUjx
        GNYWNlwYhHdUtN1NY0qGeg+Gnq9vV8L68a40l/CULcz5uKqeGCqbCbJFJzsCMKGU2QSDuX
        8Mo9Lakbb0LH9heycRS96C3K0jBH9fk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-rYVJ9fmdM5GWNUcmzlTE0Q-1; Fri, 27 Nov 2020 11:57:39 -0500
X-MC-Unique: rYVJ9fmdM5GWNUcmzlTE0Q-1
Received: by mail-qt1-f198.google.com with SMTP id i14so3555812qtq.18
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 08:57:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h1nOL9wj/tWhRU30VsP8qRNUyfiW/X3b6h6qswQWTtc=;
        b=l4SNfT2f3M6avfFF8GP9TBTlwLdxcL5N7k/HeJYOrEKb/OnvAzp3RPeFw14kNZExp5
         P3UAvq/j6bpB9IZSdQ+Grip8LZH7stwC1+QXCBSRSUE0P0eFH+uwCxC6BlWhm1Is/YYL
         fKxrP3dqSTnYVs0HPXQ59LSsZxspnDn702NEgMmq/At/UU5I3JgPLv8UvJxzyIiX2hhL
         kPKN1TDOV5Fix4ncrZ8yvltrGfReBZIs61AP6Qc0cU9opGsSMZUqiNWKmQwRMtbloXhM
         8u1N0wBNSZPKPQckzkddBJsDdAiMTJCQ+S9+OXf0YcavwL8i8rA1NkNjoTNpMLvDfCLQ
         ag6A==
X-Gm-Message-State: AOAM532u5dtJRkbuiQpP8dJ6VAOvcyv69qi6Ild15k1fxIEUpoWkLokW
        7mSa3YZc0vV87TGBmk4zVtOqgdvAcWJlNq4RLDyGbIysBW+jH3qMCWA8dbaFVNg3+OtFOL0tJ8n
        ieDX6vvgB7uLz6W8W
X-Received: by 2002:aed:3383:: with SMTP id v3mr8993403qtd.353.1606496259517;
        Fri, 27 Nov 2020 08:57:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKC91x7lxDI/bGHUwc6jbF/Sfjr2ZzeiAdBNQmS42sXzMDpxbhFKyXkdMO4M7PzyiNslBnkA==
X-Received: by 2002:aed:3383:: with SMTP id v3mr8993391qtd.353.1606496259350;
        Fri, 27 Nov 2020 08:57:39 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id e4sm7323542qtc.54.2020.11.27.08.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:57:38 -0800 (PST)
From:   trix@redhat.com
To:     khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: wan: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 08:57:34 -0800
Message-Id: <20201127165734.2694693-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wan/pci200syn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index d0062224b216..ba5cc0c53833 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -92,7 +92,7 @@ typedef struct card_s {
 
 
 #define get_port(card, port)	     (&card->ports[port])
-#define sca_flush(card)		     (sca_in(IER0, card));
+#define sca_flush(card)		     (sca_in(IER0, card))
 
 static inline void new_memcpy_toio(char __iomem *dest, char *src, int length)
 {
-- 
2.18.4

