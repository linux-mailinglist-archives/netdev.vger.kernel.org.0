Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10532D84E0
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 06:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438132AbgLLFcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 00:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgLLFcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 00:32:07 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4C1C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 21:31:26 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id j17so10115408ybt.9
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 21:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFhaEWw3NQ+QiX0GRjcThJ4PrtwDtPHjkoNpyLU9pTQ=;
        b=EdLQxxWugNTc45+8EfyP6Z5nT3DT/sKTkoyFhtvt3LfPxIG6/tqjXL/1g05M3clS0E
         PQsfSg3uVjz8TlLlYwOL4Si90/0pqcgGbmlokq46a1JJbrc8lHdgNkrXzaiOlKmaxI+E
         xKCREGPidta5cB9PqLe/p5wdwvI6lOEzWsM46kZZQUCdqa640MzaG9KFu0BdSQQP1KXZ
         37EKDJxgtz+WxXTQ+5LhMEulN+6Fd+/9EL76tTKGb00K2E0tC6or1J8xsR7c2XapgABM
         oXix4pzbXjCYFI+E9PzHWwWliur34WyTKTMe3ZmkMnITh4VWl8u5q0xfMEn4yF7ebtbP
         BAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFhaEWw3NQ+QiX0GRjcThJ4PrtwDtPHjkoNpyLU9pTQ=;
        b=jHzcKl4biRoUq8EicuJ3Uq1zcxndVT6LTfwbJtXg2+JQ64BaY7ezdlS7T1uHrMBgAp
         fY6lOMLDu8DL+hvKyzYKEFI7gHcXnS1BiSXBSSZisY/7+wf7fgnjG4WXlNauImSmdEXM
         uNfkEz5sE3WdNoVx+FlQK0k45hWYieUwpzsLdu3N/tr8ulvzYLbdEAl8/rIOP8om8kdh
         pi0dpf4sI0QFi00yyJ4bVVjDsvfJsZhQP8RS/FqIbUDN4R5dxxMI4pNz1imwPAA3gEPR
         npSOGBoJF5Qo2EqkRQDtMOgLGqZrrJfleyj1zoPdFYeVuNymXoyFR/aeEbSmQsnZxDLZ
         rk6A==
X-Gm-Message-State: AOAM5320ebNkv1IRhSH5IYonP3LldWEAk8NWatUzYCFcWUYWfXmopggz
        2d2VgscxU0KdivMdCfMo4V+mfODa/5OQjEk+zuU=
X-Google-Smtp-Source: ABdhPJxzQteXDXtVxv7TY81joh02nbNH6GMVJUuUUwnQ5Pc8I3IRctEhR1iUXuXY30qDFmatbIX1LbECIn2Y7R5swdo=
X-Received: by 2002:a25:2301:: with SMTP id j1mr25130360ybj.151.1607751085929;
 Fri, 11 Dec 2020 21:31:25 -0800 (PST)
MIME-Version: 1.0
References: <20201211122612.869225-1-jonas@norrbonn.se> <20201211122612.869225-9-jonas@norrbonn.se>
In-Reply-To: <20201211122612.869225-9-jonas@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Fri, 11 Dec 2020 21:31:15 -0800
Message-ID: <CAOrHB_BC3847Oi--N84=tT5nrdpmL6a5Csvah19qJ0Czyng1JQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/12] gtp: set dev features to enable GSO
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 4:28 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>  drivers/net/gtp.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 236ebbcb37bf..7bbeec173113 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -536,7 +536,11 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>         if (unlikely(r))
>                 goto err_rt;
>
> -       skb_reset_inner_headers(skb);
> +       r = udp_tunnel_handle_offloads(skb, true);
> +       if (unlikely(r))
> +               goto err_rt;
> +
> +       skb_set_inner_protocol(skb, skb->protocol);
>
This should be skb_set_inner_ipproto(), since GTP is L3 protocol.


>         gtp_push_header(skb, pctx, &port);
>
> @@ -618,6 +622,8 @@ static void gtp_link_setup(struct net_device *dev)
>
>         dev->priv_flags |= IFF_NO_QUEUE;
>         dev->features   |= NETIF_F_LLTX;
> +       dev->hw_features |= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
> +       dev->features   |= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
>         netif_keep_dst(dev);
>
>         dev->needed_headroom    = LL_MAX_HEADER + max_gtp_header_len;
> --
> 2.27.0
>
