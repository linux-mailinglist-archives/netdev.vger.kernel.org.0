Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71747B4198
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbfIPUNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:13:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41987 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732909AbfIPUNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:13:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id g16so1421844qto.9;
        Mon, 16 Sep 2019 13:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQieAOVOLhTB9NEpVxq8Psmz1z1YFHo6DuhpKMUCRdo=;
        b=LRwz7uV8K4RxNPFBVi0eieRgWlVOgGyvMJhZOkQB+MF8KKUORN8uEab+0FD2qqW21D
         AWJ8LjFaphwggHF4mEMtP9ZuDLG+PCQQao6821QgSwJbPXR0a70k89v0jTA3GzsyBsuF
         lkMwDvlS7x6WM+JnT8J7YzbQxtB+gecQcYeX++xLMGz2SYCcFVVu+N24upDcXuLXaA46
         NfBDICxlLX2LqWXv36wUP1SkDBbotnNXWOr1wbSdjZPumchaqY2H2xlVOYDbuJ6XT1br
         18Mnx2SweaZzlRaSjyGqt2k0vmfff9fgNWrkCdAADlL+Wpe13OJ825uALoQBGw16hYzx
         VbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQieAOVOLhTB9NEpVxq8Psmz1z1YFHo6DuhpKMUCRdo=;
        b=I2KrR3SGXOWS1K1uDV1dj5G4Mde67d1DJPFVoDmMbGKUcdBaHzAeUPY5mQVcIGEOrS
         hZXiydH2ZWqASwU2wOmSUY5NC++1cw8vM8qiiTLsLZVtWa8jY+mT0NDz4g478NSFqoyo
         dOofqKR+khymttld05vG/ptv9lP/5/SM+CMxRWHLuEq/5a41BawOoC3fiKzvLLt4YfcM
         2JxPHkcLt/tGDyEPIIg2OD/Sl6C/a3iFV4l/1+yaBU/js4zdAwRQBzYRVX4qTKuBUVh8
         Swj0VqOqcF1ZHgaUIXfH4QSOWOiqdiRfBv8PnzsUtewbJwBooDaiau3hDdBqMa1mdykP
         1axw==
X-Gm-Message-State: APjAAAUG9aRn3JPBo3h5Vzjle4m/AHPSrNmeaRhJ1LzE0TU95Or8ItHj
        ThZC16W0E1omN6LJTKsWqjpn6OLkoXuG5a+Mp3Y=
X-Google-Smtp-Source: APXvYqy55J2qV/pLKyAHT18uBJJPB/CqoqSRNilFgZD/c0LOc1OPxIYx5lu+xFQLZrnxYuNio03D9QrZms1EOaqHr+g=
X-Received: by 2002:a0c:e48b:: with SMTP id n11mr122806qvl.38.1568664815003;
 Mon, 16 Sep 2019 13:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-2-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 13:13:23 -0700
Message-ID: <CAEf4BzZVTjCybmDgM0VBzv_L-LHtF8LcDyyKSWJm0ZA4jtJKcw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 01/14] samples: bpf: makefile: fix HDR_PROBE "echo"
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
> echo should be replaced with echo -e to handle '\n' correctly, but
> instead, replace it with printf as some systems can't handle echo -e.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  samples/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 1d9be26b4edd..f50ca852c2a8 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -201,7 +201,7 @@ endif
>
>  # Don't evaluate probes and warnings if we need to run make recursively
>  ifneq ($(src),)
> -HDR_PROBE := $(shell echo "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
> +HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \

printf change is fine, but I'm confused about \# at the beginning of
the string. Not sure what was the intent, but it seems like it should
work with just #include at the beginning.

>         $(HOSTCC) $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
>         echo okay)
>
> --
> 2.17.1
>
