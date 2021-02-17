Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C7831D901
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhBQMCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:02:09 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:20567 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhBQMBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:01:48 -0500
Date:   Wed, 17 Feb 2021 12:00:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613563264; bh=f5a51AJWUIP1+g9AKjCCLIkq+KzMf7BABzoVckGuAUU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=f0NFekYpkvZVy3mI4UEYe7UqpDTEFJfKN5BnZhxYMH631ecg9GONcBNuGk5EGj4KP
         vPbdBYfbRqVlxTmaNr/pfwLeYcWUAdgMCpzSnJotGyq9yOFu66bmhsjlEDsAb2JpGw
         Dp4lYik/+6sdAxP93kxdqwF8pwaifimb+rwC/sV0FXfAVmK+MGg5XFXIyjjGcmH3Mg
         wFpoRnw6BsWAsamRR3x5VzMZRgZBKOjSuWeNJg99guRgIESWz0oxchIl6o3yrjVZII
         QB0cBLFgmdRkHaBdqHhxFDDB7/5r5lZ+DdDL6CPNoTjxNjpqNRqkxyQsK9zme81u9N
         RODymtlcXBNRg==
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
Subject: [PATCH v7 bpf-next 1/6] netdev_priv_flags: add missing IFF_PHONY_HEADROOM self-definition
Message-ID: <20210217120003.7938-2-alobakin@pm.me>
In-Reply-To: <20210217120003.7938-1-alobakin@pm.me>
References: <20210217120003.7938-1-alobakin@pm.me>
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

This is harmless for now, but comes fatal for the subsequent patch.

Fixes: 871b642adebe3 ("netdev: introduce ndo_set_rx_headroom")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
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
--=20
2.30.1


