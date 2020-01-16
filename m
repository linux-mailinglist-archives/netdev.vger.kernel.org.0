Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDF413FC45
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387638AbgAPWlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:41:42 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:44699 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbgAPWlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:41:42 -0500
Received: by mail-qv1-f68.google.com with SMTP id n8so9870548qvg.11;
        Thu, 16 Jan 2020 14:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CvIccACVJOu+2bdMdFsFdYMzg33aY8K8AC76wN0kDto=;
        b=O0cAJfcHYGCgIA8WbapvXW9IDV+kbyROt5CNbPSoThZuz9xqGvQ4Oss6M18/EmLTIc
         dTpCi9AY79w9SfhUyf9VVclC0wN3NEzcEFjLnQ517nzFc6KCuxcnGoq2IjR+5IytfGZN
         uAzQymNA3Geb/hbdYmJxWsLeashTbh2oZVJ0tKcEJVLmdAXr2yDLTSSVo05e6sx1n5HJ
         YB3StCybbRAQDJ9hNqEw8X7zb0P3ZVU4+2HGG8BG4FBhorbGhfPAbgYkUTwk3df0DFT5
         69oW98/w7JuZX8s2WgLeYQ7kD3vfv28nwfZzEDODSZ3FWFhRUtrkQvKwWi7hAeOENp2d
         edbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CvIccACVJOu+2bdMdFsFdYMzg33aY8K8AC76wN0kDto=;
        b=WkeMuTFdX2S9suHcgb5R5+kxRE6ltfbbxuCSvGVoIX2mQ6R942WnJNlZf3hN5KAW5O
         dy4xDzdhqba32PWcYiVXz29x2c9r0WBBKZK+YmL6id/d0WmKGAbSD2Uw5/U+sovBwRSM
         C4n8OVUZ3LEVCMejO08H9NlEPqKevIlFIQAhQqS1zLotVl7YEcV8kVeOyx9fgB3QAb3Q
         aLmrSWgoR286MZvjbZtj7ERaIn0QIVDV/CO71X8k7ksn/ccMpffjFCVPnD2hHSTJf4aP
         EdxGWmqSfr0P0tSrgvxaErvpSyTnMbmjK6KgTK3imrPnRjd71fSnebNZvGavElja6fq0
         /BBg==
X-Gm-Message-State: APjAAAUJd5bqDwauuiBJMGYJWtYKX8ZTaTcb9aKgrPtHigKxQhoaH32a
        mvcATIqqTqYyqn/QsLhpqDJ2dpMM8cGPyFAvbrk=
X-Google-Smtp-Source: APXvYqxG7IhaZye7iAhvt7VSksxRKKAizWjY1gJRJNlU7eKDQJUQYQ4bNcAdA2ftB2AQOKtlxIFGvajndcNjgrCkFmU=
X-Received: by 2002:ad4:54d3:: with SMTP id j19mr4814230qvx.247.1579214500294;
 Thu, 16 Jan 2020 14:41:40 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918094179.1357254.14428494370073273452.stgit@toke.dk>
In-Reply-To: <157918094179.1357254.14428494370073273452.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 14:41:29 -0800
Message-ID: <CAEf4Bzba5FHN_iN52qRiGisRcauur1FqDY545EwE+RVR-nFvQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 09/11] selftests: Remove tools/lib/bpf from
 include path
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 5:28 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> To make sure no new files are introduced that doesn't include the bpf/
> prefix in its #include, remove tools/lib/bpf from the include path
> entirely.
>
> Instead, we introduce a new header files directory under the scratch tool=
s/
> dir, and add a rule to run the 'install_headers' rule from libbpf to have=
 a
> full set of consistent libbpf headers in $(OUTPUT)/tools/include/bpf, and
> then use $(OUTPUT)/tools/include as the include path for selftests.
>
> For consistency we also make sure we put all the scratch build files from
> other bpftool and libbpf into tools/build/, so everything stays within
> selftests/.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/testing/selftests/bpf/.gitignore |    1 +
>  tools/testing/selftests/bpf/Makefile   |   50 +++++++++++++++++++-------=
------
>  2 files changed, 31 insertions(+), 20 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
> index 1d14e3ab70be..849be9990ad2 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -40,3 +40,4 @@ test_cpp
>  /bpf_gcc
>  /tools
>  bpf_helper_defs.h
> +/include/bpf

Isn't the real path (within selftests/bpf) a tools/include/bpf, which
is already ignored through /tools rule?

> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index 1fd7da49bd56..c3fa695bb028 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -20,8 +20,8 @@ CLANG         ?=3D clang
>  LLC            ?=3D llc
>  LLVM_OBJCOPY   ?=3D llvm-objcopy
>  BPF_GCC                ?=3D $(shell command -v bpf-gcc;)
> -CFLAGS +=3D -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR) -I$(LIBDIR)=
  \
> -         -I$(BPFDIR) -I$(GENDIR) -I$(TOOLSINCDIR)                      \
> +CFLAGS +=3D -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)            =
  \
> +         -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR)     \
>           -Dbpf_prog_load=3Dbpf_prog_test_load                           =
 \
>           -Dbpf_load_program=3Dbpf_test_load_program
>  LDLIBS +=3D -lcap -lelf -lz -lrt -lpthread
> @@ -97,11 +97,15 @@ OVERRIDE_TARGETS :=3D 1
>  override define CLEAN
>         $(call msg,CLEAN)
>         $(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_=
FILES) $(EXTRA_CLEAN)
> -       $(MAKE) -C $(BPFDIR) OUTPUT=3D$(OUTPUT)/ clean
>  endef
>
>  include ../lib.mk
>
> +SCRATCH_DIR :=3D $(OUTPUT)/tools
> +BUILD_DIR :=3D $(SCRATCH_DIR)/build
> +INCLUDE_DIR :=3D $(SCRATCH_DIR)/include
> +INCLUDE_BPF :=3D $(INCLUDE_DIR)/bpf/bpf.h
> +
>  # Define simple and short `make test_progs`, `make test_sysctl`, etc tar=
gets
>  # to build individual tests.
>  # NOTE: Semicolon at the end is critical to override lib.mk's default st=
atic
> @@ -120,7 +124,7 @@ $(OUTPUT)/urandom_read: urandom_read.c
>         $(call msg,BINARY,,$@)
>         $(CC) -o $@ $< -Wl,--build-id
>
> -$(OUTPUT)/test_stub.o: test_stub.c
> +$(OUTPUT)/test_stub.o: test_stub.c $(INCLUDE_BPF)
>         $(call msg,CC,,$@)
>         $(CC) -c $(CFLAGS) -o $@ $<
>
> @@ -129,7 +133,7 @@ $(OUTPUT)/runqslower: force
>         $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower      =
     \
>                     OUTPUT=3D$(CURDIR)/tools/ VMLINUX_BTF=3D$(abspath ../=
../../../vmlinux)
>
> -BPFOBJ :=3D $(OUTPUT)/libbpf.a
> +BPFOBJ :=3D $(BUILD_DIR)/libbpf/libbpf.a
>
>  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BP=
FOBJ)
>
> @@ -155,17 +159,23 @@ force:
>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/tools/sbin/bpftool
>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
>
> -$(DEFAULT_BPFTOOL): force
> -       $(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)                  =
     \
> +$(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(INCLUDE_DIR):
> +       $(call msg,MKDIR,,$@)
> +       mkdir -p $@
> +
> +$(DEFAULT_BPFTOOL): force $(BUILD_DIR)/bpftool

directories should be included as order-only dependencies (after | )

> +       $(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)         \
> +                   OUTPUT=3D$(BUILD_DIR)/bpftool/                       =
 \
>                     prefix=3D DESTDIR=3D$(OUTPUT)/tools/ install
>
> -$(BPFOBJ): force
> -       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=3D$(OUTPUT)/
> +$(BPFOBJ): force $(BUILD_DIR)/libbpf

same

> +       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) \
> +               OUTPUT=3D$(BUILD_DIR)/libbpf/
>
> -BPF_HELPERS :=3D $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.=
h)
> -$(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
> -       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                       =
     \
> -                   OUTPUT=3D$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
> +BPF_HELPERS :=3D $(wildcard $(BPFDIR)/bpf_*.h) $(INCLUDE_BPF)

Shouldn't all BPF_HELPERS come from $(INCLUDE_DIR)/bpf now?

> +$(INCLUDE_BPF): force $(BPFOBJ)

And this can be more properly a $(BPF_HELPERS): force $(BPFOBJ)?

> +       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) install_headers \
> +               OUTPUT=3D$(BUILD_DIR)/libbpf/ DESTDIR=3D$(SCRATCH_DIR) pr=
efix=3D
>
>  # Get Clang's default includes on this system, as opposed to those seen =
by
>  # '-target bpf'. This fixes "missing" files on some architectures/distro=
s,
> @@ -185,8 +195,8 @@ MENDIAN=3D$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-m=
big-endian)
>
>  CLANG_SYS_INCLUDES =3D $(call get_sys_includes,$(CLANG))
>  BPF_CFLAGS =3D -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                 =
 \
> -            -I$(OUTPUT) -I$(CURDIR) -I$(CURDIR)/include/uapi           \
> -            -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(abspath $(OUTPUT)/..=
/usr/include)
> +            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(CURDIR)/include/uapi      \
> +            -I$(APIDIR) -I$(abspath $(OUTPUT)/../usr/include)
>
>  CLANG_CFLAGS =3D $(CLANG_SYS_INCLUDES) \
>                -Wno-compare-distinct-pointer-types
> @@ -306,7 +316,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:    =
               \
>                       $(TRUNNER_EXTRA_HDRS)                             \
>                       $(TRUNNER_BPF_OBJS)                               \
>                       $(TRUNNER_BPF_SKELS)                              \
> -                     $$(BPFOBJ) | $(TRUNNER_OUTPUT)
> +                     $$(BPFOBJ) $$(INCLUDE_BPF) | $(TRUNNER_OUTPUT)

singling out $(INCLUDE_BPF) looks weird? But I think $(BPFOBJ)
achieves the same effect, so this change can be probably dropped? Same
below.

>         $$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
>         cd $$(@D) && $$(CC) $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(=
@F)
>
> @@ -314,7 +324,7 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:        =
                       \
>                        %.c                                              \
>                        $(TRUNNER_EXTRA_HDRS)                            \
>                        $(TRUNNER_TESTS_HDR)                             \
> -                      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
> +                      $$(BPFOBJ) $$(INCLUDE_BPF) | $(TRUNNER_OUTPUT)
>         $$(call msg,EXT-OBJ,$(TRUNNER_BINARY),$$@)
>         $$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
>
> @@ -326,7 +336,7 @@ ifneq ($2,)
>  endif
>
>  $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)                      \
> -                            $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)           \
> +                            $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ) $$(INCLUDE_=
BPF)           \
>                              | $(TRUNNER_BINARY)-extras
>         $$(call msg,BINARY,,$$@)
>         $$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
> @@ -388,7 +398,7 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_=
extern.skel.h $(BPFOBJ)
>         $(call msg,CXX,,$@)
>         $(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
>
> -EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS)                                   =
 \
> +EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)                    =
 \
>         prog_tests/tests.h map_tests/tests.h verifier/tests.h           \
>         feature                                                         \
> -       $(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc tools)
> +       $(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc)
>
