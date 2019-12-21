Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E6D1286BC
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 04:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfLUDVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 22:21:23 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34335 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfLUDVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 22:21:23 -0500
Received: by mail-pj1-f68.google.com with SMTP id s94so4476174pjc.1
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 19:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=f5oa8u80m09fA+W5dUO9DYzR/TIh/7dMBBTH98+gLslroANsa8qxCAHCqbgEiCI+S6
         0yPF5vnjAHjo+p+ncQNHVmGIOtPkSqJITmrtj7A8FnQ9nuhR6DPbob479+hqZ5AW1J94
         WvnYcqQBkOyRqNfQMjoWpin07CDRHAYH3+88stP+K+RG1G7ttK8caBQ0KuNoSQZmrcpq
         B1gtjezC7mT/xEz0iLug7mBaAqN3C6ivqJluwqwI2M6CU8SwmhA4CtCJHCIaaIlUGauf
         8/EmoVCISDaS2i0ZOeo2FALkPrXJDOaI648PSRhvlo22vr5bO6iH0Zi7iiXqn8VWWZuv
         5D5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=b3hiJ3A3rMjBROFjEn7dlrVf4haGfG2YX4vYzJvUu0g=;
        b=XfycsWTdzUsdJaP7XI/+nLXp2QdFOpIbRb7h/fvbDdBMbJFt6bdsiOp/SrobDMUt7m
         mYY7+YifiCtbfM74T2XdROezljAGLrfQe/Kf9yu9Z95jDQIlfdoD3PgXi9BlrBC2t0bw
         81nOZK05eb2oQ9xCOjVPKbPvwGBNRcJ4prsvTC6sp5Jewjt8bEKXOlKATn8Ad7xC5toZ
         fnB6tOC2LLXDKOCfJ/hfpLTqjWK0YV95bA5CDFSlIN1/cjErYdhnkpTErVPADiPF9b1L
         9rBqUPJk3F8iTWxU3/bAjoDWCJfie0luWkm1IDk+SBcXa6bd+mniinmMUEWZA+6qn51B
         AmfA==
X-Gm-Message-State: APjAAAW3tz9b33ny15VdwZy+9Fscs+R5Wwh+Sub9rjeN3Lt22ERFTHbC
        snLYPSdYHh9VaRzs7uxb20+/+mDQ
X-Google-Smtp-Source: APXvYqwxtnN8wHU9ZNATg0HmJdEROyGG/T9PC7q6+sVMAYxCi0NJ4YtPhfPxMuZ2AXKedrd9Ba7XwA==
X-Received: by 2002:a17:90a:1a0d:: with SMTP id 13mr817793pjk.129.1576898482471;
        Fri, 20 Dec 2019 19:21:22 -0800 (PST)
Received: from localhost.localdomain ([42.109.147.248])
        by smtp.gmail.com with ESMTPSA id g9sm15080287pfm.150.2019.12.20.19.21.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 19:21:22 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v5 2/3] net: Rephrased comments section of skb_mpls_pop()
Date:   Sat, 21 Dec 2019 08:50:23 +0530
Message-Id: <a934a03a66b3672acb09222055fe283991f93787.1576896417.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576896417.git.martin.varghese@nokia.com>
References: <cover.1576896417.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Rephrased comments section of skb_mpls_pop() to align it with
comments section of skb_mpls_push().

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d90c827..44b0894 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5533,7 +5533,7 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
  * @mac_len: length of the MAC header
- * @ethernet: flag to indicate if ethernet header is present in packet
+ * @ethernet: flag to indicate if the packet is ethernet
  *
  * Expects skb->data at mac header.
  *
-- 
1.8.3.1

