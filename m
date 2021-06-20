Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1A73ADF2C
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 17:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFTPWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 11:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhFTPWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 11:22:43 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1C7C061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 08:20:28 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id m137so17117618oig.6
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 08:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E49chSA4g6/ap5bTuUbJdFWUpI7RjlcVcsZ/pQtdIVQ=;
        b=LPznyYJPsvMIgs42JF13+Mn++FwaXmSv0T37h05wowzjHC8VQ50qPSPw4ruMPZKbC6
         Zv8L+tNoSSnS1/qBEN9gUt+ZpfTZKJZ++r0DoRznI6KON/jmBQNv9emiVhjwKDGjC7U2
         N4DpjqIrFZmNtnNNqpeoGP84G2daaMfettB7DeN/sH6myXV7Fn4WVFg3lTAO3/jJ02gm
         odsFUGgJ8W0mN2lSmBhXBUDK/khNpDxEkBW7cPxRdTL/y6Uwm/LDo193LZ5YgDt2uCtD
         IVWLpZmdmxm9PB+tXlNyCfSlyJ+/MRMNK6FFLRz7YQ0c1XOha82nNd4q8JcnwsS3XA17
         326w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E49chSA4g6/ap5bTuUbJdFWUpI7RjlcVcsZ/pQtdIVQ=;
        b=mJNkU0CCZeyeIM3zfLT8bg6UaWIjDWi3AUsMjDlKQBVjIzJ4PZgLToKP6qVZty7zep
         8TRE0vTdiolEJY7Di/nn/24idAyvOsnyTlUligvN7LkFeKoJy+BBsJ0q+7jn29V9oKGz
         Ywdy99AduwYWI8hO9/dMB3Uu1Rw8PNpfQ5ihxDEvGokA8QXLNfr/qu5GIlrYAY7pgCUd
         alG90X0Qlswmn0e4AIgbPrN1sfQWxqfTnbUIb83vKC9Df8T2O+UxRRwRUkmCHIZ6d0lW
         M7laKFV8SqAOObPZ050tz1qUzw2IIDrygb62wAJ9b0ZPZlwG32yVmywCdQBYrgMbm2cv
         qbKQ==
X-Gm-Message-State: AOAM531YZw1dHvK2dwPSMnS6O1LDNP9TxHutZvd+7KWZpB+OyzxLoSLH
        Qhu2lHx/ME+QWqDybb1ZUTui+T97/MmpbLRHm8c=
X-Google-Smtp-Source: ABdhPJwAvJnsgWZT2kEp3CQFdZeberQ2CXsKDcJrz8EH1uKONd423u6BHnWftNMVls4xlDP1oyLc0l2dy5fBR0A+scw=
X-Received: by 2002:a05:6808:1388:: with SMTP id c8mr21094157oiw.17.1624202427735;
 Sun, 20 Jun 2021 08:20:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-7-ryazanov.s.a@gmail.com>
In-Reply-To: <20210615003016.477-7-ryazanov.s.a@gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 20 Jun 2021 18:20:20 +0300
Message-ID: <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Chetan,

On Tue, Jun 15, 2021 at 3:30 AM Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> Since the last commit, the WWAN core will remove all our network
> interfaces for us at the time of the WWAN netdev ops unregistering.
> Therefore, we can safely drop the custom code that cleaning the list of
> created netdevs. Anyway it no longer removes any netdev, since all
> netdevs were removed earlier in the wwan_unregister_ops() call.

Are you Ok with this change? I plan to submit a next version of the
series. If you have any objections, I can address them in V2.

BTW, if IOSM modems have a default data channel, I can add a separate
patch to the series to create a default network interface for IOSM if
you tell me which link id is used for the default data channel.

> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> CC: M Chetan Kumar <m.chetan.kumar@intel.com>
> CC: Intel Corporation <linuxwwan@intel.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> index 1711b79fc616..bee9b278223d 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> @@ -329,22 +329,9 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
>
>  void ipc_wwan_deinit(struct iosm_wwan *ipc_wwan)
>  {
> -       int if_id;
> -
> +       /* This call will remove all child netdev(s) */
>         wwan_unregister_ops(ipc_wwan->dev);
>
> -       for (if_id = 0; if_id < ARRAY_SIZE(ipc_wwan->sub_netlist); if_id++) {
> -               struct iosm_netdev_priv *priv;
> -
> -               priv = rcu_access_pointer(ipc_wwan->sub_netlist[if_id]);
> -               if (!priv)
> -                       continue;
> -
> -               rtnl_lock();
> -               ipc_wwan_dellink(ipc_wwan, priv->netdev, NULL);
> -               rtnl_unlock();
> -       }
> -
>         mutex_destroy(&ipc_wwan->if_mutex);
>
>         kfree(ipc_wwan);

-- 
Sergey
