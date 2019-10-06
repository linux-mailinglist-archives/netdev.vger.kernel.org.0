Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F4ECCF11
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfJFGtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:49:50 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33362 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfJFGtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:49:50 -0400
Received: by mail-qt1-f196.google.com with SMTP id r5so14815691qtd.0;
        Sat, 05 Oct 2019 23:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ndSiowtmaYsMdyW5qrWKh8qoq7dXM+au1DUpgPxwWLw=;
        b=e4jTyWj0q/1ZQVBgW/uEPJ/Z7vgIDOTbELiiA3rgQZk7PX0++2+hawsS9ujMHNAujg
         mxHz5Tu0L53NfZFn8Zg9Q03T1fqHg1nyBq7WyORVMPrIdKTbIS/2IjtCx7Xs3ZjX4xLE
         gWV8H4YALE3dKDlfCJBV9f0FuL+kkboqMNrJDCBrcdBK/6QghHc3mYTM2WPZAGOeB9KE
         Zq1NIxALudM+GZNcLM3QWs90pMEk8O97MGv9xFEjNsz0CYPtPUGvR4CtWvgTpEAzNakm
         WR2VdtYFjIqu6Hs7WJTsE1H4jsXM/sO9JcaYAW4JnSZ9Wj0/pnt7qBb89475tx/f+JNG
         QrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ndSiowtmaYsMdyW5qrWKh8qoq7dXM+au1DUpgPxwWLw=;
        b=XkN5iBBdBFOShpoLWuPWtJRB70bFdkbQjggQr5CXfF+ca1PBx8SVcKMbQ5VkUAHGYa
         JbEKYj91889bxQtyXD0JGT9BM1GYsY1fwT8KSBRV163kyGnRj4TaEbucaYrcZ7zwjI/r
         +XfEa3PWH/mVi1++IgF9qJoPZ+evorDreveykpXH8SxWQmDXDdhTcjVfADEfe86R59Fz
         XH4EWZ/+bAt/AzSB8ummnnZvRS8FAsjhIOwqlrnr6Xan2U6Oeuz/TVTm4umNegyCl+1U
         wXBU0V1b4aO4zgwPXAIhnLdjXYyJJBvUrK2i8Cr+qwIj1ZmCyi3Tr/PP3KcyWp9+1Uc1
         MLeA==
X-Gm-Message-State: APjAAAXvU7gWOKeIUIjsn5iS5gIuGVVyq3UM2S+xRjq1LRYpHResj8TP
        3/po/zv8B4Bm151td0P+Px/RBdRQVNLLYTbinJ4=
X-Google-Smtp-Source: APXvYqzxj6Nc1nD60pTa8QGuDknaSt0P3FweVjbCyYwQi/6RWqR3QcxkmFm6T9eoEMlpTEfwNBAhaHMB5Oify4uMgQE=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr24338099qtn.117.1570344587576;
 Sat, 05 Oct 2019 23:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
 <20191005192040.20308-1-eric@sage.org>
In-Reply-To: <20191005192040.20308-1-eric@sage.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 23:49:36 -0700
Message-ID: <CAEf4BzYER-Fzu3=RZFfWJqq83Jx-HYg6nuGYUiszfROLKuje7A@mail.gmail.com>
Subject: Re: samples/bpf not working?
To:     Eric Sage <eric@sage.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 12:24 PM Eric Sage <eric@sage.org> wrote:
>
> 394053f4a4b3 ("kbuild: make single targets work more correctly")
> changed the way single target builds work. For example,
> 'make samples/bpf/' in the previous commit matched:
>
> Makefile:1787
> %/: prepare FORCE
>   $(Q)$(MAKE) KBUILD_MODULES=3D1 $(build)=3D$(build-dir) need-modorder=3D=
1
>
> So that 'samples/bpf/Makefile' was processed directly.
> Commit 394053f4a4b3 removed this rule and now requires that
> 'CONFIG_SAMPLES=3Dy' and that 'bpf/' be added to 'samples/Makefile'
> so it is added to the list of targets processed by the new
> 'ifdef single-build' section of 'scripts/Makefile.build'.
>
> This commit adds a new 'CONFIG_SAMPLE_BPF' under 'CONFIG_SAMPLES' to
> match what the other sample subdirs have done.
>
> Signed-off-by: Eric Sage <eric@sage.org>
> ---

See [0], Bj=C3=B6rn already attempted this.

  [0] https://lore.kernel.org/bpf/20191001101429.24965-1-bjorn.topel@gmail.=
com/

>  samples/Kconfig  | 6 ++++++
>  samples/Makefile | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/samples/Kconfig b/samples/Kconfig
> index c8dacb4dda80..396e87ba97e0 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -6,6 +6,12 @@ menuconfig SAMPLES
>
>  if SAMPLES
>
> +config SAMPLE_BPF
> +       tristate "Build bpf examples"
> +       depends on EVENT_TRACING && m
> +       help
> +         This builds the bpf example modules.
> +
>  config SAMPLE_TRACE_EVENTS
>         tristate "Build trace_events examples -- loadable modules only"
>         depends on EVENT_TRACING && m
> diff --git a/samples/Makefile b/samples/Makefile
> index 7d6e4ca28d69..e133a78f3fb8 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -2,6 +2,7 @@
>  # Makefile for Linux samples code
>
>  obj-$(CONFIG_SAMPLE_ANDROID_BINDERFS)  +=3D binderfs/
> +obj-$(CONFIG_SAMPLE_BPF) +=3D bpf/
>  obj-$(CONFIG_SAMPLE_CONFIGFS)          +=3D configfs/
>  obj-$(CONFIG_SAMPLE_CONNECTOR)         +=3D connector/
>  subdir-$(CONFIG_SAMPLE_HIDRAW)         +=3D hidraw
> --
> 2.18.1
>
