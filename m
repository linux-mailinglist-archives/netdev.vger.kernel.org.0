Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C478BB6EF9
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 23:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbfIRVmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 17:42:45 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42628 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387521AbfIRVmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 17:42:44 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so1066160qkl.9;
        Wed, 18 Sep 2019 14:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6P902L7LJNPT4ssJNWdrSjXG2av0wc4klnUEBzyUx6c=;
        b=I0USsfmHkX8/IosUABXUcAOvs0CABxoOv10rCj4DZH6xCHdY2L4yQblg6NZYhHguX2
         MsA6e++yIPq7eRMJfOF0+5ORua+JGZQPZ35gb1IFeep1EFUYMoo06xlPuVJ4kdRzbTLk
         PBO+Nl9u2hQIl6+su6TFrtXNe+RqK/AnWBXsfIz6yh08lEsPuswLbY/MT8CNOcd3mAJX
         sV1GGSl3zT58PUKSY5Z9K8Mw/GTb5W8kR7XzdlCkaOwV7F9ZyBnxDaAD3pIOUJpxNR2O
         5aNKuurKLuISXsII48WI+gCkrY1ViQd8AVJ2Sthn0YJEhJNuj3bV3cPWxKw8zLAEOtQv
         Scbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6P902L7LJNPT4ssJNWdrSjXG2av0wc4klnUEBzyUx6c=;
        b=UQiTVCu9bpQFlKkwWTehfjJNHfx9mMFhupDSn4g64A2FL8WpjoXpiWk8BzjCOhaq12
         YP3wFq3J96mpeCQYclX13Ial7Emig7L4ZI3HAdK6SSKQr99iMs6y8asi8NjmSUdfwXIe
         VTU6WjPy0zYyC2QZMLvje94oZsPd+J1qMfGZ8RvJjZuRkz6zB3SbZdpaoNOyRsB/AVLu
         jyDlmZcbA6Va9wJtQDWJ8/PHc8gUSJQCs1JyOeRcySVraHBvgnA6SkUhsipLFM68RjaB
         k/vt5HIc0y03dcm8bZj5juw0pObqFgwIH0BBkrbwuMgpjss+/GJuACCLtmyagZI21lGG
         oDgQ==
X-Gm-Message-State: APjAAAUb6aFDjWai3TQKhRKTQz5vNiVDyYU6uGAV9nqIG2iZMvSkqTOf
        n+GH3Nqyu8opZkJ1SdwxgSBawAByqbUFz/FtQ6o=
X-Google-Smtp-Source: APXvYqxbyXdn7X09SO/uvw7jxw77KPpPDng4/aylfzh22FrvFV2/QOqwmEfv3d7BmUzwno/aB5HcDaVFYVjEU4Wo0iE=
X-Received: by 2002:a37:98f:: with SMTP id 137mr6695305qkj.449.1568842963752;
 Wed, 18 Sep 2019 14:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-12-ivan.khoronzhuk@linaro.org> <CAEf4BzZXNN_dhs=jUjtfCqtuV1bk9H=q5b07kVDQQsysjhF4cQ@mail.gmail.com>
 <20190918110517.GD2908@khorivan>
In-Reply-To: <20190918110517.GD2908@khorivan>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Sep 2019 14:42:32 -0700
Message-ID: <CAEf4BzZndo1z0A83MmcwtYdstkYKSa9Kzfmf1PRuUtS-D49oeg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 11/14] libbpf: makefile: add C/CXX/LDFLAGS to
 libbpf.so and test_libpf targets
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 4:05 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Tue, Sep 17, 2019 at 10:19:22PM -0700, Andrii Nakryiko wrote:
> >On Mon, Sep 16, 2019 at 4:00 AM Ivan Khoronzhuk
> ><ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> In case of LDFLAGS and EXTRA_CC/CXX flags there is no way to pass them
> >> correctly to build command, for instance when --sysroot is used or
> >> external libraries are used, like -lelf, wich can be absent in
> >> toolchain. This can be used for samples/bpf cross-compiling allowing
> >> to get elf lib from sysroot.
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  tools/lib/bpf/Makefile | 11 ++++++++---
> >>  1 file changed, 8 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> >> index c6f94cffe06e..bccfa556ef4e 100644
> >> --- a/tools/lib/bpf/Makefile
> >> +++ b/tools/lib/bpf/Makefile
> >> @@ -94,6 +94,10 @@ else
> >>    CFLAGS := -g -Wall
> >>  endif
> >>
> >> +ifdef EXTRA_CXXFLAGS
> >> +  CXXFLAGS := $(EXTRA_CXXFLAGS)
> >> +endif
> >> +
> >>  ifeq ($(feature-libelf-mmap), 1)
> >>    override CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
> >>  endif
> >> @@ -176,8 +180,9 @@ $(BPF_IN): force elfdep bpfdep
> >>  $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
> >>
> >>  $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
> >> -       $(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
> >> -                                   -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
> >> +       $(QUIET_LINK)$(CC) $(LDFLAGS) \
> >> +               --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
> >> +               -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
> >>         @ln -sf $(@F) $(OUTPUT)libbpf.so
> >>         @ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
> >>
> >> @@ -185,7 +190,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN)
> >>         $(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
> >>
> >>  $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
> >> -       $(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
> >> +       $(QUIET_LINK)$(CXX) $(CXXFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
> >
> >Instead of doing ifdef EXTRA_CXXFLAGS bit above, you can just include
> >both $(CXXFLAGS) and $(EXTRA_CXXFLAGS), which will do the right thing
> >(and is actually recommended my make documentation way to do this).
> It's good practice to follow existent style, I've done similar way as for
> CFLAGS + EXTRACFLAGS here, didn't want to verify it can impact on
> smth else. And my goal is not to correct everything but embed my
> functionality, series tool large w/o it.

Alright, we'll have to eventually clean up this Makefile. What we do
with EXTRA_CFLAGS is not exactly correct, as in this Makefile
EXTRA_CFLAGS are overriding CFLAGS, instead of extending them, which
doesn't seem correct to me. BTW, bpftool does += instead of :=. All
this is avoided by just keeping CFLAGS and EXTRA_CFLAGS separate and
specifying both of them in $(CC)/$(CLANG) invocations. But feel free
to ignore this for now.


>
> >
> >But actually, there is no need to use C++ compiler here,
> >test_libbpf.cpp can just be plain C. Do you mind renaming it to .c and
> >using C compiler instead?
> Seems like, will try in next v.

Thanks!

>
> >
> >>
> >>  $(OUTPUT)libbpf.pc:
> >>         $(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
> >> --
> >> 2.17.1
> >>
>
> --
> Regards,
> Ivan Khoronzhuk
