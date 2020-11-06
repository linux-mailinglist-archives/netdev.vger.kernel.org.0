Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A222A9F1C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgKFVcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbgKFVcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 16:32:54 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF531C0613CF;
        Fri,  6 Nov 2020 13:32:54 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id a12so2372291ybg.9;
        Fri, 06 Nov 2020 13:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cHcHgXcRJlXjahuwxlXNQLlz52MRv1C06pV1zHy8MSY=;
        b=Rg3fB6qrZs8sy2GckFNiyCIx74uH5F+E9NTYX6KH8N17ObhUlXAPisch75/UgzIsLr
         6rt8q8JbGgqNbq0NZpzNvRUemywChuv6VU2Lrbm8F5zPZpJnaiUe0PL9rLVpBgEnbCrh
         ood+6cqWsRHzhHchp9U8MVTsxMnb3+ONSzZS/A4/I8rntqTfBHoDGaj7L00LXEFZfJVw
         5RH0tvJ2VFBPVmoa1FIlkle6npURscxHBoOLFbvhtJaIdEC8748jeqwYyoCh5lHPw9qp
         vngsQaV4rvGbRzIFAHrYE0W6zDlTBcVoFvV8q66Xnu1saK4RMJ2NrrLMhV0POuymlOcL
         UFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cHcHgXcRJlXjahuwxlXNQLlz52MRv1C06pV1zHy8MSY=;
        b=X6HX/nhjgjwQ6X5eaNY0fknVXB0+3a+1sY/Ayu0YlRNvDRTlveLrgyxWbbtixhgfn7
         gJ7f7JZrEoi39FfG1o5f4PJNnADAw0c79R83lQkhT/LlBp3akc8xuYuLWQ7FtegEWMIN
         yREm/3qH6rzS7aE0E9snYErZznvWXGu/UcC2Xcmih/qIc0V4iRTQkiuqDeSDjcqPNL7d
         wZjU6bvHzCFwByVfK+LibagOxNt5KxngHPuHYSHNhUeI/5nXV7OBst2NtdSNSQggme9y
         tpSTzEhzAuSsmi0+FPDk1xlyaW2MJjiTIWrsmf5QdBViHiihmh3ttDglXhvNA7zAPi2C
         lhFA==
X-Gm-Message-State: AOAM533+yyDZpCOrWsI6yTsZqokxp6rsupAE5yqLgOkrD2K2z2tHmPvW
        aSsDeKDTTEsyCzlZJgR/c57fISJnXDgRJfDnXqk=
X-Google-Smtp-Source: ABdhPJw+xunr/HQDnP2jT985pevV7liCe9lpCITmmzYsfo1cqOjlA2O1DA5spBRlYf1BtDOza9eIYYXXaeiv1ezPyR8=
X-Received: by 2002:a25:da4e:: with SMTP id n75mr5615969ybf.425.1604698374190;
 Fri, 06 Nov 2020 13:32:54 -0800 (PST)
MIME-Version: 1.0
References: <1604646759-785-1-git-send-email-kaixuxia@tencent.com>
In-Reply-To: <1604646759-785-1-git-send-email-kaixuxia@tencent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 13:32:43 -0800
Message-ID: <CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Remove unnecessary conversion to bool
To:     xiakaixu1987@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 11:12 PM <xiakaixu1987@gmail.com> wrote:
>
> From: Kaixu Xia <kaixuxia@tencent.com>
>
> Fix following warning from coccinelle:
>
> ./tools/lib/bpf/libbpf.c:1478:43-48: WARNING: conversion to bool not needed here
>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 313034117070..fb9625077983 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1475,7 +1475,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
>                                 ext->name, value);
>                         return -EINVAL;
>                 }
> -               *(bool *)ext_val = value == 'y' ? true : false;
> +               *(bool *)ext_val = value == 'y';

I actually did this intentionally. x = y == z; pattern looked too
obscure to my taste, tbh.

>                 break;
>         case KCFG_TRISTATE:
>                 if (value == 'y')
> --
> 2.20.0
>
