Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EB739C03F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhFDTNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFDTN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 15:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F124611CA;
        Fri,  4 Jun 2021 19:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622833902;
        bh=1OYdqDIJbvdktP3Zf73pda90ObsQDgTAwi6d/Ny82Eg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=l3i12KfTeZrShaULtvDX781siDXGZbz0OUJ+Ol0XmgrK96i8fm7u8a5uw75tem93O
         42zIsE9/ELfzCz/uD5tZnbGsXOf3XoKpo6VjGqDU1kH+enyI04JkHtvhet1CK2B0E6
         OoCeRk/kBeWiAIQX16+fj3wMxjh1F+iKL/chbiD/Vl2Nn+0U7wwO9HulXIhMwONHPC
         PKpmVK39lMsb9LmI8d9RsWN9eWZ7Evt/u0Unp/njgKsmia+XzA02xlH35pmRehGVJg
         9k7ENbxVddwLmwV4c3JsQQgsD/iRprECdGonip0thoGKQ8/GcFYi4vFo76H+fdRgP4
         0NU+egalfRzTg==
Date:   Fri, 4 Jun 2021 14:11:41 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 2/2] MAINTAINERS: move Murali Karicheri to credits
Message-ID: <20210604191141.GA2228033@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429090521.554-2-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 11:05:21AM +0200, Michael Walle wrote:
> His email bounces with permanent error "550 Invalid recipient". His last
> email was from 2020-09-09 on the LKML and he seems to have left TI.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# TI KeyStone PCI driver

I could take both, given a networking ack for [1/2].  Or both could go
via the networking tree.

> ---
> changes since v1:
>  - rebased to net
> 
>  CREDITS     |  5 +++++
>  MAINTAINERS | 13 -------------
>  2 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/CREDITS b/CREDITS
> index cef83b958cbe..80d096dbf262 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1874,6 +1874,11 @@ S: Krosenska' 543
>  S: 181 00 Praha 8
>  S: Czech Republic
>  
> +N: Murali Karicheri
> +E: m-karicheri2@ti.com
> +D: Keystone NetCP driver
> +D: Keystone PCIe host controller driver
> +
>  N: Jan "Yenya" Kasprzak
>  E: kas@fi.muni.cz
>  D: Author of the COSA/SRP sync serial board driver.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 04f4a2116b35..e264e63f09c0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13780,13 +13780,6 @@ F:	Documentation/devicetree/bindings/pci/ti-pci.txt
>  F:	drivers/pci/controller/cadence/pci-j721e.c
>  F:	drivers/pci/controller/dwc/pci-dra7xx.c
>  
> -PCI DRIVER FOR TI KEYSTONE
> -M:	Murali Karicheri <m-karicheri2@ti.com>
> -L:	linux-pci@vger.kernel.org
> -L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -S:	Maintained
> -F:	drivers/pci/controller/dwc/pci-keystone.c
> -
>  PCI DRIVER FOR V3 SEMICONDUCTOR V360EPC
>  M:	Linus Walleij <linus.walleij@linaro.org>
>  L:	linux-pci@vger.kernel.org
> @@ -17974,12 +17967,6 @@ F:	drivers/power/supply/lp8788-charger.c
>  F:	drivers/regulator/lp8788-*.c
>  F:	include/linux/mfd/lp8788*.h
>  
> -TI NETCP ETHERNET DRIVER
> -M:	Murali Karicheri <m-karicheri2@ti.com>
> -L:	netdev@vger.kernel.org
> -S:	Maintained
> -F:	drivers/net/ethernet/ti/netcp*
> -
>  TI PCM3060 ASoC CODEC DRIVER
>  M:	Kirill Marinushkin <kmarinushkin@birdec.com>
>  L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
> -- 
> 2.20.1
> 
