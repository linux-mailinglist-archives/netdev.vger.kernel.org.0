Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0C441F822
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhJAXWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhJAXV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 19:21:57 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0937FC061775;
        Fri,  1 Oct 2021 16:20:12 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id v10so23716850ybq.7;
        Fri, 01 Oct 2021 16:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21B7ZF7qpu6s4mwzmkosaovgiviZqx2bRUpMpqZFuq4=;
        b=YoJ8fn/n28so/17EjZ3yf+s9xDryqo1+Dbi6RvQVfzwkujIrn/XCzygUed3G64P5gs
         RHfqzOXivcpzFjSJVX3qz8t0o8djumY6en+6UNrI9xR3lGpczIYxXI6xMnDMZ7pGvftB
         dKX9R46C9FD+O+ZsOvZT0RGrHDfuPmB5y+JyL+xcsfsT2eOdBWZ/IYCxbPVSxXzosNrI
         wwdQ0sDrcSJn1BqlbjT/m5pgMekeeXJV8qpesVcdrrcKIa9EPTKC9eIDH989/HQFpful
         xNxC7w/hWHOZ4baDnmdvKYfwQgpCHR3IUOB6ZtLfdQGrBc+VO3NTHbMIIveRPITjNnUE
         IIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21B7ZF7qpu6s4mwzmkosaovgiviZqx2bRUpMpqZFuq4=;
        b=oIgb6oCDUU1Qs+TY/zFLUTzdK95sSKIjwRoJJ/n1X5E5UiTkL/+Wvg+35KryYML/gP
         WGzbMfmjnMFusDFWMZYkCDQbXRbeGEf0DEh5OgwQChURF1R4TZp03whM4BHs8hfXbP7N
         VE4Q7Y4OKUebVL7dZoX6hxBX+xcDU3/smDPa/4q9KfkehSd80yXT1bb1Awh5933ckS2x
         SVXUNTffs1N5jBjzf7Ps79Lec4yckF1igxOoCLBBUk2f63HJP7orlww3vkN6po9H9Bse
         6hxVK4LmZ9rjp3/LS5kPDW70g8oCc8HT8WALKKw0ZPxU97hJeiZWOZV4mXYjHcTKorgt
         tTXw==
X-Gm-Message-State: AOAM531jEbwIvihVe4wBLxD6VW+h2IScXlr3fakX10SrX+zdkfku46/C
        Sv6ZVE6f20sgAnlTDwMdxadsQHg002Nwfb5lclclkcs5Vys=
X-Google-Smtp-Source: ABdhPJyyxNU/JwELVygU17555+MEl6/6dvm9OBIvG9f5T+8Uqzv/SIa0pP7xEBr/vDXZxKEY4UCVM9Y6kpW/3bgy4I0=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr597380ybc.225.1633130411141;
 Fri, 01 Oct 2021 16:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-7-quentin@isovalent.com>
In-Reply-To: <20211001110856.14730-7-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 16:19:59 -0700
Message-ID: <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] bpf: iterators: install libbpf headers
 when building
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> API headers from libbpf should not be accessed directly from the
> library's source directory. Instead, they should be exported with "make
> install_headers". Let's make sure that bpf/preload/iterators/Makefile
> installs the headers properly when building.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  kernel/bpf/preload/iterators/Makefile | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
> index 28fa8c1440f4..cf549dab3e20 100644
> --- a/kernel/bpf/preload/iterators/Makefile
> +++ b/kernel/bpf/preload/iterators/Makefile
> @@ -6,9 +6,11 @@ LLVM_STRIP ?= llvm-strip
>  DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
>  LIBBPF_SRC := $(abspath ../../../../tools/lib/bpf)
> -BPFOBJ := $(OUTPUT)/libbpf.a
> -BPF_INCLUDE := $(OUTPUT)
> -INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../../../tools/lib)        \
> +LIBBPF_OUTPUT := $(abspath $(OUTPUT))/libbpf
> +LIBBPF_DESTDIR := $(LIBBPF_OUTPUT)
> +LIBBPF_INCLUDE := $(LIBBPF_DESTDIR)/include
> +BPFOBJ := $(LIBBPF_OUTPUT)/libbpf.a
> +INCLUDES := -I$(OUTPUT) -I$(LIBBPF_INCLUDE)                                   \
>         -I$(abspath ../../../../tools/include/uapi)
>  CFLAGS := -g -Wall
>
> @@ -44,13 +46,15 @@ $(OUTPUT)/iterators.bpf.o: iterators.bpf.c $(BPFOBJ) | $(OUTPUT)
>                  -c $(filter %.c,$^) -o $@ &&                                 \
>         $(LLVM_STRIP) -g $@
>
> -$(OUTPUT):
> +$(OUTPUT) $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE):
>         $(call msg,MKDIR,$@)
> -       $(Q)mkdir -p $(OUTPUT)
> +       $(Q)mkdir -p $@
>
> -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)            \
> +          | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)

Would it make sense for libbpf's Makefile to create include and output
directories on its own? We wouldn't need to have these order-only
dependencies everywhere, right?

>         $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)                         \
> -                   OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
> +                   OUTPUT=$(abspath $(dir $@))/ prefix=                       \
> +                   DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
>
>  $(DEFAULT_BPFTOOL):
>         $(Q)$(MAKE) $(submake_extras) -C ../../../../tools/bpf/bpftool                        \
> --
> 2.30.2
>
