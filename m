Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E003796BD
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 20:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhEJSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 14:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhEJSBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 14:01:46 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDAAC061574;
        Mon, 10 May 2021 11:00:40 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y2so22779915ybq.13;
        Mon, 10 May 2021 11:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DD7i9qP2zN0Z45a4kHjOpZVD+4L/ua3ViHeI4lwRELc=;
        b=IL2s8Hb7zDWa8g/9CV8Jb+WWAuQVB1p2p9P8TlFVvTshfkkmISMTkFnqmGvY9SqgCa
         fNALF0iXQZxdTXmTqgY+7Bgf+sfxnXjBwjIG/We2/dDEnC+LoR/pb/jPu/gQh609yyH3
         UOtZzR25YpmKeZWNeV8OTCMZFF4/Ns7EyMpXeFSUCIh+JoraxQ/6mJW0H5XFewKINZ5o
         DfZ8ubBAj6wL/O8xobf5RGrDxiwIRIS8PGJpH9leNhLODhQHBKcV8fIuYRKAXHGRj/wb
         V8pKPOA3kgqkQq+dlBU23AgJAVjq8crihk5953Ozj70o0KVyNhxtVnDvvWduK38M0QQn
         489Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DD7i9qP2zN0Z45a4kHjOpZVD+4L/ua3ViHeI4lwRELc=;
        b=Rxc7qd8T2nFA8o5sTHyO8Vf+ZS1mGg6cSVGpCO+cCgXipbhk9CMvDFuY7oR66Dr2+M
         nquRrJutOsY9e1SG1sKStT3DnK8jGWDpGX5D0KJVSDr9h/kUp24DKigsdhKPPHbkXs8n
         AkDpAe2gj6SwS85tivKNiww5qu6HBLgg4rAP53AGkV2LbebKx3nydw3Ft0+Tgk+k84pA
         TOvw3h9aTe3x8/MIrhS8bJtbS/wPxt8dvdI9nwoooDaXc/Ms0BDAsfjcD52aCwx10OEK
         p0iE2HhdEC5bOfteQCy33dild18S7ZnEa5j4Y6VGyHxIOsQiSNu+h8ZNvaCh+y+vH6Ts
         zY3w==
X-Gm-Message-State: AOAM530pRETffzRz+xMffSOeMZHieKNst0j5HyzhuM7CjGLngIv7Ag3Y
        O1UTx/EMx9OunSioWchE3QcupGyQ6jn/SeiBL6g=
X-Google-Smtp-Source: ABdhPJwQU1cEqxBN12jhvT65LdxQ/CLSsoiOa5153me5eZSjvbk3csssQsl3fuFGQD6nmk4Kk6j9UIQHAtUJK/7mWBA=
X-Received: by 2002:a25:3357:: with SMTP id z84mr33990965ybz.260.1620669640289;
 Mon, 10 May 2021 11:00:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210510124315.3854-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210510124315.3854-1-thunder.leizhen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 May 2021 11:00:29 -0700
Message-ID: <CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: Delete an unneeded bool conversion
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 5:43 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> The result of an expression consisting of a single relational operator is
> already of the bool type and does not need to be evaluated explicitly.
>
> No functional change.
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---

See [0] and [1].

  [0] https://lore.kernel.org/bpf/CAEf4BzYgLf5g3oztbA-CJR4gQ7AVKQAGrsHWCOgTtUMUM-Mxfg@mail.gmail.com/
  [1] https://lore.kernel.org/bpf/CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com/

>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e2a3cf4378140f2..fa02213c451f4d2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1504,7 +1504,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
>                                 ext->name, value);
>                         return -EINVAL;
>                 }
> -               *(bool *)ext_val = value == 'y' ? true : false;
> +               *(bool *)ext_val = value == 'y';
>                 break;
>         case KCFG_TRISTATE:
>                 if (value == 'y')
> --
> 2.26.0.106.g9fadedd
>
>
