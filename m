Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD72FC22A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbhASVWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:22:12 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:33309 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729327AbhASSqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 13:46:54 -0500
Received: by mail-oi1-f180.google.com with SMTP id d203so22272436oia.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 10:46:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8GevVF7eVYQpmA+nLIxFhhdape9cJv5UbCXMrC79l1k=;
        b=CQ7bXR6E0cRk80vJ/b/Qb1/LvrroEBNcDsbudsQZ9ABrkE7Viym8MYX7gzNDKup6tm
         a8WPXdDgaYW+ppWkNy3MpMyWwEEOHQMD16BW8Htwe1FSTK52XJP3bJcsH8I00ELJk0FK
         2jch5chmbAcvj1LvKaTZLzMVhtF8caZkWbp7EyOQ/97chK8CeQPv7WubxhlprgvHDFev
         Fuxe7UrrEW1TkH2gC9Kk/rAZiBt1863GFF2t7zk2EKyfiBDxaEpA7esQl5KWP/3fC3h4
         m8OdPt0Xfr72AauY0C903VHZ/AgGASfPJKDF+hODFlg8+mcWLaGfs/Hi4KDJzb5PbKIE
         LnbQ==
X-Gm-Message-State: AOAM533YWKqUBBpwuXhg5sag6f/XKgHXYNchFYvbtqL7d6ICFIm8sRYP
        pptCLd5fZAjr+MNBb/rCf9MzFHEIEzI=
X-Google-Smtp-Source: ABdhPJyZ5o76KtXTJN4OorqQwuYj+6tFKtGML/kqakpTQgKSYh6Escj3OZPH2s7UeDtY8obg2ThRmA==
X-Received: by 2002:aca:6202:: with SMTP id w2mr685585oib.5.1611081972477;
        Tue, 19 Jan 2021 10:46:12 -0800 (PST)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id l8sm2294107ota.9.2021.01.19.10.46.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 10:46:12 -0800 (PST)
Received: by mail-oi1-f170.google.com with SMTP id w8so467386oie.2
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 10:46:11 -0800 (PST)
X-Received: by 2002:aca:afd7:: with SMTP id y206mr710917oie.51.1611081971529;
 Tue, 19 Jan 2021 10:46:11 -0800 (PST)
MIME-Version: 1.0
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk> <20210119150802.19997-5-rasmus.villemoes@prevas.dk>
In-Reply-To: <20210119150802.19997-5-rasmus.villemoes@prevas.dk>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Tue, 19 Jan 2021 12:46:00 -0600
X-Gmail-Original-Message-ID: <CADRPPNTRMO4cM+1vV+zkUuOCZPdhKcW9583J5NeTcKs+wXZJHw@mail.gmail.com>
Message-ID: <CADRPPNTRMO4cM+1vV+zkUuOCZPdhKcW9583J5NeTcKs+wXZJHw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 04/17] soc: fsl: qe: add cpm_muram_free_addr() helper
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 9:21 AM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> Add a helper that takes a virtual address rather than the muram
> offset. This will be used in a couple of places to avoid having to
> store both the offset and the virtual address, as well as removing
> NULL checks from the callers.
>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Acked-by: Li Yang <leoyang.li@nxp.com>

> ---
>  drivers/soc/fsl/qe/qe_common.c | 12 ++++++++++++
>  include/soc/fsl/qe/qe.h        |  5 +++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/drivers/soc/fsl/qe/qe_common.c b/drivers/soc/fsl/qe/qe_common.c
> index 303cc2f5eb4a..448ef7f5321a 100644
> --- a/drivers/soc/fsl/qe/qe_common.c
> +++ b/drivers/soc/fsl/qe/qe_common.c
> @@ -238,3 +238,15 @@ dma_addr_t cpm_muram_dma(void __iomem *addr)
>         return muram_pbase + (addr - muram_vbase);
>  }
>  EXPORT_SYMBOL(cpm_muram_dma);
> +
> +/*
> + * As cpm_muram_free, but takes the virtual address rather than the
> + * muram offset.
> + */
> +void cpm_muram_free_addr(const void __iomem *addr)
> +{
> +       if (!addr)
> +               return;
> +       cpm_muram_free(cpm_muram_offset(addr));
> +}
> +EXPORT_SYMBOL(cpm_muram_free_addr);
> diff --git a/include/soc/fsl/qe/qe.h b/include/soc/fsl/qe/qe.h
> index 8ee3747433c0..66f1afc393d1 100644
> --- a/include/soc/fsl/qe/qe.h
> +++ b/include/soc/fsl/qe/qe.h
> @@ -104,6 +104,7 @@ s32 cpm_muram_alloc_fixed(unsigned long offset, unsigned long size);
>  void __iomem *cpm_muram_addr(unsigned long offset);
>  unsigned long cpm_muram_offset(const void __iomem *addr);
>  dma_addr_t cpm_muram_dma(void __iomem *addr);
> +void cpm_muram_free_addr(const void __iomem *addr);
>  #else
>  static inline s32 cpm_muram_alloc(unsigned long size,
>                                   unsigned long align)
> @@ -135,6 +136,9 @@ static inline dma_addr_t cpm_muram_dma(void __iomem *addr)
>  {
>         return 0;
>  }
> +static inline void cpm_muram_free_addr(const void __iomem *addr)
> +{
> +}
>  #endif /* defined(CONFIG_CPM) || defined(CONFIG_QUICC_ENGINE) */
>
>  /* QE PIO */
> @@ -239,6 +243,7 @@ static inline int qe_alive_during_sleep(void)
>  #define qe_muram_addr cpm_muram_addr
>  #define qe_muram_offset cpm_muram_offset
>  #define qe_muram_dma cpm_muram_dma
> +#define qe_muram_free_addr cpm_muram_free_addr
>
>  #ifdef CONFIG_PPC32
>  #define qe_iowrite8(val, addr)     out_8(addr, val)
> --
> 2.23.0
>
