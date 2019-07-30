Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33CD7B4FF
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387799AbfG3V0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:26:22 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43955 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387515AbfG3V0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:26:22 -0400
Received: by mail-qk1-f196.google.com with SMTP id m14so21965586qka.10;
        Tue, 30 Jul 2019 14:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DUmHrQZSPYgkbpUjDhxftzMr4O6/AO3CAcE2vqo5BMw=;
        b=C4vu9PIr+3UQ8pNt2eS+Mc9N8XI/szM2Qu8dIMb5Rbg7zoIBUJHnJbfM1MkUmydOf/
         +awzK5hzepS3GWcPDRbwK29Pv4LNakA4TTDv8rOUZj4VQ/KGGAWRgwFXD5mvVharyXHz
         m3y9X3tZYidTDwb0tPZuBcjQYHz1ZsBd44zTxTu+UsoAAQ6PlEl0+PG4lu0Tt55eh9dh
         weioQvMDzFlUCl7A7xVe5LIeA4/c3J5A4+EmIBr4Y7+9hgfEGM5GexnE85BJNShXziBy
         82uNECBlXVKZyQx47dHQqs5uhiIfn1m2jTveYNZ+7VmSXl5UBEHQhzarmFuf8dNcEvTN
         2H7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DUmHrQZSPYgkbpUjDhxftzMr4O6/AO3CAcE2vqo5BMw=;
        b=UHJa3/6wc9UdzwkDRevrXU1PjQMyIXM+NpE2mN7NIw09GAaIIWP4VbtPrAFkzfy2zj
         al2PEwXaC9K9Nr7MGe7Zi/BX+uVKJOEJjW4JtJVp5i5CyIqQN749LpWWxj8jIDwkMgDu
         G4J2sv6Lke4Fh8lLFqa1ij/Qr9bOjsy/I2HzZr62mPtVmS1AJNjA+iwR1CdRKR5b7Nel
         dAY/8nHCMLe6iKIDgnrr+0hX2L2gZcTGgEqPb0GvxTcHpnq/uaNP0w81qHLSjyc4vTz1
         JepK9UKudKMVcDo79beHSCSNrVYuH+Lu2y4xu+oHS/8mAcVDAkKwalb5clRXbNRgnvhF
         uVIw==
X-Gm-Message-State: APjAAAVOG8si73AQ9MC2wUnw2jvrX5cCcLEFlEch5nDRnTUj2PGAunsU
        taq+gsFSHeHrOXJ7gMw/6OIKBM1CDzLfujVJwWz+onGjHNo=
X-Google-Smtp-Source: APXvYqwbxvERf4CbwVd69GMBqMdhnwn3uLyqsXpBvP2Q86boSx+/WDylu8da6AV7SWgEsGU8yoqelA7ubQU4cBGWjYo=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr77483894qkj.39.1564521981501;
 Tue, 30 Jul 2019 14:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190730195408.670063-1-andriin@fb.com> <20190730195408.670063-4-andriin@fb.com>
 <87422673-525B-461B-B487-EB16386CAB25@fb.com>
In-Reply-To: <87422673-525B-461B-B487-EB16386CAB25@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jul 2019 14:26:10 -0700
Message-ID: <CAEf4BzakowCqkCkBdGPJCZNU3MpDf1yBhzOXL2pos1tPiUH0mQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 03/12] selftests/bpf: add BPF_CORE_READ
 relocatable read macro
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 2:24 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add BPF_CORE_READ macro used in tests to do bpf_core_read(), which
> > automatically captures offset relocation.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/testing/selftests/bpf/bpf_helpers.h | 19 +++++++++++++++++++
> > 1 file changed, 19 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > index f804f210244e..81bc51293d11 100644
> > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > @@ -501,4 +501,23 @@ struct pt_regs;
> >                               (void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
> > #endif
> >
> > +/*
> > + * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> > + * relocation for source address using __builtin_preserve_access_index()
> > + * built-in, provided by Clang.
> > + *
> > + * __builtin_preserve_access_index() takes as an argument an expression of
> > + * taking an address of a field within struct/union. It makes compiler emit
> > + * a relocation, which records BTF type ID describing root struct/union and an
> > + * accessor string which describes exact embedded field that was used to take
> > + * an address. See detailed description of this relocation format and
> > + * semantics in comments to struct bpf_offset_reloc in libbpf_internal.h.
> > + *
> > + * This relocation allows libbpf to adjust BPF instruction to use correct
> > + * actual field offset, based on target kernel BTF type that matches original
> > + * (local) BTF, used to record relocation.
> > + */
> > +#define BPF_CORE_READ(dst, src) \
> > +     bpf_probe_read(dst, sizeof(*src), __builtin_preserve_access_index(src))
>
> We should use "sizeof(*(src))"
>

Good point. Also (dst) instead of just (dst). Will update.
