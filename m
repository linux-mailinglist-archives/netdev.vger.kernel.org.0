Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DAE2527AA
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 08:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHZGqw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Aug 2020 02:46:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37673 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgHZGqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 02:46:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id x9so618599wmi.2;
        Tue, 25 Aug 2020 23:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=woDwpwEGnSTSc4kljToA4r5StN2rkeplc2dBRDufFZA=;
        b=axwIzwdJXwjZsXIrMW6pOdz/Fl6s46kYixkoGoQQN/7r9Q/vxadPrX3i+bebYsbCiu
         F4qZsZvN95U99837oYJKDflwgzafkp8BGFvkifvpW9oEhMLE333cpq/DJ6shNJJfSU5K
         fnmuUSViSObLp0Ewaib3nIfSmb8PtCnnfdI5BujC6YtDd+HCiTYKVXGRsyhEHO+jm7pY
         zQmoJVHnBmZRFKyutbDAAbYCLy1mkWk3CT00a6x0Cu1r3oCwcCfSknTc66vPeMBdwA5U
         nLq76H0aID+17EaVGxsDpqxCaKdydyCQWRbilU7I08vj/SVRvwa1e2WoBzJMws98UpK1
         2LPQ==
X-Gm-Message-State: AOAM531ug6AshDEqLNSwI/selChhVUmSRNzRglZTYEfaWpy+w8gqY/Fn
        x7ybN70ny7ur9SgYvotdq0ZJbNX2crg=
X-Google-Smtp-Source: ABdhPJwwnq5+FT5AJu3knzHTD/+s17qG77/RpFqNYzEjYg24N/OVflA007W8XbHJWMrOxuCfflZj9Q==
X-Received: by 2002:a7b:cf13:: with SMTP id l19mr5238783wmg.115.1598424408857;
        Tue, 25 Aug 2020 23:46:48 -0700 (PDT)
Received: from pi3 ([194.230.155.216])
        by smtp.googlemail.com with ESMTPSA id g17sm3402102wrr.28.2020.08.25.23.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 23:46:48 -0700 (PDT)
Date:   Wed, 26 Aug 2020 08:46:45 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
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
Message-ID: <20200826064645.GA12103@pi3>
References: <20200825185152.GC2693@kozik-lap>
 <CGME20200826051134eucas1p23a1c91b2179678eecc5dd5eeb2d0e4c9@eucas1p2.samsung.com>
 <dleftjk0xmuh3d.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <dleftjk0xmuh3d.fsf%l.stelmach@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 07:11:18AM +0200, Lukasz Stelmach wrote:
> It was <2020-08-25 wto 20:51>, when Krzysztof Kozlowski wrote:
> > On Tue, Aug 25, 2020 at 07:03:11PM +0200, Łukasz Stelmach wrote:
> >> Enable ax88796c driver for the ethernet chip on Exynos3250-based
> >> ARTIK5 boards.
> >> 
> >> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> >> ---
> >>  arch/arm/configs/exynos_defconfig   | 2 ++
> >>  arch/arm/configs/multi_v7_defconfig | 2 ++
> >>  2 files changed, 4 insertions(+)
> >> 
> >> Please DO NOT merge before these two
> >
> > Sure, it can wait but shouldn't actually DT wait? It's only defconfig so
> > it does not change anything except automated systems booting these
> > defconfigs... The boards might be broken by DT.
> 
> I was told, to ask for deferred merge of defconfig and it makes sense to
> me. DT won't break anything if the driver isn't compiled. However, I can
> see that you have a word you may decide about DT too. My point is to
> wait until spi-s3c64xx patches are merged and not to break ARTIK5
> boards.

The config is chosen and adjusted by each person, during build. Merging
defconfig does not necessarily affect them. However merging DT affects -
you cannot disable it without source code modification.

Anyway, no problem for me with waiting with defconfig.

Best regards,
Krzysztof


> 
> >> 
> >>   https://lore.kernel.org/lkml/20200821161401.11307-2-l.stelmach@samsung.com/
> >>   https://lore.kernel.org/lkml/20200821161401.11307-3-l.stelmach@samsung.com/
> >> 
> >> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> >> index 6e8b5ff0859c..82480b2bf545 100644
> >> --- a/arch/arm/configs/exynos_defconfig
> >> +++ b/arch/arm/configs/exynos_defconfig
> >> @@ -107,6 +107,8 @@ CONFIG_MD=y
> >>  CONFIG_BLK_DEV_DM=y
> >>  CONFIG_DM_CRYPT=m
> >>  CONFIG_NETDEVICES=y
> >> +CONFIG_NET_VENDOR_ASIX=y
> >> +CONFIG_SPI_AX88796C=y
> >>  CONFIG_SMSC911X=y
> >>  CONFIG_USB_RTL8150=m
> >>  CONFIG_USB_RTL8152=y
> >> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> >> index e9e76e32f10f..a8b4e95d4148 100644
> >> --- a/arch/arm/configs/multi_v7_defconfig
> >> +++ b/arch/arm/configs/multi_v7_defconfig
> >> @@ -241,6 +241,8 @@ CONFIG_SATA_HIGHBANK=y
> >>  CONFIG_SATA_MV=y
> >>  CONFIG_SATA_RCAR=y
> >>  CONFIG_NETDEVICES=y
> >> +CONFIG_NET_VENDOR_ASIX=y
> >> +CONFIG_SPI_AX88796C=m
> >>  CONFIG_VIRTIO_NET=y
> >>  CONFIG_B53_SPI_DRIVER=m
> >>  CONFIG_B53_MDIO_DRIVER=m
> >> -- 
> >> 2.26.2
> >> 
> >
> >
> 
> -- 
> Łukasz Stelmach
> Samsung R&D Institute Poland
> Samsung Electronics


