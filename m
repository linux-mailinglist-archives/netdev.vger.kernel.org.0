Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91D02F4F5B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbhAMP7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbhAMP7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 10:59:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 083D02339F;
        Wed, 13 Jan 2021 15:59:02 +0000 (UTC)
Date:   Wed, 13 Jan 2021 17:00:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nt: usb: USB_RTL8153_ECM should not default to y
Message-ID: <X/8ZCa/jgiAboGd7@kroah.com>
References: <20210113144309.1384615-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113144309.1384615-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 03:43:09PM +0100, Geert Uytterhoeven wrote:
> In general, device drivers should not be enabled by default.
> 
> Fixes: 657bc1d10bfc23ac ("r8153_ecm: avoid to be prior to r8152 driver")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/usb/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 1e37190287808973..fbbe786436319013 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -631,7 +631,6 @@ config USB_NET_AQC111
>  config USB_RTL8153_ECM
>  	tristate "RTL8153 ECM support"
>  	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
> -	default y
>  	help
>  	  This option supports ECM mode for RTL8153 ethernet adapter, when
>  	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
