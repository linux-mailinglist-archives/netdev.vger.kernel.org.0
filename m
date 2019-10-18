Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1ABDC758
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410334AbfJRO3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:29:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35222 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbfJRO3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:29:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id n124so2628215wmf.0;
        Fri, 18 Oct 2019 07:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5ptchJ9UA22jxDJh3Bd/EUwZqE/aEbLVu7JuDoUNaVo=;
        b=Yg7fL+tE/kvtd8TqGdv5DyItEgy/SQ6F5leKmV64MKRBGuxFXM91r752kNg19q1/6H
         U8HZR8HW03LFU1LVJUD3qGeu4NDOKSGdC0DmvR84qWQbYHhGHcltRYt74op6dOPN+Jtl
         tm3A1levUg0YRkb8ZXcZRDYBMBB82OyU66xxUiNWz2qDtyyhEBGFCR5dglDj8r8Sd+Dr
         A1oa6NtHjvgDmkVwlkGBZbbhSUO3odjCbp0DES+hNUdDMFjLOZ166/B0Y2mFD40K2PZG
         Tep3KgOfiUpN9R5jXoQSUxCTaRTgrfikKqeJ80iPnFfKyVPgPmq1t1QT8s05EaedDoEp
         2sSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5ptchJ9UA22jxDJh3Bd/EUwZqE/aEbLVu7JuDoUNaVo=;
        b=QBWoLOjO+JEbPFIeUVy3VDF2SGzhZYrPzgS2yDtApEh7jS1C9YSsIJOlNuKfoaBDxQ
         w6wc5qnQu0ytXLCTBLJd1hrv51pC71Grb3hYvrpjeyDspJfUMGITLqwhDmhj0uYbZxZu
         cQ9pTGrUjZYNR2Z/fxgdWX1G5hd1nhS3PX3DZSPrM8hgYRaEUn25fIMpJQ4h5yddDFty
         ljpnD+D0TaWlJ/gV6BmGyfVeNwD/8Prf4Pdm09788MpDkzaM0A8ZEwIAk29fez/V/rEE
         UiskWB8ceJEvlIuRrbLJCPhriOgBUP1IxgcO2CXi8Wl6x8pU4YywOJhBKWoq3RjvcRy/
         ifeA==
X-Gm-Message-State: APjAAAVA9h/fDWrm/5DDqUnVCyj+I5W+URYSlDSbQwLNuqLPkUzcf9Rg
        0DbS1hsV3/mExM3j/C7N+6g=
X-Google-Smtp-Source: APXvYqy2l6Z4/hxK2/QCsvDc78zWIYq2fO4nyiQ6TsMaLbtrWVUvnVhhlqCC8bd4O5M+y1JjnG11/Q==
X-Received: by 2002:a1c:5946:: with SMTP id n67mr8222592wmb.93.1571408959942;
        Fri, 18 Oct 2019 07:29:19 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 36sm6791136wrp.30.2019.10.18.07.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 07:29:19 -0700 (PDT)
Date:   Fri, 18 Oct 2019 16:29:17 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: dwmac-sun8i: show message only when
 switching to promisc
Message-ID: <20191018142917.GA26078@Red>
References: <20191018140514.21454-1-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018140514.21454-1-mans@mansr.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 03:05:14PM +0100, Mans Rullgard wrote:
> Printing the info message every time more than the max number of mac
> addresses are requested generates unnecessary log spam.  Showing it only
> when the hw is not already in promiscous mode is equally informative
> without being annoying.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> index 79c91526f3ec..5be2de1f1179 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> @@ -646,7 +646,8 @@ static void sun8i_dwmac_set_filter(struct mac_device_info *hw,
>  			}
>  		}
>  	} else {
> -		netdev_info(dev, "Too many address, switching to promiscuous\n");
> +		if (readl(ioaddr + EMAC_RX_FRM_FLT) != EMAC_FRM_FLT_RXALL)
> +			netdev_info(dev, "Too many address, switching to promiscuous\n");
>  		v = EMAC_FRM_FLT_RXALL;
>  	}
>  

You need to mask the result, if EMAC_FRM_FLT_MULTICAST | EMAC_FRM_FLT_RXALL is set, you will still print the message.
Or shorter than masking, !(readl(ioaddr + EMAC_RX_FRM_FLT) & EMAC_FRM_FLT_RXALL)

I just realize that perhaps we need to set also IFF_PROMISC in dev->flags.

Thanks
Regards
