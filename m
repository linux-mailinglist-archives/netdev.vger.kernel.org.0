Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A167B50F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfG3VfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:35:04 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44578 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfG3VfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:35:04 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so63786621edr.11
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 14:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5KTs6JoUGrPhanNm6qPYX3c+vgrGx2BZyINumqB256M=;
        b=XOhKlOsllgQt7mj+tEdrJaxD9Hdk80DikKSarq4gA4VPI8ylgcaZHVmYp5jyXb22UX
         2AWFDA9ISCkXoS5z4zCpIO7oWCXpkRzmphMyKH35ZuOm8pf4k6mAvzR1rTM5R9XoIuO7
         7xS8i8MWzZ6DfWtzsylWoVHXUE6wSPIZkYN4u3ihX7pyRz57DIrIOY4p8fOCRx7hZUil
         soZZn9c9JOM/SQ8NNbz1QiIVkiDCuU1MqzUXETOblcKry5+hg4jnXOZ79od0TaSQHHcr
         hM1t7EvzNkZbuH34DomVemyCoQRmr7u7KqL8WC0HVUXq1mvb+AaFZ3HV+qTTWdNJYWg4
         FWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5KTs6JoUGrPhanNm6qPYX3c+vgrGx2BZyINumqB256M=;
        b=irVjVKbFzm5YPyaBM2GehlhuoaEeWtAGn7IYc1l56hjyBQiAcF8L/0eBTKabAinEHx
         fae8Bu6Yt8pGFLS21PorYL5ea1qWHWwoxUSD5/wEBLk8FSfjqd29Mf/JwMEG5Rl4moxy
         6SVGG6K3q57Bb1sDhS5EIXx3vEn5vJIM92Kk5ntv8+A8f62/Cie58qGfnSl5axr/KtuM
         cUbOi0AyeqpwuGLULetdKG88LA9+hHFOsxCAMUgo2qEuFgs79eXgWgUe5/LWoTQZpexg
         /KtLyobr9RMiz6Jx1yLmqrkS5xjp3HZf56yklMpumKfwe176b+q5eIs4CbEjhFD6kTqF
         wVYw==
X-Gm-Message-State: APjAAAU8EHayR0qiyQhcWufoexmLCeaMdfs32NBnynH5Ofb5aCnyBkwW
        odZpyOrYCyxNGX37y8HlyiCNWj0uqSqeKeRUcqmDeA==
X-Google-Smtp-Source: APXvYqz4S/UtrZHKTivcDlHhsAF4Mh8sPc4Ykge1SeAWtKLEax0FagPNWrUKxwn8mJtkaau0lTjupaLMkvrZy8SPB8Y=
X-Received: by 2002:a17:906:3144:: with SMTP id e4mr53116726eje.31.1564522502533;
 Tue, 30 Jul 2019 14:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190729234934.23595-1-saeedm@mellanox.com> <20190729234934.23595-2-saeedm@mellanox.com>
 <CA+FuTSdoCfj=vcQd3TcA9BRhCNPAJamKHX+14H-6_ecpDEVS_Q@mail.gmail.com> <cb43e9dadb8e48d27df8f08464bf40f7a81eafe9.camel@mellanox.com>
In-Reply-To: <cb43e9dadb8e48d27df8f08464bf40f7a81eafe9.camel@mellanox.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jul 2019 17:34:26 -0400
Message-ID: <CAF=yD-KqHNzCfEMiW5Sks4d376vQEVWqgTDvFjBU_2aNGi3FOA@mail.gmail.com>
Subject: Re: [net-next 01/13] net/mlx5e: Print a warning when LRO feature is
 dropped or not allowed
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Huy Nguyen <huyn@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 4:08 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Tue, 2019-07-30 at 11:52 -0400, Willem de Bruijn wrote:
> > On Mon, Jul 29, 2019 at 7:50 PM Saeed Mahameed <saeedm@mellanox.com>
> > wrote:
> > > From: Huy Nguyen <huyn@mellanox.com>
> > >
> > > When user enables LRO via ethtool and if the RQ mode is legacy,
> > > mlx5e_fix_features drops the request without any explanation.
> > > Add netdev_warn to cover this case.
> > >
> > > Fixes: 6c3a823e1e9c ("net/mlx5e: RX, Remove HW LRO support in
> > > legacy RQ")
> > > Signed-off-by: Huy Nguyen <huyn@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > index 47eea6b3a1c3..776eb46d263d 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > @@ -3788,9 +3788,10 @@ static netdev_features_t
> > > mlx5e_fix_features(struct net_device *netdev,
> > >                         netdev_warn(netdev, "Dropping C-tag vlan
> > > stripping offload due to S-tag vlan\n");
> > >         }
> > >         if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
> > > -               features &= ~NETIF_F_LRO;
> > > -               if (params->lro_en)
> > > +               if (features & NETIF_F_LRO) {
> > >                         netdev_warn(netdev, "Disabling LRO, not
> > > supported in legacy RQ\n");
> >
> > This warns about "Disabling LRO" on an enable request?
> >
>
> no, this warning appears only when lro is already enabled and might
> conflict with any other feature requested by user (hence
> mlx5e_fix_features), e.g when moving away from striding rq in this
> example, we will force lro to off.

Ok. The previous commit mentioned "totally remove LRO support in
Legacy RQ". This handles the additional case when moving a queue into
legacy mode that still had LRO enabled. I see.

>
>
> > More fundamentally, it appears that the device does not advertise
> > the feature as configurable in netdev_hw_features as of commit
> > 6c3a823e1e9c ("net/mlx5e: RX, Remove HW LRO support in
> > legacy RQ"), so shouldn't this be caught by the device driver
> > independent ethtool code?
>
> when hw doesn't support MLX5E_PFLAG_RX_STRIDING_RQ then yes, you will
> never hit this code path, but when hw does support
> MLX5E_PFLAG_RX_STRIDING_RQ and you want to turn striding rq off, then
> lro will be forced to off (if it was enabled in first space) and a
> warning msg will be shown.

Got it, thanks.
