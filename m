Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3F486FBE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345200AbiAGBgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiAGBg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 20:36:29 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10813C061245;
        Thu,  6 Jan 2022 17:36:29 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so10461793pjj.2;
        Thu, 06 Jan 2022 17:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jEZouUYNVhQnJk0Xam0FggoZsamMk/MyTJNp0TxFyxw=;
        b=IN6JpPxAXxJVSmAzQ14r1lNN57kJvgCu5MH83frRfOKQ3+abkbRRiGs808wAUFOMnb
         7n6SU8XVYaNpH32NWiIXJFto5Vq6gQYDFWuadNlNobMLFtY1QsH6/aJ+vsJepbu8XYLO
         gHlPWT3910KZulhmzJtidtz2BaC+Zy+nc+VwHvQSZK14raLY/wLSAoHZFFnpx+cHPP+Q
         +9JTfjwTahHfRTnCsZryhVegp3ntrXb2i1E/XHzCeq70uJDFp/xXKKk4NN2n2PeDZ6lo
         u92IfYWEiblmOEli2Xf/upEsr406ZJ6LpLYxvBE6QyjsrRXW0awePzixiEm5FKezfY8A
         KXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jEZouUYNVhQnJk0Xam0FggoZsamMk/MyTJNp0TxFyxw=;
        b=5ZD8QlclSWXOmq8e7Q+qQ3uah3M1wnkvn9b7/wUdH3WB1t94AJDXLxGc0u84iyx36r
         hQq7EvLZmgjen9SyFpL4vRbSukAX3TfGyGCb1pvZ4HBkiCXs/3UPpXNeh50YXi1CP6Ha
         InddYskhtC+f6FcXcM5hh9LAOEYYZlPenfzBCboXvt2e/B5fQVEHLVTwR2veIaC9PL/5
         rvO0ErN6yEE23ROuDcjc398+q90YWcA/8y0Ieb3LmYkTQMfDaeUxlgFwK19l3F/Dirxq
         WkENdHcvOkNru5F2N58Nc/+HRBzZHdhT2mFlfY8/ceo0EYMJnxqEodyz4Vwwdp6H3Y7g
         NkHQ==
X-Gm-Message-State: AOAM533BCucSrAF8Evvdu2FTxSCovk4IlblMU6BRTCDxKIHK+ya/Zmrj
        ZPi5bxx9UqfpDX93NgwC7GuT4SB9zGc=
X-Google-Smtp-Source: ABdhPJxrBONRIr51X4I+b/pLmouw8BMAurQPmJMjkDH6gd0wpRy9w+EtNIlsn3wXn1GAH09o/9Ud5Q==
X-Received: by 2002:a17:903:230f:b0:149:36a2:5ea1 with SMTP id d15-20020a170903230f00b0014936a25ea1mr60975803plh.50.1641519388338;
        Thu, 06 Jan 2022 17:36:28 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:b7b9])
        by smtp.gmail.com with ESMTPSA id w7sm3721610pfu.180.2022.01.06.17.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 17:36:28 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2022-01-06
Date:   Thu,  6 Jan 2022 17:36:26 -0800
Message-Id: <20220107013626.53943-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 41 non-merge commits during the last 2 day(s) which contain
a total of 36 files changed, 1214 insertions(+), 368 deletions(-).

The main changes are:

1) Various fixes in the verifier, from Kris and Daniel.

2) Fixes in sockmap, from John.

3) bpf_getsockopt fix, from Kuniyuki.

4) INET_POST_BIND fix, from Menglong.

5) arm64 JIT fix for bpf pseudo funcs, from Hou.

6) BPF ISA doc improvements, from Christoph.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Hangbin Liu, Hengqi Chen, Jesper Dangaard Brouer, John Fastabend, 
Quentin Monnet, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit c5bcdd8228d80432471d646646a1203dce5b449f:

  Merge branch 'lan966x-extend-switchdev-and-mdb-support' (2022-01-05 11:25:14 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to eff14fcd032bc1b403c1716f6823b3c72c58096a:

  Merge branch 'net: bpf: handle return value of post_bind{4,6} and add selftests for it' (2022-01-06 17:09:01 -0800)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'samples/bpf: xdpsock app enhancements'
      Merge branch 'net: bpf: handle return value of post_bind{4,6} and add selftests for it'

Andrii Nakryiko (1):
      selftests/bpf: Don't rely on preserving volatile in PT_REGS macros in loop3

Christoph Hellwig (6):
      bpf, docs: Add a setion to explain the basic instruction encoding
      bpf, docs: Add subsections for ALU and JMP instructions
      bpf, docs: Document the opcode classes
      bpf, docs: Fully document the ALU opcodes
      bpf, docs: Fully document the JMP opcodes
      bpf, docs: Fully document the JMP mode modifiers

Christy Lee (3):
      libbpf: Deprecate bpf_perf_event_read_simple() API
      libbpf 1.0: Deprecate bpf_map__is_offload_neutral()
      libbpf 1.0: Deprecate bpf_object__find_map_by_offset() API

Daniel Borkmann (2):
      bpf: Don't promote bogus looking registers after null check.
      bpf, selftests: Add verifier test for mem_or_null register with offset.

Grant Seltzer (1):
      libbpf: Add documentation for bpf_map batch operations

Hao Luo (1):
      bpf/selftests: Test bpf_d_path on rdonly_mem.

Hou Tao (1):
      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC

Jiri Olsa (1):
      bpf/selftests: Fix namespace mount setup in tc_redirect

John Fastabend (2):
      bpf, sockmap: Fix return codes from tcp_bpf_recvmsg_parser()
      bpf, sockmap: Fix double bpf_prog_put on error case in map_link

Kris Van Hees (1):
      bpf: Fix verifier support for validation of async callbacks

Kuniyuki Iwashima (2):
      bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().
      bpf: Add SO_RCVBUF/SO_SNDBUF in _bpf_getsockopt().

Menglong Dong (3):
      net: bpf: Handle return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
      bpf: selftests: Use C99 initializers in test_sock.c
      bpf: selftests: Add bind retry for post_bind{4, 6}

Ong Boon Leong (7):
      samples/bpf: xdpsock: Add VLAN support for Tx-only operation
      samples/bpf: xdpsock: Add Dest and Src MAC setting for Tx-only operation
      samples/bpf: xdpsock: Add clockid selection support
      samples/bpf: xdpsock: Add cyclic TX operation capability
      samples/bpf: xdpsock: Add sched policy and priority support
      samples/bpf: xdpsock: Add time-out for cleaning Tx
      samples/bpf: xdpsock: Add timestamp for Tx-only operation

Paul Chaignon (3):
      bpftool: Refactor misc. feature probe
      bpftool: Probe for bounded loop support
      bpftool: Probe for instruction set extensions

Qiang Wang (2):
      libbpf: Use probe_name for legacy kprobe
      libbpf: Support repeated legacy kprobes on same function

Toke Høiland-Jørgensen (5):
      xdp: Allow registering memory model without rxq reference
      page_pool: Add callback to init pages when they are allocated
      page_pool: Store the XDP mem id
      xdp: Move conversion to xdp_frame out of map functions
      xdp: Add xdp_do_redirect_frame() for pre-computed xdp_frames

 Documentation/bpf/instruction-set.rst              | 156 +++++----
 arch/arm64/net/bpf_jit_comp.c                      |   5 +-
 include/linux/bpf.h                                |  20 +-
 include/linux/filter.h                             |   4 +
 include/net/page_pool.h                            |  11 +-
 include/net/sock.h                                 |   1 +
 include/net/xdp.h                                  |   3 +
 kernel/bpf/cpumap.c                                |   8 +-
 kernel/bpf/devmap.c                                |  32 +-
 kernel/bpf/verifier.c                              |  13 +-
 net/core/filter.c                                  |  81 ++++-
 net/core/page_pool.c                               |   6 +-
 net/core/sock_map.c                                |  21 +-
 net/core/xdp.c                                     |  94 ++++--
 net/ipv4/af_inet.c                                 |   2 +
 net/ipv4/ping.c                                    |   1 +
 net/ipv4/tcp_bpf.c                                 |  27 ++
 net/ipv4/tcp_ipv4.c                                |   1 +
 net/ipv4/udp.c                                     |   1 +
 net/ipv6/af_inet6.c                                |   2 +
 net/ipv6/ping.c                                    |   1 +
 net/ipv6/tcp_ipv6.c                                |   1 +
 net/ipv6/udp.c                                     |   1 +
 samples/bpf/xdpsock_user.c                         | 363 ++++++++++++++++++--
 tools/bpf/bpftool/feature.c                        | 109 +++++-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/lib/bpf/bpf.c                                |   8 +-
 tools/lib/bpf/bpf.h                                | 115 ++++++-
 tools/lib/bpf/libbpf.c                             |  29 +-
 tools/lib/bpf/libbpf.h                             |   5 +-
 tools/testing/selftests/bpf/prog_tests/d_path.c    |  22 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   7 +
 tools/testing/selftests/bpf/progs/loop3.c          |   4 +-
 .../bpf/progs/test_d_path_check_rdonly_mem.c       |  28 ++
 tools/testing/selftests/bpf/test_sock.c            | 370 ++++++++++++---------
 tools/testing/selftests/bpf/verifier/spill_fill.c  |  28 ++
 36 files changed, 1214 insertions(+), 368 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path_check_rdonly_mem.c
