Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E310C33D89B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbhCPQEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbhCPQEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:04:00 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E52C061756;
        Tue, 16 Mar 2021 09:03:59 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id h82so37301263ybc.13;
        Tue, 16 Mar 2021 09:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Eb3f9srlDI2VcuULDiWkd0m19KK5oNQdlsBenMZcFLU=;
        b=WPBq9+TXEj/8fgXJKt7ODrfYJJ1oT3L+ZPkH73qlfDqlZIVOhuMpsRntqUiU8GC0/F
         jIV/EGtXVdKy4ryylvW8XpAFgy44QV8OA2y26M+1SmUC3jHv67AiarqWOcelPQfuuJQF
         dNpswLbglMg8worqTrXwWiay4Rqcop1MfS94z+7bKTLDfn/hQl0C4vYYm4YchMvnHiyj
         0rt38uTlQ66uVT+vTFGnfyiKKdr9nx+TMFx/w0swGaAZoWV47TzRRxP2pS6fmeLjH6D3
         U5+uUA8669a0pzrrrymYwz7QWu0H1R/D3dcZvwlP10Gx1/EbJnxa34kk62LLgA4i+mXZ
         6w+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Eb3f9srlDI2VcuULDiWkd0m19KK5oNQdlsBenMZcFLU=;
        b=ndhhqkf2sBVmob6TNYuRtMwZuTQHHfXvkp8SCVsaoW2IkHEFJJM5i4LWkwxcFbVQ1h
         qwUvJbNEdunps63oyLpGJTbEsJogSrUqkr3eepoRQ2zNpTT51gbT+AR8hYuXhDnUGfxB
         +iVkymIIYvKs674Sbce6FoC/TO5D7a1lSA81nOx9cs0u68aaO5Mkv1VLaNvbT/LAhUdE
         Wqw1DIxdzMVyhJrzy12hOKQRSjYQ3gLNY6G/HvR5LpYIcQgO9LFGnABxIFBqkKeAtMUz
         gOtH0tdme9WsL38V0EA8tgUyDOAtA7TkGh9Zwr8QHRxee+KxmK5hw7J441UVrLz45Alf
         J6Qg==
X-Gm-Message-State: AOAM531jE6VkMiZax8G9SR+klsH6r1MwGSALAdm5EqTcYPViXwj0BA9h
        xc8+/qeOxAenE0ij2kYoCPtuPYzT/gAgna6db5M=
X-Google-Smtp-Source: ABdhPJwhghx70/1G1sN3etH6MTmrLHPupKm1udTFy7KNAaohap8VxLDg3UGi5ah9Ig0OUowYjKoz48x7JkevdpckTyw=
X-Received: by 2002:a25:ca46:: with SMTP id a67mr7581987ybg.166.1615910636450;
 Tue, 16 Mar 2021 09:03:56 -0700 (PDT)
MIME-Version: 1.0
From:   Anish Udupa <udupa.anish@gmail.com>
Date:   Tue, 16 Mar 2021 21:33:45 +0530
Message-ID: <CAPDGunNf5KZjsZVA6BDvt8Nbg_LhbDM_pS9DvjsMQtbqh+Kc-g@mail.gmail.com>
Subject: [PATCH] net: ipv6: Fixed some styling issues.
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ran checkpatch and found some warnings. Fixed some of them in this patch.
a) Added a new line after declarations.
b) Added * before each line in a multi-line comment and made sure that
they are aligned properly.

Signed-off-by: Anish Udupa H <udupa.anish@gmail.com>
---
 net/ipv6/icmp.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index fd1f896115c1..57ba852c0944 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -155,6 +155,7 @@ static bool is_ineligible(const struct sk_buff *skb)
  return false;
  if (nexthdr == IPPROTO_ICMPV6) {
  u8 _type, *tp;
+
  tp = skb_header_pointer(skb,
  ptr+offsetof(struct icmp6hdr, icmp6_type),
  sizeof(_type), &_type);
@@ -835,10 +836,10 @@ void icmpv6_notify(struct sk_buff *skb, u8 type,
u8 code, __be32 info)
  goto out;

  /* BUGGG_FUTURE: we should try to parse exthdrs in this packet.
-    Without this we will not able f.e. to make source routed
-    pmtu discovery.
-    Corresponding argument (opt) to notifiers is already added.
-    --ANK (980726)
+ * Without this we will not able f.e. to make source routed
+ * pmtu discovery.
+ * Corresponding argument (opt) to notifiers is already added.
+ * --ANK (980726)
  */

  ipprot = rcu_dereference(inet6_protos[nexthdr]);
@@ -918,9 +919,9 @@ static int icmpv6_rcv(struct sk_buff *skb)

  case ICMPV6_PKT_TOOBIG:
  /* BUGGG_FUTURE: if packet contains rthdr, we cannot update
-    standard destination cache. Seems, only "advanced"
-    destination cache will allow to solve this problem
-    --ANK (980726)
+ * standard destination cache. Seems, only "advanced"
+ * destination cache will allow to solve this problem
+ * --ANK (980726)
  */
  if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
  goto discard_it;
-- 
2.17.1
