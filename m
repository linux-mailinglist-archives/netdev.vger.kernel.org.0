Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3257C4E0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbfGaOZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 10:25:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40415 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfGaOZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 10:25:43 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so66709538qtn.7;
        Wed, 31 Jul 2019 07:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ilmbv3LwU3n/nvyIEEtNJYwKwa9nTuuolqGHBIVjFFI=;
        b=iYCmpv1Tqh1NkgYy767EfDxhSa80zx8RiW4kNKouex1nvzWg72oJ9X7GJM6K07ifwt
         6VRnzR/m3gr3cd/1aWsA+gM62VS2ESES9PoHN8mEubZoj/YD4AX3/tL6YRGDjtW+Iqv8
         fDq6mSefDaWt3FIU4QaUg+O4Ou6AFTxKdpLsBjA4Pk1lfkGPU4fFSGug2GMUNjRM/HJQ
         cLx/EFgiS2gna/Jxl9XCLTzfgWAZQhd0DdGevNnfcQ+3nnGURsS8xnwQ753P8ygP7rKA
         I5exc7qLGwULM20inqfhdqfinkrQJVPFDWGCImQgr3kf/Pd0JxFDDQoTGvwC9ZFxbdXj
         Mh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ilmbv3LwU3n/nvyIEEtNJYwKwa9nTuuolqGHBIVjFFI=;
        b=U6t65St2Aa9Qe48VjQS4f+tMQIMPC72v6CRJH1E6zS8Fl7gqcEXKP1JdwVcYFGBsDe
         UHO38U1jfcdMrJYXna0PrC0z5GtMaEI8dv78ebrjrhYmM71ApIM1uuHcJRcpzYUIv9/E
         XFpxAZx6MxG35jbB4pb2aqCa8L6UD8T3/KQw9dYqQyUcw2+5qiV+V5ILe5qhYsBy2ZAf
         AkmdYHZA2lZFkY+ODdlM/8V1tcieTM2he7hoV+tfXEyXnN5gHMqhtXIxfXFTTHcQRj0O
         5lyRbNY6KI+6cGBby7ofI4pL3EdJ4zfn5LXiFSggwSQRinlQl+hTd1jG8BgzWKLnKhns
         98CQ==
X-Gm-Message-State: APjAAAUjmct9WUc1Ar9cOTmDWYqliTHw46Z1QuIzpx/iXcEoNkwLBIQB
        GX8cv4FLPqdsjQbSfHyi12sYBO24yClN26fXXUI=
X-Google-Smtp-Source: APXvYqzxWgjc02cLAA2WDeeksryUHOXoxBOcJOOm7Xcnx36Do8x4tszpKdz8ALRxPxYQzxxL2NLzPIhRg0cfd5GDdNY=
X-Received: by 2002:aed:2ca3:: with SMTP id g32mr87786724qtd.359.1564583141992;
 Wed, 31 Jul 2019 07:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190724051043.14348-1-kevin.laatz@intel.com> <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-4-kevin.laatz@intel.com>
In-Reply-To: <20190730085400.10376-4-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 31 Jul 2019 16:25:30 +0200
Message-ID: <CAJ+HfNifxfgycmZFz8eBZq=FZXAgNQezNqUiy3Q1z4JBrUEkew@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next v4 03/11] libbpf: add flags to
 umem config
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 at 19:43, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patch adds a 'flags' field to the umem_config and umem_reg structs.
> This will allow for more options to be added for configuring umems.
>
> The first use for the flags field is to add a flag for unaligned chunks
> mode. These flags can either be user-provided or filled with a default.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
>
> ---
> v2:
>   - Removed the headroom check from this patch. It has moved to the
>     previous patch.
>
> v4:
>   - modified chunk flag define
> ---
>  tools/include/uapi/linux/if_xdp.h | 9 +++++++--
>  tools/lib/bpf/xsk.c               | 3 +++
>  tools/lib/bpf/xsk.h               | 2 ++
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux=
/if_xdp.h
> index faaa5ca2a117..a691802d7915 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -17,6 +17,10 @@
>  #define XDP_COPY       (1 << 1) /* Force copy-mode */
>  #define XDP_ZEROCOPY   (1 << 2) /* Force zero-copy mode */
>
> +/* Flags for xsk_umem_config flags */
> +#define XDP_UMEM_UNALIGNED_CHUNK_FLAG_SHIFT 15
> +#define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << XDP_UMEM_UNALIGNED_CHUNK_FLA=
G_SHIFT)
> +
>  struct sockaddr_xdp {
>         __u16 sxdp_family;
>         __u16 sxdp_flags;
> @@ -49,8 +53,9 @@ struct xdp_mmap_offsets {
>  #define XDP_OPTIONS                    8
>
>  struct xdp_umem_reg {
> -       __u64 addr; /* Start of packet data area */
> -       __u64 len; /* Length of packet data area */
> +       __u64 addr;     /* Start of packet data area */
> +       __u64 len:48;   /* Length of packet data area */
> +       __u64 flags:16; /* Flags for umem */
>         __u32 chunk_size;
>         __u32 headroom;
>  };
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 5007b5d4fd2c..5e7e4d420ee0 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -116,6 +116,7 @@ static void xsk_set_umem_config(struct xsk_umem_confi=
g *cfg,
>                 cfg->comp_size =3D XSK_RING_CONS__DEFAULT_NUM_DESCS;
>                 cfg->frame_size =3D XSK_UMEM__DEFAULT_FRAME_SIZE;
>                 cfg->frame_headroom =3D XSK_UMEM__DEFAULT_FRAME_HEADROOM;
> +               cfg->flags =3D XSK_UMEM__DEFAULT_FLAGS;
>                 return;
>         }
>
> @@ -123,6 +124,7 @@ static void xsk_set_umem_config(struct xsk_umem_confi=
g *cfg,
>         cfg->comp_size =3D usr_cfg->comp_size;
>         cfg->frame_size =3D usr_cfg->frame_size;
>         cfg->frame_headroom =3D usr_cfg->frame_headroom;
> +       cfg->flags =3D usr_cfg->flags;
>  }
>
>  static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
> @@ -182,6 +184,7 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void=
 *umem_area, __u64 size,
>         mr.len =3D size;
>         mr.chunk_size =3D umem->config.frame_size;
>         mr.headroom =3D umem->config.frame_headroom;
> +       mr.flags =3D umem->config.flags;
>
>         err =3D setsockopt(umem->fd, SOL_XDP, XDP_UMEM_REG, &mr, sizeof(m=
r));
>         if (err) {
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 833a6e60d065..44a03d8c34b9 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -170,12 +170,14 @@ LIBBPF_API int xsk_socket__fd(const struct xsk_sock=
et *xsk);
>  #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
>  #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_FRAME_S=
HIFT)
>  #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
> +#define XSK_UMEM__DEFAULT_FLAGS 0
>
>  struct xsk_umem_config {
>         __u32 fill_size;
>         __u32 comp_size;
>         __u32 frame_size;
>         __u32 frame_headroom;
> +       __u32 flags;

And the flags addition here, unfortunately, requires symbol versioning
of xsk_umem__create(). That'll be the first in libbpf! :-)


Bj=C3=B6rn

>  };
>
>  /* Flags for the libbpf_flags field. */
> --
> 2.17.1
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
