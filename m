Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C014B4229
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391496AbfIPUog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:44:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34016 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387513AbfIPUof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:44:35 -0400
Received: by mail-qt1-f195.google.com with SMTP id j1so1625889qth.1;
        Mon, 16 Sep 2019 13:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fNQ0/77F+AwzFz6t9T1s7MhdfhD+EKvJmwBiN2PsM0A=;
        b=WxF5VH3DkkGuMREPXNnBNs776VjAu9QvdYnof94lPdrdw+fGzg7amWLYNcVZTYVr0E
         PfIdvDOcGocHIpzPGEdYNNrelIItwsFKohmfRlsAGAklFkMx6av53NyNilI423DUd82r
         Iokta/kg02tepBP8pq4aKRETHwoWJ12atxXksAm7DYv+grOVEZ7bDeopX4hfAOeIs+H5
         xqqrAkaDzPDf/uUkgyy4aldUSTi/H6LdDAW24gE6c2/9LNwl25YZO2ekp+VBb/nBP26K
         WTxx9bDaMjlJtQUpnDHx7M0mNCUdkpEgKWcHN1RfMw/s/4HzDZZZtIII6f4/WcMbUDtU
         g8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fNQ0/77F+AwzFz6t9T1s7MhdfhD+EKvJmwBiN2PsM0A=;
        b=RVlorYOf2Xd6VNd8xI+CyWbxb1LdtLc4n0RI0Yf7tqq4klbo21AugdLMuGJmA+wC2N
         ct05oXKQonOvS3vRzTWMjq58j7YLjmMLTOSFdqWQkKHS3SKVIepfr34p8aN3sOOANDc9
         e72scYyx11i30cjjPDmQAe62zETqAcm7RXEbDxiyc2Me8x8KVS4Vd//MOdxsnmvrN7Uu
         fb+1f1VootE1bZrw9XjWZLjO7ITGcWMwSH+WO0EixbCe/LdWgWpr9YUd4AvPvD4lqBRs
         nb33souAwNQmvnRDUCszYmG3BRVhiK9nB7yOzjgWm/tXXqyC5ZH82NgL8edGyb8nR24y
         nz4w==
X-Gm-Message-State: APjAAAVioMPc8xECpIT9aB0NQrTDWKYaw4Ta9mhQOrsiD9mVOmT4I0vx
        qZPSoB5XG5ysvZFZoMVwoNbbuwYUH8fHedxht0g=
X-Google-Smtp-Source: APXvYqwFhlHUsQXl15LvXDGEFqUimBRifO2bhyUdORZbmWYBkPaooQHzjBdHdiW2agqPC8ionWphkYdQiv+KIkbcIjk=
X-Received: by 2002:a05:6214:114a:: with SMTP id b10mr201853qvt.150.1568666674518;
 Mon, 16 Sep 2019 13:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-6-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-6-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 13:44:23 -0700
Message-ID: <CAEf4BzYpCGHxNG-jOjwx5a2NXbvLW4gZH8GD2p7E27v9K3ookg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 05/14] samples: bpf: makefile: use
 __LINUX_ARM_ARCH__ selector for arm
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

On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> For arm, -D__LINUX_ARM_ARCH__=X is min version used as instruction
> set selector and is absolutely required while parsing some parts of
> headers. It's present in KBUILD_CFLAGS but not in autoconf.h, so let's
> retrieve it from and add to programs cflags. In another case errors
> like "SMP is not supported" for armv7 and bunch of other errors are
> issued resulting to incorrect final object.
> ---
>  samples/bpf/Makefile | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 8ecc5d0c2d5b..d3c8db3df560 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -185,6 +185,16 @@ HOSTLDLIBS_map_perf_test   += -lrt
>  HOSTLDLIBS_test_overhead       += -lrt
>  HOSTLDLIBS_xdpsock             += -pthread
>
> +ifeq ($(ARCH), arm)
> +# Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
> +# headers when arm instruction set identification is requested.
> +ARM_ARCH_SELECTOR = $(shell echo "$(KBUILD_CFLAGS) " | \
> +                   sed 's/[[:blank:]]/\n/g' | sed '/^-D__LINUX_ARM_ARCH__/!d')

Does the following work exactly like that without shelling out (and
being arguably simpler)?

ARM_ARCH_SELECTOR = $(filter -D__LINUX_ARM_ARCH__%, $(KBUILD_CFLAGS))

> +
> +CLANG_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
> +KBUILD_HOSTCFLAGS := $(ARM_ARCH_SELECTOR)

Isn't this clearing out previous value of KBUILD_HOSTCFLAGS? Is that
intentional, or it was supposed to be += here?

> +endif
> +
>  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
>  #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>  LLC ?= llc
> --
> 2.17.1
>
