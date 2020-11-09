Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F362AC965
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgKIXdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:33:31 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:13688 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgKIXd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:33:29 -0500
Date:   Mon, 09 Nov 2020 23:33:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604964807; bh=TRxXCgaE15C0k6XBtuc6PMRdlGWdL4cI78TMkWtQBQk=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=pVaSw2zzPi8pFABans0RWt+QYul5aK/b6B7012+xFmK0O+5LxaVCIClUrczl5e4N6
         x7Yt5LbSjuerxhWyQcurLvuqeQ0KkOM4db4kYh1p9XJyuVdyoubTPl2jup9h+9Nxey
         Pq41BioU1FSBbh1egQgfB8NWVdZ7REKki6ehVDDNgae0zhV7e6DPqEgCEh7DTlXVdc
         bgG3lcsreOB/ch7RroWENCVWlUUyCsE/3af72NIRopwAxE9ymAxdEGMxIL29I2nK88
         aC43Tce4P9jPiJtVM2vHgfoq7UZAGGLNZiWMm1xvXc5Y2R1XPQSOgKuPKfXF43gHaK
         MRxzkvF04M70Q==
To:     Eric Dumazet <eric.dumazet@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 0/2] inet: prevent skb changes in udp{4|6}_lib_lookup_skb()
Message-ID: <o5W2i2pZBXUMLfXAXnUsKrQPAjw9hX9EPrGQSP3I@cp4-web-034.plabs.ch>
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

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon,  9 Nov 2020 15:13:47 -0800

> From: Eric Dumazet <edumazet@google.com>
>
> This came while reviewing Alexander Lobakin patch against UDP GRO:
>
> We want to make sure skb wont be changed by these helpers
> while it is owned by GRO stack.
>
> Eric Dumazet (2):
>   inet: constify inet_sdif() argument
>   inet: udp{4|6}_lib_lookup_skb() skb argument is const

For the series:
Acked-by: Alexander Lobakin <alobakin@pm.me>

Thanks!

>  include/net/ip.h  | 2 +-
>  include/net/udp.h | 6 +++---
>  net/ipv4/udp.c    | 2 +-
>  net/ipv6/udp.c    | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
> --
> 2.29.2.222.g5d2a92d10f8-goog

Al

