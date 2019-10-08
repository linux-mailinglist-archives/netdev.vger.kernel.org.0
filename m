Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1C6CF28F
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbfJHGPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:15:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40675 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729926AbfJHGPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:15:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id m61so12360461qte.7;
        Mon, 07 Oct 2019 23:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SPhsJZ9V+Ps0Y3DV3PzfFZJ26AKcfxUtCRWQQyH5LHM=;
        b=lW+m23hMNwsO3lRqwBQk3PxkIrdmtMN123wjA1jaUW06Esy/JH7BxnY2IuivpctZGS
         no8dLNDk3fNCqqt0AND2AIb4LYlRBbvcQlRhHutGcrVaswrv0R/HiOO/x7ajOnXuvdBi
         MtB6q1g3Q3SHIqZQbbRb3o2kS2I6AgKKznoCDU2P12tY9BzT2UuFnQfDEGDOoW83ZzET
         +pmKadcHAcQC1JekzLvGkyVF6KFjsFF6CvWxQwCl0Na7gZnVdqZfUotjf4FnrgejNIDs
         LhwM1VfnoolwbGVGtiMDBhERJV6QwzNvhGtMaOouxpokSxqhZ0gcOwC14TgYWMimcx4t
         tFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SPhsJZ9V+Ps0Y3DV3PzfFZJ26AKcfxUtCRWQQyH5LHM=;
        b=QY9PTIpaMJw78YBY17WSXKN5V8bSYf6sq3ArgizuadJFOU1RnLhPKilbnzi+HS2dCo
         VkQ6leV9wJA3Dk3lzmH03WMUnqSfjd0Vcar/8CQFsPmicHumkTmOsWo4wC2T+Jcu9zrF
         LMWqdluJ7BmJPaUTaSxdO/GZ75wpSv8Q16MeVsW1CslMe+K67rvH0zLUZbkC10SNFUTj
         1TbImpzx63CknC96fkPMaD9Ftow1UELBQU75SYL3mmaUPQGKrrwsrpHWitgVuJEd5+F6
         8nVgKmBJuM7ncEzP1j7yxu3VaSv2Ph5xKAPsxtlcbm5+JXf3l8zTgTGRwswSEkstHTz9
         vyzA==
X-Gm-Message-State: APjAAAVNpxKUUh0zUesXepkpj1DIqYeMdxsyPciMNoS2cuBsT8WQ2xJ7
        DMdjugnmZe7pQFoIXTQVtZDeTD95I+qmFpf2XFY=
X-Google-Smtp-Source: APXvYqwzC5sfe2IBQ8N7m49KTeUqldof2NDTEWpTu0oBBtZa9cMG9IlwANya4O8eVxABp6P7/SDYKoKXEjOfCVSH3rI=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr33770365qtq.141.1570515349119;
 Mon, 07 Oct 2019 23:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191007224712.1984401-1-andriin@fb.com> <20191007224712.1984401-7-andriin@fb.com>
 <035617e9-2d0d-4082-8862-45bc4bb210fe@fb.com>
In-Reply-To: <035617e9-2d0d-4082-8862-45bc4bb210fe@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 23:15:37 -0700
Message-ID: <CAEf4Bzbe8mKFfd9yAN-i=f6jG50VL5SEqjVJTBcUe8=5eStYJA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 6/7] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO
 helpers
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 9:56 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/7/19 3:47 PM, Andrii Nakryiko wrote:
> > Add few macros simplifying BCC-like multi-level probe reads, while also
> > emitting CO-RE relocations for each read.
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ...
> > +/*
> > + * BPF_CORE_READ() is used to simplify BPF CO-RE relocatable read, especially
> > + * when there are few pointer chasing steps.
> > + * E.g., what in non-BPF world (or in BPF w/ BCC) would be something like:
> > + *   int x = s->a.b.c->d.e->f->g;
> > + * can be succinctly achieved using BPF_CORE_READ as:
> > + *   int x = BPF_CORE_READ(s, a.b.c, d.e, f, g);
> > + *
> > + * BPF_CORE_READ will decompose above statement into 4 bpf_core_read (BPF
> > + * CO-RE relocatable bpf_probe_read() wrapper) calls, logically equivalent to:
> > + * 1. const void *__t = s->a.b.c;
> > + * 2. __t = __t->d.e;
> > + * 3. __t = __t->f;
> > + * 4. return __t->g;
> > + *
> > + * Equivalence is logical, because there is a heavy type casting/preservation
> > + * involved, as well as all the reads are happening through bpf_probe_read()
> > + * calls using __builtin_preserve_access_index() to emit CO-RE relocations.
> > + *
> > + * N.B. Only up to 9 "field accessors" are supported, which should be more
> > + * than enough for any practical purpose.
> > + */
> > +#define BPF_CORE_READ(src, a, ...)                                       \
> > +     ({                                                                  \
> > +             ___type(src, a, ##__VA_ARGS__) __r;                         \
> > +             BPF_CORE_READ_INTO(&__r, src, a, ##__VA_ARGS__);            \
> > +             __r;                                                        \
> > +     })
> > +
>
> Since we're splitting things into
> bpf_{helpers,helper_defs,endian,tracing}.h
> how about adding all core macros into bpf_core_read.h ?

ok, but maybe just bpf_core.h then?

> #define___concat, ___empty are very generic names.
> I'd rather contain the risk of conflicts to progs that are going
> to use co-re instead of forcing it on all progs that use bpf_helpers.h.
> With my btf vmlinux stuff all these bpf_probe_read*() wrappers
> hopefully will be obsolete eventually. So keeping them separate in
> bpf_core_read.h would help the transition too.
