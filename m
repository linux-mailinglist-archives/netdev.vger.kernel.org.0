Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E944A6C01
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 07:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiBBG7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 01:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiBBG7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 01:59:20 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BE7C061714;
        Tue,  1 Feb 2022 22:59:20 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id z7so16265355ilb.6;
        Tue, 01 Feb 2022 22:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PSiXxoo8AU6y5mlDlPCceHkoKwgUM9GGvCE5NbYR96U=;
        b=BOyehoXFAesWHvML1nrPnxeZLN9hQhGM8LkPyt6oIRg4mBQyz0/4zs45C1B1cvGLmh
         ALGJrMXhsqF7wbiaxonH/J+zvq/ho28FLkNcAtwBT6RKMulN7vArIsN8D6WRtMQuHEUY
         Z2aLthDYuDumeQeLN8oDKfHVg95K/bc7kQAbMXMbP2olUoGKv5kJSMu67PZoxLcaOs3L
         Fj4dago4rviiu4UyAV1OK3/abHTWGmMQQbCkZZWTKUa4RjPPNrWyg+jF8xd2j7Tr1CTA
         QkW4BXo+Aa+Ce9+wLm+CXI5ojhLArMSiuALBuZ9Zz0gNL9vL4/TnCyukFzCQx1kHB39/
         woCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PSiXxoo8AU6y5mlDlPCceHkoKwgUM9GGvCE5NbYR96U=;
        b=o8BEWytGxlIoOSOCTmKXGLqYNGcifSzCUjTRCGGuiupWeIZzTWMgzow+tYYzyj2lMs
         Sdto4ovF8mezjwmP6FGsdwSIoW6VkIumUf+BK1nrCpdxIszVF+i8Ln2nI4eER9/DY1CB
         0csPLUEfTP3J2T7GhoZ6VsemhnqKrAA7bY0qdcY4X83XsvYC2kWKmoLzdQNgML/+NRE4
         EgfLSphn/8axcFZSWFsm+ewum9zJ1Gz0UPgErib9yvmLAvjPiFgAkKPTxCDfwcpAPzCJ
         RjCjdFEyVlucjgKZ80ibOZvFWLsJ2NMprgKwCpPQQdRqTfeYwwL5qqcSH9KHFLcBq51f
         O9gw==
X-Gm-Message-State: AOAM5317J8o212pgTFuNfSaSVsyspPaBdoZBCV+VGR2kQ3qABECDqJ8t
        pqaL5wB2gaCdnfZbArzuZhb68Q9tiq8JdU+BfVnJchWe
X-Google-Smtp-Source: ABdhPJzPQZSBtnWWilL3s4hvZjLiozk8pK5kCj/FKbZkWquaE0anOFNwS+SW6nUI/0ECefJ1n+8pwpPX32T5bG5wy3c=
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr17557747ili.239.1643785160135;
 Tue, 01 Feb 2022 22:59:20 -0800 (PST)
MIME-Version: 1.0
References: <20220131211136.71010-1-quentin@isovalent.com> <20220131211136.71010-3-quentin@isovalent.com>
In-Reply-To: <20220131211136.71010-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Feb 2022 22:59:09 -0800
Message-ID: <CAEf4BzbmXbJzwK1uCRmg+iwX+4TrENNac=WB_eCNSsYtMDALNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpftool: Add libbpf's version number to
 "bpftool version" output
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 1:11 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> To help users check what version of libbpf has been used to compile
> bpftool, embed the version number and print it along with bpftool's own
> version number.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Documentation/common_options.rst | 3 ++-
>  tools/bpf/bpftool/Makefile                         | 2 ++
>  tools/bpf/bpftool/main.c                           | 3 +++
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
> index 908487b9c2ad..24166733d3ae 100644
> --- a/tools/bpf/bpftool/Documentation/common_options.rst
> +++ b/tools/bpf/bpftool/Documentation/common_options.rst
> @@ -4,7 +4,8 @@
>           Print short help message (similar to **bpftool help**).
>
>  -V, --version
> -         Print version number (similar to **bpftool version**), and optional
> +         Print bpftool's version number (similar to **bpftool version**), the
> +         version of libbpf that was used to compile the binary, and optional
>           features that were included when bpftool was compiled. Optional
>           features include linking against libbfd to provide the disassembler
>           for JIT-ted programs (**bpftool prog dump jited**) and usage of BPF
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 83369f55df61..bd5a8cafac49 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -42,6 +42,7 @@ LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hash
>  ifeq ($(BPFTOOL_VERSION),)
>  BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
>  endif
> +LIBBPF_VERSION := $(shell make -r --no-print-directory -sC $(BPF_DIR) libbpfversion)
>

why can't you use libbpf_version_string() API instead?



>  $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
>         $(QUIET_MKDIR)mkdir -p $@
> @@ -84,6 +85,7 @@ CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
>         -I$(srctree)/tools/include \
>         -I$(srctree)/tools/include/uapi
>  CFLAGS += -DBPFTOOL_VERSION='"$(BPFTOOL_VERSION)"'
> +CFLAGS += -DLIBBPF_VERSION='"$(LIBBPF_VERSION)"'
>  ifneq ($(EXTRA_CFLAGS),)
>  CFLAGS += $(EXTRA_CFLAGS)
>  endif
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 9d01fa9de033..4bda73057980 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -89,6 +89,8 @@ static int do_version(int argc, char **argv)
>
>                 jsonw_name(json_wtr, "version");
>                 jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
> +               jsonw_name(json_wtr, "libbpf_version");
> +               jsonw_printf(json_wtr, "\"%s\"", LIBBPF_VERSION);
>
>                 jsonw_name(json_wtr, "features");
>                 jsonw_start_object(json_wtr);   /* features */
> @@ -102,6 +104,7 @@ static int do_version(int argc, char **argv)
>                 unsigned int nb_features = 0;
>
>                 printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
> +               printf("using libbpf v%s\n", LIBBPF_VERSION);
>                 printf("features:");
>                 if (has_libbfd) {
>                         printf(" libbfd");
> --
> 2.32.0
>
