Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D1A25D0F1
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 07:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgIDFlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 01:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgIDFle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 01:41:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3508FC061244;
        Thu,  3 Sep 2020 22:41:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id o68so4010265pfg.2;
        Thu, 03 Sep 2020 22:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Es+RVIZWdQ1PGQM8u6/wE9+uWwWlH7EQ/8Vj8EXs3q0=;
        b=WFP4PhrAlqQTJAeFqYU5hv+KOUXjYERHfgQ/tor2wFXCc0kSpgaHzalRXSOmjw+iYU
         BppLtlkxTgSDXXBCoZGNTV2ARMRJt/t3cLyu0kgJ4WZxenLkjjJbrdzBm+YDzRgRyLZf
         7Diwn3YfVqOKE4PEj8dgrOxygte+EAZTeRU8tQVZsVwPU41b2QOsOZ/SySPyu0AfYhmt
         qBL73bs2AhDYzMm8dPeFQ0tUtXqnGVOuSfNJt0Lx/ZxbssETrLSyTITEl0G1/C8P9/jh
         cH8gAq2N+As+uovANyl+RAK5kRaJOVk1za0z2mnoO9Xm7SWRGwIPLsL5ZmL+A4hPScBk
         2Ezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Es+RVIZWdQ1PGQM8u6/wE9+uWwWlH7EQ/8Vj8EXs3q0=;
        b=TIQzwSZz0ea3/184kjF1RmCwwQ6k6POoL3GXBuigDKzcHnQ0vJ3ilOu5nMso7n8/nx
         YBBeJPXP9iw/+0hf7656+LiUyrlE+lTwf8rVcH0xgjiOOqAsPGanEujaSp0byUiv9uzi
         L63//Qph0LSuBQXPEtLySdLl5c2lq/z33CVVazW91rMnWV5IWPu70DNbuJWKGNN9Z//1
         K/vVEl0dFVClVQSjFR8EgKWDlYMrWhjszz1Wkp1iqXEsn7ST9U+tkb8sSFFputXQWky4
         MlysPrMpQvbWkIy3CSZYdp2wVy7l5tcQ8nBEowbuW0kkC9wFguaqoriaR9eCXFKVkBXo
         O99Q==
X-Gm-Message-State: AOAM532QiOiavKjKou56SUjKD7Q1RwEWU5aLGeFtJCUf6ykByEFxklDv
        wYKQNpgGhiSaEC2+8qnYjj0=
X-Google-Smtp-Source: ABdhPJxctx4Dre8TrYh8S8T5A1G47osu/3LDCJ50He4+wQBEQlh9RkMnC9V5DpmzjoGL5fIq/QTybA==
X-Received: by 2002:a63:3103:: with SMTP id x3mr5971392pgx.80.1599198093758;
        Thu, 03 Sep 2020 22:41:33 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q34sm4285981pgl.28.2020.09.03.22.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 22:41:33 -0700 (PDT)
Date:   Thu, 03 Sep 2020 22:41:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Message-ID: <5f51d3869b4a4_3eceb20847@john-XPS-13-9370.notmuch>
In-Reply-To: <cover.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
Subject: RE: [PATCH v2 net-next 0/9] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> - Finalize XDP multi-buffer support for mvneta driver introducing the
>   capability to map non-linear buffers on tx side.
> - Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify if
>   shared_info area has been properly initialized.
> - Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
> - Add multi-buff support to xdp_return_{buff/frame} utility routines.
> - Introduce bpf_xdp_adjust_mb_header helper to adjust frame headers moving
>   *offset* bytes from/to the second buffer to/from the first one.
>   This helper can be used to move headers when the hw DMA SG is not able
>   to copy all the headers in the first fragment and split header and data
>   pages. A possible use case for bpf_xdp_adjust_mb_header is described
>   here [0]

Are those slides available anywhere? [0] is just a link to the abstract.

> - Introduce bpf_xdp_get_frag_count and bpf_xdp_get_frags_total_size helpers to
>   report the total number/size of frags for a given xdp multi-buff.
> 
> XDP multi-buffer design principles are described here [1]
> For the moment we have not implemented any self-test for the introduced the bpf
> helpers. We can address this in a follow up series if the proposed approach
> is accepted.

Will need to include selftests with series.

> 
> Changes since v1:
> - Fix use-after-free in xdp_return_{buff/frame}
> - Introduce bpf helpers
> - Introduce xdp_mb sample program
> - access skb_shared_info->nr_frags only on the last fragment
> 
> Changes since RFC:
> - squash multi-buffer bit initialization in a single patch
> - add mvneta non-linear XDP buff support for tx side
> 
> [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> 
> Lorenzo Bianconi (7):
>   xdp: introduce mb in xdp_buff/xdp_frame
>   xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
>   xdp: add multi-buff support to xdp_return_{buff/frame}
>   net: mvneta: add multi buffer support to XDP_TX
>   bpf: helpers: add bpf_xdp_adjust_mb_header helper
>   net: mvneta: enable jumbo frames for XDP
> 
> Sameeh Jubran (2):
>   bpf: helpers: add multibuffer support
>   samples/bpf: add bpf program that uses xdp mb helpers
> 
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |   1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   1 +
>  .../net/ethernet/cavium/thunder/nicvf_main.c  |   1 +
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   1 +
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   1 +
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
>  drivers/net/ethernet/marvell/mvneta.c         | 126 ++++++------
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
>  include/net/xdp.h                             |  26 ++-
>  include/uapi/linux/bpf.h                      |  39 +++-
>  net/core/dev.c                                |   1 +
>  net/core/filter.c                             |  93 +++++++++
>  net/core/xdp.c                                |  40 ++++
>  samples/bpf/Makefile                          |   3 +
>  samples/bpf/xdp_mb_kern.c                     |  68 +++++++
>  samples/bpf/xdp_mb_user.c                     | 182 ++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |  40 +++-
>  32 files changed, 572 insertions(+), 70 deletions(-)
>  create mode 100644 samples/bpf/xdp_mb_kern.c
>  create mode 100644 samples/bpf/xdp_mb_user.c
> 
> -- 
> 2.26.2
> 


