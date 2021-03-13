Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE18339DE6
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhCMLiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:38:13 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:23022 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhCMLhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:37:55 -0500
Date:   Sat, 13 Mar 2021 11:37:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615635473; bh=X3TuYcTaZPUU1Xz+TlNF44PidtjG5KU7YmET3XhmCM4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=GMkKBKUL5sdRSCcdE5yTTwl3wc/URe7EyK0nCJdNTfq8NW+VhaTWC1FcUOvK4VDFD
         oD9pYAal690ZA+vcyjSI5mWe3M72FIQrn2J4YbRAJPVQEeOJ0NmR2hlz3wP21cxz2H
         Pwxz8UwVg7wZTurXhzqZazcn2sxgS5UkTIR0nm1t+rJCmPg2vcMAJnorTykljBl9KN
         FMfdr+tqGbDQLDVA83nOGZuX6YCioD8JNZ87Hi8LMrZIZLPDhR0Z366bYbXMovmk74
         oNpc+Gm6CBdNPJJ1A8f+ODadXIVJn9YlRVhBvHEKtZCWfa2s8q5dv5tGw/iL9ZU2jY
         B6yUCH+29kWfw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 4/6] linux/etherdevice.h: misc trailing whitespace cleanup
Message-ID: <20210313113645.5949-5-alobakin@pm.me>
In-Reply-To: <20210313113645.5949-1-alobakin@pm.me>
References: <20210313113645.5949-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Caught by the text editor. Fix it separately from the actual changes.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/etherdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 2e5debc0373c..bcb2f81baafb 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -11,7 +11,7 @@
  * Authors:=09Ross Biro
  *=09=09Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *
- *=09=09Relocated to include/linux where it belongs by Alan Cox
+ *=09=09Relocated to include/linux where it belongs by Alan Cox
  *=09=09=09=09=09=09=09<gw4pts@gw4pts.ampr.org>
  */
 #ifndef _LINUX_ETHERDEVICE_H
--
2.30.2


