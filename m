Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564A38DCF7
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfHNSZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:25:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46869 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729131AbfHNSZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:25:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id q139so5777706pfc.13
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dj4KAX4oiOlHlXT1vUtLuT1vYXvby2UL10kTcUOrNVU=;
        b=aVjpnrjNjtev+v0rOvs8haZujsIS+SKSncIJWkjkfISt434mYvH9ZXTPW8wBD5bGPC
         o8SRuLOWToAWroJNjgL9mzkUg7pZL0rg9adAlql+R+78AjCyhV+sU3P0rmKZnNHhDq+Y
         cEVrmLlVbqJ8RvxQU6HF1D7onDXD6y79XuyZ3wBbiBgOCGGad+d2p7DoBN0YkWVjtRv8
         cXA/Tx/2iGDkeuY0xn6JOEzKk9UW/gSVIlOE4AeQfT6Nx8/GYwWEGSP/Oo++j+VyTGNj
         hEtA5/sv1Nv3mH/GumYlvjJsqc92BETeL6d2WiboFtAgkgTSaiGT3u7TkLGJ7IJ9RIRF
         L3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dj4KAX4oiOlHlXT1vUtLuT1vYXvby2UL10kTcUOrNVU=;
        b=mQtCWqh9S2bHRkOby17d4Cgwscux+zEKIe01R3UF/9UlXZg2K/TFtowUdeaAVfthXR
         o5qevzlQ1zAXW/ULIEXoAvIzRCsqk6wwWWXfS9Od7mHS6kg6ekFp1mSOBp9bY8yMYr9K
         QMk9BnB/biLgsUDNVEPWyhst13jpG6iqFQDrfxYn66vv52sT66/uv9/pDwvEr7YzW39p
         JnGN9E5fVY3elOvgjqQT/VbkoBcB8Vi1vZPjb2DLRNXDbeh4AMFILxrrjtBhA+co4QWy
         TaHHqm981DjkcUGG03Z/MjDyOY2VjdYyRoo99k9pfYb4iB2BNVHrI6ljjc7R9hUzHKfd
         YMsQ==
X-Gm-Message-State: APjAAAUDHRaWekNkuel2Wuue155LDm0o0sxsR3+vIKur0NuQN8YhaWMC
        b/Sce3ZBZXPdp55byFP6qp/h26Cb2hbHk5L9WJQkAw==
X-Google-Smtp-Source: APXvYqz/twTfpGfqt66xJCwQIFEHEknWQOpgXq5rPtScTXaG6QgAeHl3K1Dxc6WBbeihQAjQJx847aX1lF7z3cIPudw=
X-Received: by 2002:aa7:984a:: with SMTP id n10mr1326537pfq.3.1565807120061;
 Wed, 14 Aug 2019 11:25:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190814165809.46421-1-natechancellor@gmail.com>
In-Reply-To: <20190814165809.46421-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 14 Aug 2019 11:25:08 -0700
Message-ID: <CAKwvOdmvBkXu3JTp6c9yRKgPTv6pQ=_jrCsBzU5dJLD2xRvVxg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_bitwise: Adjust parentheses to fix memcmp
 size argument
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 9:58 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> clang warns:
>
> net/netfilter/nft_bitwise.c:138:50: error: size argument in 'memcmp'
> call is a comparison [-Werror,-Wmemsize-comparison]
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                       ~~~~~~~~~~~~~~~~~~^~
> net/netfilter/nft_bitwise.c:138:6: note: did you mean to compare the
> result of 'memcmp' instead?
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>             ^
>                                                        )
> net/netfilter/nft_bitwise.c:138:32: note: explicitly cast the argument
> to size_t to silence this warning
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                       ^
>                                       (size_t)(
> 1 error generated.
>
> Adjust the parentheses so that the result of the sizeof is used for the
> size argument in memcmp, rather than the result of the comparison (which
> would always be true because sizeof is a non-zero number).
>
> Fixes: bd8699e9e292 ("netfilter: nft_bitwise: add offload support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/638
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

oh no! thanks for the patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  net/netfilter/nft_bitwise.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index 1f04ed5c518c..974300178fa9 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -135,8 +135,8 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
>  {
>         const struct nft_bitwise *priv = nft_expr_priv(expr);
>
> -       if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
> -           priv->sreg != priv->dreg))
> +       if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
> +           priv->sreg != priv->dreg)
>                 return -EOPNOTSUPP;
>
>         memcpy(&ctx->regs[priv->dreg].mask, &priv->mask, sizeof(priv->mask));
> --
> 2.23.0.rc2
>

-- 
Thanks,
~Nick Desaulniers
