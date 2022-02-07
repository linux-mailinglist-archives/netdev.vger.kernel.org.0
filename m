Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129E34AB795
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 10:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiBGJeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245335AbiBGJZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:25:56 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0E9C043181;
        Mon,  7 Feb 2022 01:25:55 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 13so10359471qkd.13;
        Mon, 07 Feb 2022 01:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/dxAF3x0GJD/yOWW2//ISQPOYVEfNyN7bTdBahKbf8=;
        b=X55bg7//XsI+mNmzED7n8IC1BbbSnen+0lp9U3WpmhieixI6C5F0a0eMGYWPQp9/+t
         WOYhdY/3xwoEVQD/0ndQRCIChHDI18spnb5FlyYTYouTHXfFcOx/GHIjvvaLQivTijFO
         k3pQF96fzxnIGUx/hRipI16mf3YJlkg9NHMP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/dxAF3x0GJD/yOWW2//ISQPOYVEfNyN7bTdBahKbf8=;
        b=74JgpikP9Arj7T2+kRHs/ZVqSaBCD66cU7KvjOl84lunXI25WSQol9dAWwapSxN9MW
         qOKNCL9JN2H6XtbMGq+sF4ZdBEYRH6Trb5PyPgSyws6zkAuVF3jKIFImyjeBSekFf016
         9Cuk8ypsXBZuoyGB5fmm27XrROZEr+c7GrNrx4jsZSH19ZE9X9zK2zxEk2Opc1OEWqsW
         VSIc9TrulamUBapyiz7hbe8z7TdPx3lRro7Le2u/eHdjnICJDoT5sl0RlpSrKPETm5CY
         EFrknG5zbBllQM5r3/2kPsxJeP0u+uprytoNcB89j74y+cxMGleuAi+bic5MKe3w4jx/
         egbg==
X-Gm-Message-State: AOAM532JCoiVue3AumkNDwhEKtm7kub7QRHb++oZ7iDng2P6I7+iZeUF
        ymBTyUfD/NWq5pDqnAHOnyMwQ27DGy/qc00TRWk=
X-Google-Smtp-Source: ABdhPJyDzNdH8+TZMzgRoftC9sJcMcIAki0rXOsSE251InEIM467OEgMjjTjX5n8rS8lJq8A3IXiBXMyKlmkEf5AIu8=
X-Received: by 2002:a05:620a:44c7:: with SMTP id y7mr5967705qkp.347.1644225954191;
 Mon, 07 Feb 2022 01:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20220207084912.9309-1-cai.huoqing@linux.dev>
In-Reply-To: <20220207084912.9309-1-cai.huoqing@linux.dev>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 7 Feb 2022 09:25:42 +0000
Message-ID: <CACPK8Xcs-qsO5COcSPZBsShhJWtDwfhreuYfkBy1pLXh8nz3Ow@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: litex: Add the dependency on HAS_IOMEM
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Feb 2022 at 08:49, Cai Huoqing <cai.huoqing@linux.dev> wrote:
>
> The helper function devm_platform_ioremap_resource_xxx()
> needs HAS_IOMEM enabled, so add the dependency on HAS_IOMEM.
>
> Fixes: 464a57281f29 ("net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()")

That looks wrong...

$ git show --oneline --stat  464a57281f29
464a57281f29 net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()
 drivers/net/ethernet/litex/litex_liteeth.c                 |  7 ++-----
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 21
+++------------------
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |  7 +------
 drivers/net/ethernet/ni/nixge.c

That's a strange commit message for the litex driver. Similarly for
the ni driver. Did something go wrong there?

A better fixes line would be ee7da21ac4c3be1f618b6358e0a38739a5d1773e,
as the original driver addition also has the iomem dependency.

> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> ---
>  drivers/net/ethernet/litex/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> index f99adbf26ab4..04345b929d8e 100644
> --- a/drivers/net/ethernet/litex/Kconfig
> +++ b/drivers/net/ethernet/litex/Kconfig
> @@ -17,7 +17,7 @@ if NET_VENDOR_LITEX
>
>  config LITEX_LITEETH
>         tristate "LiteX Ethernet support"
> -       depends on OF
> +       depends on OF && HAS_IOMEM
>         help
>           If you wish to compile a kernel for hardware with a LiteX LiteEth
>           device then you should answer Y to this.
> --
> 2.25.1
>
