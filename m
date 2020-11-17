Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BDD2B5E86
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 12:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgKQLli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 06:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgKQLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 06:41:37 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7173C0613CF;
        Tue, 17 Nov 2020 03:41:35 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id mn12so254858pjb.1;
        Tue, 17 Nov 2020 03:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yK3guKziVoImJRhpkshknGVxmHiW95ym33CYvh9hWIg=;
        b=iAHVYAOVqqisGtYQ1zLY0u5RV/IpSgDvGtHY1zSzhYT9KvPCYxuNdAunM+7uEjoFom
         lBX2sOiIKtsoUpPB0B7BV76aN70jI5fFWwzYRD31JMCXP4VbREULcfWlywAHWQd3ZL5w
         2mJbP8rHhnFr6kvAEdxqyi28oM+a0wnOhDymiLhVM09ENww3vx+wgfreo0t0V/8aQqbZ
         TaK4/x77n4c6aR8488P0z2ZbTTjvDD6Q2Ir+2k930YktFjt5W0yMrZ2C2SKq93/s7B8V
         gy0nLp6SWcVavACgJo+o3lvZpvlWKPSrPkkWAhLb5IMCzWmc29cBHeWcKf5xe1T825QT
         wRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yK3guKziVoImJRhpkshknGVxmHiW95ym33CYvh9hWIg=;
        b=L341BxavWC1HkeNKYY7lMRNDTsuJH6BfsaODgChf44AiY/9Dwe1meW1EfEr/lxabtM
         AJudFCTU6kHBrU5+NZCI95h/p3iQ6k62vRtEvzaVHjqyb6asu/DDxGyPLBD3geMshHL9
         GJdWmq7C5iA33+Km6qr6pSa8QqhhUJ9PKdbdk4ejO7z1HlU7tlp7JHXLSYqnwysKQfSo
         8WTYBywLOWipegGQF4+3e512CnF8EQDqMIB59CgyaT8+/orrfxkUZayBrTLe+ErwWHzj
         65aWzvvgmropPecaY8V6zao5sVVz3wh74Z/4+kaax2sA0aEyz9XODeX5w+C+qBlKjDRk
         GJjw==
X-Gm-Message-State: AOAM530Dvoz2w9JCfuVYBRgM20q45HdeNuvsqEoYHEZoGWiBsdh2iz2d
        TFHjCZR8QOFqhxJwLAJkUJSUoBYKWCWGb1Zx+aU=
X-Google-Smtp-Source: ABdhPJzScNXrJOYgnPFaNtKAot0MXcj2P1ewsfdZXeYwIDnhGYiMFRqdo/5lv2zFx2verObteWcqkz7iJeMfjXkU+dU=
X-Received: by 2002:a17:902:9890:b029:d8:e265:57ae with SMTP id
 s16-20020a1709029890b02900d8e26557aemr12757128plp.78.1605613295524; Tue, 17
 Nov 2020 03:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20201116135522.21791-1-ms@dev.tdt.de> <20201116135522.21791-5-ms@dev.tdt.de>
In-Reply-To: <20201116135522.21791-5-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 17 Nov 2020 03:41:24 -0800
Message-ID: <CAJht_ENE5fGr-rgOd-5Tk_g5RJibaWBn_ey5Avo-2R2opMGcDA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/6] net/x25: support NETDEV_CHANGE notifier
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 6:00 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> This makes it possible to handle carrier lost and detection.
> In case of carrier lost, we shutdown layer 3 and flush all sessions.
>
> @@ -275,6 +275,19 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
>                                  dev->name);
>                         x25_link_device_remove(dev);
>                         break;
> +               case NETDEV_CHANGE:
> +                       pr_debug("X.25: got event NETDEV_CHANGE for device: %s\n",
> +                                dev->name);
> +                       if (!netif_carrier_ok(dev)) {
> +                               pr_debug("X.25: Carrier lost -> set link state down: %s\n",
> +                                        dev->name);
> +                               nb = x25_get_neigh(dev);
> +                               if (nb) {
> +                                       x25_link_terminated(nb);
> +                                       x25_neigh_put(nb);
> +                               }
> +                       }
> +                       break;
>                 }
>         }

I think L2 will notify L3 if the L2 connection is terminated. Is this
patch necessary?
