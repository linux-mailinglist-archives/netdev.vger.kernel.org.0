Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD02251F53
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 20:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHYSv7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 14:51:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44420 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYSv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 14:51:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id c15so13869274wrs.11;
        Tue, 25 Aug 2020 11:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=s+W3uZAiMBwphjOUwnUhUmXvFq4VneY/X9nTgR/gPEA=;
        b=sDpuwQM4lDS6vfPvTemu+m4Nnz8Ap14xTfES6oXmwtiAt4b1Y/mF9+gsZj3EsUaWKA
         7o7b0ts0nIuT5yWzxjX/CJ79JYObWBR3iG7Y4NW7WgHLB6ZJplCeOmPquR3TX9zNYDiM
         544LTBvxMxdtFe4nRDzBr2SpF9/ou23TxKGU0HRFij7rRWb8gFVDRbHOMxHV6Lu6gQB3
         2mRnHwkouPUC31OEZzAyfQdZ/BTOeYPUy5FU74QXzvkHzzvmkLbj5i0E1p9BOSmLJ8fC
         doNSaQ9EkIubMXSBq/v4c/X/exK8kKbVX+1Z3S2rbCFnjjcGq6wcu/TxUBMn2uboE16h
         sCkw==
X-Gm-Message-State: AOAM531+ADuKIyk+fh/RfJkVvpSwN10zS4B4jKFlU+2gUM/o4HvgQulb
        2nU80AMWNhXtSF22AFXNTPzQ3bZe3cE=
X-Google-Smtp-Source: ABdhPJzytjwQc52wqXSoHZIMC+5o5R4ToV/YTFKD/hV5Um+1DtUtblRCRmADb29VS4xbe5eEy8OF+Q==
X-Received: by 2002:a5d:674d:: with SMTP id l13mr11939696wrw.151.1598381515086;
        Tue, 25 Aug 2020 11:51:55 -0700 (PDT)
Received: from kozik-lap ([194.230.155.216])
        by smtp.googlemail.com with ESMTPSA id c10sm7839767wmk.30.2020.08.25.11.51.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 11:51:54 -0700 (PDT)
Date:   Tue, 25 Aug 2020 20:51:52 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 3/3] ARM: defconfig: Enable ax88796c driver
Message-ID: <20200825185152.GC2693@kozik-lap>
References: <20200825170311.24886-1-l.stelmach@samsung.com>
 <CGME20200825170323eucas1p15f2bbfa460f7ef787069dd3459dd77b3@eucas1p1.samsung.com>
 <20200825170311.24886-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200825170311.24886-3-l.stelmach@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 07:03:11PM +0200, Łukasz Stelmach wrote:
> Enable ax88796c driver for the ethernet chip on Exynos3250-based
> ARTIK5 boards.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  arch/arm/configs/exynos_defconfig   | 2 ++
>  arch/arm/configs/multi_v7_defconfig | 2 ++
>  2 files changed, 4 insertions(+)
> 
> Please DO NOT merge before these two

Sure, it can wait but shouldn't actually DT wait? It's only defconfig so
it does not change anything except automated systems booting these
defconfigs... The boards might be broken by DT.

Best regards,
Krzysztof

> 
>   https://lore.kernel.org/lkml/20200821161401.11307-2-l.stelmach@samsung.com/
>   https://lore.kernel.org/lkml/20200821161401.11307-3-l.stelmach@samsung.com/
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 6e8b5ff0859c..82480b2bf545 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -107,6 +107,8 @@ CONFIG_MD=y
>  CONFIG_BLK_DEV_DM=y
>  CONFIG_DM_CRYPT=m
>  CONFIG_NETDEVICES=y
> +CONFIG_NET_VENDOR_ASIX=y
> +CONFIG_SPI_AX88796C=y
>  CONFIG_SMSC911X=y
>  CONFIG_USB_RTL8150=m
>  CONFIG_USB_RTL8152=y
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index e9e76e32f10f..a8b4e95d4148 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -241,6 +241,8 @@ CONFIG_SATA_HIGHBANK=y
>  CONFIG_SATA_MV=y
>  CONFIG_SATA_RCAR=y
>  CONFIG_NETDEVICES=y
> +CONFIG_NET_VENDOR_ASIX=y
> +CONFIG_SPI_AX88796C=m
>  CONFIG_VIRTIO_NET=y
>  CONFIG_B53_SPI_DRIVER=m
>  CONFIG_B53_MDIO_DRIVER=m
> -- 
> 2.26.2
> 
