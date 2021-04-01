Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E67635234E
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhDAXR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDAXR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B29C61104;
        Thu,  1 Apr 2021 23:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319076;
        bh=ymiY8ZTzmhOuR3loDD2Rxst61HGOdmFWPlL6kzcgJes=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=F5b9czjGxoWcTVYm9K81Z7AbRg+iHFONt3L7rIdIqu70KIq7Hq2Ugdi4GoVCvhPU7
         V2nmHs/JqM1xxglvZSswsdT+FNL9FNXUI/OgcwugKkM6bDOYXtWIqZpqlUk8HC23e1
         vE+xxCIfYqLfcSS76j2fwj6NBHPW92rZtreXPwed7Q36N+wZ9pcV7e0PKEbVSiF55x
         VBp6zrb8ige7PjdXRoxcarKYF0rrOzXWZIrs55bzX5LmQLwMxOCmTouhbl2im0kl45
         oo2HhODHHSvG19pJiX8xfgQZb7lu7nT4iJe7gu3DN820NmvLbSqexMngGYubJ5jbRA
         O2u6ETTLwLJlA==
Received: by mail-lj1-f176.google.com with SMTP id a1so3963803ljp.2;
        Thu, 01 Apr 2021 16:17:56 -0700 (PDT)
X-Gm-Message-State: AOAM532NA5Z1NVm3SbmOJCoXVYxveoq+vaWUqDctZfd24/406hBKBUCr
        3UL2xK23eyY12PGN+WnnvGDCm/cSmEtO0d+ACY4=
X-Google-Smtp-Source: ABdhPJzKeVQTL3CELzeA2yV1t99oNC3zlANJ1CjJTEA05FRxs4UxvsKoOzmgSd05y2P3yi52l8aaJ+gH+AKpAHMW4Lg=
X-Received: by 2002:a05:651c:200b:: with SMTP id s11mr6382133ljo.177.1617319074579;
 Thu, 01 Apr 2021 16:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210401142301.1686904-1-yangyingliang@huawei.com>
In-Reply-To: <20210401142301.1686904-1-yangyingliang@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 1 Apr 2021 16:17:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6H6z5-35ja37fzC9JNYcG+P2zV3y6SCFqPwfaMVSp9tw@mail.gmail.com>
Message-ID: <CAPhsuW6H6z5-35ja37fzC9JNYcG+P2zV3y6SCFqPwfaMVSp9tw@mail.gmail.com>
Subject: Re: [PATCH -next] libbpf: remove redundant semi-colon
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 10:58 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Please add a short commit log.

Thanks,
Song

> ---
>  tools/lib/bpf/linker.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 46b16cbdcda3..4e08bc07e635 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -1895,7 +1895,7 @@ static int finalize_btf_ext(struct bpf_linker *linker)
>         hdr->func_info_len = funcs_sz;
>         hdr->line_info_off = funcs_sz;
>         hdr->line_info_len = lines_sz;
> -       hdr->core_relo_off = funcs_sz + lines_sz;;
> +       hdr->core_relo_off = funcs_sz + lines_sz;
>         hdr->core_relo_len = core_relos_sz;
>
>         if (funcs_sz) {
> --
> 2.25.1
>
