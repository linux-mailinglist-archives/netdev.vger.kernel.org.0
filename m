Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C9A17629A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgCBS0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:26:11 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44036 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgCBS0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:26:11 -0500
Received: by mail-qk1-f195.google.com with SMTP id f198so603956qke.11;
        Mon, 02 Mar 2020 10:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJlr4oBO3UMUPF2onmKLJ0zkcX25GwCDTuSzFH9TffE=;
        b=E2Ftr5r5AIZeEnhoSnNkykd09T53E//ZvQOnPbvAlGFcfmadARn4Kf4ki7/uqI6aEk
         7I53IBAxAjUU3BzyQaE2KpoEZctV2IXLKkxSga94N3fSi4On7Jdl9e5+b4ZaN1ittZ2O
         fn7S0Nsdrh9aen94wStqZc3vp+nN63Ca7jcQIYFUHFBMrT0D12TRf+/y3AtPcEsctdY8
         M1ZIiVFH+x+CQiM1sXlh4iUPgOZHdgTlGL4d5LHPaq76io7YNH79/u4fb/n9YCAit6QQ
         IXf3MZhq8f3RhObkbSld1H3+YcRikkEdswfcd6X3ph+duDpJmRXoBdMRjj5TNvgykHb1
         i9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJlr4oBO3UMUPF2onmKLJ0zkcX25GwCDTuSzFH9TffE=;
        b=JeyAmaxOjt5vaiEhNdgRZjXDDweMac/HJ0MPqRjkwKXXAmkgz1qLPR1qYUkKlq9ZhE
         IizXnsWRud+Q4E7W0yb1XRmnktsHdWle9ES7qTQiH5DbImg/KiItm4GChXakZeCxdHXh
         EmQP8+WWletJ88dWIfDowm3c8TceXJzSeH5u/uGT6nxVA1XYeg4tQgq497Ll431DIZMz
         t6Xm29oSP7csf+FWUzblsbbCvWUglx8N8cwYRA8gG8WKORpnTdAOTjNhQM5VVTByWykJ
         sWSqWF4EsSy0luwa5n9gE+3GQdiyBbwPi+xV1d2j6RY/lso1jtfu+PGthb6aFORPfj2B
         BkYQ==
X-Gm-Message-State: ANhLgQ3VZG7nh5/qHzP5weKXcVvfNDYcSL1I451GCvTqsWYUsc9Q17kA
        5r25v2e6xJavFfGb3OJvVje6eUza7HdqfU2ICgJZ+lwj
X-Google-Smtp-Source: ADFU+vvDYzCoi4Gojb/uRKud/WoT6IZQf/2NXmE+Y8DvKRa7O4uHHnQPCG59TP4nS6LjExXXKsp48sRM9nyIVN6qXg0=
X-Received: by 2002:a37:a70c:: with SMTP id q12mr597148qke.36.1583173569936;
 Mon, 02 Mar 2020 10:26:09 -0800 (PST)
MIME-Version: 1.0
References: <20200301062405.2850114-1-andriin@fb.com> <20200301062405.2850114-2-andriin@fb.com>
 <b57cdf6d-0849-2d54-982e-352886f86201@fb.com>
In-Reply-To: <b57cdf6d-0849-2d54-982e-352886f86201@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 10:25:58 -0800
Message-ID: <CAEf4BzZspu-wXMr6v=Sd-_m-XzXJwJHyU9zd0ydEiWmch8F9GQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants to enums
To:     Yonghong Song <yhs@fb.com>
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

On Mon, Mar 2, 2020 at 8:22 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 2/29/20 10:24 PM, Andrii Nakryiko wrote:
> > Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> > enum values. This preserves constants values and behavior in expressions, but
> > has added advantaged of being captured as part of DWARF and, subsequently, BTF
> > type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> > for BPF applications, as it will not require BPF users to copy/paste various
> > flags and constants, which are frequently used with BPF helpers.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
> >   include/uapi/linux/bpf_common.h       |  86 ++++----
> >   include/uapi/linux/btf.h              |  60 +++---
> >   tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
> >   tools/include/uapi/linux/bpf_common.h |  86 ++++----
> >   tools/include/uapi/linux/btf.h        |  60 +++---
> >   6 files changed, 497 insertions(+), 341 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 8e98ced0963b..03e08f256bd1 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -14,34 +14,36 @@
> >   /* Extended instruction set based on top of classic BPF */
> >
> >   /* instruction classes */
> > -#define BPF_JMP32    0x06    /* jmp mode in word width */
> > -#define BPF_ALU64    0x07    /* alu mode in double word width */
> > +enum {
> > +     BPF_JMP32       = 0x06, /* jmp mode in word width */
> > +     BPF_ALU64       = 0x07, /* alu mode in double word width */
>
> Not sure whether we have uapi backward compatibility or not.
> One possibility is to add
>    #define BPF_ALU64 BPF_ALU64
> this way, people uses macros will continue to work.

This is going to be a really ugly solution, though. I wonder if it was
ever an expected behavior of UAPI constants to be able to do #ifdef on
them.

Do you know any existing application that relies on those constants
being #defines?

>
> If this is an acceptable solution, we have a lot of constants
> in net related headers and will benefit from this conversion for
> kprobe/tracepoint of networking related functions.
>
> >
> >   /* ld/ldx fields */
> > -#define BPF_DW               0x18    /* double word (64-bit) */
> > -#define BPF_XADD     0xc0    /* exclusive add */
> > +     BPF_DW          = 0x18, /* double word (64-bit) */
> > +     BPF_XADD        = 0xc0, /* exclusive add */
> >
> >   /* alu/jmp fields */
> > -#define BPF_MOV              0xb0    /* mov reg to reg */
> > -#define BPF_ARSH     0xc0    /* sign extending arithmetic shift right */
> > +     BPF_MOV         = 0xb0, /* mov reg to reg */
> > +     BPF_ARSH        = 0xc0, /* sign extending arithmetic shift right */
> >
> >   /* change endianness of a register */
> > -#define BPF_END              0xd0    /* flags for endianness conversion: */
> > -#define BPF_TO_LE    0x00    /* convert to little-endian */
> > -#define BPF_TO_BE    0x08    /* convert to big-endian */
> > -#define BPF_FROM_LE  BPF_TO_LE
> > -#define BPF_FROM_BE  BPF_TO_BE
> > +     BPF_END         = 0xd0, /* flags for endianness conversion: */
> > +     BPF_TO_LE       = 0x00, /* convert to little-endian */
> > +     BPF_TO_BE       = 0x08, /* convert to big-endian */
> > +     BPF_FROM_LE     = BPF_TO_LE,
> > +     BPF_FROM_BE     = BPF_TO_BE,
> >
> >   /* jmp encodings */
> > -#define BPF_JNE              0x50    /* jump != */
> > -#define BPF_JLT              0xa0    /* LT is unsigned, '<' */
> > -#define BPF_JLE              0xb0    /* LE is unsigned, '<=' */
> > -#define BPF_JSGT     0x60    /* SGT is signed '>', GT in x86 */
> > -#define BPF_JSGE     0x70    /* SGE is signed '>=', GE in x86 */
> > -#define BPF_JSLT     0xc0    /* SLT is signed, '<' */
> > -#define BPF_JSLE     0xd0    /* SLE is signed, '<=' */
> > -#define BPF_CALL     0x80    /* function call */
> > -#define BPF_EXIT     0x90    /* function return */
> > +     BPF_JNE         = 0x50, /* jump != */
> > +     BPF_JLT         = 0xa0, /* LT is unsigned, '<' */
> > +     BPF_JLE         = 0xb0, /* LE is unsigned, '<=' */
> > +     BPF_JSGT        = 0x60, /* SGT is signed '>', GT in x86 */
> > +     BPF_JSGE        = 0x70, /* SGE is signed '>=', GE in x86 */
> > +     BPF_JSLT        = 0xc0, /* SLT is signed, '<' */
> > +     BPF_JSLE        = 0xd0, /* SLE is signed, '<=' */
> > +     BPF_CALL        = 0x80, /* function call */
> > +     BPF_EXIT        = 0x90, /* function return */
> > +};
> >
> [...]
