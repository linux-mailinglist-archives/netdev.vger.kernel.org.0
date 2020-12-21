Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB2B2E013F
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgLUTvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgLUTvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:51:08 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994D8C0613D3;
        Mon, 21 Dec 2020 11:50:28 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id l207so12450097oib.4;
        Mon, 21 Dec 2020 11:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EKHYKYvJjr3SdNV5NJTpZB/AVd6o6kMyWNYzPfDbcJc=;
        b=YnXqy4eXAFUfb3hjUiHXsYInF3Oc2mtZnO/TB8nfwAaTHeA37m/d6ewTHREipO8DV7
         Hh7p4CfD3gHI7eMtGXxeOQqxb0sLu4BSSjT/qMZBuEU5ucUzX74/tb1ckPOEyxsk8Lmf
         Jl7d8+KNZ/KPwq3hNvuK8HsnneueBecghDuCixOWKMWKXduVPPfm7C7sYEIvg4lzQpTI
         Ufe1LmNSMDPB3asTurRECDfSaMLCWCvpm6GvDYkbDIwney/WkQqT3lCUab4KloXfVGD/
         37eNollIh5mENPH6JICo0VdKF3jw/+roj1BwC9SUBc3TKkcsUwyEDNzfQ+S2zvzjUQx7
         FwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EKHYKYvJjr3SdNV5NJTpZB/AVd6o6kMyWNYzPfDbcJc=;
        b=WMcilFwJeIBcNqyNpL/GzpbEPC7nnv2g8FAX+SWahLRTTMnrK+PIMgS0lkXSu0iU8w
         /dqFMWVhWO6ZsjYi8fRJlMsdz65gD+lePT3Tv+aRwSmGbTEJGPYwMM7JpqrwJCEkwtpg
         Y/Jiu0zmt1y1jUpS+S9OgWWeoNklkRPsd9FDsVhjXkl8/PefT2YeaTKx5uPpE10+JvpE
         eaV3PMk8u4tQAqTQR4b4XQGu6c6b7lZGxEdHulSkzD7fOI1WGkgW24uJWmKdN2B/OzLU
         2E09+ln0IN/fSapwSFl1lDSLtx/bFfja3YunRP8kadicpTy4JwK5LBwG+I1zgNhhglIW
         ZOfg==
X-Gm-Message-State: AOAM5327lvRhy1JuscwoE0rPUbqp5mLvIYIzUey319onGBTroGX+FNxF
        Wa68zvEeZV8E8VhvjZPS83uLmVj4iKcPmIYh43o=
X-Google-Smtp-Source: ABdhPJyTF8Ofb7lnfU1nNVBGH3z83jxGYZHPN6muNzO3z236Fn3gpYFV724Nul736pJL7mdxpOixxpXuNOkl2dee1oA=
X-Received: by 2002:aca:3306:: with SMTP id z6mr1799369oiz.141.1608580228062;
 Mon, 21 Dec 2020 11:50:28 -0800 (PST)
MIME-Version: 1.0
References: <20201219135036.3216017-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20201219135036.3216017-1-martin.blumenstingl@googlemail.com>
From:   Thomas Graichen <thomas.graichen@googlemail.com>
Date:   Mon, 21 Dec 2020 20:50:14 +0100
Message-ID: <CAOUEw12Ldi9Kv2Gd=OCEgeVa+jv_FM1HqGRQBiEYCo==8PcrWA@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: ignore the second clock input
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, khilman@baylibre.com,
        jbrunet@baylibre.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 19, 2020 at 2:52 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> The dwmac glue registers on Amlogic Meson8b and newer SoCs has two clock
> inputs:
> - Meson8b and Meson8m2: MPLL2 and MPLL2 (the same parent is wired to
>   both inputs)
> - GXBB, GXL, GXM, AXG, G12A, G12B, SM1: FCLK_DIV2 and MPLL2
>
> All known vendor kernels and u-boots are using the first input only. We
> let the common clock framework automatically choose the "right" parent.
> For some boards this causes a problem though, specificially with G12A and
> newer SoCs. The clock input is used for generating the 125MHz RGMII TX
> clock. For the two input clocks this means on G12A:
> - FCLK_DIV2: 999999985Hz / 8 = 124999998.125Hz
> - MPLL2: 499999993Hz / 4 = 124999998.25Hz
>
> In theory MPLL2 is the "better" clock input because it's gets us 0.125Hz
> closer to the requested frequency than FCLK_DIV2. In reality however
> there is a resource conflict because MPLL2 is needed to generate some of
> the audio clocks. dwmac-meson8b probes first and sets up the clock tree
> with MPLL2. This works fine until the audio driver comes and "steals"
> the MPLL2 clocks and configures it with it's own rate (294909637Hz). The
> common clock framework happily changes the MPLL2 rate but does not
> reconfigure our RGMII TX clock tree, which then ends up at 73727409Hz,
> which is more than 40% off the requested 125MHz.
>
> Don't use the second clock input for now to force the common clock
> framework to always select the first parent. This mimics the behavior
> from the vendor driver and fixes the clock resource conflict with the
> audio driver on G12A boards. Once the common clock framework can handle
> this situation this change can be reverted again.
>
> Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
> Reported-by: Thomas Graichen <thomas.graichen@gmail.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Tested-by: thomas graichen <thomas.graichen@gmail.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> index 459ae715b33d..f184b00f5116 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> @@ -135,7 +135,7 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
>         struct device *dev = dwmac->dev;
>         static const struct clk_parent_data mux_parents[] = {
>                 { .fw_name = "clkin0", },
> -               { .fw_name = "clkin1", },
> +               { .index = -1, },
>         };
>         static const struct clk_div_table div_table[] = {
>                 { .div = 2, .val = 2, },
> --
> 2.29.2
>
