Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F3B5ACD
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 07:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfIRFUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 01:20:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36732 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfIRFUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 01:20:48 -0400
Received: by mail-qt1-f196.google.com with SMTP id o12so7458957qtf.3;
        Tue, 17 Sep 2019 22:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0tfdb5P9pk3INZ0jESPpPCfhjoXmj1Um+iTci+rVkE=;
        b=V80UfxZjBcDfIXajIUQ7i8Zezif4y2s7wulSTqX+DeD2RFQNK4r6iXFEPGKv2sWG+d
         m4Z9ZnLo1Sx7MrC5HwWn2A7rBtGzMlTlpe2+nCipjvPyRnKDXKArTZK/s+VMZSkNevbK
         kb398rQVGj7rBVexy7RMQxD5ek1biD2OxhuX0xubh+W0s5zaxXFwlTPeUlh/SQSzPt2x
         cG40OQg68RdDu/8JYD0wAxLKffg5OdusX/Juwg5e8ZwIWz4mDMy4KHvOCvau7y5fB3cs
         8UjYInnqg1JgKXox6zdv7f2oEDMQmohuvPbTwIK8vjCP9ktcnAPACr4mhdFaGtJNOwAV
         NtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0tfdb5P9pk3INZ0jESPpPCfhjoXmj1Um+iTci+rVkE=;
        b=HeOJ23yOMnnkeOvVX5Ho4U+eAeBA8024eJqS7E/ZKKUszSsUULz82+5l7XT2MMo4TR
         KCpMXCkufA1Cw/AMtAAkB0/AzSjF0UAbFtXHXMIi382kpi59vBldqdIkFp4thyA5MVbH
         iOUCPx0NPuqTtYeEoeOaVoTg7A1jVbvS0xGE8ToDDj1wAt3R3hVwc4m7NlDFTD6ArrEu
         ikoPB5u2YPG/wrJgr51RU9g3PMmCFFxlyFShot+sz8uumrbouMQlEC6j1Yw03rCPMN9R
         HxGWOO5b2L+eNRGKi/dQ+IPiZDfahqA4LfKiIR5vO+4tlYsw9ctbr3s0t9ODE2oqrzhA
         3ysQ==
X-Gm-Message-State: APjAAAUFZd0lC5jSVRovS7Xk7a6EwNBJ8rpDe3UIQZ++cQCx3Eg4GgsI
        20muMASjXIyT2tamLg1aSFFwwg1QLWwt4SGLrWxlxhpn
X-Google-Smtp-Source: APXvYqyiGCU4Ricj1Y4vswBQ9IX10oS11lMrz7mDmwnUs5mDtv1rTuXbOW1ujctbRNSAAs5VawEcVHrXEA4uWbcJukI=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr2351489qtq.141.1568784047221;
 Tue, 17 Sep 2019 22:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-13-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-13-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 22:20:36 -0700
Message-ID: <CAEf4Bzbwdy7qokjHAM7smgiAE=NS2kxc99X2qytaaoWbbYhNjA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 12/14] samples: bpf: makefile: provide
 C/CXX/LD flags to libbpf
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

On Mon, Sep 16, 2019 at 3:58 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> In order to build libs using C/CXX/LD flags of target arch,
> provide them to libbpf make.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  samples/bpf/Makefile | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 18ec22e7b444..133123d4c7d7 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -182,8 +182,6 @@ ifdef CROSS_COMPILE
>  TPROGS_CFLAGS += -Wall
>  TPROGS_CFLAGS += -O2
>  TPROGS_CFLAGS += -fomit-frame-pointer
> -TPROGS_CFLAGS += -Wmissing-prototypes
> -TPROGS_CFLAGS += -Wstrict-prototypes
>  else
>  TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
>  TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
> @@ -196,6 +194,14 @@ TPROGS_CFLAGS += -I$(srctree)/tools/lib/
>  TPROGS_CFLAGS += -I$(srctree)/tools/include
>  TPROGS_CFLAGS += -I$(srctree)/tools/perf
>
> +EXTRA_CXXFLAGS := $(TPROGS_CFLAGS)
> +
> +# options not valid for C++
> +ifdef CROSS_COMPILE
> +$(TPROGS_CFLAGS) += -Wmissing-prototypes
> +$(TPROGS_CFLAGS) += -Wstrict-prototypes
> +endif
> +

ugh, let's really get rid of dependency on C++ compiler, as suggested
for previous patch.


>  TPROGCFLAGS_bpf_load.o += -Wno-unused-variable
>
>  TPROGS_LDLIBS                  += $(LIBBPF) -lelf
> @@ -257,7 +263,9 @@ clean:
>
>  $(LIBBPF): FORCE
>  # Fix up variables inherited from Kbuild that tools/ build system won't like
> -       $(MAKE) -C $(dir $@) RM='rm -rf' LDFLAGS= srctree=$(BPF_SAMPLES_PATH)/../../ O=
> +       $(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
> +               EXTRA_CXXFLAGS="$(EXTRA_CXXFLAGS)" LDFLAGS=$(TPROGS_LDFLAGS) \
> +               srctree=$(BPF_SAMPLES_PATH)/../../ O=
>
>  $(obj)/syscall_nrs.h:  $(obj)/syscall_nrs.s FORCE
>         $(call filechk,offsets,__SYSCALL_NRS_H__)
> --
> 2.17.1
>
