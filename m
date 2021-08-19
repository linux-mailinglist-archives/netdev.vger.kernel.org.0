Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8E53F22E1
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhHSWRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235852AbhHSWR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:17:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDED4608FE;
        Thu, 19 Aug 2021 22:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629411410;
        bh=Jch+3Ax87+1/iAOT5wwQKdSvOesvPFQpbYLw/CCHsy4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nfEhouSa0f1oZt3fUFd6CoNcNWblbFQZJuVIgrhiOwvluHbc+w5VmqCtEQCtLcjpg
         AqJgH16xVZsLzgzq2StGFhx+22pdRClHRuoR7t/vhIiKLIkZFlzqErIKdM/rAskBR9
         ccnmrSLV7rN43GekaO+WuyLS6Xwrlat8B5gVWp+p+HRUhO45fenfibSbX3JZbc3lg5
         hTxrB3Yzp1HB9uFz42bqLCmzwoLAqesixAeGNITD8an/100eXGn6hVsrFy6VGGWygO
         adh5fGE+j/tun0Zk1ZRQhxbW6DjwZPOqDQA7iQhc+b4UckgyOGEbYLYw0x1oUdH7Tc
         L2Wox1/JUCQIw==
Received: by mail-lf1-f45.google.com with SMTP id w20so16071284lfu.7;
        Thu, 19 Aug 2021 15:16:50 -0700 (PDT)
X-Gm-Message-State: AOAM532cSTiBLLWbBrXHomSntvLcPrHYYtUDhLL6vg+R8atn9O6doPYu
        NuEFfkhpbkrhAGZRAiIiFNAH/i/UOBcmIdWZJ3A=
X-Google-Smtp-Source: ABdhPJxo1NIsebdSOYgFeXIpqE8FX/yKBJ4O71p1uiBZoohYPx/cT9sIJJhaTXvOVLcWbgcIhnHDWoMbs1wwKUHk5bQ=
X-Received: by 2002:a05:6512:169d:: with SMTP id bu29mr12221745lfb.160.1629411409125;
 Thu, 19 Aug 2021 15:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210819072431.21966-1-lizhijian@cn.fujitsu.com> <20210819072431.21966-3-lizhijian@cn.fujitsu.com>
In-Reply-To: <20210819072431.21966-3-lizhijian@cn.fujitsu.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 19 Aug 2021 15:16:38 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5J2dg+aiwbQC28YZkEYEstcCQKP7fY9e4i=OPuMMsSTQ@mail.gmail.com>
Message-ID: <CAPhsuW5J2dg+aiwbQC28YZkEYEstcCQKP7fY9e4i=OPuMMsSTQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] selftests/bpf: add missing files required by
 test_bpftool.sh for installing
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

On Thu, Aug 19, 2021 at 12:28 AM Li Zhijian <lizhijian@cn.fujitsu.com> wrote:
>
> - 'make install' will install bpftool to INSTALL_PATH/bpf/bpftool
> - add INSTALL_PATH/bpf to PATH
>
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

Acked-by: Song Liu <songliubraving@fb.com>

With one nit below:

> ---
>  tools/testing/selftests/bpf/Makefile        | 4 +++-
>  tools/testing/selftests/bpf/test_bpftool.sh | 3 ++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index f405b20c1e6c..c6ca1b8e33d5 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -85,7 +85,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>  TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>         flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>         test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> -       xdpxceiver xdp_redirect_multi
> +       xdpxceiver xdp_redirect_multi test_bpftool.py
>
>  TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
>
> @@ -187,6 +187,8 @@ $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
>                     BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR) &&      \
>                     cp $(SCRATCH_DIR)/runqslower $@
>
> +TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
> +
>  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
>
>  $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
> diff --git a/tools/testing/selftests/bpf/test_bpftool.sh b/tools/testing/selftests/bpf/test_bpftool.sh
> index 6b7ba19be1d0..50cf9d3645d2 100755
> --- a/tools/testing/selftests/bpf/test_bpftool.sh
> +++ b/tools/testing/selftests/bpf/test_bpftool.sh
> @@ -2,9 +2,10 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (c) 2020 SUSE LLC.
>
> +# 'make -C tools/testing/selftests/bpf install' will install to SCRIPT_PATH

nit: Should be SCRIPT_DIR.              ^^^^^

>  SCRIPT_DIR=$(dirname $(realpath $0))
>
>  # 'make -C tools/testing/selftests/bpf' will install to BPFTOOL_INSTALL_PATH
>  BPFTOOL_INSTALL_PATH="$SCRIPT_DIR"/tools/sbin
> -export PATH=$BPFTOOL_INSTALL_PATH:$PATH
> +export PATH=$SCRIPT_DIR:$BPFTOOL_INSTALL_PATH:$PATH
>  python3 -m unittest -v test_bpftool.TestBpftool
> --
> 2.32.0
>
>
>
