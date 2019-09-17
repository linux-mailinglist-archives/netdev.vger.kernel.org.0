Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4163B58BA
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 01:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfIQXmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 19:42:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42452 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfIQXmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 19:42:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id g16so6619198qto.9;
        Tue, 17 Sep 2019 16:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BegyS4bOdhV/4W363nuBMo/MR31JnI7T3ixbji8LT0k=;
        b=vMk1upZOsmLe++G9kBDDj9CahrV2tNdF/nBj/Sm8wZzpdEurdvhYJ5J9ixKghaKpoe
         Cabrh+OuWLIlOL8RKUBb5jFHtQb1xdQFeP0HSY5tUS40GSQMc/d4paYdK+u6g/Yr3bsN
         6joSSp0Y0CGRaUTCcNJvsHVSlzZqO0cPTY86eZbFHDEOvnqp+RjGcdWDcelGje3coVJ8
         I7Z/w7Yely9GyEovAfl0SQ6k8tjJd/NdJcl9i59BmGBOpTmRjOYlePwLpac2ocUn0GQ4
         px4HlmsNfTsrEh9cgAI0XrjTx8lSfmL8E2I9wAxcrBLDGTu2tQwc2dvhwx/ojX/ZO+Mu
         /5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BegyS4bOdhV/4W363nuBMo/MR31JnI7T3ixbji8LT0k=;
        b=YnsgEJ5js/tuoWKJQmoaFbKybu1/VeGCVjBTI7U2e7ncZWWQrM4e1KRG3fjYeP5JaP
         QuaZRSY6XRu2LR32JFYUgcMs2AgNPnYwyS73EsqpZczPi/C7gSzZWzAXHMCu4ABxON8Y
         9H7uBVDjG5qHeeS+UUiLkQcp/VcCUBSyyVyesdioDBzvr7pA4bk+HGm3/aRZMZMq4kJm
         hdTt1/v9mdl9+R+g2Iznicu5uycPMXar/30l2aCxpilYHq8o86czHSwM0SCrMPZ0YGUE
         xl5G3YFI5/A48HbB/scHwzDJLrkMziXqXPqpGWv4hF27US6I0e/ADRauP8p0KIKA5uRP
         WqFA==
X-Gm-Message-State: APjAAAUH4o5dhBY3JcsVWhQJhQxIG2vj2d5HLWRncaJO+DotT5Bt2FcJ
        C6SatMKd55tZ0I0SoLpBGO8NZ1ypw6P3XrBSYV4=
X-Google-Smtp-Source: APXvYqyqTOB5IEnz+7Pn65a64zh20YjJFL47Y3+R+LAoPucpHJlNyWRxfkqLGYegHWdmGs0Tu4e8upaaXuzL1yVMXa0=
X-Received: by 2002:a0c:88f0:: with SMTP id 45mr1124543qvo.78.1568763737848;
 Tue, 17 Sep 2019 16:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-10-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-10-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 16:42:07 -0700
Message-ID: <CAEf4BzbuPnxAs0A=w60q0jTCy5pb2R-h0uEuT2tmvjsaj4DH4A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 09/14] samples: bpf: makefile: use own flags
 but not host when cross compile
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
> While compile natively, the hosts cflags and ldflags are equal to ones
> used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it should
> have own, used for target arch. While verification, for arm, arm64 and
> x86_64 the following flags were used alsways:
>
> -Wall
> -O2
> -fomit-frame-pointer
> -Wmissing-prototypes
> -Wstrict-prototypes
>
> So, add them as they were verified and used before adding
> Makefile.target, but anyway limit it only for cross compile options as
> for host can be some configurations when another options can be used,
> So, for host arch samples left all as is, it allows to avoid potential
> option mistmatches for existent environments.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  samples/bpf/Makefile | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 1579cc16a1c2..b5c87a8b8b51 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -178,8 +178,17 @@ CLANG_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
>  TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
>  endif
>
> +ifdef CROSS_COMPILE
> +TPROGS_CFLAGS += -Wall
> +TPROGS_CFLAGS += -O2

Specifying one arg per line seems like overkill, put them in one line?

> +TPROGS_CFLAGS += -fomit-frame-pointer

Why this one?

> +TPROGS_CFLAGS += -Wmissing-prototypes
> +TPROGS_CFLAGS += -Wstrict-prototypes

Are these in some way special that we want them in cross-compile mode only?

All of those flags seem useful regardless of cross-compilation or not,
shouldn't they be common? I'm a bit lost about the intent here...

> +else
>  TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
>  TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
> +endif
> +
>  TPROGS_CFLAGS += -I$(objtree)/usr/include
>  TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf/
>  TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
> --
> 2.17.1
>
