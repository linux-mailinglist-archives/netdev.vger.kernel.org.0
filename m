Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58792E332
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfE2R0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:26:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45027 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfE2R0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:26:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id x47so200666qtk.11;
        Wed, 29 May 2019 10:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDUWmCv2vpg5tql25VaXZrlYPqh/xixKPSNMeuY3PNI=;
        b=RKDeRPtHx2rkzAGZSPINfomEjEJQ5S4GhKXb+tYE+YoK+VJ+6UTYLqR71jMLXKpnmK
         mbiA/K/Jf25sdobwzEYWZjLCRJ6Onzl0T1uNeHXJdNAjrOpubT9c/0tl6kKglZlrZs04
         s5QB9Sdv9t2RHb6Akn/MURgTprr2rB3lZlhItvRatFUC3HLaD4mDd4Vb2gf0j1AgrmuW
         7CucPVWSawm48KfYOPrh4tQAaBy3T4ETnf62mIiboX0aXVz2uGmCjZxaP5RhHBcY5uJA
         dMB3nXLgfN8uNcXzDUgGj0ohrdzh48SIizXrf7DbROxYfelMGnJ7rRtWBdPVoy+0o6xA
         ETwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDUWmCv2vpg5tql25VaXZrlYPqh/xixKPSNMeuY3PNI=;
        b=ewo1P+gLUSWa0zt0ujWLlLgJa4EZUi5mRjKMXo2sSbvQixvaEsa0uqZj9s9anP5bIc
         vYb1ve8k2QMtTY7LKO0IwBPU7ZYx4z17yjRaywzyrY27NfIpESp/pcge1fDCjUxD2q2p
         MW16S53ziCsR1zNWI4c0rjvSAA3nqbiAbQnyJfg3pm4rLV8Hu6MPFt8SlI6c0n1OesOL
         OxemP/GTGcrgaZJL65M38if4/jUpVPaHGm/2jMP0jWOG5Ep1RkbN/jCei0tUTbRgoLQ6
         ydXzUEAwa+2mKbbD/i47OJHTSLUU4iAeq75+biXEkn1havraiHn7OFb12dBcUlNLcekG
         luvg==
X-Gm-Message-State: APjAAAXXL0Ig1HNf3xI+/a+WpFZ6LfJwM90Hf06nzTX5UdtBaXfRPReK
        SEKeea6jQ1/SWw0vEJafcRfsDGcaPu6fxGQ2hOQ=
X-Google-Smtp-Source: APXvYqzIRkZ6MJtPDpRhSddLHZjsXV+t22O6P6rQoA+NRv996yMc6fWr9jOIhOC7v1MzbmzpnFw26WZjE0xcEDxVv/I=
X-Received: by 2002:a0c:bf4f:: with SMTP id b15mr6990604qvj.24.1559150763691;
 Wed, 29 May 2019 10:26:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-9-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-9-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:25:52 -0700
Message-ID: <CAPhsuW7xXXRX+mAe35xhRfDNBqPco+nwrAyVyVu6eEMwM1YO7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/9] libbpf: typo and formatting fixes
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 6:14 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> A bunch of typo and formatting fixes.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e3bc00933145..9d9c19a1b2fe 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -505,7 +505,7 @@ static struct bpf_object *bpf_object__new(const char *path,
>
>         obj->efile.fd = -1;
>         /*
> -        * Caller of this function should also calls
> +        * Caller of this function should also call
>          * bpf_object__elf_finish() after data collection to return
>          * obj_buf to user. If not, we should duplicate the buffer to
>          * avoid user freeing them before elf finish.
> @@ -574,8 +574,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
>                 }
>
>                 obj->efile.elf = elf_begin(obj->efile.fd,
> -                               LIBBPF_ELF_C_READ_MMAP,
> -                               NULL);
> +                                          LIBBPF_ELF_C_READ_MMAP, NULL);
>         }
>
>         if (!obj->efile.elf) {
> @@ -594,9 +593,9 @@ static int bpf_object__elf_init(struct bpf_object *obj)
>         ep = &obj->efile.ehdr;
>
>         /* Old LLVM set e_machine to EM_NONE */
> -       if ((ep->e_type != ET_REL) || (ep->e_machine && (ep->e_machine != EM_BPF))) {
> -               pr_warning("%s is not an eBPF object file\n",
> -                       obj->path);
> +       if (ep->e_type != ET_REL ||
> +           (ep->e_machine && ep->e_machine != EM_BPF)) {
> +               pr_warning("%s is not an eBPF object file\n", obj->path);
>                 err = -LIBBPF_ERRNO__FORMAT;
>                 goto errout;
>         }
> @@ -1438,7 +1437,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>                         }
>
>                         if (map_idx >= nr_maps) {
> -                               pr_warning("bpf relocation: map_idx %d large than %d\n",
> +                               pr_warning("bpf relocation: map_idx %d larger than %d\n",
>                                            (int)map_idx, (int)nr_maps - 1);
>                                 return -LIBBPF_ERRNO__RELOC;
>                         }
> @@ -1797,7 +1796,7 @@ bpf_object__create_maps(struct bpf_object *obj)
>                         }
>                 }
>
> -               pr_debug("create map %s: fd=%d\n", map->name, *pfd);
> +               pr_debug("created map %s: fd=%d\n", map->name, *pfd);
>         }
>
>         return 0;
> --
> 2.17.1
>
