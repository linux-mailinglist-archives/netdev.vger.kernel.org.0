Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8F11C6075
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgEESue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgEESud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:50:33 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B68C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 11:50:31 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f18so2752994lja.13
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQtcPUQW49oPTnT+jASB+pu5t+m5qPdUelhle+W5F4o=;
        b=e2LM4c7y4U0BetC/gB0eIa7BcxIovrqW2+yMivftL2EUsrm9A/3tzPHnkWrENn0+BY
         3u8nlKnzNbvWltqUbePhaEVeITEBqdy3oJ/OoqwDOACo021vaWG3fpFzoZBwAEfpJ/T7
         +AgIzXtc4NJ1zsQ+y6SrWc1RKchP8F8XxTSv08dWWyQ2BtBnzBt+iy4L92tZ3UliSHEx
         lZPLffC2w/YnG5vf5M2YiUUcpWIt7S3jEiV8hAHP9h79nVayw4X1+qTG0d8wF3MY8iSJ
         v9f/mCqFam0KZFjTCQpO/p7SAEWfWjm3aKaNwCqNALVOt0eWz/CsLXXLRBCOZRGKAVY5
         N1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQtcPUQW49oPTnT+jASB+pu5t+m5qPdUelhle+W5F4o=;
        b=Sx+QNLv7NgVVueQTyaZShC1YOa7vdqQ/wuviXZWoVPUlwKjnfxr+sUSW4MBLJYRz+e
         hviOZ/T5fcNkR42OFWhnVH0h4AvevbZNHNCYf7LPDI3xk6LE4Wpk5XGbn7B0f3H7qeT3
         nZnO8kl3GWu6EVMlkdX0+u8P2oAK9XNErnaqc7mzs3FB8KwiCEGZ0z5IX4CSSRdq8YMH
         G3JfiDNUiV9LbB8vXWCsPCfiR2jMD+LDrcIMecxToiiRSVE7/ME9ORaZmBh/5x3eBEVO
         0pWQaDOKZqldfFvfzEtK6J3ahPDY1UZ/PJWcF926pxjIeBGvOnRN3yHxdfyjDBY1oWu8
         nlOg==
X-Gm-Message-State: AGi0PubVAHX9oxjmInVzEccYoXMDJrBd6Mj8s7GWkdBHzHDNYnMo3Sik
        yLquwvLJFlCV7Pbog4fkIbyhy2wU/0AXLWF4sdKevA==
X-Google-Smtp-Source: APiQypKvjCJ8PklB3LOXCvVyQOThS4XpKMQ/Afaf/e/kP6nt/5BFFzQYKIqd2OgadCHb/8wFTCM6UEj3k7Ta0f50ic0=
X-Received: by 2002:a05:651c:107a:: with SMTP id y26mr2697805ljm.80.1588704629773;
 Tue, 05 May 2020 11:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200505162123.13366-1-grygorii.strashko@ti.com>
In-Reply-To: <20200505162123.13366-1-grygorii.strashko@ti.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 5 May 2020 20:50:18 +0200
Message-ID: <CADYN=9KZ9GSBv+VOA0MSLHcW312sEOX+T+h5GNyaaAridaLXuA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: fix build
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 at 18:21, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>
> It's possible to have build configuration which will force PTP_1588_CLOCK=m
> and so TI_K3_AM65_CPTS=m while still have TI_K3_AM65_CPSW_NUSS=y. This will
> cause build failures:
>
> aarch64-linux-gnu-ld: ../drivers/net/ethernet/ti/am65-cpsw-nuss.o: in function `am65_cpsw_init_cpts':
> ../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685: undefined reference to `am65_cpts_create'
> aarch64-linux-gnu-ld: ../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:(.text+0x2e20):
> relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `am65_cpts_create'
>
> Fix it by adding dependencies from CPTS in TI_K3_AM65_CPSW_NUSS as below:
>    config TI_K3_AM65_CPSW_NUSS
>    ...
>      depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS
>
> Note. This will create below dependencies and for NFS boot + CPTS all of them
> have to be built-in.
>   PTP_1588_CLOCK -> TI_K3_AM65_CPTS -> TI_K3_AM65_CPSW_NUSS
>
> While here, clean up TI_K3_AM65_CPTS definition.
>
> Fixes: b1f66a5bee07 ("net: ethernet: ti: am65-cpsw-nuss: enable packet timestamping support")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Reported-by: Anders Roxell <anders.roxell@linaro.org>

Tested-by: Anders Roxell <anders.roxell@linaro.org>

> ---
>  drivers/net/ethernet/ti/Kconfig | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 4ab35ce7b451..988e907e3322 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -99,7 +99,7 @@ config TI_K3_AM65_CPSW_NUSS
>         depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
>         select TI_DAVINCI_MDIO
>         imply PHY_TI_GMII_SEL
> -       imply TI_AM65_CPTS
> +       depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS

Don't we want to move this so it is below the other 'depends on' ?

Cheers,
Anders

>         help
>           This driver supports TI K3 AM654/J721E CPSW2G Ethernet SubSystem.
>           The two-port Gigabit Ethernet MAC (MCU_CPSW0) subsystem provides
> @@ -112,9 +112,8 @@ config TI_K3_AM65_CPSW_NUSS
>
>  config TI_K3_AM65_CPTS
>         tristate "TI K3 AM65x CPTS"
> -       depends on ARCH_K3 && OF && PTP_1588_CLOCK
> +       depends on ARCH_K3 && OF
>         depends on PTP_1588_CLOCK
> -       select NET_PTP_CLASSIFY
>         help
>           Say y here to support the TI K3 AM65x CPTS with 1588 features such as
>           PTP hardware clock for each CPTS device and network packets
> --
> 2.17.1
>
