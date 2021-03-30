Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCCE34DDBF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhC3Bp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhC3Bpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:45:47 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E05C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:46 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so14106988oty.12
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VU6AMZvMiBod9NnjpFXnQk4+eSiYkzMttOpXSSUp+CA=;
        b=c8eqvbvk0SXepV4PWKVqopkXbE9nIEa4WR3T3fs4z1bdRGFCkoSs+c3NOSptwqsBi2
         8iLzYzvuwVp1Euui4QG66mIrtXlIkq8FnYIJ69Ar76k+6XSZmAKNj8y64P1DylJ62bNm
         Q9WyJ57cA1yZ/dltCHfsneipn+NP5cjdtwoBCHzr9e0hI02NB0D9KLobmLwlhFGzrtZo
         +T6S0p7T59ndVhJucINsbxDWoEyVd4fsh/M055VrQFv66cMZS8LLWPH5FZI1L9ixbs+9
         kqHMFaQgPSrRQ9Ep7+C/xSvWsOIWJrLH648nNiP6LgdaY4EUp3M5KlpSw/1AGjzwXC27
         kwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VU6AMZvMiBod9NnjpFXnQk4+eSiYkzMttOpXSSUp+CA=;
        b=ru7npRuBWi4bLUEAvPBaH4jJV/WS9CGDIeXL+0tZImVwpYWOyoF+R4cm2TFygw+X2A
         O7uD9mUS6i18+HPcqpP26JFYWeyZNBij8ahfSCJ8q6zPE79v8c+c1va//SEDtzj5EwPa
         dF681miKjvwMKkd0HM5KG2olGRlQkEgp+LIRLwcKd5iIm4Q+8253dZSMBoBGs2yGn8p8
         HeIzs00VZYcn97Zp7eNobPqD0chrRtA61TetgVfg1duMqHbD/vZC0TfhU7ixmcVfmd70
         8kKRI5QefIRM9Uoj+WCZWjYkk0ybjDAJUV7TGMJSzp/GBK2XhgtSH5g0gw42qo3t4rgX
         veTg==
X-Gm-Message-State: AOAM531j1CX2FJ8BfzyzV+3wULhDxer8LOu+XaFl/xBGlqDQSJidWjE1
        eIG7mialtOEXhs217J/FIxr+x3MBHjs=
X-Google-Smtp-Source: ABdhPJzcG2iqHi3Ik9DHkHM1XZGbI9IYBlJFQN8/xJaL8rOZPRwk27OAdiuaHiaFKnrCOIvEawymiw==
X-Received: by 2002:a9d:5e94:: with SMTP id f20mr18241192otl.150.1617068746273;
        Mon, 29 Mar 2021 18:45:46 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:35b:834f:7126:8db])
        by smtp.googlemail.com with ESMTPSA id i3sm4064297oov.2.2021.03.29.18.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:45:46 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V6 5/6] ipv6: add ipv6_dev_find to stubs
Date:   Mon, 29 Mar 2021 18:45:43 -0700
Message-Id: <aa665807b1ab756c1db62a038fa42b6503e2e308.1617067968.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
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
index a36626afbc02..1d4054bb345b 100644
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
index 3c9bacffc9c3..4f7ca5807046 100644
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

