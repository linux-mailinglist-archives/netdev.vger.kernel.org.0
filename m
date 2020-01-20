Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC9814232F
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 07:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgATGVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 01:21:08 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34650 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgATGVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 01:21:08 -0500
Received: by mail-qk1-f195.google.com with SMTP id j9so29127135qkk.1;
        Sun, 19 Jan 2020 22:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HzgwQjk23FH9alWYUZE6q0CWsQkjBSTe2jUKbbfrMf8=;
        b=CvqTeXhX9F6eVJZp+SYzLBQGk1j0R2KFNWPCi2rapCMh4k2e1ccT//93/BPrWl82y1
         vGarXBJzdbATNWwv/w9OlWb+ZVhBtDiyan/veftuq9TC5NB1wKROhJDgjUBLx/V5dUZc
         0Q9/RlS3HmjPLQPgJctAqVzZIicj/l8DEDtcVKSn7KnbOdwd+4jWGhZI6KbpxLNBXEmt
         MQqnbeDlWSshcgQOKRHQ181Hhbj7+ZqVt6uq82LMofX5Nk20WVSmM99TD+NwzwTMgYLj
         PJP0O6DGp9v8ZdizZZdoFOu7lAfFobH/Je2qQXRCAC2D2J7+d/WnDcDgQsOlve/gUbys
         JpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HzgwQjk23FH9alWYUZE6q0CWsQkjBSTe2jUKbbfrMf8=;
        b=iJZ3V8n3haQHUpA4YYze4a8YBOFdIOHUlKDJKyVxoYJmkdcMtuCoS7X1fdznTK78b3
         jRvZcasBZT1etMtzara6WS/l00uS+GXvAFyYBxQ502X99a3WQjekUvJqp1mb0nuP1w6A
         LiDiLBitNS7QnNimpvOtU49BgiETGPuz8fcq4aclG9DJ74gGmdz2PXbNOwrP+4cLjDdk
         FF3lKmAoCtbXO6iFFHsN6E9n/yUhVRCVjoufy89VNq7SlQnUKJ6DAHXn/tw2/aj45mj1
         idigrvaFo+JgUxxllVVmgwjMpbl96+nTnSSK1PpfQCIu+mot217iWy8vV5W0xRNDZMZC
         Lc7g==
X-Gm-Message-State: APjAAAUTNUXCUQY6d9H4LkkfFZ66QqzD6+ooSQQ2Qa5X5wtikuKJ8vPz
        Hb2RiJBwhwphHxhsAu5Lc++iSaUWmcmpHp6G/Cg=
X-Google-Smtp-Source: APXvYqyf+AOg23rg7WeXYxqzp4r3mgJLIWtxn6tckbkEE2rtwGF9JOexPu3kHucfyEKTtHP4YPeGHwAWjvVI+3UbALs=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr46460647qkq.437.1579501266863;
 Sun, 19 Jan 2020 22:21:06 -0800 (PST)
MIME-Version: 1.0
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk> <157926820677.1555735.5437255599683298212.stgit@toke.dk>
In-Reply-To: <157926820677.1555735.5437255599683298212.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 19 Jan 2020 22:20:55 -0800
Message-ID: <CAEf4Bzb9zUmhxTyYahJqySJzgfyB-zMEd+o4ybv=a8-t+iZS4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 09/10] selftests: Remove tools/lib/bpf from
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

On Fri, Jan 17, 2020 at 5:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
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
>  tools/testing/selftests/bpf/.gitignore |    2 +
>  tools/testing/selftests/bpf/Makefile   |   49 +++++++++++++++++++++-----=
------
>  2 files changed, 33 insertions(+), 18 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
> index 1d14e3ab70be..8c9eac626996 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -39,4 +39,4 @@ test_cpp
>  /no_alu32
>  /bpf_gcc
>  /tools
> -bpf_helper_defs.h

can you please also drop libbpf.pc and libbpf.so.* rules from .gitignore?

> +
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index 858d4e3369ad..ac0292a82fdc 100644
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

extra space here

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
> +INCLUDE_BPF :=3D $(INCLUDE_DIR)/bpf
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
> @@ -133,7 +137,7 @@ $(OUTPUT)/runqslower: force
>         $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower     \
>                     OUTPUT=3D$(OUTPUT)/tools/ VMLINUX_BTF=3D$(VMLINUX_BTF=
)
>
> -BPFOBJ :=3D $(OUTPUT)/libbpf.a
> +BPFOBJ :=3D $(BUILD_DIR)/libbpf/libbpf.a
>
>  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BP=
FOBJ)
>
> @@ -159,17 +163,28 @@ force:
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
> +$(DEFAULT_BPFTOOL): force | $(BUILD_DIR)/bpftool
> +       $(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)         \

slash alignment


> +                   OUTPUT=3D$(BUILD_DIR)/bpftool/                       =
 \
>                     prefix=3D DESTDIR=3D$(OUTPUT)/tools/ install
>
> -$(BPFOBJ): force
> -       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=3D$(OUTPUT)/
> +$(BPFOBJ): force | $(BUILD_DIR)/libbpf
> +       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) \
> +               OUTPUT=3D$(BUILD_DIR)/libbpf/
> +
> +$(INCLUDE_BPF): $(BPFOBJ) | $(INCLUDE_DIR)
> +       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) install_headers \
> +               OUTPUT=3D$(BUILD_DIR)/libbpf/ DESTDIR=3D$(SCRATCH_DIR) pr=
efix=3D
> +
> +BPF_HELPERS :=3D $(or $(wildcard $(INCLUDE_BPF)/bpf_*.h),$(INCLUDE_BPF))
> +ifneq ($(BPF_HELPERS),$(INCLUDE_BPF))
> +$(BPF_HELPERS): $(INCLUDE_BPF)
> +endif
>
> -BPF_HELPERS :=3D $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.=
h)
> -$(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
> -       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                       =
     \
> -                   OUTPUT=3D$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
>

I really-really didn't like this alternating dependency on directory
or a set of file, depending on current state of those temporary
directories. Then also this ugly check to avoid circular dependency.
All that seemed wrong. So I played a bit with how to achieve the same
differently, and here's what I came up with, which I like a bit
better. What do you think?

$(BPFOBJ): $(wildcard $(BPFDIR)/*.c $(BPFDIR)/*.h $(BPFDIR)/Makefile)      =
    \
           ../../../include/uapi/linux/bpf.h                               =
    \
           | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
        $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=3D$(BUILD_DIR)/li=
bbpf/ \
                    DESTDIR=3D$(SCRATCH_DIR) prefix=3D all install_headers

So, essentially, just make sure that we install local copies of
headers whenever libbpf.a needs to be re-built.
../../../include/uapi/linux/bpf.h ensures we don't miss uapi header
changes as well. Now anything that uses libbpf headers will need to
depend on $(BPFOBJ) and will automatically get up-to-date local copies
of headers.

This seems much simpler. Please give it a try, thanks!

>  # Get Clang's default includes on this system, as opposed to those seen =
by
>  # '-target bpf'. This fixes "missing" files on some architectures/distro=
s,
> @@ -189,8 +204,8 @@ MENDIAN=3D$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-m=
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
> @@ -392,7 +407,7 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_=
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
