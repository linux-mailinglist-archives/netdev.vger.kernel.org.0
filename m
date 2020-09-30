Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1158327F2B7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgI3Tre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3Tre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:47:34 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D4FC061755;
        Wed, 30 Sep 2020 12:47:34 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b12so348519ilh.12;
        Wed, 30 Sep 2020 12:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QVlRW9fKzP6hA/KjW/ElCxKDHp1ruA7N/RjYzVWIbYc=;
        b=pknr5SG+nRmRwsg4QsuAuq9QIF/3ZhwLabRgQUHLM4chs3UAxLjC/4oFza1uxGG6sr
         Q5lYs+jrXLI+SVe0RZU1hukGn12M3zlTVLsQEWaJq2aB1ROAsOycYBzg1QtgTftO7CjS
         O7xyon3j07CU+Rqo3CC6qQzXjEqCqKEzITPE3H6frRFVamH+WT/CFoeAApUiNvVsmQ8F
         dTtXdH/NxYlvsYhLx21MMGnzPOwk3hqFDRx0k8Z3NHIBlVP0Khwk3fYgsJD8WrDXbXYC
         HkzRoHJNAT/N7WqDm9Tfgi0PfYIWFHd4V7MU0/2mHjiZitRk+T9DQR+iocN7VowFmYqi
         zK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QVlRW9fKzP6hA/KjW/ElCxKDHp1ruA7N/RjYzVWIbYc=;
        b=moSSXv2B8UzbAfg5CaSKXgglvv+jNVnna4lvIm53FB1J8h+ZVUt7hp03Tr0fM2wH9n
         sWkTpnrAoGmB0EycedIMccOuZ7K8f6MZxPC5se8XsFqJvHeabCh3h44PxrjWt/zyzxE7
         8IUWpKhiSaqYQvG5Z5n1uoKpkN0FCWc50nDa/55m3zCw05i0P8IixyV0c3Y4fO56fayv
         coOl0pbyX18qrEIr1a298dNsCGWfTPCJcyNv6Xkqi4DnZbHpSoSu1eeKEU/1HX46ROoL
         M47X27Tq/7b10tUkMAWHp5cQ/5yZ0DZ6ce4ZNbhtPMmz3XeOdH8v+OBee38w73APr/rD
         aqiA==
X-Gm-Message-State: AOAM531SMqImRw0mOsMCCEliRXbMgLzMhrubxnYFVX8kpTuzN4IYUNWX
        Km2We7XAunJBSfHXdr4VPMM=
X-Google-Smtp-Source: ABdhPJwqNt+oK04TQmt4P82ao8q/HSDxnDkf46bXvY4k7d2Rg6SSMEv21W1dtIttr/HM2sPFJ7S2xg==
X-Received: by 2002:a92:89c3:: with SMTP id w64mr3517336ilk.49.1601495253696;
        Wed, 30 Sep 2020 12:47:33 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w1sm1478842ilj.83.2020.09.30.12.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 12:47:32 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:47:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, sameehj@amazon.com,
        kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Message-ID: <5f74e0cc804fa_364f8208d4@john-XPS-13-9370.notmuch>
In-Reply-To: <cover.1601478613.git.lorenzo@kernel.org>
References: <cover.1601478613.git.lorenzo@kernel.org>
Subject: RE: [PATCH v3 net-next 00/12] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers=

> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
> =

> For now, to keep the design simple and to maintain performance, the XDP=

> BPF-prog (still) only have access to the first-buffer. It is left for
> later (another patchset) to add payload access across multiple buffers.=

> This patchset should still allow for these future extensions. The goal
> is to lift the XDP MTU restriction that comes with XDP, but maintain
> same performance as before.
> =

> The main idea for the new multi-buffer layout is to reuse the same
> layout used for non-linear SKB. This rely on the "skb_shared_info"
> struct at the end of the first buffer to link together subsequent
> buffers. Keeping the layout compatible with SKBs is also done to ease
> and speedup creating an SKB from an xdp_{buff,frame}. Converting
> xdp_frame to SKB and deliver it to the network stack is shown in cpumap=

> code (patch 12/12).

Couple questions I think we want in the cover letter. How I read above
is if mb is enabled every frame received at the end of the first buffer
there will be skb_shared_info field.

First just to be clear a driver may have mb support but the mb bit
should only be used per frame so a frame with only a single buffer
will not have any extra cost even when driver/network layer support
mb. This way I can receive both multibuffer and single buffer frames
in the same stack without extra overhead on single buffer frames. I
think we want to put the details here in the cover letter so we don't
have to read mvneta driver to learn these details. I'll admit we've
sort of flung features like this with minimal descriptions in the
past, but this is important so lets get it described here.

Or put the details in the patch commits those are pretty terse for
a new feature that has impacts for all xdp driver writers.
> =

> In order to provide to userspace some metdata about the non-linear
> xdp_{buff,frame}, we introduced 2 bpf helpers:
> - bpf_xdp_get_frag_count:
>   get the number of fragments for a given xdp multi-buffer.
> - bpf_xdp_get_frags_total_size:
>   get the total size of fragments for a given xdp multi-buffer.
> =

> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> - TSO
> =

> More info about the main idea behind this approach can be found here [1=
][2].
> =

> We carried out some throughput tests in order to verify we did not intr=
oduced
> any performance regression adding xdp multi-buff support to mvneta:
> =

> offered load is ~ 1000Kpps, packet size is 64B
> =

> commit: 879456bedbe5 ("net: mvneta: avoid possible cache misses in mvne=
ta_rx_swbm")
> - xdp-pass:     ~162Kpps
> - xdp-drop:     ~701Kpps
> - xdp-tx:       ~185Kpps
> - xdp-redirect: ~202Kpps
> =

> mvneta xdp multi-buff:
> - xdp-pass:     ~163Kpps
> - xdp-drop:     ~739Kpps
> - xdp-tx:       ~182Kpps
> - xdp-redirect: ~202Kpps

But these are fairly low rates?  Also why can't we push line rate
here on xdp-tx and xdp-redirect, 1gbps should be no problem unless
we have a very small core or something? Finally, can you explain
why the huge hit between xdp-drop and xdp-tx?

I'm a bit wary of touching the end of a buffer on 40/100Gbps nic
with DDIO and getting a cache miss. Do you have some argument why
this wouldn't be the case? Do we need someone to step up with a
10/40/100gbps nic and implement the feature as well so we can verify
this?

> =

> This series is based on "bpf: cpumap: remove rcpu pointer from cpu_map_=
build_skb signature"
> https://patchwork.ozlabs.org/project/netdev/patch/33cb9b7dc447de3ea6fd6=
ce713ac41bca8794423.1601292015.git.lorenzo@kernel.org/
> =

> Changes since v2:
> - add throughput measurements
> - drop bpf_xdp_adjust_mb_header bpf helper
> - introduce selftest for xdp multibuffer
> - addressed comments on bpf_xdp_get_frag_count
> - introduce xdp multi-buff support to cpumaps
> =

> Changes since v1:
> - Fix use-after-free in xdp_return_{buff/frame}
> - Introduce bpf helpers
> - Introduce xdp_mb sample program
> - access skb_shared_info->nr_frags only on the last fragment
> =

> Changes since RFC:
> - squash multi-buffer bit initialization in a single patch
> - add mvneta non-linear XDP buff support for tx side
> =

> [0] https://netdevconf.info/0x14/pub/slides/62/Implementing%20TCP%20RX%=
20zero%20copy.pdf
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
> [2] https://netdevconf.info/0x14/pub/slides/10/add-xdp-on-driver.pdf (X=
DPmulti-buffers section)
> =

> Lorenzo Bianconi (10):
>   xdp: introduce mb in xdp_buff/xdp_frame
>   xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF laye=
r
>   xdp: add multi-buff support to xdp_return_{buff/frame}
>   net: mvneta: add multi buffer support to XDP_TX
>   bpf: move user_size out of bpf_test_init
>   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
>   bpf: add xdp multi-buffer selftest
>   net: mvneta: enable jumbo frames for XDP
>   bpf: cpumap: introduce xdp multi-buff support
> =

> Sameeh Jubran (2):
>   bpf: helpers: add multibuffer support
>   samples/bpf: add bpf program that uses xdp mb helpers
> =

>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |   1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   1 +
>  .../net/ethernet/cavium/thunder/nicvf_main.c  |   1 +
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   1 +
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   1 +
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
>  drivers/net/ethernet/marvell/mvneta.c         | 131 +++++++------
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   1 +
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 +
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   1 +
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   1 +
>  drivers/net/ethernet/qlogic/qede/qede_fp.c    |   1 +
>  drivers/net/ethernet/sfc/rx.c                 |   1 +
>  drivers/net/ethernet/socionext/netsec.c       |   1 +
>  drivers/net/ethernet/ti/cpsw.c                |   1 +
>  drivers/net/ethernet/ti/cpsw_new.c            |   1 +
>  drivers/net/hyperv/netvsc_bpf.c               |   1 +
>  drivers/net/tun.c                             |   2 +
>  drivers/net/veth.c                            |   1 +
>  drivers/net/virtio_net.c                      |   2 +
>  drivers/net/xen-netfront.c                    |   1 +
>  include/net/xdp.h                             |  31 ++-
>  include/uapi/linux/bpf.h                      |  14 ++
>  kernel/bpf/cpumap.c                           |  45 +----
>  net/bpf/test_run.c                            |  45 ++++-
>  net/core/dev.c                                |   1 +
>  net/core/filter.c                             |  42 ++++
>  net/core/xdp.c                                | 104 ++++++++++
>  samples/bpf/Makefile                          |   3 +
>  samples/bpf/xdp_mb_kern.c                     |  68 +++++++
>  samples/bpf/xdp_mb_user.c                     | 182 ++++++++++++++++++=

>  tools/include/uapi/linux/bpf.h                |  14 ++
>  .../testing/selftests/bpf/prog_tests/xdp_mb.c |  77 ++++++++
>  .../selftests/bpf/progs/test_xdp_multi_buff.c |  24 +++
>  36 files changed, 691 insertions(+), 114 deletions(-)
>  create mode 100644 samples/bpf/xdp_mb_kern.c
>  create mode 100644 samples/bpf/xdp_mb_user.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_mb.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_multi_bu=
ff.c
> =

> -- =

> 2.26.2
> =



