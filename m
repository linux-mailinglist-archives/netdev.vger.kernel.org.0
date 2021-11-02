Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E84442528
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhKBBeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKBBd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:33:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D162C061714;
        Mon,  1 Nov 2021 18:31:26 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p18so10170892plf.13;
        Mon, 01 Nov 2021 18:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCyL3k0y5/xe3v+mJOy16A0ota8+sJrqJRDkUbyOILo=;
        b=S2RspkxJkG2kg/3KyLIVfphXjdf/zYX35IJDqQHBl4LjZvl0u+ckSaGwoNUlQRjq+o
         +aQlOL9xCzI417y8nXmWCjttnu0NCW7UDXjshfd5gaP1R+BKDYdxEwi1pgHZSmupZhRU
         MWJQ2vN3UTAMEG6JLnovi0wIkrlfYKuesHXZfDAzCj9jbv8R7tx6YwZwVrHh8KJmmSYJ
         2RYPV4VtaqZbAKWBQMvtnRtUnvyZRGQflAB+iMXhqYV84gKP8cXG58o3OtDDRLdP5PWU
         ycVeKaNhyVXjJl/j6JA6tAjOtJ3q+FO3HSU2fE7fO5jbWR18GmPQ1KRFUfnQYObsKLSv
         EC+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gCyL3k0y5/xe3v+mJOy16A0ota8+sJrqJRDkUbyOILo=;
        b=3Tczx6TbtxD3yVYAokfUWfbaeGmOnE/EedIiVwlbhZgz/GYj6S+m93pHwaoRW8x8hq
         VqZxoSw+RP9OYLag4RKHlkuWXsquM1eAuOIWjUHfMPP3b85TpXcUiV4L+LHj6lJbC+TY
         s86dMAF4Z+svlQqXDrR7LU8wTjnCJCXMnuCbZQnthkwKQ33qNuXH+pJe3Vh77PlpEzbJ
         Tghk5s0b5I2kWVaBa24nahzwJLKmElucLLEuajZspj7im1UPLU72/7+hO6Y0snYYRwdU
         NKQh4ceD2xf6ssS9lljctlIHwECj2WP0w9EBz+l7MB3sec+sUo8Y6TAxXK1e5YWjnm9O
         bzZw==
X-Gm-Message-State: AOAM532oRzT5kypXhDcWLWeSFtzG3ctuXxG6Y85g46+UOJaPMjCqz5gl
        O5Fuy37CIfKb83oiHD08g/U=
X-Google-Smtp-Source: ABdhPJyf7Q0+xgwQYW+1QVqAp1v33h6tLg0QdOVvHNqItOWFyf/zqcY5S8vlRKxBSPS/tS4P3tqZdA==
X-Received: by 2002:a17:90a:4a06:: with SMTP id e6mr2990388pjh.228.1635816685185;
        Mon, 01 Nov 2021 18:31:25 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:880e])
        by smtp.gmail.com with ESMTPSA id e8sm17707798pfn.45.2021.11.01.18.31.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Nov 2021 18:31:24 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2021-11-01
Date:   Mon,  1 Nov 2021 18:31:23 -0700
Message-Id: <20211102013123.9005-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 181 non-merge commits during the last 28 day(s) which contain
a total of 280 files changed, 11791 insertions(+), 5879 deletions(-).

The main changes are:

1) Fix bpf verifier propagation of 64-bit bounds, from Alexei.

2) Parallelize bpf test_progs, from Yucong and Andrii.

3) Deprecate various libbpf apis including af_xdp, from Andrii, Hengqi, Magnus.

4) Improve bpf selftests on s390, from Ilya.

5) bloomfilter bpf map type, from Joanne.

6) Big improvements to JIT tests especially on Mips, from Johan.
      
7) Support kernel module function calls from bpf, from Kumar.
      
8) Support typeless and weak ksym in light skeleton, from Kumar.

9) Disallow unprivileged bpf by default, from Pawan.

10) BTF_KIND_DECL_TAG support, from Yonghong.

11) Various bpftool cleanups, from Quentin.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

There should be no merge conflicts. Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Björn Töpel, Cong Wang, Daniel Borkmann, Evgeny 
Vereshchagin, Jakub Sitnicki, Jiaxun Yang, Johan Almbladh, John 
Fastabend, Mark Rutland, Martin KaFai Lau, Pu Lehui, Quentin Monnet, 
Shuah Khan, Song Liu, syzbot, Toke Høiland-Jørgensen, Yonghong Song, 
Zeal Robot

----------------------------------------------------------------

The following changes since commit d0f1c248b4ff71cada1b9e4ed61a1992cd94c3df:

  Merge tag 'for-net-next-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next (2021-10-05 07:41:16 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 0b170456e0dda92b8925d40e217461fcc4e1efc9:

  libbpf: Deprecate AF_XDP support (2021-11-01 18:12:44 -0700)

----------------------------------------------------------------
Alexei Starovoitov (14):
      Merge branch 'Support kernel module function calls from eBPF'
      Merge branch 'Add bpf_skc_to_unix_sock() helper'
      Merge branch 'libbpf: support custom .rodata.*/.data.* sections'
      Merge branch 'bpf: add support for BTF_KIND_DECL_TAG typedef'
      Merge branch 'Parallelize verif_scale selftests'
      Merge branch 'libbpf: add bpf_program__insns() accessor'
      Merge branch 'bpf: use 32bit safe version of u64_stats'
      Merge branch 'Implement bloom filter map'
      Merge branch 'Typeless/weak ksym for gen_loader + misc fixups'
      Merge branch 'introduce dummy BPF STRUCT_OPS'
      Merge branch '"map_extra" and bloom filter fixups'
      bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.
      bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.
      selftests/bpf: Add a testcase for 64-bit bounds propagation issue.

Andrea Righi (1):
      selftests/bpf: Fix fclose/pclose mismatch in test_progs

Andrey Ignatov (1):
      bpf: Avoid retpoline for bpf_for_each_map_elem

Andrii Nakryiko (40):
      libbpf: Add API that copies all BTF types from one BTF object to another
      selftests/bpf: Refactor btf_write selftest to reuse BTF generation logic
      selftests/bpf: Test new btf__add_btf() API
      Merge branch 'libbpf: Deprecate bpf_{map,program}__{prev,next} APIs since v0.7'
      Merge branch 'install libbpf headers when using the library'
      Merge branch 'add support for writable bare tracepoint'
      Merge branch 'selftests/bpf: Add parallelism to test_progs'
      Merge branch 'fixes for bpftool's Makefile'
      Merge branch 'btf_dump fixes for s390'
      Merge branch 'bpf: keep track of verifier insn_processed'
      Merge branch 'selftests/bpf: Fixes for perf_buffer test'
      libbpf: Deprecate btf__finalize_data() and move it into libbpf.c
      libbpf: Extract ELF processing state into separate struct
      libbpf: Use Elf64-specific types explicitly for dealing with ELF
      libbpf: Remove assumptions about uniqueness of .rodata/.data/.bss maps
      bpftool: Support multiple .rodata/.data internal maps in skeleton
      bpftool: Improve skeleton generation for data maps without DATASEC type
      libbpf: Support multiple .rodata.* and .data.* BPF maps
      selftests/bpf: Demonstrate use of custom .rodata/.data sections
      libbpf: Simplify look up by name of internal maps
      selftests/bpf: Switch to ".bss"/".rodata"/".data" lookups for internal maps
      libbpf: Fix the use of aligned attribute
      selftests/bpf: Make perf_buffer selftests work on 4.9 kernel again
      Merge branch 'libbpf: Add btf__type_cnt() and btf__raw_data() APIs'
      Merge branch 'libbpf: use func name when pinning programs with LIBBPF_STRICT_SEC_NAME'
      libbpf: Fix overflow in BTF sanity checks
      libbpf: Fix BTF header parsing checks
      selftests/bpf: Normalize selftest entry points
      selftests/bpf: Support multiple tests per file
      selftests/bpf: Mark tc_redirect selftest as serial
      selftests/bpf: Split out bpf_verif_scale selftests into multiple tests
      Merge branch 'bpftool: Switch to libbpf's hashmap for referencing BPF objects'
      libbpf: Fix off-by-one bug in bpf_core_apply_relo()
      libbpf: Add ability to fetch bpf_program's underlying instructions
      libbpf: Deprecate multi-instance bpf_program APIs
      libbpf: Deprecate ambiguously-named bpf_program__size() API
      Merge branch 'core_reloc fixes for s390'
      Merge branch 'selftests/bpf: parallel mode improvement'
      selftests/bpf: Fix strobemeta selftest regression
      selftests/bpf: Fix also no-alu32 strobemeta selftest

Björn Töpel (4):
      riscv, bpf: Increase the maximum number of iterations
      tools, build: Add RISC-V to HOSTARCH parsing
      riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
      selftests, bpf: Fix broken riscv build

Brendan Jackman (1):
      selftests/bpf: Some more atomic tests

Daniel Borkmann (2):
      Merge branch 'bpf-mips-jit'
      bpf, arm: Remove dummy bpf_jit_compile stub

Dave Marchevsky (4):
      selftests/bpf: Remove SEC("version") from test progs
      libbpf: Migrate internal use of bpf_program__get_prog_info_linear
      bpf: Add verified_insns to bpf_prog_info and fdinfo
      selftests/bpf: Add verif_stats test

David Yang (1):
      samples/bpf: Fix application of sizeof to pointer

Eric Dumazet (4):
      bpf: Avoid races in __bpf_prog_run() for 32bit arches
      bpf: Fixes possible race in update_prog_stats() for 32bit arches
      bpf: Use u64_stats_t in struct bpf_prog_stats
      bpf: Add missing map_delete_elem method to bloom filter map

Grant Seltzer (1):
      libbpf: Add API documentation convention guidelines

Hengqi Chen (10):
      libbpf: Deprecate bpf_{map,program}__{prev,next} APIs since v0.7
      selftests/bpf: Switch to new bpf_object__next_{map,program} APIs
      libbpf: Deprecate bpf_object__unload() API since v0.6
      bpf: Add bpf_skc_to_unix_sock() helper
      selftests/bpf: Test bpf_skc_to_unix_sock() helper
      libbpf: Add btf__type_cnt() and btf__raw_data() APIs
      perf bpf: Switch to new btf__raw_data API
      tools/resolve_btfids: Switch to new btf__type_cnt API
      bpftool: Switch to new btf__type_cnt API
      selftests/bpf: Switch to new btf__type_cnt/btf__raw_data APIs

Hou Tao (7):
      bpf: Support writable context for bare tracepoint
      libbpf: Support detecting and attaching of writable tracepoint program
      bpf/selftests: Add test for writable bare tracepoint
      bpf: Factor out a helper to prepare trampoline for struct_ops prog
      bpf: Factor out helpers for ctx access checking
      bpf: Add dummy BPF STRUCT_OPS for test purpose
      selftests/bpf: Add test cases for struct_ops prog

Ilya Leoshkevich (11):
      selftests/bpf: Skip verifier tests that fail to load with ENOTSUPP
      selftests/bpf: Use cpu_number only on arches that have it
      libbpf: Fix dumping big-endian bitfields
      libbpf: Fix dumping non-aligned __int128
      libbpf: Fix ptr_is_aligned() usages
      libbpf: Fix endianness detection in BPF_CORE_READ_BITFIELD_PROBED()
      libbpf: Use __BYTE_ORDER__
      selftests/bpf: Use __BYTE_ORDER__
      samples: seccomp: Use __BYTE_ORDER__
      selftests/seccomp: Use __BYTE_ORDER__
      selftests/bpf: Fix test_core_reloc_mods on big-endian machines

Jie Meng (2):
      bpf, x64: Save bytes for DIV by reducing reg copies
      bpf, x64: Factor out emission of REX byte in more cases

Jiri Olsa (5):
      selftest/bpf: Switch recursion test to use htab_map_delete_elem
      selftests/bpf: Fix perf_buffer test on system with offline cpus
      selftests/bpf: Fix possible/online index mismatch in perf_buffer test
      selftests/bpf: Use nanosleep tracepoint in perf buffer test
      kbuild: Unify options for BTF generation for vmlinux and modules

Joanne Koong (8):
      bpf: Add bloom filter map implementation
      libbpf: Add "map_extra" as a per-map-type extra flag
      selftests/bpf: Add bloom filter map test cases
      bpf/benchs: Add benchmark tests for bloom filter throughput + false positive
      bpf/benchs: Add benchmarks for comparing hashmap lookups w/ vs. w/out bloom filter
      bpf: Bloom filter map naming fixups
      bpf: Add alignment padding for "map_extra" + consolidate holes
      selftests/bpf: Add bloom map success test for userspace calls

Joe Burton (1):
      libbpf: Deprecate bpf_objects_list

Johan Almbladh (9):
      mips, uasm: Add workaround for Loongson-2F nop CPU errata
      mips, bpf: Add eBPF JIT for 32-bit MIPS
      mips, bpf: Add new eBPF JIT for 64-bit MIPS
      mips, bpf: Add JIT workarounds for CPU errata
      mips, bpf: Enable eBPF JITs
      mips, bpf: Remove old BPF JIT implementations
      mips, bpf: Fix Makefile that referenced a removed file
      mips, bpf: Optimize loading of 64-bit constants
      bpf, tests: Add more LD_IMM64 tests

Kumar Kartikeya Dwivedi (18):
      bpf: Introduce BPF support for kernel module function calls
      bpf: Be conservative while processing invalid kfunc calls
      bpf: btf: Introduce helpers for dynamic BTF set registration
      tools: Allow specifying base BTF file in resolve_btfids
      bpf: Enable TCP congestion control kfunc from modules
      libbpf: Support kernel module function calls
      libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
      libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
      bpf: selftests: Add selftests for module kfunc support
      bpf: Silence Coverity warning for find_kfunc_desc_btf
      bpf: Add bpf_kallsyms_lookup_name helper
      libbpf: Add typeless ksym support to gen_loader
      libbpf: Add weak ksym support to gen_loader
      libbpf: Ensure that BPF syscall fds are never 0, 1, or 2
      libbpf: Use O_CLOEXEC uniformly when opening fds
      selftests/bpf: Add weak/typeless ksym test for light skeleton
      selftests/bpf: Fix fd cleanup in sk_lookup test
      selftests/bpf: Fix memory leak in test_ima

Liu Jian (3):
      skmsg: Lose offset info in sk_psock_skb_ingress
      selftests, bpf: Fix test_txmsg_ingress_parser error
      selftests, bpf: Add one test for sockmap with strparser

Magnus Karlsson (1):
      libbpf: Deprecate AF_XDP support

Mauricio Vásquez (1):
      libbpf: Fix memory leak in btf__dedup()

Pawan Gupta (1):
      bpf: Disallow unprivileged bpf by default

Pu Lehui (1):
      samples: bpf: Suppress readelf stderr when probing for BTF support

Qing Wang (1):
      net: bpf: Switch over to memdup_user()

Quentin Monnet (25):
      bpf: Use $(pound) instead of \# in Makefiles
      libbpf: Skip re-installing headers file if source is older than target
      bpftool: Remove unused includes to <bpf/bpf_gen_internal.h>
      bpftool: Install libbpf headers instead of including the dir
      tools/resolve_btfids: Install libbpf headers when building
      tools/runqslower: Install libbpf headers when building
      bpf: preload: Install libbpf headers when building
      bpf: iterators: Install libbpf headers when building
      samples/bpf: Update .gitignore
      samples/bpf: Install libbpf headers when building
      samples/bpf: Do not FORCE-recompile libbpf
      selftests/bpf: Better clean up for runqslower in test_bpftool_build.sh
      bpftool: Add install-bin target to install binary only
      libbpf: Remove Makefile warnings on out-of-sync netlink.h/if_link.h
      bpftool: Fix install for libbpf's internal header(s)
      bpftool: Do not FORCE-build libbpf
      bpftool: Turn check on zlib from a phony target into a conditional error
      bpf/preload: Clean up .gitignore and "clean-files" target
      bpftool: Remove useless #include to <perf-sys.h> from map_perf_ring.c
      bpftool: Avoid leaking the JSON writer prepared for program metadata
      bpftool: Remove Makefile dep. on $(LIBBPF) for $(LIBBPF_INTERNAL_HDRS)
      bpftool: Do not expose and init hash maps for pinned path in main.c
      bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects
      bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing
      bpftool: Switch to libbpf's hashmap for PIDs/names references

Song Liu (3):
      selftests/bpf: Skip the second half of get_branch_snapshot in vm
      selftests/bpf: Skip all serial_test_get_branch_snapshot in vm
      selftests/bpf: Guess function end for test_get_branch_snapshot

Stanislav Fomichev (2):
      libbpf: Use func name when pinning programs with LIBBPF_STRICT_SEC_NAME
      selftests/bpf: Fix flow dissector tests

Tiezhu Yang (3):
      bpf, mips: Clean up config options about JIT
      bpf, mips: Fix comment on tail call count limiting
      bpf, tests: Add module parameter test_suite to test_bpf module

Tong Tiangen (1):
      riscv, bpf: Add BPF exception tables

Tony Ambardar (1):
      mips, uasm: Enable muhu opcode for MIPS R6

Wan Jiabing (1):
      selftests/bpf: Remove duplicated include in cgroup_helpers

Yonghong Song (6):
      bpf: Rename BTF_KIND_TAG to BTF_KIND_DECL_TAG
      bpf: Add BTF_KIND_DECL_TAG typedef support
      selftests/bpf: Add BTF_KIND_DECL_TAG typedef unit tests
      selftests/bpf: Test deduplication for BTF_KIND_DECL_TAG typedef
      selftests/bpf: Add BTF_KIND_DECL_TAG typedef example in tag.c
      docs/bpf: Update documentation for BTF_KIND_DECL_TAG typedef support

Yucong Sun (12):
      selftests/bpf: Fix btf_dump test under new clang
      selftests/bpf: Add parallelism to test_progs
      selftests/bpf: Allow some tests to be executed in sequence
      selftests/bpf: Add per worker cgroup suffix
      selftests/bpf: Fix race condition in enable_stats
      selftests/bpf: Make cgroup_v1v2 use its own port
      selftests/bpf: Adding pid filtering for atomics test
      selftests/bpf: Fix pid check in fexit_sleep test
      selfetest/bpf: Make some tests serial
      selfetests/bpf: Update vmtest.sh defaults
      selftests/bpf: Fix attach_probe in parallel mode
      selftests/bpf: Adding a namespace reset for tc_redirect

 Documentation/bpf/btf.rst                          |   28 +-
 .../bpf/libbpf/libbpf_naming_convention.rst        |   40 +
 MAINTAINERS                                        |    1 +
 Makefile                                           |    3 +
 arch/arm/net/bpf_jit_32.c                          |    5 -
 arch/mips/Kconfig                                  |   15 +-
 arch/mips/include/asm/uasm.h                       |    5 +
 arch/mips/mm/uasm-mips.c                           |    4 +-
 arch/mips/mm/uasm.c                                |    3 +-
 arch/mips/net/Makefile                             |    9 +-
 arch/mips/net/bpf_jit.c                            | 1299 -------------
 arch/mips/net/bpf_jit.h                            |   81 -
 arch/mips/net/bpf_jit_asm.S                        |  285 ---
 arch/mips/net/bpf_jit_comp.c                       | 1034 +++++++++++
 arch/mips/net/bpf_jit_comp.h                       |  235 +++
 arch/mips/net/bpf_jit_comp32.c                     | 1899 +++++++++++++++++++
 arch/mips/net/bpf_jit_comp64.c                     | 1060 +++++++++++
 arch/mips/net/ebpf_jit.c                           | 1938 --------------------
 arch/riscv/mm/extable.c                            |   19 +-
 arch/riscv/net/bpf_jit.h                           |    1 +
 arch/riscv/net/bpf_jit_comp64.c                    |  185 +-
 arch/riscv/net/bpf_jit_core.c                      |   21 +-
 arch/x86/net/bpf_jit_comp.c                        |  130 +-
 include/linux/bpf.h                                |   59 +-
 include/linux/bpf_types.h                          |    1 +
 include/linux/bpf_verifier.h                       |    2 +
 include/linux/bpfptr.h                             |    1 +
 include/linux/btf.h                                |   39 +
 include/linux/filter.h                             |   15 +-
 include/linux/skmsg.h                              |   18 +-
 include/trace/bpf_probe.h                          |   19 +-
 include/uapi/linux/bpf.h                           |   34 +
 include/uapi/linux/btf.h                           |    8 +-
 kernel/bpf/Kconfig                                 |    7 +
 kernel/bpf/Makefile                                |    2 +-
 kernel/bpf/bloom_filter.c                          |  204 +++
 kernel/bpf/bpf_struct_ops.c                        |   32 +-
 kernel/bpf/bpf_struct_ops_types.h                  |    3 +
 kernel/bpf/btf.c                                   |  103 +-
 kernel/bpf/core.c                                  |    4 +
 kernel/bpf/preload/.gitignore                      |    4 +-
 kernel/bpf/preload/Makefile                        |   26 +-
 kernel/bpf/preload/iterators/Makefile              |   38 +-
 kernel/bpf/syscall.c                               |   77 +-
 kernel/bpf/trampoline.c                            |   12 +-
 kernel/bpf/verifier.c                              |  250 ++-
 kernel/trace/bpf_trace.c                           |   18 +-
 lib/test_bpf.c                                     |  332 +++-
 net/bpf/Makefile                                   |    3 +
 net/bpf/bpf_dummy_struct_ops.c                     |  200 ++
 net/bpf/test_run.c                                 |   28 +-
 net/core/filter.c                                  |   23 +
 net/core/skmsg.c                                   |   43 +-
 net/ipv4/bpf_tcp_ca.c                              |   45 +-
 net/ipv4/tcp_bbr.c                                 |   28 +-
 net/ipv4/tcp_cubic.c                               |   26 +-
 net/ipv4/tcp_dctcp.c                               |   26 +-
 samples/bpf/.gitignore                             |    4 +
 samples/bpf/Makefile                               |   47 +-
 samples/bpf/xdp1_user.c                            |    2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |    6 +-
 samples/bpf/xdp_sample_pkts_user.c                 |    2 +-
 samples/seccomp/bpf-helper.h                       |    8 +-
 scripts/Makefile.modfinal                          |    3 +-
 scripts/bpf_doc.py                                 |    2 +
 scripts/link-vmlinux.sh                            |   11 +-
 scripts/pahole-flags.sh                            |   20 +
 tools/bpf/bpftool/Makefile                         |   60 +-
 tools/bpf/bpftool/btf.c                            |  150 +-
 tools/bpf/bpftool/common.c                         |   50 +-
 tools/bpf/bpftool/gen.c                            |  161 +-
 tools/bpf/bpftool/iter.c                           |    2 +-
 tools/bpf/bpftool/link.c                           |   45 +-
 tools/bpf/bpftool/main.c                           |   17 +-
 tools/bpf/bpftool/main.h                           |   54 +-
 tools/bpf/bpftool/map.c                            |   45 +-
 tools/bpf/bpftool/map_perf_ring.c                  |    1 -
 tools/bpf/bpftool/pids.c                           |   90 +-
 tools/bpf/bpftool/prog.c                           |   64 +-
 tools/bpf/resolve_btfids/Makefile                  |   16 +-
 tools/bpf/resolve_btfids/main.c                    |   36 +-
 tools/bpf/runqslower/Makefile                      |   22 +-
 tools/include/uapi/linux/bpf.h                     |   34 +
 tools/include/uapi/linux/btf.h                     |    8 +-
 tools/lib/bpf/Makefile                             |   35 +-
 tools/lib/bpf/bpf.c                                |   63 +-
 tools/lib/bpf/bpf_core_read.h                      |    2 +-
 tools/lib/bpf/bpf_gen_internal.h                   |   24 +-
 tools/lib/bpf/bpf_tracing.h                        |   32 +
 tools/lib/bpf/btf.c                                |  321 ++--
 tools/lib/bpf/btf.h                                |   39 +-
 tools/lib/bpf/btf_dump.c                           |   64 +-
 tools/lib/bpf/gen_loader.c                         |  419 ++++-
 tools/lib/bpf/libbpf.c                             | 1241 ++++++++-----
 tools/lib/bpf/libbpf.h                             |   85 +-
 tools/lib/bpf/libbpf.map                           |   13 +-
 tools/lib/bpf/libbpf_internal.h                    |   64 +-
 tools/lib/bpf/libbpf_legacy.h                      |    9 +
 tools/lib/bpf/libbpf_probes.c                      |    2 +-
 tools/lib/bpf/linker.c                             |   45 +-
 tools/lib/bpf/relo_core.c                          |    2 +-
 tools/lib/bpf/xsk.c                                |    6 +-
 tools/lib/bpf/xsk.h                                |   90 +-
 tools/perf/util/bpf-event.c                        |    2 +-
 tools/scripts/Makefile.arch                        |    3 +-
 tools/testing/selftests/bpf/Makefile               |   52 +-
 tools/testing/selftests/bpf/README.rst             |    4 +-
 tools/testing/selftests/bpf/bench.c                |   60 +-
 tools/testing/selftests/bpf/bench.h                |    3 +
 .../selftests/bpf/benchs/bench_bloom_filter_map.c  |  477 +++++
 .../bpf/benchs/run_bench_bloom_filter_map.sh       |   45 +
 .../selftests/bpf/benchs/run_bench_ringbufs.sh     |   30 +-
 tools/testing/selftests/bpf/benchs/run_common.sh   |   60 +
 .../selftests/bpf/bpf_testmod/bpf_testmod-events.h |   15 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   33 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.h        |    5 +
 tools/testing/selftests/bpf/btf_helpers.c          |   12 +-
 tools/testing/selftests/bpf/cgroup_helpers.c       |    5 +-
 tools/testing/selftests/bpf/cgroup_helpers.h       |    2 +-
 tools/testing/selftests/bpf/flow_dissector_load.c  |   18 +-
 tools/testing/selftests/bpf/flow_dissector_load.h  |   10 +-
 tools/testing/selftests/bpf/prog_tests/atomics.c   |   35 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |    9 +-
 .../selftests/bpf/prog_tests/bloom_filter_map.c    |  211 +++
 .../selftests/bpf/prog_tests/bpf_iter_setsockopt.c |    2 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |    2 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |  225 ++-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  247 ++-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |   12 +-
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |   18 +-
 tools/testing/selftests/bpf/prog_tests/btf_split.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/btf_write.c |  159 +-
 .../selftests/bpf/prog_tests/cg_storage_multi.c    |    2 +-
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |    2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |    2 +-
 .../bpf/prog_tests/cgroup_attach_override.c        |    2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |    2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_v1v2.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |    2 +-
 .../selftests/bpf/prog_tests/core_autosize.c       |    4 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    4 +-
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |  115 ++
 .../selftests/bpf/prog_tests/fentry_fexit.c        |   16 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |   14 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |    9 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |   12 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |   14 +-
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |    2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |    2 +-
 .../selftests/bpf/prog_tests/get_branch_snapshot.c |   39 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |   11 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |    2 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |    5 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |    6 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |   35 +-
 .../selftests/bpf/prog_tests/ksyms_module.c        |   57 +-
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |    2 +-
 .../selftests/bpf/prog_tests/modify_return.c       |    3 +-
 .../selftests/bpf/prog_tests/module_attach.c       |   35 +
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |    3 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   24 +-
 tools/testing/selftests/bpf/prog_tests/perf_link.c |    3 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |    3 +-
 .../bpf/prog_tests/raw_tp_writable_test_run.c      |    3 +-
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/recursion.c |   10 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |   14 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |   12 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |    4 +-
 .../bpf/prog_tests/send_signal_sched_switch.c      |    3 +-
 .../selftests/bpf/prog_tests/signal_pending.c      |    2 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |    4 +-
 .../selftests/bpf/prog_tests/sk_storage_tracing.c  |    2 +-
 .../selftests/bpf/prog_tests/skc_to_unix_sock.c    |   54 +
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |   29 +
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |    4 +-
 .../selftests/bpf/prog_tests/snprintf_btf.c        |    2 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |    2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |    2 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   16 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |    2 +-
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |    3 +-
 tools/testing/selftests/bpf/prog_tests/timer.c     |    3 +-
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |    2 +-
 .../selftests/bpf/prog_tests/tp_attach_query.c     |    2 +-
 .../selftests/bpf/prog_tests/trace_printk.c        |   16 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c       |   14 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |    3 +-
 .../testing/selftests/bpf/prog_tests/verif_stats.c |   28 +
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |    6 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |    2 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |    2 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |    2 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |    6 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |    2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |    2 +-
 tools/testing/selftests/bpf/progs/atomics.c        |   16 +
 .../selftests/bpf/progs/bloom_filter_bench.c       |  153 ++
 .../testing/selftests/bpf/progs/bloom_filter_map.c |   82 +
 .../bpf/progs/btf_dump_test_case_bitfields.c       |   10 +-
 .../bpf/progs/btf_dump_test_case_packing.c         |    4 +-
 .../bpf/progs/btf_dump_test_case_padding.c         |    2 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |    2 +-
 .../bpf/progs/cgroup_skb_sk_lookup_kern.c          |    1 -
 .../testing/selftests/bpf/progs/connect4_dropper.c |    2 +-
 tools/testing/selftests/bpf/progs/connect4_prog.c  |    2 -
 tools/testing/selftests/bpf/progs/connect6_prog.c  |    2 -
 .../selftests/bpf/progs/connect_force_port4.c      |    1 -
 .../selftests/bpf/progs/connect_force_port6.c      |    1 -
 tools/testing/selftests/bpf/progs/dev_cgroup.c     |    1 -
 tools/testing/selftests/bpf/progs/dummy_st_ops.c   |   50 +
 tools/testing/selftests/bpf/progs/fexit_sleep.c    |    4 +-
 .../selftests/bpf/progs/get_cgroup_id_kern.c       |    1 -
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |    1 -
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |    1 -
 tools/testing/selftests/bpf/progs/recursion.c      |    9 +-
 tools/testing/selftests/bpf/progs/sendmsg4_prog.c  |    2 -
 tools/testing/selftests/bpf/progs/sendmsg6_prog.c  |    2 -
 .../selftests/bpf/progs/sockmap_parse_prog.c       |    2 -
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |    2 -
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |    2 -
 .../testing/selftests/bpf/progs/sockopt_inherit.c  |    1 -
 tools/testing/selftests/bpf/progs/strobemeta.h     |    4 +-
 tools/testing/selftests/bpf/progs/tag.c            |   15 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c        |    1 -
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |    2 -
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |    2 -
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |    2 -
 .../selftests/bpf/progs/test_core_reloc_mods.c     |    9 +
 .../selftests/bpf/progs/test_enable_stats.c        |    2 +-
 .../selftests/bpf/progs/test_ksyms_module.c        |   46 +-
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |    2 +-
 tools/testing/selftests/bpf/progs/test_l4lb.c      |    2 -
 .../testing/selftests/bpf/progs/test_map_in_map.c  |    1 -
 .../selftests/bpf/progs/test_module_attach.c       |   14 +
 .../testing/selftests/bpf/progs/test_perf_buffer.c |   18 +-
 tools/testing/selftests/bpf/progs/test_pinning.c   |    2 -
 .../selftests/bpf/progs/test_pinning_invalid.c     |    2 -
 .../testing/selftests/bpf/progs/test_pkt_access.c  |    1 -
 .../selftests/bpf/progs/test_queue_stack_map.h     |    2 -
 .../bpf/progs/test_select_reuseport_kern.c         |    2 -
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |    1 -
 .../selftests/bpf/progs/test_skb_cgroup_id_kern.c  |    2 -
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |    1 -
 .../selftests/bpf/progs/test_skc_to_unix_sock.c    |   40 +
 tools/testing/selftests/bpf/progs/test_skeleton.c  |   18 +
 .../selftests/bpf/progs/test_sockmap_kern.h        |    1 -
 .../selftests/bpf/progs/test_sockmap_listen.c      |    1 -
 .../selftests/bpf/progs/test_stacktrace_build_id.c |    1 -
 .../testing/selftests/bpf/progs/test_tcp_estats.c  |    1 -
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |    1 -
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |    2 -
 .../testing/selftests/bpf/progs/test_tracepoint.c  |    1 -
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |    2 -
 tools/testing/selftests/bpf/progs/test_xdp.c       |    2 -
 tools/testing/selftests/bpf/progs/test_xdp_loop.c  |    2 -
 .../selftests/bpf/progs/test_xdp_redirect.c        |    2 -
 tools/testing/selftests/bpf/progs/twfw.c           |   58 +
 tools/testing/selftests/bpf/test_bpftool_build.sh  |    4 +
 tools/testing/selftests/bpf/test_btf.h             |    4 +-
 tools/testing/selftests/bpf/test_flow_dissector.sh |   10 +-
 tools/testing/selftests/bpf/test_progs.c           |  675 ++++++-
 tools/testing/selftests/bpf/test_progs.h           |   38 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   35 +-
 tools/testing/selftests/bpf/test_sysctl.c          |    4 +-
 tools/testing/selftests/bpf/test_verifier.c        |   12 +-
 tools/testing/selftests/bpf/trace_helpers.c        |   36 -
 tools/testing/selftests/bpf/trace_helpers.h        |    5 -
 .../testing/selftests/bpf/verifier/array_access.c  |    2 +-
 .../selftests/bpf/verifier/atomic_cmpxchg.c        |   38 +
 .../testing/selftests/bpf/verifier/atomic_fetch.c  |   57 +
 .../selftests/bpf/verifier/atomic_invalid.c        |   25 +
 tools/testing/selftests/bpf/verifier/calls.c       |   23 +
 tools/testing/selftests/bpf/verifier/ctx_skb.c     |   14 +-
 tools/testing/selftests/bpf/verifier/jit.c         |   47 +
 tools/testing/selftests/bpf/verifier/lwt.c         |    2 +-
 .../bpf/verifier/perf_event_sample_period.c        |    6 +-
 tools/testing/selftests/bpf/vmtest.sh              |    6 +-
 tools/testing/selftests/bpf/xdping.c               |    2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |    6 +-
 280 files changed, 11791 insertions(+), 5879 deletions(-)
 delete mode 100644 arch/mips/net/bpf_jit.c
 delete mode 100644 arch/mips/net/bpf_jit.h
 delete mode 100644 arch/mips/net/bpf_jit_asm.S
 create mode 100644 arch/mips/net/bpf_jit_comp.c
 create mode 100644 arch/mips/net/bpf_jit_comp.h
 create mode 100644 arch/mips/net/bpf_jit_comp32.c
 create mode 100644 arch/mips/net/bpf_jit_comp64.c
 delete mode 100644 arch/mips/net/ebpf_jit.c
 create mode 100644 kernel/bpf/bloom_filter.c
 create mode 100644 net/bpf/bpf_dummy_struct_ops.c
 create mode 100755 scripts/pahole-flags.sh
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bloom_filter_map.sh
 create mode 100644 tools/testing/selftests/bpf/benchs/run_common.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skc_to_unix_sock.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/bloom_filter_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/bloom_filter_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/twfw.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_fetch.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_invalid.c
