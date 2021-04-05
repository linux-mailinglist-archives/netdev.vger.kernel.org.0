Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49603542A8
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237592AbhDEOQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237537AbhDEOQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 10:16:07 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E10FC061756;
        Mon,  5 Apr 2021 07:16:01 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 82so2068249yby.7;
        Mon, 05 Apr 2021 07:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wkzE6z3jlVm2CtBojLYq0ziEdm7E4Xl4LO0dFtmTEpw=;
        b=WRA6gOF50mK8Yydfg22tp/JRfwty1RZLFbHXGr/ilPwlupU1ZzeB9EJVjMzypHkwds
         AonT2GnqBrDJ7JWewO3XBYJ5Zc7OY0ITrQSkmVVNu9h45uIPQGlIBqVEolM89Q8/6YQK
         XYhxDmh9yIs+9HBusFGjUK2UVqgBeo1bwGMaQeXAaMkpRGDdqZc67cnNmb8TZpXhs2ZY
         4lvXFt62T6dHf3nRhpwvJN0lnS0HJXip/zVEJQYQKjmPZf8YW/Ma501lKV9IyhoFuNxM
         8QVp4yHP1gUxABZioxikRhgo0ktE8DmEc7h7fAU5qxEgM33fH9a2j2EOKdVNpEJXVFil
         GOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wkzE6z3jlVm2CtBojLYq0ziEdm7E4Xl4LO0dFtmTEpw=;
        b=VH8rrj+4VvIcApd6nFMA8blF4WgaLT3/bTGv9nWgR9H/XA+A/MLZPtiJDcMTaHPz07
         1p042AdPfLJ88rZLslg249inTt6UvOtk+0fEW0BNKdYd5IsomvrMqJQivewNPofooZai
         +h+gYYeq2ZeisRJAy/n5r5sVqGuYgjrAe7YwfZLD2niX06iOazIjtUW7sqzzzOFwfaPl
         ZnbeQThFQ7ZY0E6fZMwgjG1y4cGCC6uPggu/IbvLHy6V2o37GNDpdhLBpEN7annx20zO
         X2kp83nBbb9rZ+Dj+MHc1aDlHh73hRTMCZjAE2fxROScNP81jMT+GiBQYshBpNminvZN
         /gYw==
X-Gm-Message-State: AOAM530retP8O8j/ie/PH31im5OpLCTiwV7jY9Q9qg7QKYAruUJa+Haj
        iK2njB4eADou2zIGr1uTzEN7yqEUlQBJDZEsaeU=
X-Google-Smtp-Source: ABdhPJyU2Y+l2VCLhvR9N4qk/aIM8kE57PfiYGZCXApt3RUU/oGlxkTjEPV9ZloX1FqcfBUsq5biBqoYid5GnIKtnVg=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr34997409ybb.510.1617632160631;
 Mon, 05 Apr 2021 07:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210405040119.802188-1-hengqi.chen@gmail.com>
In-Reply-To: <20210405040119.802188-1-hengqi.chen@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Apr 2021 07:15:49 -0700
Message-ID: <CAEf4BzYz3KYJ0xSZhJfTfNWC4J2ibyVsuy842W0w3sNs1JW12w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix KERNEL_VERSION macro
To:     Hengqi Chen <hengqi.chen@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 4, 2021 at 9:01 PM Hengqi Chen <hengqi.chen@gmail.com> wrote:
>
> Add missing ')' for KERNEL_VERSION macro.
>
> Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
> ---

Applied to bpf-next, thanks.

>  tools/lib/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index cc2e51c64a54..b904128626c2 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -51,7 +51,7 @@
>  #endif
>
>  #ifndef KERNEL_VERSION
> -#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c))
> +#define KERNEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c)))
>  #endif
>
>  /*
> --
> 2.25.1
>
