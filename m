Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7551E7854
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgE2I2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgE2I17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:27:59 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B82C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:27:58 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s18so1479281ioe.2
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3d129KIQl0F/HD1hAf9TNqbvJlvdS5cc8KsVfjCHT5Q=;
        b=wmyW81JabzxHJmyCKMgZjhesXeaxlHAgtiSlQtfNNLqtFcCrytSXj05vrtsugNI+4e
         cfEaRb4P/p456XvH6fTzAvynFbm1j8iN/KG5+cIDq8dpjbfm1pMTjOf60KV8RWik3/de
         1eaGl0ZLxmBp0eYX6Oh3hGpLro16xeOKrrUwZLm/j4wIIVouEbL6btDd3cWH6rTNnWWM
         yItf/W3AGeYP32m8aYT1kn81XaPibh0YxX9TkvEfkjFoKK/hOH21th+HLU9QeZvS7qMP
         wxJZLuvTclR/UhJOiystbHeZen80bdCUIz+slilZhz2xIv7VNwGFp8WcxCZcr7rDbe87
         TR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3d129KIQl0F/HD1hAf9TNqbvJlvdS5cc8KsVfjCHT5Q=;
        b=M3/EJriECK//VJYhlfpiY5tN4Tgke7QMusLQZUKrw0WsI8Qp4r3ysc2OeyXFpU8YPs
         yx9ghvqzcEdJIGnyquxcquvPH6rewmuPn7cPRmYhFEKiu3JSyVkIVWuPQ1bbe+Wll7ac
         uDcyQ+KGtxY70n85lR0WME7j8iv/NNBDq3707gzUsJYzciQ96TfqoqaPSZNsUjodeztZ
         TDRfdhSfMzQskx+9u0iH9a1kXi/yWLF4bPm/QDlRDuVNsaogUcm0GIPSaxPpP4Snriln
         DO3r61gRHBi21L8yutEW2IEMLmswiUxbyvs9foZnoAvN8OJ9Bt6Hs/vXMNQ5+0Rk8Pr9
         VMFQ==
X-Gm-Message-State: AOAM533V27TUI1LPfOuTuFTng0HKVqwWxGmbPBBOwCqAQgOe3gMWhWHU
        dlnjyqryaYq+D9r75sYBFTYybEwB/nUg3k+L1rdZdg==
X-Google-Smtp-Source: ABdhPJwA8vRDCN9N0HPnWhWtdnh8yznfwlfh5vLhi00vaN8ZbQ3tavDm+I4SrAQgg7Tnm8hKYE5T5eYY2+qznSroVnY=
X-Received: by 2002:a5d:9e55:: with SMTP id i21mr5656308ioi.130.1590740878066;
 Fri, 29 May 2020 01:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200529082648.19677-1-brgl@bgdev.pl>
In-Reply-To: <20200529082648.19677-1-brgl@bgdev.pl>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Fri, 29 May 2020 10:27:47 +0200
Message-ID: <CAMRc=Md+KMpa-6f2rpd=fbR-xmCzaR3QypAk3FvMHpeyNzUX=g@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: mtk-star-emac: remove unused variable
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 29 maj 2020 o 10:26 Bartosz Golaszewski <brgl@bgdev.pl> napisa=C5=82(a=
):
>
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> The desc pointer is set but not used. Remove it.
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/=
ethernet/mediatek/mtk_star_emac.c
> index 8596ca0e60eb..7df35872c107 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -746,15 +746,12 @@ mtk_star_ring_free_skbs(struct mtk_star_priv *priv,=
 struct mtk_star_ring *ring,
>                                            struct mtk_star_ring_desc_data=
 *))
>  {
>         struct mtk_star_ring_desc_data desc_data;
> -       struct mtk_star_ring_desc *desc;
>         int i;
>
>         for (i =3D 0; i < MTK_STAR_RING_NUM_DESCS; i++) {
>                 if (!ring->dma_addrs[i])
>                         continue;
>
> -               desc =3D &ring->descs[i];
> -
>                 desc_data.dma_addr =3D ring->dma_addrs[i];
>                 desc_data.skb =3D ring->skbs[i];
>
> --
> 2.26.1
>

Cr*p I forgot to tag it for net-next. David let me know if you want me
to resend it.

Bartosz
