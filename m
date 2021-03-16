Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1EE33CD16
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 06:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhCPFXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 01:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhCPFXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 01:23:39 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED59DC06174A;
        Mon, 15 Mar 2021 22:23:38 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f145so19171257ybg.11;
        Mon, 15 Mar 2021 22:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=as1j5TVIebKSB3+bjZr2vTbvneBg0ZJAwUTNHGfGzUQ=;
        b=aJgWVmD8t70yKWFC/f84fdysDUgGpCiV7ZPxAguc1pPf2voiP0j8EEJ/uEzCAWacSV
         LSJr2Y5p1CbKMon3gy0nFfambYRahsXoh69YQ3OcQ3IXgfDHdDp0rW6MDL3Qg40yZSk5
         lsZr7b/KBV4EK/5P8B4P9+lWl62bfEYhfcWx6hHZsOMJMCBBlfaR8RN3sGnM/cxnmVG1
         +pn+BP0xocYkoJvrpKuBYIP9jXpRyLs2xTlgn1FNGrBoKmqJ/J1exN+eV1RFV7ANFNlz
         8k0SCocQzFP2FYW0hrOotLdhHAHO39Hmh8uqxkXoSYSSFvmZDRPWfoRsipiUVe4TLOkE
         X/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=as1j5TVIebKSB3+bjZr2vTbvneBg0ZJAwUTNHGfGzUQ=;
        b=sU8Fv1/lK9TVFO2kcycWWY9hhilDN0z/DvaKSE1cidf/LUyoUff1muN2YkSo+uxEaL
         RKtrR8F9sW8zMgZaHpeI3UO4IE8cTSNp9TtZEUsVwSt1D2EGdivnu6g0NmiS8AfwI2vm
         Gr1M/uOIUUhhYkl2iwUPxDHoqntTSRFirEaQX9iI9bpVgfiMia0eXAHir3Nxz2YZmv5u
         RI30tBXMLzwEFt6PRwNUBG5FALzv1GsWQC1EGMRVEdWcjH7BEGZuAQXlZtudzi6mmuV+
         kYxcecFJiEJEevhmGF8XaNdfdb8V8kj7rZhLrjvY5V1fSBqRHvs+9TwoQpXB54b/KViZ
         Ue9Q==
X-Gm-Message-State: AOAM531zdcdAwMByzcHd1MWRnOCJ+ILCz6e3x2TMLe1VEC7dEHaGJhXM
        5Zo9U4/upDZa+wHArdAYEv5Sw4r+E98mQuIqmIlLENQRWmyIAA==
X-Google-Smtp-Source: ABdhPJyGc7Xj8nvyC2jRrF96FWXw2EdoCuquHOTechoqcfHI5Mw1mgCGWlrRtREYH8haO1q+iDtoHEBu+b7POGNQNlk=
X-Received: by 2002:a25:74cb:: with SMTP id p194mr1321969ybc.347.1615872218190;
 Mon, 15 Mar 2021 22:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210313210920.1959628-1-andrii@kernel.org> <20210313210920.1959628-5-andrii@kernel.org>
In-Reply-To: <20210313210920.1959628-5-andrii@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Mar 2021 22:23:27 -0700
Message-ID: <CAEf4Bzb0Rv=vtarbKr_4-roQsb4P41UerPPagObWMx-73GMo=Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: build everything in debug mode
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 1:09 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Build selftests, bpftool, and libbpf in debug mode with DWARF data to
> facilitate easier debugging.
>
> In terms of impact on building and running selftests. Build is actually faster
> now:
>
> BEFORE: make -j60  380.21s user 37.87s system 1466% cpu 28.503 total
> AFTER:  make -j60  345.47s user 37.37s system 1599% cpu 23.939 total
>
> test_progs runtime seems to be the same:
>
> BEFORE:
> real    1m5.139s
> user    0m1.600s
> sys     0m43.977s
>
> AFTER:
> real    1m3.799s
> user    0m1.721s
> sys     0m42.420s
>
> Huge difference is being able to debug issues throughout test_progs, bpftool,
> and libbpf without constantly updating 3 Makefiles by hand (including GDB
> seeing the source code without any extra incantations).
>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/testing/selftests/bpf/Makefile | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index c3999587bc23..d0db2b673c6f 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -21,7 +21,7 @@ endif
>
>  BPF_GCC                ?= $(shell command -v bpf-gcc;)
>  SAN_CFLAGS     ?=
> -CFLAGS += -g -rdynamic -Wall -O2 $(GENFLAGS) $(SAN_CFLAGS)             \
> +CFLAGS += -g -Og -rdynamic -Wall $(GENFLAGS) $(SAN_CFLAGS)             \
>           -I$(CURDIR) -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)          \
>           -I$(TOOLSINCDIR) -I$(APIDIR) -I$(OUTPUT)                      \
>           -Dbpf_prog_load=bpf_prog_test_load                            \
> @@ -201,6 +201,7 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
>                     $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
>         $(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)                        \
>                     CC=$(HOSTCC) LD=$(HOSTLD)                                  \
> +                   EXTRA_CFLAGS='-g -Og'                                      \

I was asked about '-Og' flag and the minimum GCC version that supports
it. It seems it was added in GCC 4.8 ([0]), so given the kernel's
minimum version is GCC 4.9, we shouldn't need take any extra
precautions to handle older compilers.

  [0] https://gcc.gnu.org/gcc-4.8/changes.html

>                     OUTPUT=$(HOST_BUILD_DIR)/bpftool/                          \
>                     prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install
>
> @@ -218,6 +219,7 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)                 \
>            ../../../include/uapi/linux/bpf.h                                   \
>            | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
>         $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
> +                   EXTRA_CFLAGS='-g -Og'                                              \
>                     DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
>
>  ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
> @@ -225,7 +227,8 @@ $(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)                \
>            ../../../include/uapi/linux/bpf.h                                   \
>            | $(INCLUDE_DIR) $(HOST_BUILD_DIR)/libbpf
>         $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                             \
> -               OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD)     \
> +                   EXTRA_CFLAGS='-g -Og'                                              \
> +                   OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
>                     DESTDIR=$(HOST_SCRATCH_DIR)/ prefix= all install_headers
>  endif
>
> --
> 2.24.1
>
