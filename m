Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793313F22DB
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhHSWOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235679AbhHSWOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31A70610A0;
        Thu, 19 Aug 2021 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629411217;
        bh=48vToeVCTgJWFqh43BBe/nhigtxNdkSSAJh27xugjVg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l+bKA3le/phRKytYe6EEMgLaIG6kDta81HcBri1QXlimWKQSgA8mxiNJov3lz37Re
         KECkvgOqht5H16etSIc01E+V+4gxpG83jo7Izvv4QrSpCiw1M77DcJpWIzfB+07bMA
         7V+xbnojHDo/J5pSojo8uXFJiURKKpLZg8yA71+i8irz8Gm5m9nMudXCozL0zykQ2V
         yPjGF7IPNCNv6k4cxVMso7RLMm7vhfSO6OvUhntOu5XFUI6TG1uZAZFQytB51pECZ9
         a0lX5V9NwhJ8jUkmlDxVOqRHaPq9u8o0nlIeT3WkYkbFgp9KPCTWMjM5vrUWvLNXUn
         7nn8mic7JyEUA==
Received: by mail-lf1-f51.google.com with SMTP id u22so16001575lfq.13;
        Thu, 19 Aug 2021 15:13:37 -0700 (PDT)
X-Gm-Message-State: AOAM5332kK6kNmhvK01EY2zxPp2cBzvkeIgm3G2YimiIdQ6FajO6w5XR
        ze/R9j6eZ5p+f1Y0MlF9mWyiwYP2df+d5yF4q9s=
X-Google-Smtp-Source: ABdhPJwumbdNjAIQOU/dThvLNp3k2jl6kVoIqFHgbRcETT9xYYUrzue39xM/LDvoIaVxRit81S+oWcFQDXbqCXh/eaQ=
X-Received: by 2002:ac2:58e5:: with SMTP id v5mr11834113lfo.438.1629411215541;
 Thu, 19 Aug 2021 15:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210819072431.21966-1-lizhijian@cn.fujitsu.com> <20210819072431.21966-2-lizhijian@cn.fujitsu.com>
In-Reply-To: <20210819072431.21966-2-lizhijian@cn.fujitsu.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 19 Aug 2021 15:13:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Bq==H9qdjCQtuQiaUz6+oqgeMTTnseCUwS5WuhH1TNQ@mail.gmail.com>
Message-ID: <CAPhsuW6Bq==H9qdjCQtuQiaUz6+oqgeMTTnseCUwS5WuhH1TNQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] selftests/bpf: add default bpftool built by selftests
 to PATH
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>, philip.li@intel.com,
        yifeix.zhu@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 12:27 AM Li Zhijian <lizhijian@cn.fujitsu.com> wrote:
>
> For 'make run_tests':
> selftests will build bpftool into tools/testing/selftests/bpf/tools/sbin/bpftool
> by default.
>
> ==================
> root@lkp-skl-d01 /opt/rootfs/v5.14-rc4# make -C tools/testing/selftests/bpf run_tests
> make: Entering directory '/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf'
>   MKDIR    include
>   MKDIR    libbpf
>   MKDIR    bpftool
> [...]
>   GEN     /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/profiler.skel.h
>   CC      /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/prog.o
>   GEN     /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/pid_iter.skel.h
>   CC      /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/pids.o
>   LINK    /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/bpftool
>   INSTALL bpftool
>   GEN      vmlinux.h
> [...]
>  # test_feature_dev_json (test_bpftool.TestBpftool) ... ERROR
>  # test_feature_kernel (test_bpftool.TestBpftool) ... ERROR
>  # test_feature_kernel_full (test_bpftool.TestBpftool) ... ERROR
>  # test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool) ... ERROR
>  # test_feature_macros (test_bpftool.TestBpftool) ... Error: bug: failed to retrieve CAP_BPF status: Invalid argument
>  # ERROR
>  #
>  # ======================================================================
>  # ERROR: test_feature_dev_json (test_bpftool.TestBpftool)
>  # ----------------------------------------------------------------------
>  # Traceback (most recent call last):
>  #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 57, in wrapper
>  #     return f(*args, iface, **kwargs)
>  #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 82, in test_feature_dev_json
>  #     res = bpftool_json(["feature", "probe", "dev", iface])
>  #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 42, in bpftool_json
>  #     res = _bpftool(args)
>  #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 34, in _bpftool
>  #     return subprocess.check_output(_args)
>  #   File "/usr/lib/python3.7/subprocess.py", line 395, in check_output
>  #     **kwargs).stdout
>  #   File "/usr/lib/python3.7/subprocess.py", line 487, in run
>  #     output=stdout, stderr=stderr)
>  # subprocess.CalledProcessError: Command '['bpftool', '-j', 'feature', 'probe', 'dev', 'dummy0']' returned non-zero exit status 255.
>  #
> ==================
>
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/testing/selftests/bpf/test_bpftool.sh | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_bpftool.sh b/tools/testing/selftests/bpf/test_bpftool.sh
> index 66690778e36d..6b7ba19be1d0 100755
> --- a/tools/testing/selftests/bpf/test_bpftool.sh
> +++ b/tools/testing/selftests/bpf/test_bpftool.sh
> @@ -2,4 +2,9 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (c) 2020 SUSE LLC.
>
> +SCRIPT_DIR=$(dirname $(realpath $0))
> +
> +# 'make -C tools/testing/selftests/bpf' will install to BPFTOOL_INSTALL_PATH
> +BPFTOOL_INSTALL_PATH="$SCRIPT_DIR"/tools/sbin
> +export PATH=$BPFTOOL_INSTALL_PATH:$PATH
>  python3 -m unittest -v test_bpftool.TestBpftool
> --
> 2.32.0
>
>
>
