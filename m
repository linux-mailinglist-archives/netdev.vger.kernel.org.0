Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91C77ACE3
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfG3PxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:53:16 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:33802 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfG3PxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 11:53:16 -0400
Received: by mail-yw1-f66.google.com with SMTP id q128so23972982ywc.1
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 08:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EXGN8A88PIFoBxsKiaT6bQT9hwFNwnqvKYAmTNemspo=;
        b=X+EIgTMOvzfuauqaefvwCN4jIr+8M857iAhfxUHWTFTT78bDUmng/D1H4EE5GFVdms
         VnY4RmelS5SkD5zFCaxpdIW1AQbh4axqLrL46AzJyVUuqk/eBnoASv+02TRqVxXzs0W3
         lY60+r1+I5AlXzBJEFV6CMiuc9oD+u3DpJWwdIOp+RG5d6000ybPY3COv1Y9MW0a9LrR
         WHtvqnI0wBccPeRWd4iD9TWBxzIwTjkru4rLvfJJ0Nvc0i98sEU5/ycqLu7Czb6H3sty
         X/hwSYk6H5wSAaTyqknY2Y8flerWMnoaP+0Y7nUAeNSCm+yVhIf1htMxJHMG1XyO52uZ
         eK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EXGN8A88PIFoBxsKiaT6bQT9hwFNwnqvKYAmTNemspo=;
        b=uiDIcNlOeTC0e3I/ouKbcvTh0VXgm2hxiszCm8qFbsNTR1V4llCwvqay/NoIMmqhJI
         EGndOB5nTXY2JNjlWyiMIjHhr/ivvzzdy/UOucSIc6wC/oibGnbDQ6FJSvbPMjnV2n1V
         OJA+vgAwJ2tMhUtsuUfsv+wT1XA1rkVA+p3R5neEy93VpNkTmw6Z/kFXl0/Cw04gW3bY
         H7FH1Mj0N08QJlnJBnxeK+pAXdL7+2yoL6X2yxz1U68l/JK5GoYRn0FgrdSPnJ20TMIJ
         fzE8v36CHH00QOjH+T4wBVOJHxKN04gH4uSaUXNkdwvJa/kZJ/6zC5Yqoqhq5iJUplMf
         PStg==
X-Gm-Message-State: APjAAAWG7pxWuKiLw3dBlMadfqnnDizfieaxkpPzyJr/WIWqcBmiD7Jm
        l1d69F24au1CiSroamrar2F2Isom
X-Google-Smtp-Source: APXvYqysEvhlEqEJLavuSe70d7d3sS9DyAfutAyP1QHyFSD4Ayf2ayyJpPUYrX+LctgxN2fgPIC9Zw==
X-Received: by 2002:a0d:d88b:: with SMTP id a133mr70322675ywe.481.1564501995100;
        Tue, 30 Jul 2019 08:53:15 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id 197sm15023424ywf.16.2019.07.30.08.53.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 08:53:14 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id u141so23951399ywe.4
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 08:53:13 -0700 (PDT)
X-Received: by 2002:a0d:fc44:: with SMTP id m65mr66970318ywf.109.1564501993312;
 Tue, 30 Jul 2019 08:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190729234934.23595-1-saeedm@mellanox.com> <20190729234934.23595-2-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-2-saeedm@mellanox.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 30 Jul 2019 11:52:36 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdoCfj=vcQd3TcA9BRhCNPAJamKHX+14H-6_ecpDEVS_Q@mail.gmail.com>
Message-ID: <CA+FuTSdoCfj=vcQd3TcA9BRhCNPAJamKHX+14H-6_ecpDEVS_Q@mail.gmail.com>
Subject: Re: [net-next 01/13] net/mlx5e: Print a warning when LRO feature is
 dropped or not allowed
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 7:50 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> From: Huy Nguyen <huyn@mellanox.com>
>
> When user enables LRO via ethtool and if the RQ mode is legacy,
> mlx5e_fix_features drops the request without any explanation.
> Add netdev_warn to cover this case.
>
> Fixes: 6c3a823e1e9c ("net/mlx5e: RX, Remove HW LRO support in legacy RQ")
> Signed-off-by: Huy Nguyen <huyn@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 47eea6b3a1c3..776eb46d263d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -3788,9 +3788,10 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
>                         netdev_warn(netdev, "Dropping C-tag vlan stripping offload due to S-tag vlan\n");
>         }
>         if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
> -               features &= ~NETIF_F_LRO;
> -               if (params->lro_en)
> +               if (features & NETIF_F_LRO) {
>                         netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");

This warns about "Disabling LRO" on an enable request?

More fundamentally, it appears that the device does not advertise
the feature as configurable in netdev_hw_features as of commit
6c3a823e1e9c ("net/mlx5e: RX, Remove HW LRO support in
legacy RQ"), so shouldn't this be caught by the device driver
independent ethtool code?
