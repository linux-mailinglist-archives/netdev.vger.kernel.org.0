Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B893D7AF2
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbfJOQOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:14:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45931 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfJOQOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:14:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id c21so31311097qtj.12;
        Tue, 15 Oct 2019 09:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PRGsT8GbvyRksuvDBmAjymIwvNsa6d6xWPHkkdbVceA=;
        b=UGd5PTUwkSSxUTBbU3Ms54idCmfjZhzuTlhKVwDIXzHXJ2732VJyBT80kraQ4LJ0Re
         yQTzFSh4Tg/Yf1qYzmzJMkhHlKgkPnCFFy52qAgSA34Tiz9X3vk8FCnroX/tL6ttmxuM
         A0OJmV6wM8QZmvwE85Xf2HIjbh/RCcWyzF5d4iEtbTeYlKke4dEXwAW6fkpu19ShD7+P
         z2WsR4xUyLVnZuYL2h+slIrS1KIZIZFjWrwxE20sWxTytoK7ZwsaNp2DQXxuQtMyLdE8
         C8llm0v5fEggmkStR1s9OWKNdfeaxtGFlgzS2uJuFBGVGQ+UBLIF4coS+jEA5P9W+Cz3
         Q+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PRGsT8GbvyRksuvDBmAjymIwvNsa6d6xWPHkkdbVceA=;
        b=JlEMCeogGAm2koC/V3FpG0maUW5gjVWxAQlA/HemQWbKr5y5OuqehHEXvjFz2D9IHx
         qavuZGWs9mp+EofPP39LCOWa+x9tE2njyuWZTtPGR4xjG7m9uaZ+jh2af74hoXTdwBYD
         CaFh1FSDd8f0J81bJ0WDDdQS1CeMKOHYilwi61jirEqR3O9/VXKKX88WQ0bOxCc2y3o4
         P+LQdgGasEApHgz5bIfwm8ocfUmfn1r/aWmZVlfnyBjrCQA+5FCTCovJPLWF9cYzkDgz
         cWc52d8TY0e62JNRmqm87XGm+xIn9zkmoTJ6OPfLshkvMpJfdKa0+V/gSAT1b0c78shH
         Kq+A==
X-Gm-Message-State: APjAAAUBTHj3ifr3i/9H69oXWEs87JKAwUQFmyxpmS7pM8E7T1IO9yCO
        Qc7qwJxeZH8WYS4F0O8Cv92FuGN/4b5QfvQwIKE=
X-Google-Smtp-Source: APXvYqzS+TVoGfADyugkQIgeGkfVKU97p5wIWeGCUahKundssFjNBZ5KiqyorXCPLJuSw0tp4wzSRsDaouAm2pocFJc=
X-Received: by 2002:ac8:379d:: with SMTP id d29mr37607271qtc.93.1571156060883;
 Tue, 15 Oct 2019 09:14:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191014234928.561043-1-andriin@fb.com> <20191014234928.561043-2-andriin@fb.com>
 <4c10947e-5d75-a224-8b9c-6af81fc07324@fb.com>
In-Reply-To: <4c10947e-5d75-a224-8b9c-6af81fc07324@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 09:14:09 -0700
Message-ID: <CAEf4BzafrChR-OwfYmu1qbkKuMMZzFQM6kQpb9nADWnYgMSSxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] libbpf: update BTF reloc support to latest
 Clang format
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

On Tue, Oct 15, 2019 at 8:15 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/14/19 4:49 PM, Andrii Nakryiko wrote:
> > BTF offset reloc was generalized in recent Clang into field relocation,
> > capturing extra u32 field, specifying what aspect of captured field
> > needs to be relocated. This changes .BTF.ext's record size for this
> > relocation from 12 bytes to 16 bytes. Given these format changes
> > happened in Clang before official released version, it's ok to not
> > support outdated 12-byte record size w/o breaking ABI.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ...> -/* The minimum bpf_offset_reloc checked by the loader
> > +/* bpf_field_reloc_kind encodes which aspect of captured field has to be
> > + * adjusted by relocations. Currently supported values are:
> > + *   - BPF_FI_BYTE_OFFSET: field offset (in bytes);
> > + *   - BPF_FI_EXISTS: field existence (1 if field exists, 0 - otherwise);
> > + */
> > +enum bpf_field_reloc_kind {
> > +     BPF_FRK_BYTE_OFFSET = 0,
> > +     BPF_FRK_EXISTS = 2,
> > +};
>
> Comment above doesn't match the enum.

he-he, you can see that I went back and forth with names :)

> Also in patch 4 :
> +enum bpf_field_info_kind {
> +       BPF_FI_BYTE_OFFSET = 0,   /* field byte offset */
> +       BPF_FI_EXISTS = 2,        /* whether field exists in target kernel */
> +};
>
> Do you expect that .btf.ext encoding to be different from
> argument passed into __builtin_field_info() ?
> May be better to design the interface that it always matches
> and keep single enum for both?
> I don't like either FRK or FI abbreviations.
> May be
> BPF_FIELD_BYTE_OFFSET
> BPF_FIELD_EXISTS ?
>
> These constants would need to be exposed in bpf_core_read.h and
> will become uapi as soon as we release next libbpf at
> the end of this bpf-next cycle. At that point llvm side would have
> to stick to these constants as well.
> It would have to understand them as arguments and use the same in .btf.ext.
> Does it make sense?

yeah, it does. My thinking was that we already have two built-ins that
share the same BTF relocation (__builtin_preserve_access_index() and
__builtin_preserve_field_info()), so I figured it might be worth-while
to not couple low-level relocation and bulit-in parameters together,
because it might be the case in the future where we'll be emitting
multiple relos from single built-in or some other arrangement.

But I think it's ok to couple enum definitions for now. In the end,
it's just numbers, so if we ever need to diverge, it will be possible.
The only exposed constants are those that are in bpf_core_read.h and
are only supposed to be passed into __builtin_preserve_field_info().
libbpf's enum bpf_field_reloc_kind is internal, so we can change it
whenever we need to.

btw, I'm going to add bpf_core_field_exists() macro to
bpf_core_read.h, similar to bpf_core_read() macro, hope it's not very
controversial.

>
