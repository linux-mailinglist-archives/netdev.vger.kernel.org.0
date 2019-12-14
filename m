Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C70F011EF70
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLNBGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:06:24 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36158 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfLNBGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:06:24 -0500
Received: by mail-qt1-f196.google.com with SMTP id q20so76192qtp.3;
        Fri, 13 Dec 2019 17:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ur3AS21W7QWJfWRDEFH0RYs0tRqzBV19xUV525O1AqQ=;
        b=V22iCSG/qaQy7i9fZVnJtikGPZnWa71+EBqeUJP96dfx9NTQvOOi4Wote/3itavCIA
         c6LNRCIIAy1nS+j5pe7TkhsxE7ANVaGOlYJoLw4vGoFLdR3Qyyrb9jaW88KIMSMZpRM4
         TbZR/H7IzdugX/OALPUg4zDo9F0PicXDqUzNtnwNORj44RMxWQuQIRVv+5WTUOauxTh6
         zKx1Hwf2cGRiEYjMz05bGhRaVTFFgXBWMXFQQLkzm3bD471UbFKQZYfi+BfzxGm6ODe+
         /jkt8LTbAXj3t+ff1SCXoAfE6JkDpBVCiMrkthayOrb2QoWouuu8Bfv8EIRDDd9PbNg4
         Ztjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ur3AS21W7QWJfWRDEFH0RYs0tRqzBV19xUV525O1AqQ=;
        b=XWBca3np94blrtH+ff01r3tlyHlhixE2t6Za5S5goAyfUs77lV/4SlKIvLdcX/F1eO
         VGNQkKK9VzZr40p+OyBZHmdSxtUykjuHKM+29ATmCT4CnPftN59A4J9cwu3H+havUDjQ
         1xM80aW128qbf330lzBo5E2KPYOGKVEZWxRJOw76bTZ5UeCxSCvz8ws278wCt46P/CxJ
         DvVCHEuSXoEvrU7SHxH4rBE1YcnQpxsDTw6epLoYFRLtUVUk4sU4BlAMHwxgGOTcmDJw
         zpMOB7RR3vQFfgyQOHNFQIOR952Z/1u6XnX1SSkwnxZC6GPsJX40DfqNfFTk496Fn53l
         /ZTQ==
X-Gm-Message-State: APjAAAWIueTGOMtR/24RlpmYart60ldoSRTV7VurNkY/CByTeh/gyL/2
        o18ITQIELcJpv0xHhst6aK/1y/GmrVYfp6ljP7M=
X-Google-Smtp-Source: APXvYqxygnaGQnR2ny7dVMP1YKj3Rn+AUmAnmLcvidk1bfn9m6G1D2mEU/egyi2wOucgKeNaKbt/LETqdK21LQDGcRY=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr14753355qtu.141.1576285582650;
 Fri, 13 Dec 2019 17:06:22 -0800 (PST)
MIME-Version: 1.0
References: <20191213223214.2791885-1-andriin@fb.com> <20191213223214.2791885-8-andriin@fb.com>
 <20191213234959.7qrvp5n3habe34pp@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191213234959.7qrvp5n3habe34pp@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Dec 2019 17:06:11 -0800
Message-ID: <CAEf4BzanTLig+Gpg7EWgw6KUBpGaTr8CrexK5p=G0uC=b=vvwQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 07/17] libbpf: expose BTF-to-C type
 declaration emitting API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 3:50 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 13, 2019 at 02:32:04PM -0800, Andrii Nakryiko wrote:
> > Expose API that allows to emit type declaration and field/variable definition
> > (if optional field name is specified) in valid C syntax for any provided BTF
> > type. This is going to be used by bpftool when emitting data section layout as
> > a struct. As part of making this API useful in a stand-alone fashion, move
> > initialization of some of the internal btf_dump state to earlier phase.
> >
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/btf.h      | 22 ++++++++++++++
> >  tools/lib/bpf/btf_dump.c | 62 +++++++++++++++++++++++-----------------
> >  tools/lib/bpf/libbpf.map |  1 +
> >  3 files changed, 59 insertions(+), 26 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > index a114c8ef4f08..1f9625946ead 100644
> > --- a/tools/lib/bpf/btf.h
> > +++ b/tools/lib/bpf/btf.h
> > @@ -126,6 +126,28 @@ LIBBPF_API void btf_dump__free(struct btf_dump *d);
> >
> >  LIBBPF_API int btf_dump__dump_type(struct btf_dump *d, __u32 id);
> >
> > +struct btf_dump_emit_type_decl_opts {
> > +     /* size of this struct, for forward/backward compatiblity */
> > +     size_t sz;
> > +     /* optional field name for type declaration, e.g.:
> > +      * - struct my_struct <FNAME>
> > +      * - void (*<FNAME>)(int)
> > +      * - char (*<FNAME>)[123]
> > +      */
> > +     const char *field_name;
> > +     /* extra indentation level (in number of tabs) to emit for multi-line
> > +      * type declarations (e.g., anonymous struct); applies for lines
> > +      * starting from the second one (first line is assumed to have
> > +      * necessary indentation already
> > +      */
> > +     int indent_level;
> > +};
> > +#define btf_dump_emit_type_decl_opts__last_field attach_prog_fd
>
> OPTS_VALID() is missing in btf_dump__emit_type_decl() ?
> Otherwise it would have caught above typo.

duh... right, very good catch, thanks!

>
>
> >       d->ident_names = hashmap__new(str_hash_fn, str_equal_fn, NULL);
> >       if (IS_ERR(d->ident_names)) {
> >               err = PTR_ERR(d->ident_names);
> >               d->ident_names = NULL;
> > -             btf_dump__free(d);
> > -             return ERR_PTR(err);
> > +             goto err;
> > +     }
> > +     d->type_states = calloc(1 + btf__get_nr_types(d->btf),
> > +                             sizeof(d->type_states[0]));
> > +     if (!d->type_states) {
> > +             err = -ENOMEM;
> > +             goto err;
> > +     }
> > +     d->cached_names = calloc(1 + btf__get_nr_types(d->btf),
> > +                              sizeof(d->cached_names[0]));
> > +     if (!d->cached_names) {
> > +             err = -ENOMEM;
> > +             goto err;
> >       }
> >
> > +     /* VOID is special */
> > +     d->type_states[0].order_state = ORDERED;
> > +     d->type_states[0].emit_state = EMITTED;
>
> Not following the logic with 1 + btf__get_nr_types(d->btf) and
> above init...
> type_states[0] is void. true.
> But btf__get_nr_types() includes that type_id=0 == void.
> So what this 1+ is for?
> I know it's just a move of old code. I just noticed.
> Would be great to add a comment.

btf__get_nr_types() does not actually include void, thus we need +1.
It is confusing, I agree, but is consistent throughout libbpf.

>
