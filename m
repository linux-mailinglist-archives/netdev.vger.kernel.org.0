Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D7F13CADA
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgAORWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:22:14 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46686 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAORWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:22:14 -0500
Received: by mail-qk1-f193.google.com with SMTP id r14so16340078qke.13;
        Wed, 15 Jan 2020 09:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c+q9bObKfV/TNxL1HH2wA5LqldoKCgE44YTN9MzEObM=;
        b=GrMEzUhQn0zT6crSejZhHzxJ565zwTFsxUR9ki86EyRy2cx7HvDN74IZyaV6aroql8
         K3fgFCmV1hnJaRrk6iJf0Tg94tPjQrxxg4vuKsRva69odUjEQ4f4j2772ygYz+WmMFhL
         cjrTGWoirgaXuP/24safNCO032yWaugbswo5hvRBFFN/4Ck+Dc1U7D+bf2ToYXx6Josa
         W3ljqEgmBLdUSYqIwoM7CATcCYyJqse5xecvkBpyk5y2UoWJKzXNJU9v8zFVtbs8/AbH
         ctM1VPLWN5+dHqy0WrXYem4qJXV+5LScvIQix21l+e/GP2j4mnZa2P2a72TqKUP5PgvQ
         vx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c+q9bObKfV/TNxL1HH2wA5LqldoKCgE44YTN9MzEObM=;
        b=tDXIFNgiMY6acOiV1NpgEXjQR6zYvEA0TSOfdkFhAxyGbodDwF7z41CrrMr9e3ReXw
         Mgo8bR9mHKY2JW/A37gx7kteRqcMm2xkmLCe8/qvec1Vl9992g4oH0CNmHUdGvR42FL9
         Lwpp63vjegzdjtX+pIzWxI0qUIENRreYVTHrClAB71T0ZR77+mKUv1gdABwJAWlxyVgD
         6XbAxrG5p6EIB0Dgv2Qa6Xll7Zw4L1uJdKYXwPJzg8klzXjp1SejJErhoXE1ef+woECI
         wNPU6ZyczaePQE4s5bnyN27rBh4UW3D0ujaRMNrV22ubQNRwzvDDG7/TuwfTHwBVzZUm
         vggA==
X-Gm-Message-State: APjAAAVmrvtqVMgfGrycNLtD1ciZttIyyrvkVL0sTroVprZAzeXsQiQP
        4gb/HUOdp5SZ18k0sD2yn3CSrZRLdK06Cm3ASlY=
X-Google-Smtp-Source: APXvYqyScdlmdVrGF9w3giFftAWTK3e0Gn2ZeH9X7LVvi8//1y3KSjgGhLXpszFvMNhgWxx4uor59cXxWZRukp51R/I=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr24418928qkq.437.1579108932557;
 Wed, 15 Jan 2020 09:22:12 -0800 (PST)
MIME-Version: 1.0
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk> <157909757860.1192265.1725940708658939712.stgit@toke.dk>
In-Reply-To: <157909757860.1192265.1725940708658939712.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 09:22:01 -0800
Message-ID: <CAEf4BzZ2jAQPKzzp+NhWXbUFcfdcXs+akFSY4O0JhabJy=9vag@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 09/10] selftests: Remove tools/lib/bpf from
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
        Jakub Kicinski <jakub.kicinski@netronome.com>,
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

On Wed, Jan 15, 2020 at 6:16 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> To make sure no new files are introduced that doesn't include the bpf/
> prefix in its #include, remove tools/lib/bpf from the include path
> entirely, and use tools/lib instead. To fix the original issue with
> bpf_helper_defs.h being stale, change the Makefile rule to regenerate the
> file in the lib/bpf dir instead of having a local copy in selftests.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/testing/selftests/bpf/.gitignore |    3 ++-
>  tools/testing/selftests/bpf/Makefile   |   16 ++++++++--------
>  2 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
> index 1d14e3ab70be..17dd02651dee 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -33,10 +33,11 @@ libbpf.pc
>  libbpf.so.*
>  test_hashmap
>  test_btf_dump
> +test_cgroup_attach
> +test_select_reuseport

These were moved into test_progs, they are not independent binaries
anymore, you probably just had old leftovers lying in your
selftests/bpf directory. Let's not re-add them.

>  xdping
>  test_cpp
>  *.skel.h
>  /no_alu32
>  /bpf_gcc
>  /tools
> -bpf_helper_defs.h
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index cd98ae875e30..4889cc3ead4b 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -21,7 +21,7 @@ LLC           ?=3D llc
>  LLVM_OBJCOPY   ?=3D llvm-objcopy
>  BPF_GCC                ?=3D $(shell command -v bpf-gcc;)
>  CFLAGS +=3D -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR) -I$(LIBDIR)=
  \
> -         -I$(BPFDIR) -I$(GENDIR) -I$(TOOLSINCDIR)                      \
> +         -I$(GENDIR) -I$(TOOLSINCDIR)                  \
>           -Dbpf_prog_load=3Dbpf_prog_test_load                           =
 \
>           -Dbpf_load_program=3Dbpf_test_load_program
>  LDLIBS +=3D -lcap -lelf -lz -lrt -lpthread
> @@ -129,7 +129,7 @@ $(OUTPUT)/runqslower: force
>         $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower      =
     \
>                     OUTPUT=3D$(CURDIR)/tools/
>
> -BPFOBJ :=3D $(OUTPUT)/libbpf.a
> +BPFOBJ :=3D $(BPFDIR)/libbpf.a

We can't do that. See fa633a0f8919 ("libbpf: Fix build on read-only
filesystems") for why and why we have this problem with
bpf_helper_defs.h in the first place.

>
>  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BP=
FOBJ)
>
> @@ -155,17 +155,17 @@ force:
>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/tools/sbin/bpftool
>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
>
> -$(DEFAULT_BPFTOOL): force
> +$(DEFAULT_BPFTOOL): force $(BPFOBJ)

do we need this? bpftool's makefile will build its own libbpf.a
independently. We can probably optimize that, but see above, we need
to ensure that we build only within selftest/bpf dirs.

This "read-only outside of selftests/bpf" requirement actually made me
realize that we probably need to specify OUTPUT pointing somewhere
inside selftests/bpf/tools subdir to build entire bpftool within
selftests/bpf directory and not touch anything outside. Do you mind
fixing that while you are at it?

>         $(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)                  =
     \
>                     prefix=3D DESTDIR=3D$(OUTPUT)/tools/ install
>
>  $(BPFOBJ): force
> -       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=3D$(OUTPUT)/
> +       $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=3D$(BPFDIR)/ $(=
BPFOBJ)
>
> -BPF_HELPERS :=3D $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.=
h)
> -$(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
> +BPF_HELPERS :=3D $(BPFDIR)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.=
h)
> +$(BPFDIR)/bpf_helper_defs.h: $(BPFOBJ)
>         $(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                       =
     \
> -                   OUTPUT=3D$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
> +               OUTPUT=3D$(BPFDIR)/ $(BPFDIR)/bpf_helper_defs.h
>
>  # Get Clang's default includes on this system, as opposed to those seen =
by
>  # '-target bpf'. This fixes "missing" files on some architectures/distro=
s,
> @@ -186,7 +186,7 @@ MENDIAN=3D$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-m=
big-endian)
>  CLANG_SYS_INCLUDES =3D $(call get_sys_includes,$(CLANG))
>  BPF_CFLAGS =3D -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                 =
 \
>              -I$(OUTPUT) -I$(CURDIR) -I$(CURDIR)/include/uapi           \
> -            -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(abspath $(OUTPUT)/..=
/usr/include)
> +            -I$(APIDIR) -I$(LIBDIR) -I$(abspath $(OUTPUT)/../usr/include=
)
>
>  CLANG_CFLAGS =3D $(CLANG_SYS_INCLUDES) \
>                -Wno-compare-distinct-pointer-types
>
