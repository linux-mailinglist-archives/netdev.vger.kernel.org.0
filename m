Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46727668F16
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbjAMHWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbjAMHWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:22:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDBD5BA1E;
        Thu, 12 Jan 2023 23:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C26A862274;
        Fri, 13 Jan 2023 07:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE1AC433D2;
        Fri, 13 Jan 2023 07:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673593968;
        bh=QW1PY3rFgL7HIa1lrzMI5uksSAfbml0XYJbvQzFAuWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0oMMF0AsnNGVsfn35DXLDvgW2FFDBQctJVJeY8ZKTXb5ezzn7lhGkAftJpZH35IQL
         SnxMV96zvZ93p/8lbSuV6nhLT/2v6ajWOmV2dS1jXf/y0bbQOvb+apnJ6XXiXzoBRc
         F2PSRDe2WkZQdYDnszi1VWAGguwJrTfCgd0RBj8I=
Date:   Fri, 13 Jan 2023 08:12:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 02/22] usb: remove the dead USB_OHCI_SH option
Message-ID: <Y8EEbCP6PRMzWP5y@kroah.com>
References: <20230113062339.1909087-1-hch@lst.de>
 <20230113062339.1909087-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113062339.1909087-3-hch@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 07:23:19AM +0100, Christoph Hellwig wrote:
> USB_OHCI_SH is a dummy option that never builds any code, remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/usb/host/Kconfig | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 8d799d23c476e1..ca5f657c092cf4 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -548,17 +548,6 @@ config USB_OHCI_HCD_SSB
>  
>  	  If unsure, say N.
>  
> -config USB_OHCI_SH
> -	bool "OHCI support for SuperH USB controller (DEPRECATED)"
> -	depends on SUPERH || COMPILE_TEST
> -	select USB_OHCI_HCD_PLATFORM
> -	help
> -	  This option is deprecated now and the driver was removed, use
> -	  USB_OHCI_HCD_PLATFORM instead.
> -
> -	  Enables support for the on-chip OHCI controller on the SuperH.
> -	  If you use the PCI OHCI controller, this option is not necessary.
> -
>  config USB_OHCI_EXYNOS
>  	tristate "OHCI support for Samsung S5P/Exynos SoC Series"
>  	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
> -- 
> 2.39.0
> 

Do you want all of these to go through a single tree, or can they go
through the different driver subsystem trees?

If single:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

If not, I'll be glad to take this.

thanks,

greg k-h
