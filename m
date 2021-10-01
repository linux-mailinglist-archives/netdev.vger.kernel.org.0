Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9112641F831
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhJAXYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhJAXYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 19:24:41 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621F8C061775;
        Fri,  1 Oct 2021 16:22:56 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id q189so5668668ybq.1;
        Fri, 01 Oct 2021 16:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24fbhZQNa58q6nxnYFx4+aR230w/NDlL/Pj34MQIT4E=;
        b=MoS1SLo8ugNY81joBchLqs0B8Vik9pDD5njYHgVkyaWAeBSSb6OvcISVGHo5MlnDgj
         +BjA6VkSVfLUSDS//639ViQ6bUiiG52JxHeM8G8YumOxaGI8lEMUcGg/Fhxde1SVlOZg
         0hM3UYIzP+i39yHNzH/J/TciHEJj93tWxxUgb6+rO4z3dmOCyUao+T8y8JuP/3D7QO20
         Pg1AMzwZW49LOldTsHCECg89GXvIRbnD9bG/psb7Q296AKeFVBf49F77EHfew0uWOhTt
         zYcZcVE2snmwJ15KBn2Q2rCmrJ0caBbnmYLkVEHZVHIJdJ7LiPPHiJEaTC6iKiH+2yoY
         dzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24fbhZQNa58q6nxnYFx4+aR230w/NDlL/Pj34MQIT4E=;
        b=ABuCy7M8nv8BdVKdK4Kl2i8WCuh2QSLkt4n0GKopoTNK8S00Ap+O0bz9gosCG1pZJm
         cDi6gc+4SyLoDC0O+EhNISZmlUvQdZyzgOputdXxC9U1u07g3arpxI3z6OINtUq30S+7
         WdQf3GmdQCVG/+xJFx0apIQXacz0H2uSzP1qGoIGKijlsK01KWjtzyVIG0I/D6D26OlY
         C89TsebhiRC++BTcAjnLUZyuhHi+yXo5pur54C4ew91tIV3ZqlSDXHciq0QICsjGOUJY
         oiechoU9xFOoDPcDhQpisjScqnoh+mLy8+hDsbFfPXDvwKv5PmRUiSxwyheR8CZrEIBN
         aWcg==
X-Gm-Message-State: AOAM532ceIKwWqvrX2SqX7xc3JY+oMPa0ztEgatx9ZonCExR8GuhuNEe
        Fz4AoG/equcMwA3hB5/RLQiJ9fCBexaCGnk8x47Q1PsMvr0=
X-Google-Smtp-Source: ABdhPJxqV+FnU6r5FuVJieLydWuids5EK4PUfv89Eq0uXOXIniDVOigrOMZ/qBHib0MtV3zupbyYLuIIiO4ai67cDcI=
X-Received: by 2002:a25:24c1:: with SMTP id k184mr657745ybk.2.1633130575650;
 Fri, 01 Oct 2021 16:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-8-quentin@isovalent.com>
In-Reply-To: <20211001110856.14730-8-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 16:22:44 -0700
Message-ID: <CAEf4BzaOXUgiDwsTFhWKwKm=05qTjQCyXRB6a=n_kdCgSdAZ6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/9] samples/bpf: install libbpf headers when building
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
> API headers from libbpf should not be accessed directly from the source
> directory. Instead, they should be exported with "make install_headers".
> Make sure that samples/bpf/Makefile installs the headers properly when
> building.
>
> The object compiled from and exported by libbpf are now placed into a
> subdirectory of sample/bpf/ instead of remaining in tools/lib/bpf/. We
> attempt to remove this directory on "make clean". However, the "clean"
> target re-enters the samples/bpf/ directory from the root of the
> repository ("$(MAKE) -C ../../ M=$(CURDIR) clean"), in such a way that
> $(srctree) and $(src) are not defined, making it impossible to use
> $(LIBBPF_OUTPUT) and $(LIBBPF_DESTDIR) in the recipe. So we only attempt
> to clean $(CURDIR)/libbpf, which is the default value.
>
> We also change the output directory for bpftool, to place the generated
> objects under samples/bpf/bpftool/ instead of building in bpftool's
> directory directly. Doing so, we make sure bpftool reuses the libbpf
> library previously compiled and installed.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  samples/bpf/Makefile | 36 ++++++++++++++++++++++++++----------
>  1 file changed, 26 insertions(+), 10 deletions(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 4dc20be5fb96..7de602c2c705 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -59,7 +59,11 @@ tprogs-y += xdp_redirect
>  tprogs-y += xdp_monitor
>
>  # Libbpf dependencies
> -LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
> +LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
> +LIBBPF_OUTPUT = $(abspath $(BPF_SAMPLES_PATH))/libbpf
> +LIBBPF_DESTDIR = $(LIBBPF_OUTPUT)
> +LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
> +LIBBPF = $(LIBBPF_OUTPUT)/libbpf.a
>
>  CGROUP_HELPERS := ../../tools/testing/selftests/bpf/cgroup_helpers.o
>  TRACE_HELPERS := ../../tools/testing/selftests/bpf/trace_helpers.o
> @@ -198,7 +202,7 @@ TPROGS_CFLAGS += -Wstrict-prototypes
>
>  TPROGS_CFLAGS += -I$(objtree)/usr/include
>  TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
> -TPROGS_CFLAGS += -I$(srctree)/tools/lib/
> +TPROGS_CFLAGS += -I$(LIBBPF_INCLUDE)
>  TPROGS_CFLAGS += -I$(srctree)/tools/include
>  TPROGS_CFLAGS += -I$(srctree)/tools/perf
>  TPROGS_CFLAGS += -DHAVE_ATTR_TEST=0
> @@ -268,16 +272,28 @@ all:
>  clean:
>         $(MAKE) -C ../../ M=$(CURDIR) clean
>         @find $(CURDIR) -type f -name '*~' -delete
> +       @/bin/rm -rf $(CURDIR)/libbpf $(CURDIR)/bpftool

should this be $(RM) -rf ? I've seen other makefiles don't hardcode
/bin/rm. And also below we are passing RM='rm -rf', not /bin/rm.
Inconsistent :)

>
> -$(LIBBPF): FORCE
> +$(LIBBPF): FORCE | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
>  # Fix up variables inherited from Kbuild that tools/ build system won't like
> -       $(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
> -               LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
> +       $(MAKE) -C $(LIBBPF_SRC) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
> +               LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ \
> +               O= OUTPUT=$(LIBBPF_OUTPUT)/ DESTDIR=$(LIBBPF_DESTDIR) prefix= \
> +               $@ install_headers
>
>  BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
> -BPFTOOL := $(BPFTOOLDIR)/bpftool
> -$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)
> -           $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../
> +BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
> +BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
> +           | $(BPFTOOL_OUTPUT)
> +           $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
> +               OUTPUT=$(BPFTOOL_OUTPUT)/ \
> +               LIBBPF_OUTPUT=$(LIBBPF_OUTPUT) \
> +               LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)
> +
> +$(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE) $(BPFTOOL_OUTPUT):
> +       $(call msg,MKDIR,$@)
> +       $(Q)mkdir -p $@
>
>  $(obj)/syscall_nrs.h:  $(obj)/syscall_nrs.s FORCE
>         $(call filechk,offsets,__SYSCALL_NRS_H__)
> @@ -367,7 +383,7 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
>         $(Q)$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(SRCARCH) \
>                 -Wno-compare-distinct-pointer-types -I$(srctree)/include \
>                 -I$(srctree)/samples/bpf -I$(srctree)/tools/include \
> -               -I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
> +               -I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
>                 -c $(filter %.bpf.c,$^) -o $@
>
>  LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
> @@ -404,7 +420,7 @@ $(obj)/%.o: $(src)/%.c
>         @echo "  CLANG-bpf " $@
>         $(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(BPF_EXTRA_CFLAGS) \
>                 -I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
> -               -I$(srctree)/tools/lib/ \
> +               -I$(LIBBPF_INCLUDE) \
>                 -D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
>                 -D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
>                 -Wno-gnu-variable-sized-type-not-at-end \
> --
> 2.30.2
>
