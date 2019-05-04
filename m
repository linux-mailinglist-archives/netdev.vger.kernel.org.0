Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE3713B68
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 19:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfEDR0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 13:26:03 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37698 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfEDR0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 13:26:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id e2so8705068qtb.4;
        Sat, 04 May 2019 10:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7u0082f7BXRr33GLp+jMp5y6Dcqt1DasDYM9WMjlfvg=;
        b=CHe4yaZhawnTVRx5T60IKE2KQM9KzD3tIX9LNvkkaSjGv15nGTF2dBjpHt0b9bLO9T
         SwHlBcMmocpR3mkCMZBSnDh6ad7XQHG2wFt/XewHlXuV4jYNQpM++xujZzrRDVFr2FK9
         lXoCfYhojOgmWmPi2AZtRibunxDJdohOWOBGBP0uZr7EwFOu1xe3mroVB4IlU96RSEcj
         x5gumkNMm8vBNbnlDfjar3/BSWfV+WhkdFF+5MsHaj8seeWM1hONqVUqYYAJkWaGqT8L
         16Zq/XzaCO/grLXYkE6SBLoFRO7Yf0KoedOzXdv4IINqRg71JgohTelLkoGBMacVZrcw
         NVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7u0082f7BXRr33GLp+jMp5y6Dcqt1DasDYM9WMjlfvg=;
        b=keDHlKbOzK8UB/04orZ9d9n29ekfR7+CQbRe6kB8K5liBsQkDdfa6hYFKEaSl63YKj
         sLByv7Hf+CM2kQ7bW+bOS6hA7G4oa/ewT+ZkCxUV4KQdMk7UHCIXMPXD8Jw3pmm9tLgT
         abuEyiWRkDCSuDWZOycrHBHbFdvKZ4pPCcBiK51JE6g/VHeoMC+AnhDr29lcmFIfsVkk
         qTpw4h5GyFwhTPzd7HDNFBJSLuDn19um02rLkfMsLa3tSKUwGCBKeQr6dcryNSKqJulm
         ysNLWGVi1C0PYcDJPpskZujZ4BqrRZGKawepMvcE3LzsuqPcJ0+QAfI3AiNc1ORKl8/y
         hwCA==
X-Gm-Message-State: APjAAAXMgKQt9LJXIAuPwZKjiy8OMyKJvaT+ekS5Mo65LRfy2+GagSss
        RzBsb/CS/KxTnz8sYyCpsVqsPXdE8VsjpilPYd8=
X-Google-Smtp-Source: APXvYqz3bd+HxWu+MQMoYg70uaNmznmA9cblm2xdm4pdBPU3ycn9eTCeKhvCSKidbrZe1g+NBuj7QRonjB3sURzmZ1k=
X-Received: by 2002:ac8:3758:: with SMTP id p24mr14448333qtb.3.1556990762079;
 Sat, 04 May 2019 10:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190430181215.15305-1-maximmi@mellanox.com> <20190430181215.15305-3-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-3-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 4 May 2019 19:25:50 +0200
Message-ID: <CAJ+HfNid2hFN6ECetptT+pRQhvPpbdm39zQT9O9xVthadeqQWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/16] xsk: Add getsockopt XDP_OPTIONS
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Apr 2019 at 20:12, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> Make it possible for the application to determine whether the AF_XDP
> socket is running in zero-copy mode. To achieve this, add a new
> getsockopt option XDP_OPTIONS that returns flags. The only flag
> supported for now is the zero-copy mode indicator.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  include/uapi/linux/if_xdp.h       |  7 +++++++
>  net/xdp/xsk.c                     | 22 ++++++++++++++++++++++
>  tools/include/uapi/linux/if_xdp.h |  7 +++++++
>  3 files changed, 36 insertions(+)
>
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index caed8b1614ff..9ae4b4e08b68 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
>  #define XDP_UMEM_FILL_RING             5
>  #define XDP_UMEM_COMPLETION_RING       6
>  #define XDP_STATISTICS                 7
> +#define XDP_OPTIONS                    8
>
>  struct xdp_umem_reg {
>         __u64 addr; /* Start of packet data area */
> @@ -60,6 +61,12 @@ struct xdp_statistics {
>         __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
>  };
>
> +struct xdp_options {
> +       __u32 flags;
> +};
> +
> +#define XDP_OPTIONS_FLAG_ZEROCOPY (1 << 0)

Nit: The other flags doesn't use "FLAG" in its name, but that doesn't
really matter.

> +
>  /* Pgoff for mmaping the rings */
>  #define XDP_PGOFF_RX_RING                        0
>  #define XDP_PGOFF_TX_RING               0x80000000
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index b68a380f50b3..998199109d5c 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -650,6 +650,28 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
>
>                 return 0;
>         }
> +       case XDP_OPTIONS:
> +       {
> +               struct xdp_options opts;
> +
> +               if (len < sizeof(opts))
> +                       return -EINVAL;
> +
> +               opts.flags = 0;

Maybe get rid of this, in favor of "opts = {}" if the structure grows?


> +
> +               mutex_lock(&xs->mutex);
> +               if (xs->zc)
> +                       opts.flags |= XDP_OPTIONS_FLAG_ZEROCOPY;
> +               mutex_unlock(&xs->mutex);
> +
> +               len = sizeof(opts);
> +               if (copy_to_user(optval, &opts, len))
> +                       return -EFAULT;
> +               if (put_user(len, optlen))
> +                       return -EFAULT;
> +
> +               return 0;
> +       }
>         default:
>                 break;
>         }
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
> index caed8b1614ff..9ae4b4e08b68 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
>  #define XDP_UMEM_FILL_RING             5
>  #define XDP_UMEM_COMPLETION_RING       6
>  #define XDP_STATISTICS                 7
> +#define XDP_OPTIONS                    8
>
>  struct xdp_umem_reg {
>         __u64 addr; /* Start of packet data area */
> @@ -60,6 +61,12 @@ struct xdp_statistics {
>         __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
>  };
>
> +struct xdp_options {
> +       __u32 flags;
> +};
> +
> +#define XDP_OPTIONS_FLAG_ZEROCOPY (1 << 0)
> +
>  /* Pgoff for mmaping the rings */
>  #define XDP_PGOFF_RX_RING                        0
>  #define XDP_PGOFF_TX_RING               0x80000000
> --
> 2.19.1
>
