Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2608A216333
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgGGA4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGGA4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:56:21 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDEDC061755;
        Mon,  6 Jul 2020 17:56:21 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g13so30519684qtv.8;
        Mon, 06 Jul 2020 17:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6fw6WKZ6UGWkbhJSWGi9QKbnCAhXFQhP/a1wNjXzL7E=;
        b=BM2/xDn2u4GzfPlLnZ5VTKzreIgwXV37Y2sWWoWnmUgrzDscS51yC3QZyTBEVlTiXA
         d7JY4IfLRGZxy10VSMI+LA0Y9SeQ1cTQj4TDa5GnhHes7zfEDIxJau3zUwZZK5dw7bnt
         wRUG3VsRyiGi/7bAXxr6mVsHTWDE2fvpSYLG9q0OFbeGikfY32DzAgZQ4lYnzg5tQNf7
         tloYIoXEFsfXdRLnNzlpC0/N7cMfqDVs+eWC7cjNWCoW6SIgdMoTiVmaTtvXSVBCClCV
         8QpTT9MLPVA6jW7fN5w19ar5i++xuiYLLmDVfJvNCKGP5wlRNbPE0ujZPmu3uGkiJUrq
         FVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6fw6WKZ6UGWkbhJSWGi9QKbnCAhXFQhP/a1wNjXzL7E=;
        b=OafGxkbI26+upNCSnIq0xLaWaZyGCRorQnhhEbw2goXJcBvLke04UOUxPuI79wkG61
         LzErL9Dabr3v1AgPZy2NYgHdDD+unp5EwJWInzzKMO8b6lg/Qn9vailuqHR+WzXqgOwx
         ZclyXnSRVpgJEUGN0BRNOFhxnw2Qb3mBWY8RpEXXsVIPL3xSlo+XLJWLG5LKMCzxhCDM
         pV0GvS/spWzuFtw8lF2ZiZ39My9yR1/+SGx/K1EDlQZX9a+ncnS0oC8A/aMKnIKCtK4Z
         NjJfXcoHAh+qn0Oi510vjjQGR8R/EeCp42L2gMz5zhR/oJwLQjZscN1MZMTPkmMzkyBC
         utZw==
X-Gm-Message-State: AOAM530ABKjIC6ZSOxtHyg/NgKE+zIzKYVh0N6Kh+V6Ml6dPU6vE+TWL
        zDei5vU6E0+AZ/GoABKpetENvrL6SK5v6KargZUqkZX4mI8=
X-Google-Smtp-Source: ABdhPJyAMwSeOwPoYeRqPtKp3y5DdJFg17HMn7Rd5NYJ3Ru3eYT4AIkoOG/Yw7fpG6WkAnum8ro4GT92PRMMOu4BcYs=
X-Received: by 2002:ac8:345c:: with SMTP id v28mr22648232qtb.171.1594083380281;
 Mon, 06 Jul 2020 17:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200703095111.3268961-1-jolsa@kernel.org> <20200703095111.3268961-9-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 17:56:09 -0700
Message-ID: <CAEf4Bza9Mcu4d9BCbmPGw8EepRYdM-sTAoctdQX_ZCpdxfyCjg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 8/9] tools headers: Adopt verbatim copy of
 btf_ids.h from kernel sources
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 2:53 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> It will be needed by bpf selftest for resolve_btfids tool.
>
> Also adding __PASTE macro as btf_ids.h dependency, which is
> defined in:
>
>   include/linux/compiler_types.h
>
> but because tools/include do not have this header, I'm putting
> the macro into linux/compiler.h header.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/include/linux/btf_ids.h  | 87 ++++++++++++++++++++++++++++++++++
>  tools/include/linux/compiler.h |  4 ++
>  2 files changed, 91 insertions(+)
>  create mode 100644 tools/include/linux/btf_ids.h
>
> diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
> new file mode 100644
> index 000000000000..d317150bc9e3
> --- /dev/null
> +++ b/tools/include/linux/btf_ids.h
> @@ -0,0 +1,87 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_BTF_IDS_H
> +#define _LINUX_BTF_IDS_H
> +
> +#include <linux/compiler.h> /* for __PASTE */
> +
> +/*
> + * Following macros help to define lists of BTF IDs placed
> + * in .BTF_ids section. They are initially filled with zeros

One more inconsistency with .BTF_ids vs .BTF.ids (probably same in the
original header, which I missed).

> + * (during compilation) and resolved later during the
> + * linking phase by btfid tool.

typo: resolve_btfids tool

> + *
> + * Any change in list layout must be reflected in btfid
> + * tool logic.
> + */
> +

[...]
