Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6914D541
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 03:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgA3Cin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 21:38:43 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43923 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgA3Cin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 21:38:43 -0500
Received: by mail-qt1-f194.google.com with SMTP id d18so1255681qtj.10;
        Wed, 29 Jan 2020 18:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dbcD6682c+KrFWBTEZOgSBLcGdzJ+QWAbpm1C62YsGg=;
        b=GxSf5vv9IYqodESHslTJkjQkrGZeux57/uZJGht1qC6w283vMnjYU/9KJT4QgbHpiU
         iUD41wweXu7argTUucVSWVQpaUaWeGOfq/nxvYgxDb3mYIuFO6XloJXU+9KK6z66l3aX
         wUR/zqejWKKD/9SDkwhmjG3NAWRfm+aCv8a5yfK8U6+5WPTDfDbNjZD+pFGAFcawPWih
         mi19lYYoTgNuTZwW9r4Q8DeJnUC96fpS6mtYVvuybh9vsRkn4gB7x/TWK6YOmmrhJWyf
         xZIucvSrVxawLPmor8HO1sUq5YPeuuV3/9mMT927mDjDktxUXQqWLLk0k0ymjxokKNy8
         U4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dbcD6682c+KrFWBTEZOgSBLcGdzJ+QWAbpm1C62YsGg=;
        b=Cu2VY9E2XlqmD7WMn2VJsFhS3fHn34kAxBwllkyvpFoKBJOqeZEBCb5PirKwIRgrWo
         4brtNHxsnCAfJCqbCCU+jnlg3Bj5X8aI6GnS6jVZqS+4SpRfy6zHLPMCQ+xvhqWlqgTN
         Hs+uBaQgrBhSlue+Lb75MCg7LRdHntk8LqPQHzgYQtn1f5pZjT8VrNCL1UC1uowu7vzG
         00C/4LGWFdoyTt4odcRW5UDltMCKKisSU2E96lQ9wHU/hK54cdsExqLw/kMAgwx8p9b+
         vYXj0diqxKrlZU4+qO07L/t1HlWq42nHb6pNQwl+UnGfO8KkWVpDA/Ufn8D/OIItrwPo
         ySmg==
X-Gm-Message-State: APjAAAWUkGFLp7Fbn52zvpRKRFU5q/Hl8WHZAemeBD8PSjj3QVi8kuIN
        R5bKZTL57wyUTDFUFvKHHEXBphZqWURJcI5VSKg=
X-Google-Smtp-Source: APXvYqwJ3A3yFJ8SlW5LFUUG87FfZtL6778DlBEPb5RcLvmyYhhD7sXhml2u2Wen1SR4ulXLTWQTme2vxOWRUgos8wk=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr2519503qtu.141.1580351921621;
 Wed, 29 Jan 2020 18:38:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1580348836.git.hex@fb.com> <065fa340d5f65648e908bc94b6bd63e57e976f35.1580348836.git.hex@fb.com>
 <CAEf4BzapaKj+CArhK+GooqcRsTTSoYkR0Vbh87inX8kMYDHeSw@mail.gmail.com>
In-Reply-To: <CAEf4BzapaKj+CArhK+GooqcRsTTSoYkR0Vbh87inX8kMYDHeSw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Jan 2020 18:38:30 -0800
Message-ID: <CAEf4BzYBKHVVoD9d3cDG=Adoeh6s2dzrJE-7M4tdHfbRX2zdFg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/1] runqslower: fix Makefile
To:     Yulia Kartseva <hex@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 6:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 29, 2020 at 6:10 PM Yulia Kartseva <hex@fb.com> wrote:
> >
> > From: Julia Kartseva <hex@fb.com>
> >
> > Fix undefined reference linker errors when building runqslower with
> > gcc 7.4.0 on Ubuntu 18.04.
> > The issue is with misplaced -lelf, -lz options in Makefile:
> > $(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
> >
> > -lelf, -lz options should follow the list of target dependencies:
> > $(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
> > or after substitution
> > cc -g -Wall runqslower.o libbpf.a -lelf -lz -o runqslower
> >
> > The current order of gcc params causes failure in libelf symbols resolution,
> > e.g. undefined reference to `elf_memory'
> > ---
>
> Thanks for fixing!
>
> Just for the future, there is no need to create a cover letter for a
> single patch.
>
> Please also add Fixes tag like so:
>
> Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")

Oh, and Signed-off-by is missing too, please add and respin v2.

With that, also add:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> >  tools/bpf/runqslower/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> > index 0c021352b..87eae5be9 100644
> > --- a/tools/bpf/runqslower/Makefile
> > +++ b/tools/bpf/runqslower/Makefile
> > @@ -41,7 +41,7 @@ clean:
> >
> >  $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
> >         $(call msg,BINARY,$@)
> > -       $(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
> > +       $(Q)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
> >
> >  $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h             \
> >                         $(OUTPUT)/runqslower.bpf.o
> > --
> > 2.17.1
> >
