Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82D4B5AC6
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 07:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfIRFTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 01:19:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:32961 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfIRFTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 01:19:34 -0400
Received: by mail-qt1-f194.google.com with SMTP id r5so7457589qtd.0;
        Tue, 17 Sep 2019 22:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xo9zYrCJEPVHMiv3h+aCm77vZarT+/8uPX2EY63h768=;
        b=bcPs6RjqrMrXV/QavjfJADE8CxKAVMNOM1fCm10VeGTuw1fF0b8O0tpuxry+vAiGnO
         zF7e/HTdlCYstizqK6PL2uObrtp+TfxLA4XZloQqoymLLeggkHtgLZOkchh6hSyE5GkC
         +EoHk9Q9pjmP3cSWHMznOLFoAawTTSW92+auoT1pb6EXuoi5BBU1AlmXQ1b+3HK9WLh2
         p5PJeEqKlp0pce/bsV34qYfeu7Bi78zKouoO5IBjNJUvldSFgI3/TFNlwlN9j4gRzQNq
         pI7dQCrNj3+Yuj2/1VjTh2Vw1HRZzUsGKZA0xRWKBi+wPa9btMl83JSYtWwQ/6LDjV1G
         dMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xo9zYrCJEPVHMiv3h+aCm77vZarT+/8uPX2EY63h768=;
        b=EX/FWRFw/8YgrxSEHWVNBN0HcT9vtS0wnlgq6TIzHXum+KOgZfFwj1Ae4YAHdBLEck
         8JvrHegBYAQB4pEPYQoFThHz27vuWNtL120E3FK3E4I+oR9Y0/FvcFClEHmYmWfM/BlD
         t0Cf2/mAxb+NYNBuyaagNr0HdCe1vQAahlDSD1RyoA7nQAJtLceIgNuIOz2MXouL7ZQD
         HXMwhs0i1gkrSsMDSVKPd9KNDWBbFmMeg05fhSiXi/h9wzNj6EgHNeDRb814v6SbZS8j
         pIeHZGDqFU8zKl4uSWiUYAL6VEuHeTFCmxN8tLKQgs0Xr3A+ISN/QsGrIPPwMm25VD1p
         twsw==
X-Gm-Message-State: APjAAAW2FXraM6LHbaw5xyrDe9c6bQbi/lppvI2CYTfG3lWIZ653VzSs
        wjdO0Z7oj/N8SJXtErd9fstElLDq5lYq56swS3g=
X-Google-Smtp-Source: APXvYqyF2U//4Y/0kYTdvEZfq0mb+FedAAlJS1dB+uxTAwKjFBE9h56N5jlr5HOLDmbQw3AAIoEkUtl1j+Xs5pn0aWk=
X-Received: by 2002:a0c:88f0:: with SMTP id 45mr1845990qvo.78.1568783973290;
 Tue, 17 Sep 2019 22:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-12-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-12-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 22:19:22 -0700
Message-ID: <CAEf4BzZXNN_dhs=jUjtfCqtuV1bk9H=q5b07kVDQQsysjhF4cQ@mail.gmail.com>
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

On Mon, Sep 16, 2019 at 4:00 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> In case of LDFLAGS and EXTRA_CC/CXX flags there is no way to pass them
> correctly to build command, for instance when --sysroot is used or
> external libraries are used, like -lelf, wich can be absent in
> toolchain. This can be used for samples/bpf cross-compiling allowing
> to get elf lib from sysroot.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  tools/lib/bpf/Makefile | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index c6f94cffe06e..bccfa556ef4e 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -94,6 +94,10 @@ else
>    CFLAGS := -g -Wall
>  endif
>
> +ifdef EXTRA_CXXFLAGS
> +  CXXFLAGS := $(EXTRA_CXXFLAGS)
> +endif
> +
>  ifeq ($(feature-libelf-mmap), 1)
>    override CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
>  endif
> @@ -176,8 +180,9 @@ $(BPF_IN): force elfdep bpfdep
>  $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
>
>  $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN)
> -       $(QUIET_LINK)$(CC) --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
> -                                   -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
> +       $(QUIET_LINK)$(CC) $(LDFLAGS) \
> +               --shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
> +               -Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
>         @ln -sf $(@F) $(OUTPUT)libbpf.so
>         @ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
>
> @@ -185,7 +190,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN)
>         $(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
>
>  $(OUTPUT)test_libbpf: test_libbpf.cpp $(OUTPUT)libbpf.a
> -       $(QUIET_LINK)$(CXX) $(INCLUDES) $^ -lelf -o $@
> +       $(QUIET_LINK)$(CXX) $(CXXFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@

Instead of doing ifdef EXTRA_CXXFLAGS bit above, you can just include
both $(CXXFLAGS) and $(EXTRA_CXXFLAGS), which will do the right thing
(and is actually recommended my make documentation way to do this).

But actually, there is no need to use C++ compiler here,
test_libbpf.cpp can just be plain C. Do you mind renaming it to .c and
using C compiler instead?

>
>  $(OUTPUT)libbpf.pc:
>         $(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
> --
> 2.17.1
>
