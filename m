Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F32A3A77A6
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFOHKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhFOHKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:10:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14636C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:08:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e20so10705316pgg.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M4ylQlHxq0e8DoMlnrGycIgsscKhdmHM+gpqPKakZpA=;
        b=FIHohuh1lg5ZOwgCH5N2yDyDwukyPuxlxBCSY3ainalp+0hdVl0/T+yWuNQeHJmklt
         bgMZ0uponPlNhc2ndQMUho81B5kvD9QuaZmspK3pRAnMpjW6FfJeKovN75MopiQ5bwtR
         BGoi4fo/D1ypaUFIDI9tI3rFreM+TQqXbuFACzSOE8V4kk0ssvLI0p3y3jBbpG/g7qgv
         aWpjsQeY1z2d0ufdc3WhK1Kxizm1izsd1TGSqRVvq3ft0yKokgd6qOoH+L46TY4nFrCn
         HxReojQodAvcvVOicXLqbU/CE2jkq6SXQ2MoMu5Sz5MvtnWFtOcTIx0sOLUIHPVJsXdE
         Qk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M4ylQlHxq0e8DoMlnrGycIgsscKhdmHM+gpqPKakZpA=;
        b=fK2LTDM9KgKFmfKOA4U6+ToIncfg8gTcnMGYKRdk+dHCYqKgdK410RNi90DqdW+S7X
         Nlg+K6d5hs2m7vZe21sBpKnJSPpMeqVHSqtrSQ8MJ8xFcLQQ4V4+12VpWosvEvneuQxi
         NGPikQ8gWyC+4O/wr647S0VQRCpN7X4pDoJ+WVPFWxvoYGkrHGvi2cKWQk7+o1e+hmMw
         auc2YsKg6rVqFj2DevUcyso1WKzOjqdy6E+oayXB/VaCEELvCAt1qN+YZq6Q7uonuDjm
         r/ckvUI3Di9CNyymav6uZh3c5Rvxkbr1jcKAFd/EBMFlKYaFye57sIH8MRMGxd6XBEY1
         uSBw==
X-Gm-Message-State: AOAM530nSgRh15a9VopCSQOXTVKhnKXl+ObtZ2X9S3jmucQqp6DdNdm1
        iprpw3fdSSdhCKJahwWtT51dkucK4vmpEli8Pb1ZJw==
X-Google-Smtp-Source: ABdhPJxP3RsU/m3n5n5S6vtrfSyGwQf3pZhjt1Y+o0okYbeib/FmV60M5Lpwt3dFxjqHPXYky7d0Zd4WclnpAgm8SFw=
X-Received: by 2002:a63:bf0d:: with SMTP id v13mr20601063pgf.303.1623740910475;
 Tue, 15 Jun 2021 00:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-10-ryazanov.s.a@gmail.com>
In-Reply-To: <20210615003016.477-10-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 15 Jun 2021 09:17:32 +0200
Message-ID: <CAMZdPi-C+Yhf27+-7Ct-1pkp0htrr6Qbt=Om2KQk+5aVVFPRMQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] net: mhi_net: create default link via WWAN core
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Utilize the just introduced WWAN core feature to create a default netdev
> for the default data channel. Since the netdev is now created via the
> WWAN core, rely on it ability to destroy all child netdevs on ops
> unregistering.
>
> While at it, remove the RTNL lock acquiring hacks that were earlier used
> to call addlink/dellink without holding the RTNL lock. Also make the
> WWAN netdev ops structure static to make sparse happy.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---
>  drivers/net/mhi/net.c | 54 +++++--------------------------------------
>  1 file changed, 6 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
> index b003003cbd42..06253acecaa2 100644
> --- a/drivers/net/mhi/net.c
> +++ b/drivers/net/mhi/net.c
> @@ -342,10 +342,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
>         /* Number of transfer descriptors determines size of the queue */
>         mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
>
> -       if (extack)
> -               err = register_netdevice(ndev);
> -       else
> -               err = register_netdev(ndev);
> +       err = register_netdevice(ndev);
>         if (err)
>                 goto out_err;
>
> @@ -370,10 +367,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
>         struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
>         struct mhi_device *mhi_dev = ctxt;
>
> -       if (head)
> -               unregister_netdevice_queue(ndev, head);
> -       else
> -               unregister_netdev(ndev);
> +       unregister_netdevice_queue(ndev, head);
>
>         mhi_unprepare_from_transfer(mhi_dev);
>
> @@ -382,7 +376,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
>         dev_set_drvdata(&mhi_dev->dev, NULL);
>  }
>
> -const struct wwan_ops mhi_wwan_ops = {
> +static const struct wwan_ops mhi_wwan_ops = {
>         .priv_size = sizeof(struct mhi_net_dev),
>         .setup = mhi_net_setup,
>         .newlink = mhi_net_newlink,
> @@ -392,55 +386,19 @@ const struct wwan_ops mhi_wwan_ops = {
>  static int mhi_net_probe(struct mhi_device *mhi_dev,
>                          const struct mhi_device_id *id)
>  {
> -       const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
>         struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
> -       struct net_device *ndev;
> -       int err;
> -
> -       err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
> -                               WWAN_NO_DEFAULT_LINK);
> -       if (err)
> -               return err;
> -
> -       if (!create_default_iface)
> -               return 0;
> -
> -       /* Create a default interface which is used as either RMNET real-dev,
> -        * MBIM link 0 or ip link 0)
> -        */
> -       ndev = alloc_netdev(sizeof(struct mhi_net_dev), info->netname,
> -                           NET_NAME_PREDICTABLE, mhi_net_setup);

I like the idea of the default link, but here we need to create the
netdev manually for several reasons:
- In case of QMAP/rmnet, this link is the lower netdev (transport
layer) and is not associated with any link id.
- In case of MBIM, it changes the netdev parent device from the MHI
dev to the WWAN dev, which (currently) breaks how ModemManager groups
ports/netdevs (based on bus).

For the last one, I don't think device hierarchy is considered as
UAPI, so we probably just need to add this new wwan link support to
user tools like MM. For the first one, I plan to split the mhi_net
driver into two different ones (mhi_net_qmap, mhi_net_mbim), and in
the case of qmap(rmnet) forward newlink/dellink call to rmnet
rtnetlink ops.

Regards,
Loic
