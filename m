Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D5456EC3
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFZQ31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:29:27 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33224 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfFZQ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:29:27 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so2197486qkc.0;
        Wed, 26 Jun 2019 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NCNP1rR2y0/7U0oWB6lQc44w9v6vUALkPtzrDhSFcXI=;
        b=HyDTH92jD8E11VuUUihz0ayfwTNc8saAM9JiXe+STHSU6QiJIKVf9feVprIZjNfNWP
         XnvzIfrFMk96zh8RKkyuSE7Dya197uaxFHH8AlreM0Vq8UdJqpLEQM6lZz8tLE/yw2K+
         eZQ0CsPRlbHZGuSkM9wa/IqDLFVMvXuOiy9L2YIM1J4g7thNRJ6EltYvm7VEkGC5JWvK
         uA/eJ+8jkrrQF3Fk6zPQT81go8xG52wJ0yBoTO1R6hOZ06P0N/fzpMeyIxypOAqQgxzy
         7aGZRegc5E5DxsQ8TKlqB4cz/19F0CsGhALlwmmyergZkhUrgs4vFMKo1YybnI/Xx9f2
         jFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NCNP1rR2y0/7U0oWB6lQc44w9v6vUALkPtzrDhSFcXI=;
        b=Oc2ABGxy3bPRJh34lmmb1IgdwZ6+aZdUsn2sBIPHuYX1eBqplV3rAhicd6G1ppfsyZ
         NLLF4E1eW90IXUWLOo7FOa9u8CHCpsh8fovF6Vnoa1WcslErZX5snctlMjZdO0wMVrFB
         pYIemBHMSfnR/JjWMYY4tNK7SEHUby6KiMdewxN+3bG/II7vtRO4NTfpXKBVlry7uLfG
         aQg1QzGgO+wEPtTUvqPTokPLjGzUxQT5V5zUCPvv11VjMoiHs++aNgyvf0v/wOIJ0v29
         12z8NG18s6GKQOh0c8BJ5duX/VG5rQXAIsTy+5WpJf+4DQ/oCwX+EnzglkAB+cQAycWY
         sYdw==
X-Gm-Message-State: APjAAAVrERwWRz5RMh4sPr6B+J/3b5TvcYomrI8lKzi4UfGsZiX+86MO
        eRv36R9KpMJ14GhPTu8QmPzKLu/6DCL4W9NOyy0=
X-Google-Smtp-Source: APXvYqzSoClvSOEtmfQ8Emm8cOSqO+xKNKGxn0cWSbhRmCd3vo+dZeb7EXrXU5TyZPTyDhKoi9z28scOP9alcNzq25s=
X-Received: by 2002:a37:d16:: with SMTP id 22mr4621962qkn.232.1561566566083;
 Wed, 26 Jun 2019 09:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 26 Jun 2019 18:29:14 +0200
Message-ID: <CAJ+HfNifGAruzJp7XUsXKZ_SyL20x5P_zLuFJDvqsHPNGyox=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next V6 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 at 16:36, Tariq Toukan <tariqt@mellanox.com> wrote:
>
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
> txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
> rxdrop: 12.2 Mpps
> l2fwd: 9.4 Mpps
>
> The results with retpoline enabled, single stream:
>
> txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
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
> Rebased for the newer bpf-next, resolved conflicts in libbpf. Addressed
> Bj=C3=B6rn's comments for coding style. Fixed a bug in error handling flo=
w in
> mlx5e_open_xsk.
>
> v4 changes:
>
> UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
> half of the available amount of RX queues are regular queues, and the
> upper half are XSK RX queues. The patch "xsk: Extend channels to support
> combined XSK/non-XSK traffic" was dropped. The final patch was reworked
> accordingly.
>
> Added "net/mlx5e: Attach/detach XDP program safely", as the changes
> introduced in the XSK patch base on the stuff from this one.
>
> Added "libbpf: Support drivers with non-combined channels", which aligns
> the condition in libbpf with the condition in the kernel.
>
> Rebased over the newer bpf-next.
>
> v5 changes:
>
> In v4, ethtool reports the number of channels as 'combined' and the
> number of XSK RX queues as 'rx' for mlx5e. It was changed, so that 'rx'
> is 0, and 'combined' reports the double amount of channels if there is
> an active UMEM - to make libbpf happy.
>
> The patch for libbpf was dropped. Although it's still useful and fixes
> things, it raises some disagreement, so I'm dropping it - it's no longer
> useful for mlx5e anymore after the change above.
>
> v6 changes:
>
> As Maxim is out of office, I rebased the series on behalf of him,
> solved some conflicts, and re-spinned.
>
> Series generated against bpf-next commit:
> 572a6928f9e3 xdp: Make __mem_id_disconnect static
>

Thanks Tariq, re-adding my ack for the series.

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

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
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 730 +++++++++++++--=
------
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
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefi=
le
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.=
c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.=
h
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
>
> --
> 1.8.3.1
>
