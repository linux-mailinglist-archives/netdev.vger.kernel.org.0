Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68060976
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfGEPin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:38:43 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35206 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbfGEPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:38:42 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so7896246qke.2;
        Fri, 05 Jul 2019 08:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=44CRColOz43PILbQYOculO6DgJNLJH0X0qbN9V0XzEU=;
        b=Uskf37oRaXD4YMjMeTnbGfsw5Dy96Q3fq7kFX7OJ5eWSXh51/L8q5wn4JYMxXeRBD5
         fbeZJzK2jFKQ4Bnx4/a2g7rMbc1lW9FwM2fwv96rlnz/nU+DimN5jsUAaKzvVJt2Eelg
         gnwkIfR5UmfRBdJzAdEYBMgsInMswkYRk1NgJ5spymG0bL5Hq2vxFJX1A+i8LLxE1bH8
         n4RjarRwzsiNTDf/nMis/iId7XFhj2PAAVcgVzzW6E2ifH73wOR6x1QXSr0EaPfiNcHU
         N5fyyMaZu2ejYAcQMiVvDJlNuV0Xt5rl9jJsbqNcdQ7ILhpgXb9YYBsz0OQHjIuspYZf
         gweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=44CRColOz43PILbQYOculO6DgJNLJH0X0qbN9V0XzEU=;
        b=Pa8fVC37tEmEea1+s6mXlmMSUJXs0ujGdudZL6Fawrf0a+zz7P2zfA52WN+zrqLiF4
         3ALrW3Y01q2cQyRce7bk96DNGd4VLXzayR/OvvPiS8ygiEBIdezzb8T7t+ZSDAe+klQQ
         ElbS9iGqdTQuD2/E6nalh0NCWxk0nRikL7B+C1LoogR5V+7rkNlUbIbFTECusL1BlykA
         W87PjwYJ4kDMYJLrA4J6/HhsH+8+JXZNDssC+uFzAMuaD5YQEArPUY9XfRN08teD080s
         HWRZniJoSTtUHf/YU+uHh7hnkjKgcLfVD7Hb0qWH2hVIf8TEem21bdtDRFkdN4aXpYYG
         WIPA==
X-Gm-Message-State: APjAAAUa1wx6ATsF0HPxOEobziDWyNRQTQNNMzoerlE+u9f58QXnXmYv
        jDnFhMs7L4ercoGeVgktkS6e8/SJkSa7sFIYlJY=
X-Google-Smtp-Source: APXvYqxzFmHRM25rB4uGmkBENRYgJymD6oRy2BwlNTaB4J9gNA9TBY3ZHAOM7xKhXmrjj/+msqF3z3UVy83mpkV/lEI=
X-Received: by 2002:a37:b646:: with SMTP id g67mr3602775qkf.92.1562341121213;
 Fri, 05 Jul 2019 08:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190628152539.3014719-5-andriin@fb.com> <20190705074215.GC17490@shao2-debian>
In-Reply-To: <20190705074215.GC17490@shao2-debian>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Jul 2019 08:38:30 -0700
Message-ID: <CAEf4BzZt7kP9m-TrH=M38ugVzYuQaXoCJKcsLU7uVzq-f1UHRA@mail.gmail.com>
Subject: Re: [selftests/bpf] 6135bdd95f: kernel_selftests.bpf.test_offload.py.fail
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, lkp@01.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 12:43 AM kernel test robot <rong.a.chen@intel.com> wrote:
>
> FYI, we noticed the following commit (built with gcc-7):
>
> commit: 6135bdd95f26fe417db4e46d1e517de41e0ab9c1 ("[PATCH v2 bpf-next 4/4] selftests/bpf: convert legacy BPF maps to BTF-defined ones")
> url: https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/capture-integers-in-BTF-type-info-for-map-defs/20190701-041153
> base: https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git master
>
> in testcase: kernel_selftests
> with following parameters:
>
>         group: kselftests-00
>
> test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
>
>
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <rong.a.chen@intel.com>
>
>
> # selftests: bpf: test_offload.py
> # Test destruction of generic XDP...
> # Test TC non-offloaded...
> # Test TC non-offloaded isn't getting bound...
> # Test TC offloads are off by default...
> # Test TC offload by default...
> # Test TC cBPF bytcode tries offload by default...
> # Test TC cBPF unbound bytecode doesn't offload...
> # Test non-0 chain offload...
> # Test TC replace...
> # Test TC replace bad flags...
> # Test spurious extack from the driver...
> # Test TC offloads work...
> # Test TC offload basics...
> # Test TC offload is device-bound...
> # Test disabling TC offloads is rejected while filters installed...
> # Test qdisc removal frees things...
> # Test disabling TC offloads is OK without filters...
> # Test destroying device gets rid of TC filters...
> # Test destroying device gets rid of XDP...
> # Test XDP prog reporting...
> # Test XDP prog replace without force...
> # Test XDP prog replace with force...
> # Test XDP prog replace with bad flags...
> # Test XDP prog remove with bad flags...
> # Test MTU restrictions...
> # Test non-offload XDP attaching to HW...
> # Test offload XDP attaching to drv...
> # Test XDP offload...
> # Test XDP offload is device bound...
> # Test removing XDP program many times...
> # Test attempt to use a program for a wrong device...
> # Test multi-attachment XDP - default + offload...
> # Test multi-attachment XDP - replace...
> # Test multi-attachment XDP - detach...
> # Test multi-attachment XDP - reattach...
> # Test multi-attachment XDP - device remove...
> # Test multi-attachment XDP - drv + offload...
> # Test multi-attachment XDP - replace...
> # Test multi-attachment XDP - detach...
> # Test multi-attachment XDP - reattach...
> # Test multi-attachment XDP - device remove...
> # Test multi-attachment XDP - generic + offload...
> # Test multi-attachment XDP - replace...
> # Test multi-attachment XDP - reattach...
> # Test multi-attachment XDP - device remove...
> # Test mixing of TC and XDP...
> # Test binding TC from pinned...
> # Test binding XDP from pinned...
> # Test offload of wrong type fails...
> # Test asking for TC offload of two filters...
> # Test if netdev removal waits for translation...
> # Test loading program with maps...
> # Traceback (most recent call last):
> #   File "./test_offload.py", line 1153, in <module>
> #     sim.set_xdp(map_obj, "offload", JSON=False) # map fixup msg breaks JSON
> #   File "./test_offload.py", line 469, in set_xdp
> #     fail=fail, include_stderr=include_stderr)
> #   File "./test_offload.py", line 230, in ip
> #     fail=fail, include_stderr=include_stderr)
> #   File "./test_offload.py", line 155, in tool
> #     fail=fail, include_stderr=False)
> #   File "./test_offload.py", line 108, in cmd
> #     return cmd_result(proc, include_stderr=include_stderr, fail=fail)
> #   File "./test_offload.py", line 130, in cmd_result
> #     raise Exception("Command failed: %s\n%s" % (proc.args, stderr))
> # Exception: Command failed: ip link set dev eth1 xdpoffload obj /usr/src/perf_selftests-x86_64-rhel-7.6-6135bdd95f26fe417db4e46d1e517de41e0ab9c1/tools/testing/selftests/bpf/sample_map_ret0.o sec .text

We can't yet convert BPF programs that are loaded with iproute2 to new
BTF-defined maps, until iprout2 uses libbpf as a loader. I missed that
sample_map_ret0.c is used with iproute2, will undo conversion for it.

Thanks!

> #
> #
> # BTF debug data section '.BTF' rejected: Invalid argument (22)!
> #  - Length:       811
> # Verifier analysis:
> #
> # magic: 0xeb9f
> # version: 1
> # flags: 0x0
> # hdr_len: 24
> # type_off: 0
> # type_len: 384
> # str_off: 384
> # str_len: 403
> # btf_total_size: 811
> # [1] FUNC_PROTO (anon) return=2 args=(void)
> # [2] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> # [3] FUNC func type_id=1
> # [4] STRUCT (anon) size=32 vlen=4
> #       type type_id=5 bits_offset=0
> #       max_entries type_id=8 bits_offset=64
> #       key type_id=10 bits_offset=128
> #       value type_id=13 bits_offset=192
> # [5] PTR (anon) type_id=6
> # [6] ARRAY (anon) type_id=2 index_type_id=7 nr_elems=1
> # [7] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
> # [8] PTR (anon) type_id=9
> # [9] ARRAY (anon) type_id=2 index_type_id=7 nr_elems=2
> # [10] PTR (anon) type_id=11
> # [11] TYPEDEF __u32 type_id=12
> # [12] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
> # [13] PTR (anon) type_id=14
> # [14] INT long int size=8 bits_offset=0 nr_bits=64 encoding=SIGNED
> # [15] VAR htab type_id=4 linkage=1
> # [16] STRUCT (anon) size=32 vlen=4
> #       type type_id=8 bits_offset=0
> #       max_entries type_id=8 bits_offset=64
> #       key type_id=10 bits_offset=128
> #       value type_id=13 bits_offset=192
> # [17] VAR array type_id=16 linkage=1
> # [18] DATASEC .maps size=0 vlen=2 size == 0
> #
> #
> # Prog section '.text' rejected: Permission denied (13)!
> #  - Type:         6
> #  - Instructions: 21 (0 over limit)
> #  - License:
> #
> # Verifier analysis:
> #
> # 0: (b7) r1 = 0
> # 1: (7b) *(u64 *)(r10 -8) = r1
> # last_idx 1 first_idx 0
> # regs=2 stack=0 before 0: (b7) r1 = 0
> # 2: (63) *(u32 *)(r10 -12) = r1
> # 3: (bf) r2 = r10
> # 4: (07) r2 += -12
> # 5: (18) r1 = 0x0
> # 7: (85) call bpf_map_lookup_elem#1
> # R1 type=inv expected=map_ptr
> # processed 7 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
> #
> # Error fetching program/map!
> not ok 34 selftests: bpf: test_offload.py
>
>
> To reproduce:
>
>         # build kernel
>         cd linux
>         cp config-5.2.0-rc5-01621-g6135bdd95f26f .config
>         make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email
>
>
>
> Thanks,
> Rong Chen
>
