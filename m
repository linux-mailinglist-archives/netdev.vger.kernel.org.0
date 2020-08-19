Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18C824A814
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHSU6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSU6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:58:03 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340EBC061757;
        Wed, 19 Aug 2020 13:58:03 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q3so14074291ybp.7;
        Wed, 19 Aug 2020 13:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYJit2DOCfkY8sTCk27/mnZitItuDVeSi6cqy/KAqrQ=;
        b=X3D6JjWX1lVN31i+amns+xpnTJoYN5eSHu5f8qX0ph8IiMiiNldZ9ptZknDaMxr0Dy
         5H470R1KOnEBbo8qClnM4KtVMagDi8hK3Y9gxgnqIfo1UmVWjDsOeCA1VN6yNGt4Iezj
         IvcGapgLDsGhQrj6FiZNWB5Re59G5DG9JkXmUwFrLcrFHUcS8Tgl2R3vWGDKT9dIzB4j
         Mg5BUImX04CRzQ8ulkniBxj+yBjluzbGJ0RV0TTC2hnPD7W8SATETL8lgT48pO0vTiyb
         uIVG7E+B7mQ+xxHA1dnPx5hcArCW7zKmIXvpVo13XuTPn5AQ9kUI+pa5hiObi2ThcSZY
         FZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYJit2DOCfkY8sTCk27/mnZitItuDVeSi6cqy/KAqrQ=;
        b=JEMsa8U1Gf03ugX+4bVU+ICyo80rV7wc4Eo3X1GKAWL6bgiVILuhbvNNHuLTY78Rd8
         dvDpgfHGZrvm8xmBVoxS7gWnwXg8llPcTCNwN/3oqjn38MlMLYLI0HMml/7dFpoafrCn
         Rqebw2z0Dz1AS5v4RdzcNgInmnR4/0gmFzDHXWofeMizWsetmHTMXRtTdqTFWraXdIDM
         uDz7wSc69x/syuONnuzGhoK7SIkLgF7UIXQgceDS2/3BVEKKiElIuIOsNe4MV113PF7d
         vqvqzFKEajNkN7Iq+DVFgUKd3X4Tm4Xg8hKaLdCveWR4LBLyqroE98C9+h0hVqWVSo62
         HuZg==
X-Gm-Message-State: AOAM530TLcH4RfRNcZG5IIliiG/SOfyEdT+ZGBwHCucKIA3bQ04a0gdi
        UFgS0LCO5s0qORTkJQgWc6LpsKF/Nq5QuEMCxsA=
X-Google-Smtp-Source: ABdhPJztJZn/IVNEDq2IoT4pBH8i3ibCqlXWecvwEIvAu21jgNP0NeWjW89k/A8rXWoIqQpg/AEZ1lVtQVjoiMFcvCo=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr355253ybe.510.1597870682469;
 Wed, 19 Aug 2020 13:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200819092811.GA2420@lore-desk>
In-Reply-To: <20200819092811.GA2420@lore-desk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Aug 2020 13:57:51 -0700
Message-ID: <CAEf4BzZSui9r=-yDzy0CjWKVx9zKvQWX6ZBNXmSUTOHCOR+7RA@mail.gmail.com>
Subject: Re: xdp generic default option
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 2:29 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Hi Andrii,
>
> working on xdp multi-buff I figured out now xdp generic is the default choice
> if not specified by userspace. In particular after commit 7f0a838254bd
> ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device"), running
> the command below, XDP will run in generic mode even if the underlay driver
> support XDP in native mode:
>
> $ip link set dev eth0 xdp obj prog.o
> $ip link show dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc mq state UP mode DEFAULT
>    group default qlen 1024
>    link/ether f0:ad:4e:09:6b:57 brd ff:ff:ff:ff:ff:ff
>    prog/xdp id 1 tag 3b185187f1855c4c jited
>
> Is it better to use xdpdrv as default choice if not specified by userspace?
> doing something like:
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a00aa737ce29..1f85880ee412 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8747,9 +8747,9 @@ static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
>  {
>         if (flags & XDP_FLAGS_HW_MODE)
>                 return XDP_MODE_HW;
> -       if (flags & XDP_FLAGS_DRV_MODE)
> -               return XDP_MODE_DRV;
> -       return XDP_MODE_SKB;
> +       if (flags & XDP_FLAGS_SKB_MODE)
> +               return XDP_MODE_SKB;
> +       return XDP_MODE_DRV;
>  }
>

I think the better way would be to choose XDP_MODE_DRV if ndo_bpf !=
NULL and XDP_MODE_SKB otherwise. That seems to be matching original
behavior, no?

It was not my intent to change the behavior, sorry about that. I'll
post patch a bit later today.


>  static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
>
> Regards,
> Lorenzo
