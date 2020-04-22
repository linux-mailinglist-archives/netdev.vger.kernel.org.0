Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF621B36DC
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 07:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgDVFh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 01:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVFh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 01:37:56 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C46C03C1A6;
        Tue, 21 Apr 2020 22:37:55 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id u203so310507vkb.11;
        Tue, 21 Apr 2020 22:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NTa2yi7YH9O/+4TfbxHTCCNG2Y8i4hCKmTOzzOqOaac=;
        b=ByVA5TjoJ5489zFtXjPrUQbsATmhsbdTqMbab2H8ISsy7lt6SuBjCmPudXmnRCvGns
         u+FWeHFXh52oJJZbYcjdaB3+JEdv3K8GyRe4aDiAy04rfk5ztzZHatDIEErN467Gih7W
         r3p8zhMJQ57f3oaCw3UwqabmuJ3Pi+qaxS1XwOBpKn4Vcp4cmWB5TDAcpHs3PHDlMYcM
         Yglao9tIxFPIEIRquW4plnWLZCRWpY2YmnohO57NuvBGoutJd5kk6iITxxK2iUyioiwn
         Wg0W8c4/8RVeTJGzjKgqxqqIguebg3r3T601BUnyJz0EREFFufh4SprtrU7eSkJCgqrH
         nLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NTa2yi7YH9O/+4TfbxHTCCNG2Y8i4hCKmTOzzOqOaac=;
        b=jyP9RqNgf5/pG4faPlss/llIGRWpcPWfDurHfclU3O84v9SEotSBuTu2OzFOsBIq/u
         b7S31AYU8ty0eMHD03HBm4uBlpvFlRv87KQUePBeM1Nwn0yGYxSzfGdVO5l5o3HUtLJS
         EhENICbpe/6165U4kvcXgk+hDNrQBYSj03wrX2yGQzSCVV9WGLHVIGUo3c1A4G/+uliy
         PzPBe6xW0wWgqIlD26sHb3cPp5EjXp2x+Yr0zfsFj9L8yVUg351MXZg1TyLOWBFqwXX/
         iaxeegm9wn2RUNcs0xDCMPO7f1vSVESZ5ZEvQs4gIZL9KxIgfWxGYPONLHOAhT5VqqRm
         zCHg==
X-Gm-Message-State: AGi0PuY9VRluY1PLOGRKqBI4nUlJohf1MJEJI8BdaZED9BC757cR+Q1l
        OkEIURFsw8s+pDrDoMA9jYOg9QKxIZJCj8iYz80=
X-Google-Smtp-Source: APiQypKAJhnyNXBC0eRsaCMZZTQ//bTjQf6ddHdBFc+sxVCEOzTqwigxjvnu/8TXS/ysA9oYv8EdruJy36EWXxaG1UQ=
X-Received: by 2002:a1f:5844:: with SMTP id m65mr17601482vkb.47.1587533874935;
 Tue, 21 Apr 2020 22:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200421232927.21082-1-tklauser@distanz.ch>
In-Reply-To: <20200421232927.21082-1-tklauser@distanz.ch>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 22 Apr 2020 07:37:43 +0200
Message-ID: <CAJ8uoz1vgJG=z4u3h=OkPynf0TVBt9ih2XvwSO1d-GHNYNTxrg@mail.gmail.com>
Subject: Re: [PATCH] xsk: Fix typo in xsk_umem_consume_tx and xsk_generic_xmit comments
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 1:30 AM Tobias Klauser <tklauser@distanz.ch> wrote:
>
> s/backpreassure/backpressure/

Thanks Tobias.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  net/xdp/xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index c350108aa38d..f6e6609f70a3 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -322,7 +322,7 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
>                 if (!xskq_cons_peek_desc(xs->tx, desc, umem))
>                         continue;
>
> -               /* This is the backpreassure mechanism for the Tx path.
> +               /* This is the backpressure mechanism for the Tx path.
>                  * Reserve space in the completion queue and only proceed
>                  * if there is space in it. This avoids having to implement
>                  * any buffering in the Tx path.
> @@ -406,7 +406,7 @@ static int xsk_generic_xmit(struct sock *sk)
>                 addr = desc.addr;
>                 buffer = xdp_umem_get_data(xs->umem, addr);
>                 err = skb_store_bits(skb, 0, buffer, len);
> -               /* This is the backpreassure mechanism for the Tx path.
> +               /* This is the backpressure mechanism for the Tx path.
>                  * Reserve space in the completion queue and only proceed
>                  * if there is space in it. This avoids having to implement
>                  * any buffering in the Tx path.
> --
> 2.26.1
>
