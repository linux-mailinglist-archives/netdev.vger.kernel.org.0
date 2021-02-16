Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A659B31CC0B
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhBPOfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:35:12 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:55821 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhBPOex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 09:34:53 -0500
Date:   Tue, 16 Feb 2021 14:34:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613486050; bh=lYDCa6iLqFT+6be7jVyPBd42LZlNQ5lJltfvJUcfGWA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=GKBYwAoLlfpGLfTCo0twTluBuP3DI2gbTrilQvDFjOv16JAno+bxYQ4NAV1Y7JUF8
         c/K3uIhRwqOb7dD6HMQpWl56GWfagGV16ifMXY6CtNtyXeDMuvEHxyjOIkGouILrb7
         khMABDkJUrxc7isbmT0AfbvGbE/btW4uNArWaRu43JpLPaw39/fo0FoOlwj0dKQSan
         Lk3WNWG4CJJJLHKGhwnet3g3bty9/ZET++PLuVY6BW4mDXbfTYHp683UohjPXGLf9g
         uYTF91pOY60vtVpKSs9WYmC7m53Z9A+oG6TjqqGSln3IGPOT1QvGmLIyXNuAOYZdEq
         J+PBIDGRqezKw==
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: [PATCH v5 bpf-next 1/6] netdev_priv_flags: add missing IFF_PHONY_HEADROOM self-definition
Message-ID: <20210216143333.5861-2-alobakin@pm.me>
In-Reply-To: <20210216143333.5861-1-alobakin@pm.me>
References: <20210216143333.5861-1-alobakin@pm.me>
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
index b9bcbfde7849..b895973390ee 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1584,6 +1584,7 @@ enum netdev_priv_flags {
 #define IFF_L3MDEV_SLAVE=09=09IFF_L3MDEV_SLAVE
 #define IFF_TEAM=09=09=09IFF_TEAM
 #define IFF_RXFH_CONFIGURED=09=09IFF_RXFH_CONFIGURED
+#define IFF_PHONY_HEADROOM=09=09IFF_PHONY_HEADROOM
 #define IFF_MACSEC=09=09=09IFF_MACSEC
 #define IFF_NO_RX_HANDLER=09=09IFF_NO_RX_HANDLER
 #define IFF_FAILOVER=09=09=09IFF_FAILOVER
--=20
2.30.1


