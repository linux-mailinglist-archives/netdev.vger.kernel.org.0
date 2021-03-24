Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24B348045
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhCXSSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbhCXSST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:18:19 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44E6C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:17 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so23901864ota.9
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jsFMOnHTaYqx7LeUFb/5lV47lLjS2I+zclun6rcpJ+Y=;
        b=gTw8KTPi/aBDaFC8XKZMZ8enrhuJykPcqryaOyH1jSWxn6oas8gNXV+hB7C1gh7v1j
         79LCPxERE/QzLEPc7R5OOIHcEG3y/7G6gPRVTnMTzUKc0ufMMzHX9Pt2TOUlXb9KZOwg
         AABz7DuT0Myk7X139svwcKl5fqt9rpsHx3LF4mNoctOriYki8rS+6sC+LWbvpJ7I4QJF
         4CF7wY/adGy+qyEdSaJCqk2eo4bHQitTczuIKy/sj8sptQm3gDh9fkiOtvbOttKTad9m
         TKrwzAJsyT+AQeGYTB7eiZnCK9gUHPCfUbULR6EhpaChu0a3KV/u9iCdKs8VI8C+w3uL
         zfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jsFMOnHTaYqx7LeUFb/5lV47lLjS2I+zclun6rcpJ+Y=;
        b=FnCpYNwJ+eoduScnp40c9Pga+KF/j5JamjfDjbOQPT3Bfjy4cca0mFnFGbR03ZYM9+
         5eF5KpZ+lDarAjHgdu6PRr1kyZgvkfUJzZDDzey8KB+EiybUgmt+M517Hva3Kvse8Ah5
         z2sECnbBxeqqtUFNZ6r95AEAjAVvw4iCkFwQ1l2D18I9765sSKgXOoDsJqzjygp/FvHM
         Nb2t+hpu0ru+Ip7Ktq0qD2cLFnda2uVUNN55cLi8uBsflqcphVm9v4Q4WXaucOiTm6LR
         LRG1Lh7OJGf7+OaQ9ye/5WXZa59lkw5wSBAvh5rBrbjSXkhYyR7OHlHscwf1pGgAOOHj
         g7Gw==
X-Gm-Message-State: AOAM530ArZN9SWRgXdeNeJpLmqzvsxd9FyIRoiR9DCLaoWa1Zr/wTtKC
        SszhbcTqKJbsIgs/5luTrCRC2ZRzi3Q=
X-Google-Smtp-Source: ABdhPJxNRiaqEPHZ4446iO97Ka0Afrb8K1VYjZOcgU5QnSS3Yv3XH+42ZG3Zc+0/Jz84BHDLpEfDsQ==
X-Received: by 2002:a9d:37b4:: with SMTP id x49mr4122422otb.237.1616609897070;
        Wed, 24 Mar 2021 11:18:17 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:abb9:79f4:f528:e200])
        by smtp.googlemail.com with ESMTPSA id h59sm707942otb.29.2021.03.24.11.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 11:18:16 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V5 5/6] ipv6: add ipv6_dev_find to stubs
Date:   Wed, 24 Mar 2021 11:18:14 -0700
Message-Id: <2d1a2ac63ae19879557526a1ca5dc37a04d1a076.1616608328.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ipv6_dev_find to ipv6_stub to allow lookup of net_devices by IPV6
address in net/ipv4/icmp.c.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/net/ipv6_stubs.h | 2 ++
 net/ipv6/addrconf_core.c | 7 +++++++
 net/ipv6/af_inet6.c      | 1 +
 3 files changed, 10 insertions(+)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 8fce558b5fea..afbce90c4480 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -66,6 +66,8 @@ struct ipv6_stub {
 
 	int (*ipv6_fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
 			     int (*output)(struct net *, struct sock *, struct sk_buff *));
+	struct net_device *(*ipv6_dev_find)(struct net *net, const struct in6_addr *addr,
+					    struct net_device *dev);
 };
 extern const struct ipv6_stub *ipv6_stub __read_mostly;
 
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index c70c192bc91b..8f0b6024eba8 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -198,6 +198,12 @@ static int eafnosupport_ipv6_fragment(struct net *net, struct sock *sk, struct s
 	return -EAFNOSUPPORT;
 }
 
+static struct net_device *eafnosupport_ipv6_dev_find(struct net *net, const struct in6_addr *addr,
+						     struct net_device *dev)
+{
+	return ERR_PTR(-EAFNOSUPPORT);
+}
+
 const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
 	.ipv6_dst_lookup_flow = eafnosupport_ipv6_dst_lookup_flow,
 	.ipv6_route_input  = eafnosupport_ipv6_route_input,
@@ -209,6 +215,7 @@ const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
 	.fib6_nh_init	   = eafnosupport_fib6_nh_init,
 	.ip6_del_rt	   = eafnosupport_ip6_del_rt,
 	.ipv6_fragment	   = eafnosupport_ipv6_fragment,
+	.ipv6_dev_find     = eafnosupport_ipv6_dev_find,
 };
 EXPORT_SYMBOL_GPL(ipv6_stub);
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 802f5111805a..f0b860aecc2f 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1032,6 +1032,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 #endif
 	.nd_tbl	= &nd_tbl,
 	.ipv6_fragment = ip6_fragment,
+	.ipv6_dev_find = ipv6_dev_find,
 };
 
 static const struct ipv6_bpf_stub ipv6_bpf_stub_impl = {
-- 
2.17.1

