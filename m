Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F9FB41F2
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391464AbfIPUfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:35:34 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41826 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391449AbfIPUfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:35:33 -0400
Received: by mail-qt1-f195.google.com with SMTP id x4so1524936qtq.8;
        Mon, 16 Sep 2019 13:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ihyLcr/IE8dYmQPkpIxkQFwoGx9mvcYHtpb7Os1ZV9I=;
        b=NVDnnS7Qjr/iIlDteTT8VdQpogh5KuOmqGAR+uyUiMRjAcDLr+uF+NSzaRmuN0SzyG
         DDYmyjgeGNHR6DQI/SXQxp6dBzMWV0moM0bbd/wIxEDP4cbEuylTVBW9dhtl1fLoJKir
         e/Xm32DiqsKNhoV3N9E/FgaWo8OCSgqeY4HAkOGfibBs6G5GbKmwrxCw1AFEl94rn6N3
         Rnc/imUTNVAdFVs2RrLRgIaC+NuEht3gb6z51oHKDMXoWcRh6mpOyFGgnPRPHd+iXIlr
         Ke1WZ3hTXpcUkIXD1nU0spWaYs8W0axbgLtphCVsDArRicsBh2GpteOCq1ejiKhThHHP
         8Oag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ihyLcr/IE8dYmQPkpIxkQFwoGx9mvcYHtpb7Os1ZV9I=;
        b=E2wfzM9LrOJysvDoS5serqsOAemdO9kavdBfdcOh2YQLcp+Ai9byzJUbuFzdklc09K
         EIdRpSuz0OhIJ5TafDEJKibWv/zRuSZNMCBpbTvdvuvhuPsfN3Gr2ZhoSt3jrstabaZV
         XddBI+elWiDMVyycEd0A5SoJyG7ZQcBt5N3V8l9LY31FMn17f/iYCJcVOqVylSx4KVJ+
         NFtCbj7yw4lE0Pub0HJAUeHthvbYBBbLez+iY4AcAfZ6qKpZadJE/riU1CW43VjbOrKr
         TiLYNMu3j2+XyrrtzKQVBjP87EWQ7RvFygOYwTmeE3ZzkX5sVzx1Zo1OIlTLzXQZMXrN
         ZUCA==
X-Gm-Message-State: APjAAAXnHuNl3pAp/lsfHeOCdfqd/76zA224eZ4iF79PuZZajFLXns+H
        tXO/J5aLwUh5qPMKCnIYoElrkPD5rfMq3Buqexo=
X-Google-Smtp-Source: APXvYqy8aV+MnFrM7mg9z9Q3FKj5HhJM55bINhYiDMgDGGW0Vt197cpT56rOs3YEQQ8XH4TDqGsRq5JFKRqX+bh0Zv4=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr259871qtq.141.1568666132646;
 Mon, 16 Sep 2019 13:35:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-5-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-5-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 13:35:21 -0700
Message-ID: <CAEf4BzYJ5Q4rBHGET5z6nPBhh=8qAK7uuCK=Qnsh14FDH-24gA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 04/14] samples: bpf: use own EXTRA_CFLAGS for
 clang commands
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
> It can overlap with CFLAGS used for libraries built with gcc if
> not now then in next patches. Correct it here for simplicity.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

With GCC BPF front-end recently added, we should probably generalize
this to something like BPF_EXTRA_CFLAGS or something like that,
eventually. But for now:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/Makefile | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index b59e77e2250e..8ecc5d0c2d5b 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -218,10 +218,10 @@ BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
>                           /bin/rm -f ./llvm_btf_verify.o)
>
>  ifneq ($(BTF_LLVM_PROBE),)
> -       EXTRA_CFLAGS += -g
> +       CLANG_EXTRA_CFLAGS += -g
>  else
>  ifneq ($(and $(BTF_LLC_PROBE),$(BTF_PAHOLE_PROBE),$(BTF_OBJCOPY_PROBE)),)
> -       EXTRA_CFLAGS += -g
> +       CLANG_EXTRA_CFLAGS += -g
>         LLC_FLAGS += -mattr=dwarfris
>         DWARF2BTF = y
>  endif
> @@ -280,8 +280,8 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>  # useless for BPF samples.
>  $(obj)/%.o: $(src)/%.c
>         @echo "  CLANG-bpf " $@
> -       $(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(EXTRA_CFLAGS) -I$(obj) \
> -               -I$(srctree)/tools/testing/selftests/bpf/ \
> +       $(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(CLANG_EXTRA_CFLAGS) \
> +               -I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
>                 -D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
>                 -D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
>                 -Wno-gnu-variable-sized-type-not-at-end \
> --
> 2.17.1
>
