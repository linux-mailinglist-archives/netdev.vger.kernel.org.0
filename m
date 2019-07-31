Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E177C216
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 14:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbfGaMqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 08:46:05 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36334 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbfGaMqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 08:46:05 -0400
Received: by mail-qk1-f193.google.com with SMTP id g18so49071507qkl.3;
        Wed, 31 Jul 2019 05:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vLpkXNHhxEM17yvb6EI7BaAyJql2ESScNq7hPZTMJs8=;
        b=ClvLvbodde1OBQTL4cQEBUNATjh4NuCJLeyvO1xkzFujlkmlPl481j/C5Q4FC2++7J
         Ufj012+IsGSqvuJS1BCFoYow+/YP08kbDl5u1t3TUBZYuHJk/FbOqlXLeypb1bv/Z2IT
         /wNTsGr4lU7b6XJ3w+94St8xJyzVe4arR3y9BNiDaPWwtoIWnk9brl1rHRmZaOdJ3H9h
         mWa1D8FNQnWd+tAhz3R2oMqgkZ8vWL630qOJU9OOCpf0VqW6RCkApG3zM9rKQzQMnrSL
         8Fcm5ee94IpOazEbCNxxjHilgFoDtTdYJeH1c7UlKof4tAHfmzNLMRG16wIx7Jiyo/C2
         qrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vLpkXNHhxEM17yvb6EI7BaAyJql2ESScNq7hPZTMJs8=;
        b=U5ICnvsBlauiUHadi+tOWGX04VeUKwgY6uzrz4ZiiIrX8LJQThkoy6OFscJi+vg9nG
         K17h6+K0yJjuf57XhNN7cfBoMUkG+SXb6koIsMRjgiay78EPqc2NGH0FeFtTSfuc8Ha1
         O9zM32M1sEWTb1NPItrV0rEgMfZipf6AlIXrUNI08GkT0u9GMuEvorCKcJJltOazINiO
         5k6TiNeD8dbvyyXOnIk3fn2GLRP/TkZgOu/bJUC5op9WpIeaExVF0q24Y6UdD6bmypzC
         eVBCtrRwjoWnMYAWzCbf6IrytZBIy8L7V4TW0PbVJuBFjSyWmTRsjy/oeCI8GdZtbP+9
         QMZg==
X-Gm-Message-State: APjAAAUHrCEi8YheKzk7RynSOqJB539/ZT//7317aVZzp+M6VvbYR3Kb
        1KbX+F+kFSuoEWmAelcDzYP2Dg5mDV3MDEt3TLA=
X-Google-Smtp-Source: APXvYqz4OpyytBFMjrUi+2Ek+BzAgpYTbK35jF6eoPLPS76d/m951mKVWT1i986GzTd6nwpG3luXSXILDNLnc74lcCg=
X-Received: by 2002:a37:6146:: with SMTP id v67mr64646448qkb.493.1564577163571;
 Wed, 31 Jul 2019 05:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190724051043.14348-1-kevin.laatz@intel.com> <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-4-kevin.laatz@intel.com>
In-Reply-To: <20190730085400.10376-4-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 31 Jul 2019 14:45:52 +0200
Message-ID: <CAJ+HfNgqZFnikLMNYo7wE3fqyyZzgsQXuix905SQ+iRo8FfqpA@mail.gmail.com>
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

So, the flags member moved from struct sockaddr_xdp to struct
xdp_umem_reg. Makes sense. However, I'm not a fan of the bitfield. Why
not just add the flags member after the last member (headroom) and
deal with it in xsk.c/xsk_setsockopt and libbpf? The bitfield
preserves the size, but makes it hard to read/error prone IMO.


Bj=C3=B6rn


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
