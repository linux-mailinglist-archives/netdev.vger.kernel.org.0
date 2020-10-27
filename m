Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE629CB5C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374211AbgJ0VjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:39:20 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:47009 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374206AbgJ0VjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:39:20 -0400
Received: by mail-vs1-f68.google.com with SMTP id s6so1716864vss.13
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mRF0dXHaJY2NmFr/CiLE+YsmP6ywhNL3cKU7DNNO3oo=;
        b=fQuIPlcmTNC2AtrU+C+hNLuU6z/khewH0OxxJ5r0rRrYerGrNqzd+vv3zd/D4rUHAv
         rkf3I5cFrDuRQCpJxj842unRB+QU5GGirOizFZ5smatvB++Y+hl1N+xhoZAfPovnek0h
         J8NDnN0Prd9iMIxBXZkTeiCz8aFrw3N+wpMt/Mlt/SHbrGIxNER4Ed9QTU0cj8mCCaal
         l/AEKr2LHtdPnth1Q3OKHeyAkxSRehr4EjVsZq5O5sWbJFvU0j4x/j2q4g51/eIXiIDX
         W849TEbIfGiok7luG7BO4KbNaRIa0dgCxcf6FukfBpc3PuPEivZR0WtEn2CBEQlIr5pK
         CWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRF0dXHaJY2NmFr/CiLE+YsmP6ywhNL3cKU7DNNO3oo=;
        b=msLZNY3P0wZrGnuUmhFozO8ijg1qcEPOsjR8ozplY96ueABJCkoeHBKZGvmjG7esTH
         cG/EVE1blgN7LQ+XTsSMSdiKQK0LlFzonAOsbctQiwr0yY7WRCQkx0TtRvt7Gd5kNP5g
         1odZOVaMkDGxAfDuKMdL38MX8F3IcROIkkdUoZX47f3KKVkqh1jqIB+90dJ2a2/kxScT
         ua5+XJiQ/Jd/7/P1y3MF/N66kzrKgtpGHls3ZPPavSZs8Qg0dvW5m1XBXQ0YBTLIV2jx
         okAf8F7WBW/ubYj2Se6tlv5FeUVEVDm8s7eaDheLscJKK+OtQQ/SKBgvacN3n7+J2+Lx
         Zgsg==
X-Gm-Message-State: AOAM532UO0bcCOP7YmXzuoOn3LQrEHiGYxSx6yHFLnkfpbq/BCKyDyir
        dLL7s6k9CDiAFizMhVDMUB3SuNoGzGE=
X-Google-Smtp-Source: ABdhPJxWQmqKKwXJHQOFprciFuRk8NxsKKfVoUV0kKhRAHxwVbpcAT4v2mBqaud8EU0G2GenTayU1w==
X-Received: by 2002:a1f:6091:: with SMTP id u139mr3290866vkb.17.1603834317046;
        Tue, 27 Oct 2020 14:31:57 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id m205sm316045vkm.9.2020.10.27.14.31.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 14:31:56 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id z10so721480vkn.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:31:55 -0700 (PDT)
X-Received: by 2002:a1f:c149:: with SMTP id r70mr3260653vkf.1.1603834315501;
 Tue, 27 Oct 2020 14:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603804282.git.camelia.groza@nxp.com> <434895b93ba0039abc94d5fdfcd91a27f2d867cb.1603804282.git.camelia.groza@nxp.com>
In-Reply-To: <434895b93ba0039abc94d5fdfcd91a27f2d867cb.1603804282.git.camelia.groza@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Oct 2020 17:31:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTSftPvRLjkU-efkDkqhUdS0hSCtSEwufzbAPKnSSjTNcKg@mail.gmail.com>
Message-ID: <CA+FuTSftPvRLjkU-efkDkqhUdS0hSCtSEwufzbAPKnSSjTNcKg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] dpaa_eth: fix the RX headroom size alignment
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     madalin.bucur@oss.nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 11:04 AM Camelia Groza <camelia.groza@nxp.com> wrote:
>
> The headroom reserved for received frames needs to be aligned to an
> RX specific value. There is currently a discrepancy between the values
> used in the Ethernet driver and the values passed to the FMan.
> Coincidentally, the resulting aligned values are identical.
>
> Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 1aac0b6..67ae561 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2842,7 +2842,8 @@ static int dpaa_ingress_cgr_init(struct dpaa_priv *priv)
>         return err;
>  }
>
> -static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
> +static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
> +                                   enum port_type port)
>  {
>         u16 headroom;
>
> @@ -2856,9 +2857,12 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
>          *
>          * Also make sure the headroom is a multiple of data_align bytes
>          */
> -       headroom = (u16)(bl->priv_data_size + DPAA_PARSE_RESULTS_SIZE +
> +       headroom = (u16)(bl[port].priv_data_size + DPAA_PARSE_RESULTS_SIZE +
>                 DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE);
>
> +       if (port == RX)
> +               return ALIGN(headroom, DPAA_FD_RX_DATA_ALIGNMENT);
> +
else?

>         return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
>  }
>
> @@ -3027,8 +3031,8 @@ static int dpaa_eth_probe(struct platform_device *pdev)
>                         goto free_dpaa_fqs;
>         }
>
> -       priv->tx_headroom = dpaa_get_headroom(&priv->buf_layout[TX]);
> -       priv->rx_headroom = dpaa_get_headroom(&priv->buf_layout[RX]);
> +       priv->tx_headroom = dpaa_get_headroom(&priv->buf_layout[0], TX);
> +       priv->rx_headroom = dpaa_get_headroom(&priv->buf_layout[0], RX);

This can be just priv->buf_layout
>
>         /* All real interfaces need their ports initialized */
>         err = dpaa_eth_init_ports(mac_dev, dpaa_bp, &port_fqs,
> --
> 1.9.1
>
