Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B74E432B8E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 03:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhJSBqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 21:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJSBqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 21:46:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122FBC06161C;
        Mon, 18 Oct 2021 18:44:40 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w14so6586432edv.11;
        Mon, 18 Oct 2021 18:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eIyfm+J/Yiqd42wl+2b5QKxYh+1XpsmhBsVt4wFmf+I=;
        b=qShU93dfa/sj9q0hdtN7R6YbFMIX8lLRbtRSYMl4baM5yg+YCYJR1UlFKVwaodp8FP
         2nMGMeAx9IKmcxyNs7QePGEDi6vrwfKfQLYlqmlTDXSY/ahYRl3rsAM+TqbOjqEbnJ9M
         iNR8UCHtN+8vvhwhUOMyz+AqAEtHIo2bO5flUN8lE+MeprQFM4LHyJmX7JFBLVTb1b9c
         MZuiLubrhaI/wScW90cI5OQLPxc4EXzgJ8WQmuPtyeikLsAKIfKgkvwuIOywpORrxYQj
         igz5kxratpPu61QBzB20567Ish9laoEBhKqnIQPYeMzGfVwePLwF8cRK6mq9wKYbKu8L
         ebag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eIyfm+J/Yiqd42wl+2b5QKxYh+1XpsmhBsVt4wFmf+I=;
        b=jwvfPE5BvMlixiNJ4ZmmQ2LvEYris5E3xCxZmiCKAKy3MK27V84o9AV4iqVdLQZxqO
         60sRlsNCErVnVeMNE1ZJNyU0SdX7zw57YwP/O/jO8lqiHt0B6R6kBpg2pKabQCzOEXeB
         5UKl8HMVJaEEpS6ThgqYKYlF910u3ucx5xty+JEuI02/oO22TVbIh3qLChUIhpyvNUNe
         mWdAJAJhKunQn1sp9TRMEfE/EPwiYu6pN0lg6nIv6+zoRIh0/ObW8kDa4OI1Lv09DuiX
         XLMfVTKfikC5P1n2PIt7GMepQjCbYqqMWgQ1PYLCRwWYOpJEewmSag7uNT0fS/CsXbju
         In4w==
X-Gm-Message-State: AOAM530hne/HoVhbGR9byGAgtvkxFkoCVwLQu4+DWZwuOjC1OP1aPks9
        XmcFBc591tCw4HIcYVlgjH1x70qRrYpydKQkfE7VDqcVlk5RKq8R
X-Google-Smtp-Source: ABdhPJzpMGSttq1LxPFQAy0/QQ3kY4ML/4FAPDu+Lvy5V9Orglgt0VLaADKMA3cqC6v7UhdLO3RiflHKf2eJTJ+ehGI=
X-Received: by 2002:aa7:cd99:: with SMTP id x25mr49392012edv.266.1634607878541;
 Mon, 18 Oct 2021 18:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211017125022.3100329-1-mudongliangabcd@gmail.com> <20211018104759.t5ib62kqjenjepkv@pengutronix.de>
In-Reply-To: <20211018104759.t5ib62kqjenjepkv@pengutronix.de>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 19 Oct 2021 09:44:12 +0800
Message-ID: <CAD-N9QVziDjvdSwqADX2hDdepHBeDF7FxzPLfH5UGhGvUxshcg@mail.gmail.com>
Subject: Re: [PATCH] can: xilinx_can: remove redundent netif_napi_del from xcan_remove
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 6:48 PM Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
>
> On 17.10.2021 20:50:21, Dongliang Mu wrote:
> > Since netif_napi_del is already done in the free_candev, so we remove
> > this redundent netif_napi_del invocation. In addition, this patch can
> > match the operations in the xcan_probe and xcan_remove functions.
> >
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/net/can/xilinx_can.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.=
c
> > index 3b883e607d8b..60a3fb369058 100644
> > --- a/drivers/net/can/xilinx_can.c
> > +++ b/drivers/net/can/xilinx_can.c
> > @@ -1848,7 +1848,6 @@ static int xcan_remove(struct platform_device *pd=
ev)
> >
> >       unregister_candev(ndev);
> >       pm_runtime_disable(&pdev->dev);
> > -     netif_napi_del(&priv->napi);
> >       free_candev(ndev);
> >
> >       return 0;
>
> Fixed the following error:
>
> | drivers/net/can/xilinx_can.c: In function =E2=80=98xcan_remove=E2=80=99=
:
> | drivers/net/can/xilinx_can.c:1847:20: error: unused variable =E2=80=98p=
riv=E2=80=99 [-Werror=3Dunused-variable]
> |  1847 |  struct xcan_priv *priv =3D netdev_priv(ndev);
> |       |                    ^~~~

For now, xilinx_can already enables "-Werror" proposed by Linus?

That's my problem. Sorry for that.

>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
