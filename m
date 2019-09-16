Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9724CB41BA
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733018AbfIPUZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:25:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41209 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730502AbfIPUZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:25:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id x4so1485377qtq.8;
        Mon, 16 Sep 2019 13:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1t82i6X11aZoLXvnOKNwH+tVPB4SBAU5NMbxltAh8Q=;
        b=PPncx+oiRjtvht6VJEZH3QKIN/OO4JtQ0iaLZ7/FLKKvnaCK2XXBARhU6EUqnwXpWJ
         pkUcBZzvF21P7z5mT9fZ+dSnCZtu4VzJku/YhNjK3hh/9WTvXChJ2TIF7fZjLW3r41x4
         gDjyByBCQUpg4XWLHzHn90TbxgFsWRCe1+9mc0Beo8mJjVyTLjpeQKCsg4gcucElWcex
         wLa4ojoRHLDp0+T4vOvYr1UTdmeal3wgfbziVl2q4OLODbKnzUi1k+geJsUJIZTtFsSn
         kQPsberfZ6o/yUzTMOF9PHD0cVEUiTZq4cRYiQUGHB9CxlfCJSD/rAfVNhjh2HTOGgPV
         KbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1t82i6X11aZoLXvnOKNwH+tVPB4SBAU5NMbxltAh8Q=;
        b=aF+hC7AowtleHOQc5vTYSTgAfsZYxKFm263MZhdvTxR2gxdeCi0MC+jWOTTKRC19aZ
         z/R1wuuTjip7RD65ZJXNLGjX19qjvXtIUL0IAFWm1yYRtUSKdeh6SrCPRM20sL7WIa7n
         loMM1XAuSgfuzpQHpXC9grvMrQSmKpggWe/DBEKEZ+J7OfTLach4Aj1IbmcSa2WioYvJ
         sgjRggpcg3umYe9fxUf0NE100bvQ79RHCG7/9tllL45CsTChoGXKll0IIPB0EVGH3ElY
         4Q0yQbHAWtWIYc5b5707kp5K4+wJrzpdnLqcNQqUgUHx1NRe6uvcmSKeBigXs64D//Ui
         21QA==
X-Gm-Message-State: APjAAAUHMNqVA0QiQ2CMoJ5Ym8f+LEU8r2ZzimPTOv9uVdzNoaUUzFxJ
        Bw4bjUB4JQ7R/uh7cwNT+aYgoVTewqW4baIfMwE=
X-Google-Smtp-Source: APXvYqxu+ci+i8bh13T9ReN3PfZ/8LKTC1ABrELo9BhvKuAV3JrhwLwUEB2Yv9J0BS4SaIcxktwx9mnyI3UZu7hmXz8=
X-Received: by 2002:a0c:e48b:: with SMTP id n11mr166604qvl.38.1568665513084;
 Mon, 16 Sep 2019 13:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-4-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-4-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 13:25:02 -0700
Message-ID: <CAEf4BzY+5YQpfJBOVzBfSdZAEcCFjZ9WbeFng8W6tb4M_UwGVQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 03/14] samples: bpf: makefile: use --target
 from cross-compile
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

On Mon, Sep 16, 2019 at 4:01 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> For cross compiling the target triple can be inherited from
> cross-compile prefix as it's done in CLANG_FLAGS from kernel makefile.
> So copy-paste this decision from kernel Makefile.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 43dee90dffa4..b59e77e2250e 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -195,7 +195,7 @@ BTF_PAHOLE ?= pahole
>  # Detect that we're cross compiling and use the cross compiler
>  ifdef CROSS_COMPILE
>  HOSTCC = $(CROSS_COMPILE)gcc
> -CLANG_ARCH_ARGS = -target $(ARCH)
> +CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
>  endif
>
>  # Don't evaluate probes and warnings if we need to run make recursively
> --
> 2.17.1
>
