Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDDDDE96F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbfJUK1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:27:34 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52493 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfJUK1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:27:34 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M7KKA-1iNbtw3Liu-007i8U for <netdev@vger.kernel.org>; Mon, 21 Oct 2019
 12:27:33 +0200
Received: by mail-qt1-f181.google.com with SMTP id c21so20139458qtj.12
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 03:27:32 -0700 (PDT)
X-Gm-Message-State: APjAAAVpNFJfhOHcfy6ajIZOoSiUAIEPguAA3CLrY4v5e8S9HaHCW8SE
        lCtLifYsbWm26qMxoSwpLecpF9hgStjXx3VW4mI=
X-Google-Smtp-Source: APXvYqx+o6h3GrENMk92oLRBMoI8YIMY/xHPIvlrcEMz+eBa0TV7rhg2d5lOWhuneE6lApuzqtlWQbcPd9cTA2nOLYk=
X-Received: by 2002:a0c:fde8:: with SMTP id m8mr23198779qvu.4.1571653651698;
 Mon, 21 Oct 2019 03:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191021000824.531-1-linus.walleij@linaro.org> <20191021000824.531-11-linus.walleij@linaro.org>
In-Reply-To: <20191021000824.531-11-linus.walleij@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 21 Oct 2019 12:27:15 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0BSN8jxxnjPgSoLFouM3awS9DryL0_4Qcwd_cwn+aUEg@mail.gmail.com>
Message-ID: <CAK8P3a0BSN8jxxnjPgSoLFouM3awS9DryL0_4Qcwd_cwn+aUEg@mail.gmail.com>
Subject: Re: [PATCH 10/10] net: ethernet: ixp4xx: Use parent dev for DMA pool
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:WsPuFt2Jsd8fjaFuDHsinvoT98mqRXfrQsjj82TocZSW2O3FAEO
 IMMgRvKQZ97K0d7asy5EDpfb6i73I+FSu96kC4z1UKhkViW3P3PizmL4BSER/E2FgS/nDjb
 weyf1ERJ5NMF+qUPm5602xSULEnbtFskhIBsgaLlx3MoBoBJbpeC5pmipxoqBJ+Q8VkvOuT
 KInX9mHGjlpnXn90rOL8w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zA12N3TwO78=:WkVEcASZE1A+Ylg45xvkc7
 gScKYRoXlDhKfxN7p9MUcRS6Ae4GHw/4nNspuzKi7hCTjGMFo7bugRytXlweuYib2PvdazfXu
 ub3e+JHlRoebXpVBYyEs7bwbZCMKBrDCgw8LDEo2EU7lsEgK+a3nAly5Kx7czGRAVpT9LTWrX
 VGEy+kUKhwdEASvMybbRAfLAv1KWM3GNNIHOCyTUXzI0qVxIDwfhViWA2XvqX3KFqL0J1BCoc
 GvNkrpbfqRmo4v+cjWbwKDWc4oD9MSaaQOLIiuuflznfUJVPRcmYIffbBacDGIyTkEEL8cu7b
 xb781+J7ldnVCqpkPQKdVduNvzSKkKtW8YrdGJF1Pi8jeHuSWW/UkspZahV+J718LEHmDouMd
 BZkbStZmBfYWxIttkIHuaBz7WFD7RfWlhdSAE+9VJVsoUPDHZiyJ2pmdw3bC5TeahylsOcTkn
 TZ1AInyXlJTEsboOIeXhkjxi/7QwGEYcbRvhVObl4v67nsTnactkLxagv02q5YI8K6HvjTWIZ
 BcOZ0pXaMs5+2/qP3iNWwKb/gxrGb3x1Fgz1PJ+Ww9TQgxfcFZDSgebwskydf6XPXv6pexl5/
 vjpP2WzXNyowx8U4X5V6Wcw4Ne9sIgc1bPHJ3xq57ugiAVpWxzUuv+DBSrX2MANbqZlmKklWj
 /m1R9ePsFXLy14YORglYru1er6edFAOfRRkfd+fIivpTM7tM6Rd0nN+o7kYcVu36z8gEjRCWY
 570F8+328xXjnO3I9K0ugCbW5wqJiQ+zj5WYMtgXRwHPsJjriCmPoKSL1sNyF+9XOggDdE0Tl
 0NeJuTiPKOlZzZYSAzR6Rg0sew6OrkvSI9hxu2Tou///HewCBWwvhBpvADmPJLi5UEiNhp/et
 SCOGSUJUO7ZnDl7lRsUQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 2:10 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> Use the netdevice struct device .parent field when calling
> dma_pool_create(): the .dma_coherent_mask and .dma_mask
> pertains to the bus device on the hardware (platform)
> bus in this case, not the struct device inside the network
> device. This makes the pool allocation work.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Has this always been broken, or can you identify when it stopped
working? It might be a candidate for stable backports.

> ---
>  drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> index 0996046bd046..3ee6d7232eb9 100644
> --- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
> +++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> @@ -1090,7 +1090,7 @@ static int init_queues(struct port *port)
>         int i;
>
>         if (!ports_open) {
> -               dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
> +               dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
>                                            POOL_ALLOC_SIZE, 32, 0);
>                 if (!dma_pool)
>                         return -ENOMEM;
> --
> 2.21.0
>
