Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8012230FCCA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbhBDT2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236970AbhBDT2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 14:28:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7BB164F6A;
        Thu,  4 Feb 2021 19:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612466872;
        bh=tY8/mb/pgUOhz3q9X5oeyZT0tvaW36b3usnwkCEu92s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bPLjIKqGxAKXMyWTsBKeGBdc6OlclmNa7r941BCX01ySnup5px82ttanAhDiQnILp
         MKOcrIfxIKC2genhoHsZKnNkCJvB8bJ1smWKtNDFm8C1Nmp1AtnW6hT8sFbZRycQcH
         JBOYVvONk3kxWBrV48VwrwxUalzm/czpMSju10OwcpohII+JQYtZu0i0BQwt3gIRpM
         6JjFEUfX1D8TlnrfbdHxdI5P4tSraPcIMFbdhr/91/+j/ugoOuOqTFO3+NrR2l0B2f
         e0ruNco1vWD/RgOTKw8gYCxcnebXtX+SCFkak/dWD61h43If5yWyJ+Kk6Kd8vX3que
         MDTDA3gyfhXvw==
Received: by mail-lj1-f179.google.com with SMTP id r23so2923452ljh.1;
        Thu, 04 Feb 2021 11:27:51 -0800 (PST)
X-Gm-Message-State: AOAM532dHEx+tjI/Zz6glcEvl+utqdRkmJ4nwdlCUOH7QlX5ynyYtGzT
        g6lQgnIPvdh2/4PjsLNaPRSs4va/LhrOdvK4B2w=
X-Google-Smtp-Source: ABdhPJzCWNJ+b/m3ICuZlRpYMKj/y45anJ9mwZbXKDLUWU10Oj3GQspTNxR8wD7qjvdbaziJcDkWUrdtOCWcSVF1o+o=
X-Received: by 2002:a2e:8e91:: with SMTP id z17mr516165ljk.506.1612466870187;
 Thu, 04 Feb 2021 11:27:50 -0800 (PST)
MIME-Version: 1.0
References: <1612438753-30133-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1612438753-30133-1-git-send-email-yangtiezhu@loongson.cn>
From:   Song Liu <song@kernel.org>
Date:   Thu, 4 Feb 2021 11:27:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5M-zkFMo=qpQ1_aQe3cfCQHbdyHGxvcsqGPO-5x5q=3w@mail.gmail.com>
Message-ID: <CAPhsuW5M-zkFMo=qpQ1_aQe3cfCQHbdyHGxvcsqGPO-5x5q=3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: Add hello world sample for newbies
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 3:42 AM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> The program is made in a way that everytime an execve syscall
> is executed it prints Hello, BPF World!
>
> This is inspired and based on the code example for the book
> Linux Observability with BPF [1], load_bpf_file() has been
> removed after commit ceb5dea56543 ("samples: bpf: Remove
> bpf_load loader completely"), so the old version can not
> work in the latest mainline kernel.
>
> Since it is very simple and useful for newbies, I think it is
> necessary to be upstreamed.

I wonder how much value we will get from this sample. If the user is
able to compile and try the hello world, they are sure able to compile
other code in samples/bpf. Also, this code doesn't use BPF skeleton,
which is the recommended way to write BPF programs. Maybe an
minimal example with BPF skeleton will add more value here?

Thanks,
Song



>
> [1] https://github.com/bpftools/linux-observability-with-bpf/tree/master/code/chapter-2/hello_world
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  samples/bpf/Makefile     |  3 +++
>  samples/bpf/hello_kern.c | 14 ++++++++++++++
>  samples/bpf/hello_user.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 59 insertions(+)
>  create mode 100644 samples/bpf/hello_kern.c
>  create mode 100644 samples/bpf/hello_user.c
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 45ceca4..fd17cbd 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -55,6 +55,7 @@ tprogs-y += task_fd_query
>  tprogs-y += xdp_sample_pkts
>  tprogs-y += ibumad
>  tprogs-y += hbm
> +tprogs-y += hello
>
>  # Libbpf dependencies
>  LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
> @@ -113,6 +114,7 @@ task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
>  xdp_sample_pkts-objs := xdp_sample_pkts_user.o
>  ibumad-objs := ibumad_user.o
>  hbm-objs := hbm.o $(CGROUP_HELPERS)
> +hello-objs := hello_user.o $(TRACE_HELPERS)
>
>  # Tell kbuild to always build the programs
>  always-y := $(tprogs-y)
> @@ -174,6 +176,7 @@ always-y += ibumad_kern.o
>  always-y += hbm_out_kern.o
>  always-y += hbm_edt_kern.o
>  always-y += xdpsock_kern.o
> +always-y += hello_kern.o
>
>  ifeq ($(ARCH), arm)
>  # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
> diff --git a/samples/bpf/hello_kern.c b/samples/bpf/hello_kern.c
> new file mode 100644
> index 0000000..b841029
> --- /dev/null
> +++ b/samples/bpf/hello_kern.c
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +SEC("tracepoint/syscalls/sys_enter_execve")
> +int trace_enter_execve(void *ctx)
> +{
> +       static const char msg[] = "Hello, BPF World!\n";
> +
> +       bpf_trace_printk(msg, sizeof(msg));
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/samples/bpf/hello_user.c b/samples/bpf/hello_user.c
> new file mode 100644
> index 0000000..9423bbb
> --- /dev/null
> +++ b/samples/bpf/hello_user.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <stdio.h>
> +#include <bpf/libbpf.h>
> +#include "trace_helpers.h"
> +
> +int main(int argc, char **argv)
> +{
> +       struct bpf_link *link = NULL;
> +       struct bpf_program *prog;
> +       struct bpf_object *obj;
> +
> +       obj = bpf_object__open_file("hello_kern.o", NULL);
> +       if (libbpf_get_error(obj)) {
> +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> +               return 0;
> +       }
> +
> +       if (bpf_object__load(obj)) {
> +               fprintf(stderr, "ERROR: loading BPF object file failed\n");
> +               goto cleanup;
> +       }
> +
> +       prog = bpf_object__find_program_by_name(obj, "trace_enter_execve");
> +       if (!prog) {
> +               fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
> +               goto cleanup;
> +       }
> +
> +       link = bpf_program__attach(prog);
> +       if (libbpf_get_error(link)) {
> +               fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> +               link = NULL;
> +               goto cleanup;
> +       }
> +
> +       read_trace_pipe();
> +
> +cleanup:
> +       bpf_link__destroy(link);
> +       bpf_object__close(obj);
> +       return 0;
> +}
> --
> 2.1.0
>
