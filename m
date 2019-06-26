Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCCE56F0F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZQqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:46:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37096 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZQqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:46:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id bh12so1757701plb.4;
        Wed, 26 Jun 2019 09:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HZWgIioCqoR3+EXg/6PBiByFdV7tx27KPQAGYWlWonc=;
        b=T0BVFMdDbc8R7blh1iIOJV40p/ZB3Noy5RKBNmCtxQIqYtAokoHoQGVAKcHKH93Ld0
         TtZOJ7tVGJ/Q7gWkNPcNHECU3J940fReBUaAwnml7LyjjM91XvXAPHKaV48TGybGKDTy
         7Jt6UEvJgLb6dqB8CaZkgV/z7LVN1St8o8aQGJj+uACG/4KcBNW62n8zPV7eBPpLzoIq
         iGzslun7e2MVZboD50S6vpCS/c+evQivaXCsYOB0O0xJB5W2K5RSoiqKsYJmw7QuK5ie
         8/sG9w/ofO2plxaymxmm5PdR1F1zdIu1BQ4NrJj698em+Kpw0ErKoZ5zOeWpg7kpVEAV
         emSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZWgIioCqoR3+EXg/6PBiByFdV7tx27KPQAGYWlWonc=;
        b=QuEIdFWWGr4PZVFae66zyRwFzvnyUvwT7RgrpUCEgTdlyso88pnjG8Y9g+7wxoXtQd
         e2cHXFN2eDbNuPGsIlpbOYaJdSHaqVia0Cw0KlY1Ni8ELScv5MRv1kPgCn9fCtb5ZxQU
         zwHIio3Gfc6EvLJPr9I94yTlwIHZIzALuMjzOH/tOM38BDrxhBqhRIQXkIRKRQmejzeX
         vLAkKIZ6ZseIOSMS5y39Bxr2ZU7GSC6wj1BerePuPmYj+RqowXHwgNFvQS7DW6eAmHsJ
         ZZ0s7UR6FveEHyGFdFy++nie3lWimVa2akR8auh1LsLzYb+TYrziu4wNZXA+f0BVwq9r
         IObQ==
X-Gm-Message-State: APjAAAWF6FIGGvzUuJFLsBbsCh1rC7R0WOnupFs3tJY5skaTjTtccdC9
        LIzHLQRfaLaUTZpxnOeV8Zk=
X-Google-Smtp-Source: APXvYqzTYPUHPJ/HN4F8dqhfUuDuUNKBbFu4r0rAOkWzN46UrB0QNU4Bv9lF1H5/hGOXwZNJ6gwptA==
X-Received: by 2002:a17:902:b487:: with SMTP id y7mr6358734plr.219.1561567571614;
        Wed, 26 Jun 2019 09:46:11 -0700 (PDT)
Received: from [172.26.110.73] ([2620:10d:c090:180::1:e729])
        by smtp.gmail.com with ESMTPSA id j15sm21219436pfr.146.2019.06.26.09.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 09:46:11 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Tariq Toukan" <tariqt@mellanox.com>
Cc:     "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>, bjorn.topel@intel.com,
        "Magnus Karlsson" <magnus.karlsson@intel.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>
Subject: Re: [PATCH bpf-next V6 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Date:   Wed, 26 Jun 2019 09:46:09 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <25F8D83F-4287-4D87-B79D-33BEED35956B@gmail.com>
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Jun 2019, at 7:35, Tariq Toukan wrote:

> This series contains improvements to the AF_XDP kernel infrastructure
> and AF_XDP support in mlx5e. The infrastructure improvements are
> required for mlx5e, but also some of them benefit to all drivers, and
> some can be useful for other drivers that want to implement AF_XDP.
>
> The performance testing was performed on a machine with the following
> configuration:
>
> - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
> - Mellanox ConnectX-5 Ex with 100 Gbit/s link
>
> The results with retpoline disabled, single stream:
>
> txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same 
> CPU)
> rxdrop: 12.2 Mpps
> l2fwd: 9.4 Mpps
>
> The results with retpoline enabled, single stream:
>
> txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same 
> CPU)
> rxdrop: 9.9 Mpps
> l2fwd: 6.8 Mpps
>
> v2 changes:
>
> Added patches for mlx5e and addressed the comments for v1. Rebased for
> bpf-next.
>
> v3 changes:
>
> Rebased for the newer bpf-next, resolved conflicts in libbpf. 
> Addressed
> Björn's comments for coding style. Fixed a bug in error handling flow 
> in
> mlx5e_open_xsk.
>
> v4 changes:
>
> UAPI is not changed, XSK RX queues are exposed to the kernel. The 
> lower
> half of the available amount of RX queues are regular queues, and the
> upper half are XSK RX queues. The patch "xsk: Extend channels to 
> support
> combined XSK/non-XSK traffic" was dropped. The final patch was 
> reworked
> accordingly.
>
> Added "net/mlx5e: Attach/detach XDP program safely", as the changes
> introduced in the XSK patch base on the stuff from this one.
>
> Added "libbpf: Support drivers with non-combined channels", which 
> aligns
> the condition in libbpf with the condition in the kernel.
>
> Rebased over the newer bpf-next.
>
> v5 changes:
>
> In v4, ethtool reports the number of channels as 'combined' and the
> number of XSK RX queues as 'rx' for mlx5e. It was changed, so that 
> 'rx'
> is 0, and 'combined' reports the double amount of channels if there is
> an active UMEM - to make libbpf happy.
>
> The patch for libbpf was dropped. Although it's still useful and fixes
> things, it raises some disagreement, so I'm dropping it - it's no 
> longer
> useful for mlx5e anymore after the change above.
>
> v6 changes:
>
> As Maxim is out of office, I rebased the series on behalf of him,
> solved some conflicts, and re-spinned.

If this is just a re-spin, you can add back:

Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>


>
> Series generated against bpf-next commit:
> 572a6928f9e3 xdp: Make __mem_id_disconnect static
>
>
> Maxim Mikityanskiy (16):
>   net/mlx5e: Attach/detach XDP program safely
>   xsk: Add API to check for available entries in FQ
>   xsk: Add getsockopt XDP_OPTIONS
>   libbpf: Support getsockopt XDP_OPTIONS
>   xsk: Change the default frame size to 4096 and allow controlling it
>   xsk: Return the whole xdp_desc from xsk_umem_consume_tx
>   net/mlx5e: Replace deprecated PCI_DMA_TODEVICE
>   net/mlx5e: Calculate linear RX frag size considering XSK
>   net/mlx5e: Allow ICO SQ to be used by multiple RQs
>   net/mlx5e: Refactor struct mlx5e_xdp_info
>   net/mlx5e: Share the XDP SQ for XDP_TX between RQs
>   net/mlx5e: XDP_TX from UMEM support
>   net/mlx5e: Consider XSK in XDP MTU limit calculation
>   net/mlx5e: Encapsulate open/close queues into a function
>   net/mlx5e: Move queue param structs to en/params.h
>   net/mlx5e: Add XSK zero-copy support
>
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  12 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  15 +-
>  drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en.h       | 155 ++++-
>  .../net/ethernet/mellanox/mlx5/core/en/params.c    | 108 +--
>  .../net/ethernet/mellanox/mlx5/core/en/params.h    | 118 +++-
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 231 +++++--
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  36 +-
>  .../ethernet/mellanox/mlx5/core/en/xsk/Makefile    |   1 +
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    | 192 ++++++
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  27 +
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 223 +++++++
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |  25 +
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    | 111 ++++
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |  15 +
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  | 267 ++++++++
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |  31 +
>  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  25 +-
>  .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  18 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 730 
> +++++++++++++--------
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  12 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 104 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 115 +++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  30 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  42 +-
>  .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  14 +-
>  drivers/net/ethernet/mellanox/mlx5/core/wq.h       |   5 -
>  include/net/xdp_sock.h                             |  27 +-
>  include/uapi/linux/if_xdp.h                        |   8 +
>  net/xdp/xsk.c                                      |  36 +-
>  net/xdp/xsk_queue.h                                |  14 +
>  samples/bpf/xdpsock_user.c                         |  44 +-
>  tools/include/uapi/linux/if_xdp.h                  |   8 +
>  tools/lib/bpf/xsk.c                                |  12 +
>  tools/lib/bpf/xsk.h                                |   2 +-
>  35 files changed, 2331 insertions(+), 484 deletions(-)
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
>  create mode 100644 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
>
> -- 
> 1.8.3.1
