Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCEC1D577E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgEORV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726219AbgEORV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:21:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D727C061A0C;
        Fri, 15 May 2020 10:21:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id l73so4191619pjb.1;
        Fri, 15 May 2020 10:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=35HyAw9zmoVHtnMhNhUc0eB8VDDuplrFilWXrtTPywo=;
        b=WKKinlU9jgGgJmexATOS/798jU9houmifd5vekTaR6N6mWnoBjnid7hbLl6KjEl1oO
         fm0hfl9ldCf/LVPoXBAw4NjakCh71YlpR+64cFjI3mYnSNXE4yLcCs/+GcGLlfhbJo6C
         cFEEnzftPfxtzc/UnOFC8r76fLReVxCmN4bIiLOX2+ZAEZU8Q3PpgKHW1TX6FOs1AVxR
         o8ALy5iuWAr/RD7QTCOjdKm2XRQeV40INQugL7PCM94aoqmEuL2NfnqKNRS7VnC9gqJj
         2iVGXzMuQyHjW788GORKB9WPJhRUtYi7RYRy+KjXuva98ZNiiausaExPRLK6Qo2GW1FZ
         ULkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=35HyAw9zmoVHtnMhNhUc0eB8VDDuplrFilWXrtTPywo=;
        b=cY9nOO946aRNgVqMxYih0mqW/RxEhYOt6uZC6hQoX+evzKCJefmj4ZoCepbRm1y1Xa
         +DEOgDFaQEe6Hp4KUCr3ttzrRQZvLaWZFeXfGSJu0BwyzwtZyX42Sv7ac+oDjpI2JJ/s
         tq2irkG1YmivVQMFMqf3V4f0wswTSLku9OxBvT7lY1pTDqdtIksJtwmCxbYFAnR4Wy+P
         ETcX9dIElLr7AyhI7pz5rM5aLAbVtDEyjJCRLwzzBofe757W7Axf3+yo90F5wOz6yKYk
         UWV5QflS6u2Z94rs5RpkHX55AHkhA+SmBCTvq6PZs5KUcWic4XY7fb1IOMAHjBGRTC3i
         VJdw==
X-Gm-Message-State: AOAM531Hb5NSe9U0EM2ezdC5pPtkts+QhzGx98LO+lpU7q5NiMWrxAuE
        bzdDFzCM8FKGCFZI60CHjPk=
X-Google-Smtp-Source: ABdhPJwLNpI61lel8Edw3bda3fi8wvyeiUq2JRSzz/0GUgBedc4ckSRSiajoXFToOJ0KHCWwwi4ZGA==
X-Received: by 2002:a17:90a:1f4b:: with SMTP id y11mr4701576pjy.136.1589563287513;
        Fri, 15 May 2020 10:21:27 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id i25sm2543012pfd.45.2020.05.15.10.21.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 10:21:26 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-05-15
Date:   Fri, 15 May 2020 10:21:24 -0700
Message-Id: <20200515172124.44077-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 37 non-merge commits during the last 1 day(s) which contain
a total of 67 files changed, 741 insertions(+), 252 deletions(-).

The main changes are:

1) bpf_xdp_adjust_tail() now allows to grow the tail as well, from Jesper.

2) bpftool can probe CONFIG_HZ, from Daniel.

3) CAP_BPF is introduced to isolate user processes that use BPF infra and
   to secure BPF networking services by dropping CAP_SYS_ADMIN requirement
   in certain cases, from Alexei.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andy Gospodarek, Björn Töpel, Grygorii Strashko, Jakub Kicinski, Jason 
Wang, Lorenzo Bianconi, Mao Wenan, Michael S. Tsirkin, Quentin Monnet, 
Sameeh Jubran, Tariq Toukan, Toke Høiland-Jørgensen, Toshiaki Makita

----------------------------------------------------------------

The following changes since commit d00f26b623333f2419f4c3b95ff11c8b1bb96f56:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2020-05-14 20:31:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to ed24a7a852b542911479383d5c80b9a2b4bb8caa:

  Merge branch 'bpf-cap' (2020-05-15 17:29:46 +0200)

----------------------------------------------------------------
Alexei Starovoitov (4):
      Merge branch 'xdp-grow-tail'
      bpf, capability: Introduce CAP_BPF
      bpf: Implement CAP_BPF
      selftests/bpf: Use CAP_BPF and CAP_PERFMON in tests

Daniel Borkmann (2):
      bpf, bpftool: Allow probing for CONFIG_HZ from kernel config
      Merge branch 'bpf-cap'

Ilias Apalodimas (1):
      net: netsec: Add support for XDP frame size

Jesper Dangaard Brouer (32):
      xdp: Add frame size to xdp_buff
      bnxt: Add XDP frame size to driver
      sfc: Add XDP frame size
      mvneta: Add XDP frame size to driver
      net: XDP-generic determining XDP frame size
      xdp: Xdp_frame add member frame_sz and handle in convert_to_xdp_frame
      xdp: Cpumap redirect use frame_sz and increase skb_tailroom
      veth: Adjust hard_start offset on redirect XDP frames
      veth: Xdp using frame_sz in veth driver
      dpaa2-eth: Add XDP frame size
      hv_netvsc: Add XDP frame size to driver
      qlogic/qede: Add XDP frame size to driver
      net: ethernet: ti: Add XDP frame size to driver cpsw
      ena: Add XDP frame size to amazon NIC driver
      mlx4: Add XDP frame size and adjust max XDP MTU
      net: thunderx: Add XDP frame size
      nfp: Add XDP frame size to netronome driver
      tun: Add XDP frame size
      vhost_net: Also populate XDP frame size
      virtio_net: Add XDP frame size in two code paths
      ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K
      ixgbe: Add XDP frame size to driver
      ixgbevf: Add XDP frame size to VF driver
      i40e: Add XDP frame size to driver
      ice: Add XDP frame size to driver
      xdp: For Intel AF_XDP drivers add XDP frame_sz
      mlx5: Rx queue setup time determine frame_sz for XDP
      xdp: Allow bpf_xdp_adjust_tail() to grow packet size
      xdp: Clear grow memory in bpf_xdp_adjust_tail()
      bpf: Add xdp.frame_sz in bpf_prog_test_run_xdp().
      selftests/bpf: Adjust BPF selftest for xdp_adjust_tail
      selftests/bpf: Xdp_adjust_tail add grow tail tests

 drivers/media/rc/bpf-lirc.c                        |   2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   1 +
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   7 ++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  30 ++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   2 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  34 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  33 ++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   2 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  34 ++++--
 drivers/net/ethernet/marvell/mvneta.c              |  25 +++--
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   3 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   6 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
 drivers/net/ethernet/sfc/rx.c                      |   1 +
 drivers/net/ethernet/socionext/netsec.c            |  30 +++--
 drivers/net/ethernet/ti/cpsw.c                     |   1 +
 drivers/net/ethernet/ti/cpsw_new.c                 |   1 +
 drivers/net/hyperv/netvsc_bpf.c                    |   1 +
 drivers/net/hyperv/netvsc_drv.c                    |   2 +-
 drivers/net/tun.c                                  |   2 +
 drivers/net/veth.c                                 |  28 +++--
 drivers/net/virtio_net.c                           |  15 ++-
 drivers/vhost/net.c                                |   1 +
 include/linux/bpf.h                                |  18 ++-
 include/linux/bpf_verifier.h                       |   3 +
 include/linux/capability.h                         |   5 +
 include/net/xdp.h                                  |  27 ++++-
 include/net/xdp_sock.h                             |  11 ++
 include/uapi/linux/bpf.h                           |   4 +-
 include/uapi/linux/capability.h                    |  34 +++++-
 kernel/bpf/arraymap.c                              |  10 +-
 kernel/bpf/bpf_struct_ops.c                        |   2 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/cpumap.c                                |  23 +---
 kernel/bpf/hashtab.c                               |   4 +-
 kernel/bpf/helpers.c                               |   4 +-
 kernel/bpf/lpm_trie.c                              |   2 +-
 kernel/bpf/map_in_map.c                            |   2 +-
 kernel/bpf/queue_stack_maps.c                      |   2 +-
 kernel/bpf/reuseport_array.c                       |   2 +-
 kernel/bpf/stackmap.c                              |   2 +-
 kernel/bpf/syscall.c                               |  89 +++++++++++----
 kernel/bpf/verifier.c                              |  37 ++++---
 kernel/trace/bpf_trace.c                           |   3 +
 net/bpf/test_run.c                                 |  16 ++-
 net/core/bpf_sk_storage.c                          |   4 +-
 net/core/dev.c                                     |  14 ++-
 net/core/filter.c                                  |  19 +++-
 net/core/xdp.c                                     |   8 ++
 security/selinux/include/classmap.h                |   4 +-
 tools/bpf/bpftool/feature.c                        | 120 +++++++++++---------
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     | 123 ++++++++++++++++++++-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |  33 ++++++
 ...adjust_tail.c => test_xdp_adjust_tail_shrink.c} |  12 +-
 tools/testing/selftests/bpf/test_verifier.c        |  44 ++++++--
 tools/testing/selftests/bpf/verifier/calls.c       |  16 +--
 tools/testing/selftests/bpf/verifier/dead_code.c   |  10 +-
 67 files changed, 741 insertions(+), 252 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
 rename tools/testing/selftests/bpf/progs/{test_adjust_tail.c => test_xdp_adjust_tail_shrink.c} (70%)
