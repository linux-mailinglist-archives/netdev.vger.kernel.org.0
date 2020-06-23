Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E5B206776
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388498AbgFWWrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388348AbgFWWr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:47:28 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1A7C061797
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:21 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id n10so314846qvp.17
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JXjmqcPdDbbV+2JN9dMNcfWrSWf2OWX382UapR2lx2U=;
        b=lVwaGH/YWXrPZVddAFrjOQOxP2Z9jDvUQJmpCgtwM+8V59LJNBeKxBwp6dvo1la7/L
         4JwjskKv+3cAhEX+jHeQH4wstPmjq3cLud9LmLZjGBBt+HxSzyPQepC4PjagwNuhLFrW
         EpbWPuxxQsTo00phgu7Jv+qD7WKLoOPy3yuoHATComeFvnOay0yJ+5wUQZ3oklCT4k7T
         6qzV+gr9KVe3pYQvTqG80FD760GT38cnjnpFx0CsQ4VmQ7jw8jl6bseIrJlD8tDokAUs
         lL15qymJz05t3rdU/M51rIngtpYz9tX78aP4jEPdx2YaNP3n6/1g3ixQgQiJRZeLRpqc
         UAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JXjmqcPdDbbV+2JN9dMNcfWrSWf2OWX382UapR2lx2U=;
        b=MTMXyfA07NUWfNyGBPoksiR5C5V5b0GFFyJUC+7QY1XcIIhGkVS16i7fe+49oUiiWi
         E54/IeCRbUpPA6e0sXYXGzYEHlLvKVAiTE6USGfv4DLAIOoIhX49fOrgMC+9UjFcqLaS
         eVGyUB5egrimxiR0S8gmAbl6vxsYJ/IZdFzMH6JWlYq2Opm6rA9qF8iN7yhMLAEt5jWr
         fB4keNa5FpqbUViKrEGaJxXFxJyGNW8qC1SeiNqCtgNtB/Ea41xZZvi1Iz7L5eY7ym0T
         oa0NkFwASMyIw5iJODjzC4J82xqLutwcdWjqTjLImBRT8b/BI/o564+1rkM6JEoKk+j2
         8vXg==
X-Gm-Message-State: AOAM533+hz1kJQRO4x6dhklo7xdZnbyrYtRz9jhI5olmxHYXRXebtR3/
        HurMeg1UtoCOQY2waHkjP90b7NtcGxoX5A==
X-Google-Smtp-Source: ABdhPJz/Gd/x4kXr+3tInfYIjfXoV7hzpJW7QdDJg4NG6dzW1puVxog2ihrj8XLK9WHsmvcNjtq3owty/7oufw==
X-Received: by 2002:a0c:fe01:: with SMTP id x1mr17359qvr.246.1592951480559;
 Tue, 23 Jun 2020 15:31:20 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:31:11 -0700
In-Reply-To: <20200623223115.152832-1-edumazet@google.com>
Message-Id: <20200623223115.152832-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200623223115.152832-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 1/5] tcp: add declarations to avoid warnings
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove these errors:

net/ipv6/tcp_ipv6.c:1550:29: warning: symbol 'tcp_v6_rcv' was not declared. Should it be static?
net/ipv6/tcp_ipv6.c:1770:30: warning: symbol 'tcp_v6_early_demux' was not declared. Should it be static?

net/ipv6/tcp_ipv6.c:1550:29: warning: no previous prototype for 'tcp_v6_rcv' [-Wmissing-prototypes]
 1550 | INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
      |                             ^~~~~~~~~~
net/ipv6/tcp_ipv6.c:1770:30: warning: no previous prototype for 'tcp_v6_early_demux' [-Wmissing-prototypes]
 1770 | INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
      |                              ^~~~~~~~~~~~~~~~~~

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index cd9cc348dbf9c62efa30d909f23a0ed1b39e4492..a8c36fa886a48bb3a242d0360a581b2aba49756b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -934,6 +934,8 @@ static inline int tcp_v6_sdif(const struct sk_buff *skb)
 }
 
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb));
+INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *skb));
+INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *skb));
 
 #endif
 
-- 
2.27.0.111.gc72c7da667-goog

