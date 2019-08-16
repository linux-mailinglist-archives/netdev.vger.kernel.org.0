Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61EE8F847
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfHPBDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:03:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39454 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfHPBDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:03:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id i63so2722809wmg.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 18:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGFmqBdA/wvQwbbWUVXUd9Ry+DzusZHN47w9yBvata8=;
        b=mVOejC6yDyoP19xgGtJ879ewY08jQ/SW5QcqydTF0x2Gu4Sd2bdGGlY1zMKflBjJ52
         jPqUEHKw5s1kR/Ap0jp0nEsqdlR6rj1rvCLGod/EMugP0MG6crFUHVHY69js1CO2ST1w
         w5kCoFBKBzJC5igPAZzgLwo96+hVMNFeUWz7E+xPU5bWD7GOgS9tm67Mi+LjRYED6JCU
         f+eRSwx09zvrw0zUCWSGjv3N9I8+sAfTVpNWyOyqlEQStNCdwTeOftaHd5pE8N+ksaGZ
         Q1uxCUYxksHSbV4AQlbLFHSt5G1hdhjFZ0JsHwoQ9JAQ0K6qxY0Oe+nbcs/9QNgCLHcy
         Hl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGFmqBdA/wvQwbbWUVXUd9Ry+DzusZHN47w9yBvata8=;
        b=JnX5y9Z8ZUq+QPQK131cTF9mToSCZvYPCXbr0qWLHNNbTKhw4hpEdwjKUJVlVhOrNd
         SOWt7VnZyV2F5VokB6RpZ+sVoRwn7t8/YZoOMvoFXv1yKLMiHl9uHIqjKeHV3xWEvHF8
         umzQX2pFvjdQ5CGNFihCyifd1ESb6hXJnsjI40ilKRkB/zC7zU1HcDRQsEM44RSuFazI
         IL1voeLVWtVHmpujypbKTQw94UhT+wFp4EsT/b4dcINYnd7Aev57O1JFCo7PTElNJypL
         PTdYWoF+O9s4C90X9gRk3lVUD4E6/wKTrqq+9xZr1Cm4jq0SnhVlOfT07T2JdHdduf/O
         moNg==
X-Gm-Message-State: APjAAAWZtb0kXG9eB57FhWbotDi2RN89IiGfyM/IC8Lvmx96kIzmjuBK
        u7cTSbWMMgcHjGKhilVMM2yes0sGzbBjrAZiBy/J9w==
X-Google-Smtp-Source: APXvYqyOYixSxf71I7Ngi3eAsgja8E0mvV1aqKirfGIsC7sYSYD076vcmRqvqneMCu8cVNWvhLvKrzxQpwpaERLeRv8=
X-Received: by 2002:a1c:6785:: with SMTP id b127mr4595938wmc.66.1565917413040;
 Thu, 15 Aug 2019 18:03:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190815001043.153874-1-wsommerfeld@google.com>
In-Reply-To: <20190815001043.153874-1-wsommerfeld@google.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 15 Aug 2019 18:03:16 -0700
Message-ID: <CAF2d9jgRk7EVNNcZe+y+PRh3EkYTVJ794SXa4RNYXAu3-7ktNQ@mail.gmail.com>
Subject: Re: [PATCH] ipvlan: set hw_enc_features like macvlan
To:     Bill Sommerfeld <wsommerfeld@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 5:10 PM Bill Sommerfeld <wsommerfeld@google.com> wrote:
>
> Allow encapsulated packets sent to tunnels layered over ipvlan to use
> offloads rather than forcing SW fallbacks.
>
> Since commit f21e5077010acda73a60 ("macvlan: add offload features for
> encapsulation"), macvlan has set dev->hw_enc_features to include
> everything in dev->features; do likewise in ipvlan.
>
Thanks Bill

> Signed-off-by: Bill Sommerfeld <wsommerfeld@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index 1c96bed5a7c4..887bbba4631e 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -126,6 +126,7 @@ static int ipvlan_init(struct net_device *dev)
>                      (phy_dev->state & IPVLAN_STATE_MASK);
>         dev->features = phy_dev->features & IPVLAN_FEATURES;
>         dev->features |= NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED;
> +       dev->hw_enc_features |= dev->features;
>         dev->gso_max_size = phy_dev->gso_max_size;
>         dev->gso_max_segs = phy_dev->gso_max_segs;
>         dev->hard_header_len = phy_dev->hard_header_len;
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
