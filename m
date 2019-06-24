Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016335107C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbfFXPag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:30:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34143 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfFXPag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:30:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id m29so14957485qtu.1;
        Mon, 24 Jun 2019 08:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uO8h/FxgnyTvba83hS63h/+pbp5njycXsHdBYpaJQgs=;
        b=UFWodPqbRC0KE4NdEPT2o5CQbkgCC6WBymgDEu9V9GQDx+RWoTMYGK7P2raA/2UOTf
         2au5U+iZbdNsJ7PTA71aH0ktHjurCYLlRLQGD8cqILGlF1e69nGWG2UF8XKXJiLGgQkx
         PA1zFx1+6TqBhBbjk3jp0MFMOebBL7E9mu+K7206BFortLXYR1UePiM2Dut6Unbe0Wl5
         SRlmt1105IrDdraYxaGEW9x5Ew/kEZ36u3+/IOTE40dEPQt5DTdeHOMi0vIcKX0u5nOK
         Qybk2WjK37Ro18y2vIQLotaVrE5sUnHaDEQmFlfyW1UBHmXX5xOQcHxr62UGOd5cGDlv
         /Cew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uO8h/FxgnyTvba83hS63h/+pbp5njycXsHdBYpaJQgs=;
        b=RmmKdzsCMwYxbs6/1voigWy3gXEUY4qEH4RSuMy0G8TrKoHPsxV66LIjw/X7JhDlqa
         WFdecF7uhFIZ3blceEH5Mu8XrZlvq1qmv0GGT12PDHOOvP3/D+yx7AlIeOQWukzhTl6p
         e+41eYgWoG4P2NL2NEnD9q7bx0ZRVMb5SFDSj5YcvrE02G58W0dcYMTAGc605DNt0wbX
         7qw/DUQOOhtQbr/C/u5eExb9mvLIsVLXXrX9R2Awb7z+QkwwHqJWodUhJAlq6xVc/sjo
         SYWm9FmxAy9HWXzzdEaM/e2kPDL30e7PtMsU2Es2Ie3qlxAlqLWE/wjzwQ78DfUWnSDx
         26Cg==
X-Gm-Message-State: APjAAAWBNicLWloV6in9aKp+6GTmuEU9hEj+AZEjByNJf7Dcdql2Y9Gs
        Fue/wCb7+kLrtUpYVQP8TMiBb4wCKHX7Z6gGEkw=
X-Google-Smtp-Source: APXvYqzlSrEM2D9kNi0B0f4/2yLu29pfkiVe7Zz9poO72Tdgi2OEa1K9LrFdv8akj1yfUQGMnSFA6gKbzyJuR30WaZ0=
X-Received: by 2002:ac8:2f07:: with SMTP id j7mr118883469qta.359.1561390234918;
 Mon, 24 Jun 2019 08:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-8-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-8-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 17:30:24 +0200
Message-ID: <CAJ+HfNjzXpOQPjPS4Pg6iAmOG=2H=nku-1Rt8YXN5oZf06Uefw@mail.gmail.com>
Subject: Re: [PATCH 07/11] libbpf: add flags to umem config
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:26, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patch adds a 'flags' field to the umem_config and umem_reg structs.
> This will allow for more options to be added for configuring umems.
>
> The first use for the flags field is to add a flag for unaligned chunks
> mode. These flags can either be user-provided or filled with a default.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/include/uapi/linux/if_xdp.h | 4 ++++
>  tools/lib/bpf/xsk.c               | 7 +++++++
>  tools/lib/bpf/xsk.h               | 2 ++
>  3 files changed, 13 insertions(+)
>
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
> index caed8b1614ff..8548f2110a77 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -17,6 +17,9 @@
>  #define XDP_COPY       (1 << 1) /* Force copy-mode */
>  #define XDP_ZEROCOPY   (1 << 2) /* Force zero-copy mode */
>
> +/* Flags for xsk_umem_config flags */
> +#define XDP_UMEM_UNALIGNED_CHUNKS (1 << 0)
> +
>  struct sockaddr_xdp {
>         __u16 sxdp_family;
>         __u16 sxdp_flags;
> @@ -52,6 +55,7 @@ struct xdp_umem_reg {
>         __u64 len; /* Length of packet data area */
>         __u32 chunk_size;
>         __u32 headroom;
> +       __u32 flags;
>  };
>
>  struct xdp_statistics {
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 7ef6293b4fd7..df4207d4ff4a 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -115,6 +115,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
>                 cfg->comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
>                 cfg->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
>                 cfg->frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
> +               cfg->flags = XSK_UMEM__DEFAULT_FLAGS;
>                 return;
>         }
>
> @@ -122,6 +123,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
>         cfg->comp_size = usr_cfg->comp_size;
>         cfg->frame_size = usr_cfg->frame_size;
>         cfg->frame_headroom = usr_cfg->frame_headroom;
> +       cfg->flags = usr_cfg->flags;
>  }
>
>  static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
> @@ -181,6 +183,11 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
>         mr.len = size;
>         mr.chunk_size = umem->config.frame_size;
>         mr.headroom = umem->config.frame_headroom;
> +       mr.flags = umem->config.flags;
> +
> +       /* Headroom must be 0 for unaligned chunks */
> +       if ((mr.flags & XDP_UMEM_UNALIGNED_CHUNKS) && mr.headroom != 0)
> +               return -EINVAL;

Ah. :-) I'd prefer that this is done in the bind syscall.

>
>         err = setsockopt(umem->fd, SOL_XDP, XDP_UMEM_REG, &mr, sizeof(mr));
>         if (err) {
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 82ea71a0f3ec..8d393873b70f 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -170,12 +170,14 @@ LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
>  #define XSK_UMEM__DEFAULT_FRAME_SHIFT    11 /* 2048 bytes */
>  #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_FRAME_SHIFT)
>  #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
> +#define XSK_UMEM__DEFAULT_FLAGS 0
>
>  struct xsk_umem_config {
>         __u32 fill_size;
>         __u32 comp_size;
>         __u32 frame_size;
>         __u32 frame_headroom;
> +       __u32 flags;
>  };
>
>  /* Flags for the libbpf_flags field. */
> --
> 2.17.1
>
