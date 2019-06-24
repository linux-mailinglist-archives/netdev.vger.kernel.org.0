Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C96F50E24
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfFXOdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:33:11 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36381 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbfFXOdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:33:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so9916307qkl.3;
        Mon, 24 Jun 2019 07:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y9Y2C5sAs+7ESo3yvMuycRT88EAj9a/XPg+oK6UXn8E=;
        b=AAvZB0tJ+TlcBgquT4PTY6Is1MdjKBOhaoYpASqP8SVqMf0w1oof4avV7z7JovvO1S
         LgWVyNQyWo3jd39ADq+ZiJIfcIdlrFI5pd+oR0608yOLcJs5CGNOd/D/7dIec0bNFR5U
         t1Yh0nYR5EP+PAsFn6QmCWfQKdlPl1Zn9s9NPr7dRYBkFX2OyfGGpkpNN8OhTa9xpFa2
         fn/+QDqLuv6Ytj7Mfi0eV0q0NQyKLcovkKIdP53Suoh7nwPaP0xCAfOJJvYyw3EcUJxT
         WYBgeEZL6xOjVKiddZo0NV6tYn43Z2wvIs0SGsGo9mVmHuTVQWS3jYI8judBfBQcJ8Q0
         jQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y9Y2C5sAs+7ESo3yvMuycRT88EAj9a/XPg+oK6UXn8E=;
        b=WHbGyxKxC3vpXynVGwbRxtiC0zRKbc3cRBzXTEUwt1nhPjiIMnBdF+R5CSZBWXNRG0
         +KmvWv/bfJ37Iji15YwLL3Vskh+goRUkcxwMC3oByloD9mGVsX3/UQaFTEHcdwaAAntR
         PIT4Lq4C9hKJykpxGsNsCiW2qCNBcEv/HP7ri/uLmEMNx4gCgM8HQ0AEhZGhlvshZtQu
         6F0Q+LENyQiAr4b1KnYD409QPU1hObuQz4M4xyeSm2OCIJRM9TB6YU2ud4j5vTBnz2R/
         6Fz6kxGRX2hlvg5DZGOruvC6mW4TwJWU3qIUBnbbcdJogcswrfphxnHqwg12ncJ+dmQN
         4IYQ==
X-Gm-Message-State: APjAAAXBee/q8K4+11uXRlE6WwwCZy3AWXU5tQphi/R+qeJ2BJNFaiMI
        A+eihTn1OUunutPtJ5w9fgFKAczGkC8IjrpKNEQ=
X-Google-Smtp-Source: APXvYqzpeMWaYgUjFY2oiWqgasi4EBY4BCU1lPGhcVFWMmJwsJoFyDMJa4XvPuFDReBSdr0tWjVYftj+nP6p62mqFn4=
X-Received: by 2002:a05:620a:1270:: with SMTP id b16mr100549560qkl.333.1561386790244;
 Mon, 24 Jun 2019 07:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-6-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-6-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 16:32:59 +0200
Message-ID: <CAJ+HfNg9chx674Sc=Ht-UJ_iYoau=X6LJYn5w05rUQ85b9oyDg@mail.gmail.com>
Subject: Re: [PATCH 05/11] ixgbe: add offset to zca_free
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:25, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patch adds the offset param to for zero_copy_allocator to
> ixgbe_zca_free. This change is required to calculate the handle, otherwis=
e,
> this function will not work in unaligned chunk mode since we can't easily=
 mask
> back to the original handle in unaligned chunk mode.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h | 3 ++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c         | 8 ++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drive=
rs/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> index d93a690aff74..49702e2a4360 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> @@ -33,7 +33,8 @@ struct xdp_umem *ixgbe_xsk_umem(struct ixgbe_adapter *a=
dapter,
>  int ixgbe_xsk_umem_setup(struct ixgbe_adapter *adapter, struct xdp_umem =
*umem,
>                          u16 qid);
>
> -void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long han=
dle);
> +void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long han=
dle,
> +               off_t off);
>
>  void ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_c=
ount);
>  int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
> index 49536adafe8e..1ec02077ccb2 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -268,16 +268,16 @@ static void ixgbe_reuse_rx_buffer_zc(struct ixgbe_r=
ing *rx_ring,
>         obi->skb =3D NULL;
>  }
>
> -void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long han=
dle)
> +void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long han=
dle,
> +               off_t off)
>  {
>         struct ixgbe_rx_buffer *bi;
>         struct ixgbe_ring *rx_ring;
> -       u64 hr, mask;
> +       u64 hr;
>         u16 nta;
>
>         rx_ring =3D container_of(alloc, struct ixgbe_ring, zca);
>         hr =3D rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
> -       mask =3D rx_ring->xsk_umem->chunk_mask;
>
>         nta =3D rx_ring->next_to_alloc;
>         bi =3D rx_ring->rx_buffer_info;
> @@ -285,7 +285,7 @@ void ixgbe_zca_free(struct zero_copy_allocator *alloc=
, unsigned long handle)
>         nta++;
>         rx_ring->next_to_alloc =3D (nta < rx_ring->count) ? nta : 0;
>
> -       handle &=3D mask;
> +       handle -=3D off;
>
>         bi->dma =3D xdp_umem_get_dma(rx_ring->xsk_umem, handle);
>         bi->dma +=3D hr;
> --
> 2.17.1
>
