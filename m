Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB248456167
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhKRR3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhKRR3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 12:29:05 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93F9C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:26:04 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id f18so29718460lfv.6
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bGKGCRi1CjX5Tk0YG9VwyMS9D1+fF37vLBxcoxpJhhw=;
        b=BYzEVJ11rzgWHa+0FKvkm1lway1bF9n7mlR/JJvqP5uOXZRAH+0oHJN3dfN3HPK4JS
         tVSs45mnEaIgR2TW14NaC68Oe3amFkqnBOieM73+VJ1aNoxvpby4MxH+n+HEyXJYWs8+
         ew6st4d5996co9sxGIZwFL2mID8fyzWbmv9XXDIdFYEs2+pq3kccaqWTkYRoZn+ArsIv
         bQmIYf0kTcQaeOeuRkvJoTbjJJo41SzpCbXe/S7Dc17KTRDZlE/HP+hULcbptQ7juzZB
         zqqGnjxLoIk2YJqu/UiSLrCQO1KVZuJEGEC5jK5YBsZDtcI+aeeRWY6cZSDs4ZWZ+0pK
         zoyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bGKGCRi1CjX5Tk0YG9VwyMS9D1+fF37vLBxcoxpJhhw=;
        b=nE20LbVCPE8k15p9tetkP54iYQyY3MlP1fHLp7pIEa2HCqMLHNYfUakZoDqWq9zxTc
         kK14SvaiLc5yjC8ylvfyV1G/ylmM5Kgr1DK7kR53xEGFJdCxucA7+xwMIAh0pEJaIJ25
         OIpl4wQ7waHghGKH8+Dg8bfDEAa6qNjcb+B8WC1pF8pd0eRVlIOiJS6FPYpIeleoWV3G
         0pWmoOD3+cn/7zACWgDEOxB3tZHemAM2ueiprKWIgIMJ7c+DLeXT8OnnJDKgY3byo4NS
         n9D8/RaXlf/Iqb0866TZ6kk+cwpXhDxWbPFg4retPo9MHB3Z+DEj9b1j8/zuZhxtoK4Q
         6Qvw==
X-Gm-Message-State: AOAM531+7Jm73AoI+wYwVs+RUw6i74WCd2lROk++1GVT/PlLrw0d2eI/
        67XLYGbvqzNsSnJ05PTJRAy2wrbA6o0CwRSLv64=
X-Google-Smtp-Source: ABdhPJw8GA7/PCBXqs6am/0afmVF7hkgHKUYD36vdfTKoSfCKU+jTXi5l3/Z/bRO/CoSzihH/8JW4HL6OhTC5N/Wl8Y=
X-Received: by 2002:a05:6512:33a8:: with SMTP id i8mr26558589lfg.497.1637256362945;
 Thu, 18 Nov 2021 09:26:02 -0800 (PST)
MIME-Version: 1.0
References: <20211118142720.3176980-1-kuba@kernel.org> <20211118142720.3176980-5-kuba@kernel.org>
In-Reply-To: <20211118142720.3176980-5-kuba@kernel.org>
From:   Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date:   Thu, 18 Nov 2021 21:27:03 +0400
Message-ID: <CA++WF2OR40tHPnONJqE3m69T+1Y4nLMDJUB21RpAvLEgMTYijg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] ipw2200: constify address in ipw_send_adapter_address
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 at 18:27, Jakub Kicinski <kuba@kernel.org> wrote:
>
> Add const to the address param of ipw_send_adapter_address()
> all the functions down the chain have already been changed.
>
> Not sure how I lost this in the rebase.
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: stas.yakovlev@gmail.com
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> index 23037bfc9e4c..5727c7c00a28 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -2303,7 +2303,7 @@ static int ipw_send_ssid(struct ipw_priv *priv, u8 * ssid, int len)
>                                 ssid);
>  }
>
> -static int ipw_send_adapter_address(struct ipw_priv *priv, u8 * mac)
> +static int ipw_send_adapter_address(struct ipw_priv *priv, const u8 * mac)
>  {
>         if (!priv || !mac) {
>                 IPW_ERROR("Invalid args\n");
> --
> 2.31.1
>
