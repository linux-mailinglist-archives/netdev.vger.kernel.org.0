Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F2F2312DA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgG1TjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgG1TjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:39:19 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD8BC061794;
        Tue, 28 Jul 2020 12:39:19 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v22so9873227qtq.8;
        Tue, 28 Jul 2020 12:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uC2eLVhYt5o2L3EkdXiZ0wHXR6DBNV6ezz2kj48c/z0=;
        b=KQrhII97xK/IbvNsvrVNdmyWZiavi1gwqjEEqo13uGZMzQxW3KtgJIQkEob1gcK3pB
         s6FhKZzctjAXZuzjjDpTjDmCSyrv2X2tyIAbNnzNrUjDvavRpXVvEOVVv0BTofhxv3Ip
         WQSj8E0ByFXGCuHMZsAvTtCQJgp9hKV5yuKE0yDgA4u65wa2ctuA938p64AwBTrkBnww
         OwbFKbosmf03WNZ2ln9AakAQ75ps1Uyix6TcrDWXDNvM8yxH1rHDcSEcVa1bBu3XPSq9
         ixaCkH3BhYyhsa9eiAH27OfCOIMWukgVNf4yewaqr24/C+1500ugF/xbUUzFoBQno26F
         5VRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uC2eLVhYt5o2L3EkdXiZ0wHXR6DBNV6ezz2kj48c/z0=;
        b=jY1FLh7wKtnr/SQMdtT8/SmmLsnodTo6dTr5ufFeF5xm5mCCvpJmp509vNK6sJY7Ho
         +iQZwwOaNQQCOa2vrPLSgwOfiHQtmshJcti8fZZC3HL6DT8OLdQQyy69lLCdjhXKD52B
         M9Lhfnlc8nyZPHBUG9TJDtilDYrhr+hOW38w2jUZDyEDDG9RmF3J/uwdFuO80ws+W3b8
         LiTzLF47847vZskIRW9V3SVNR0b6FjBAanA+HyC3p6j/gZsbXqvHPMRBDK/XBCkFA6kk
         jcBBiNHZlYQyLwCE6txEseW1D7DQXBKzV2TkjsxUAowj4x3v/FFSxL2C/4Z530xkiYQU
         ucTg==
X-Gm-Message-State: AOAM5327PJ2g08m6bmkUVFvCyUW2EXsAnlhYM1yzhs/owk0cxDbySMF1
        /iSADKLrlXs7cSAhxGXSzpJoovp63JWTjdN3SsM=
X-Google-Smtp-Source: ABdhPJxzZR5RCibQkvJ+m1K9hnWd7bVDC9RQwviR6fL5GPboW7oX/JyLWjTp9NyEYFk0eOOROlPca3nSmtk3qA79lK0=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr27833340qtd.59.1595965157839;
 Tue, 28 Jul 2020 12:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-9-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 12:39:06 -0700
Message-ID: <CAEf4BzbwJ+FXYWOK2k6UZ8X1f-2XQP1rRLFAFO6_OyK2iKv8Eg@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 08/13] bpf: Add BTF_SET_START/END macros
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

On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to define sorted set of BTF ID values.
>
> Following defines sorted set of BTF ID values:
>
>   BTF_SET_START(btf_whitelist_d_path)
>   BTF_ID(func, vfs_truncate)
>   BTF_ID(func, vfs_fallocate)
>   BTF_ID(func, dentry_open)
>   BTF_ID(func, vfs_getattr)
>   BTF_ID(func, filp_close)
>   BTF_SET_END(btf_whitelist_d_path)
>
> It defines following 'struct btf_id_set' variable to access
> values and count:
>
>   struct btf_id_set btf_whitelist_d_path;
>
> Adding 'allowed' callback to struct bpf_func_proto, to allow
> verifier the check on allowed callers.
>
> Adding btf_id_set_contains function, which will be used by
> allowed callbacks to verify the caller's BTF ID value is
> within allowed set.
>
> Also removing extra '\' in __BTF_ID_LIST macro.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h           |  4 ++++
>  include/linux/btf_ids.h       | 43 ++++++++++++++++++++++++++++++++++-
>  kernel/bpf/btf.c              | 14 ++++++++++++
>  kernel/bpf/verifier.c         |  5 ++++
>  tools/include/linux/btf_ids.h | 43 ++++++++++++++++++++++++++++++++++-
>  5 files changed, 107 insertions(+), 2 deletions(-)
>

[...]

> +#define BTF_SET_START(name)                            \
> +__BTF_ID_LIST(name, local)                             \
> +asm(                                                   \
> +".pushsection " BTF_IDS_SECTION ",\"a\";       \n"     \
> +".local __BTF_ID__set__" #name ";              \n"     \
> +"__BTF_ID__set__" #name ":;                    \n"     \
> +".zero 4                                       \n"     \
> +".popsection;                                  \n");
> +
> +#define BTF_SET_END(name)                              \
> +asm(                                                   \
> +".pushsection " BTF_IDS_SECTION ",\"a\";      \n"      \
> +".size __BTF_ID__set__" #name ", .-" #name "  \n"      \
> +".popsection;                                 \n");    \
> +extern struct btf_id_set name;
> +
>  #else

This local symbol assumption will probably at some point bite us.
Yonghong already did global vs static variants for BTF ID list, we'll
end up doing something like that for sets of BTF IDs as well. Let's do
this similarly from the get go.

>
>  #define BTF_ID_LIST(name) static u32 name[5];
>  #define BTF_ID(prefix, name)
>  #define BTF_ID_UNUSED
>  #define BTF_ID_LIST_GLOBAL(name) u32 name[1];
> +#define BTF_SET_START(name) static struct btf_id_set name = { 0 };

nit: this zero is unnecessary and misleading (it's initialized for
only the first member of a struct). Just {} is enough.

> +#define BTF_SET_END(name)
>
>  #endif /* CONFIG_DEBUG_INFO_BTF */
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 562d4453fad3..06714cdda0a9 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -21,6 +21,8 @@
>  #include <linux/btf_ids.h>
>  #include <linux/skmsg.h>
>  #include <linux/perf_event.h>
> +#include <linux/bsearch.h>
> +#include <linux/btf_ids.h>
>  #include <net/sock.h>
>
>  /* BTF (BPF Type Format) is the meta data format which describes
> @@ -4740,3 +4742,15 @@ u32 btf_id(const struct btf *btf)
>  {
>         return btf->id;
>  }
> +
> +static int btf_id_cmp_func(const void *a, const void *b)
> +{
> +       const int *pa = a, *pb = b;
> +
> +       return *pa - *pb;
> +}
> +
> +bool btf_id_set_contains(struct btf_id_set *set, u32 id)
> +{
> +       return bsearch(&id, set->ids, set->cnt, sizeof(int), btf_id_cmp_func) != NULL;

very nit ;) sizeof(__u32)

> +}
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 39922fa07154..49f728c696a9 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4706,6 +4706,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 return -EINVAL;
>         }
>

[...]
