Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5933031F158
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhBRUvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:51:04 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:10550 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBRUuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 15:50:39 -0500
Date:   Thu, 18 Feb 2021 20:49:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613681385; bh=qd8YH/ZJZyXiTeuWuSjWkQwVFPKKu5hK9PwUOTkC+Yg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=JLd3BFFqmqlK5YvYKyOBF0u66U0ZD/xadJkOEHNpUEcbgUfxmp7gc7rH2wVptKKzH
         5aAoeIWMLst6Eeg638jiyGQcFw6P+QJQ2188JLLvojAQDeruvMiu1FsPOdpSNOsklH
         a4Z/nZ4MHwJVZ4JrFN3dJGHKz/cja7BJBHYdA6apqn9TUPgj9D46DGUdeim587GmQV
         q0wLuDEH+RswdJ8Ue8XqJEekiKzIP7g6aN1Ma+HwihRRnZiCXNxuSCV7c4TrnJ8QeF
         wdIvLq1Xc9aLxYMe+vMXzvdGKBr/I/pzGJHEIXzRwNnftx/MK+Lo2AZalHxHQLhzT5
         UAG3ILzYOqrlg==
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v8 bpf-next 1/5] netdevice: add missing IFF_PHONY_HEADROOM self-definition
Message-ID: <20210218204908.5455-2-alobakin@pm.me>
In-Reply-To: <20210218204908.5455-1-alobakin@pm.me>
References: <20210218204908.5455-1-alobakin@pm.me>
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

This is harmless for now, but can be fatal for future refactors.

Fixes: 871b642adebe3 ("netdev: introduce ndo_set_rx_headroom")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..3b6f82c2c271 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1577,6 +1577,7 @@ enum netdev_priv_flags {
 #define IFF_L3MDEV_SLAVE=09=09IFF_L3MDEV_SLAVE
 #define IFF_TEAM=09=09=09IFF_TEAM
 #define IFF_RXFH_CONFIGURED=09=09IFF_RXFH_CONFIGURED
+#define IFF_PHONY_HEADROOM=09=09IFF_PHONY_HEADROOM
 #define IFF_MACSEC=09=09=09IFF_MACSEC
 #define IFF_NO_RX_HANDLER=09=09IFF_NO_RX_HANDLER
 #define IFF_FAILOVER=09=09=09IFF_FAILOVER
--
2.30.1


